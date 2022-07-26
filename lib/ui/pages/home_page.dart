import 'package:date_picker_timeline/date_picker_timeline.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:todo/controllers/task_controller.dart';
import 'package:todo/models/task.dart';
import 'package:todo/services/theme_services.dart';
import 'package:todo/ui/pages/add_task_page.dart';
import 'package:todo/ui/widgets/task_tile.dart';
import '../../services/notification_services.dart';
import '../size_config.dart';
import '../theme.dart';
import '../widgets/button.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
    DateTime selectedDate = DateTime.now();
    late NotifyHelper _notifyHelper;

  @override
  void initState() {
    super.initState();
    _notifyHelper = NotifyHelper();
    _notifyHelper.initializeNotification();
    _notifyHelper.requestIOSPermissions();
    _taskController.getTask();
  }

  final TaskController _taskController = Get.put(TaskController());

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
        appBar: buildAppBar(),
        backgroundColor: Theme.of(context).backgroundColor,
        body: Column(
          children: [
            _addTaskBar(),
            _addDatePicker(),
            _showTask(),
          ],
        ));
  }

  AppBar buildAppBar() {
    return AppBar(
      elevation: 0,
      backgroundColor: Theme.of(context).backgroundColor,
      leading: IconButton(
          onPressed: () {
            ThemeServices().switchMode();
            //   _notifyHelper.displayNotification(
            //     title: 'saqer',
            //     body: 'saqer',
            //   );
            // _notifyHelper.scheduledNotification(10);
          },
          icon: Icon(Get.isDarkMode
              ? Icons.wb_sunny_outlined
              : Icons.nightlight_round),
          color: Get.isDarkMode ? Colors.white : Colors.black),
      actions: [
        IconButton(
            onPressed: () {
              _notifyHelper.cancelAllNotification();
              _taskController.deleteAllTask();
            },
            icon: Icon(
              Icons.cleaning_services_outlined,
              size: 24,
              color: Get.isDarkMode ? Colors.white : Colors.black,
            )),
        const CircleAvatar(
          backgroundImage: AssetImage('images/person.jpeg'),
          radius: 18,
        ),
        const SizedBox(
          width: 10,
        )
      ],
    );
  }

  Container _addTaskBar() {
    return Container(
      margin: const EdgeInsets.only(left: 20, right: 10, top: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                DateFormat.yMMMMd().format(DateTime.now()).toString(),
                style: subHeadingStyle,
              ),
              Text(
                'Today',
                style: headingStyle,
              ),
            ],
          ),
          MyButton(
            onTap: () async {
              await Get.to(() => const AddTaskPage());
            },
            label: '+ Add Task',
          )
        ],
      ),
    );
  }

  Container _addDatePicker() {
    return Container(
        padding: const EdgeInsets.only(top: 10, left: 20),
        child: DatePicker(
          DateTime.now(),
          width: 70,
          height: 100,
          selectedTextColor: white,
          selectionColor: primaryClr,
          dateTextStyle: dateStyle,
          dayTextStyle: dayStyle,
          monthTextStyle: monthStyle,
          initialSelectedDate: DateTime.now(),
          onDateChange: (newDate) {
            setState(() {
              selectedDate = newDate;
            });
          },
        ));
  }

  Future<void> _onRefresh() async {
    _taskController.getTask();
  }

  _showTask() {
    return Expanded(child: Obx(() {
      if (_taskController.taskList.isEmpty) {
        return _noTaskMsg();
      }
      else {
        return RefreshIndicator(
          onRefresh: _onRefresh,
          child: ListView.builder(
            itemCount: _taskController.taskList.length,
            scrollDirection: SizeConfig.orientation == Orientation.landscape
                ? Axis.horizontal
                : Axis.vertical,
            itemBuilder: (context, index) {
              var task = _taskController.taskList[index];
              if (task.repeat == 'Daily' ||
                  task.date == DateFormat.yMd().format(selectedDate) ||
                  (task.repeat == 'Weekly' &&
                      selectedDate.difference( DateFormat.yMd().parse(task.date!)) .inDays % 7 == 0) ||
                  (task.repeat == 'Monthly' &&
                      DateFormat.yMd().parse(task.date!).day ==
                          selectedDate.day)) {
              //   var hour = task.startTime.toString().split(':')[0];
           //      var minutes = task.startTime.toString().split(':')[1];
        var date = DateFormat.jm().parse(task.startTime!);
          var myTime = DateFormat('HH:mm').format(date);
            _notifyHelper.scheduledNotification(
              int.parse(myTime.toString().split(':')[0]),
              int.parse(myTime.toString().split(':')[1]),
              task,
            );
            return AnimationConfiguration.staggeredList(
                  position: index,
                  duration: const Duration(milliseconds: 1375),
                  child: SlideAnimation(
                    horizontalOffset: 300,
                    child: FadeInAnimation(

                      child: GestureDetector(
                        onTap: () {
                          _showBottomSheet(context, task);
                        },
                        child: TaskTile(task),
                      ),
                    ),
                  ),
                );
              } else {
                return Container();
              }
            },
          ),
        );
      }
    }));
  }

  _noTaskMsg() {
    return Stack(
      children: [
        AnimatedPositioned(
          duration: const Duration(milliseconds: 2000),
          child: RefreshIndicator(
            onRefresh: _onRefresh,
            child: SingleChildScrollView(
              child: Wrap(
                direction: SizeConfig.orientation == Orientation.landscape
                    ? Axis.horizontal
                    : Axis.vertical,
                alignment: WrapAlignment.center,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  SizeConfig.orientation == Orientation.landscape
                      ? const SizedBox(
                          height: 6,
                        )
                      : const SizedBox(
                          height: 220,
                        ),
                  SvgPicture.asset(
                    'images/task.svg',
                    height: 90,
                    color: primaryClr.withOpacity(0.5),
                    semanticsLabel: 'Task',
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 30, vertical: 10),
                    child: Text(
                      'You to not have any tasks yet!\n Add new tasks to make your days productive',
                      style: subTitle,
                      textAlign: TextAlign.center,
                    ),
                  ),
                  SizeConfig.orientation == Orientation.landscape
                      ? const SizedBox(
                          height: 120,
                        )
                      : const SizedBox(
                          height: 180,
                        )
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  _showBottomSheet(BuildContext context, Task task) {
    Get.bottomSheet(SingleChildScrollView(
      child: Container(
        padding: const EdgeInsets.only(top: 4),
        width: SizeConfig.screenWidth,
        height: (SizeConfig.orientation == Orientation.landscape)
            ? (task.isCompleted == 1
                ? SizeConfig.screenHeight * 0.6
                : SizeConfig.screenHeight * 0.8)
            : (task.isCompleted == 1
                ? SizeConfig.screenHeight * 0.30
                : SizeConfig.screenHeight * 0.39),
        color: Get.isDarkMode ? darkHeaderClr : Colors.white,
        child: Column(
          children: [
            Flexible(
              child: Container(
                height: 6,
                width: 120,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color:
                        Get.isDarkMode ? Colors.grey[600] : Colors.grey[300]),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            task.isCompleted == 1
                ? Container()
                : _buildBottomSheet(
                    clr: primaryClr,
                    onTap: () {
                      _notifyHelper.cancelNotification(task);
                      _taskController.markTasksCompleted(task.id!);
                      Get.back();
                    },
                    label: 'Task Completed',
                  ),
            _buildBottomSheet(
              clr: Colors.red[300]!,
              onTap: () {
                _notifyHelper.cancelNotification(task);
                _taskController.deleteTasks(task);
                Get.back();
              },
              label: 'delete Task ',
            ),
            Divider(
              color: Get.isDarkMode ? Colors.grey : darkGreyClr,
            ),
            _buildBottomSheet(
              clr: primaryClr,
              onTap: () {
                Get.back();
              },
              label: 'Cancel Task ',
            ),
            const SizedBox(
              height: 20,
            ),
          ],
        ),
      ),
    ));
  }

  _buildBottomSheet({
    required Color clr,
    required Function() onTap,
    required String label,
    bool isClose = false,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4),
        height: 65,
        width: SizeConfig.screenWidth * 0.9,
        decoration: BoxDecoration(
            border: Border.all(
              width: 2,
              color: isClose
                  ? Get.isDarkMode
                      ? Colors.grey[600]!
                      : Colors.grey[300]!
                  : clr,
            ),
            borderRadius: BorderRadius.circular(20),
            color: isClose ? Colors.transparent : clr),
        child: Center(
          child: Text(
            label,
            style:
                isClose ? titleStyle : titleStyle.copyWith(color: Colors.white),
          ),
        ),
      ),
    );
  }
}
