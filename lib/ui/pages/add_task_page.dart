import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:todo/controllers/task_controller.dart';
import 'package:todo/models/task.dart';
import 'package:todo/ui/theme.dart';
import 'package:todo/ui/widgets/button.dart';
import 'package:todo/ui/widgets/input_field.dart';

class AddTaskPage extends StatefulWidget {
  const AddTaskPage({Key? key}) : super(key: key);

  @override
  State<AddTaskPage> createState() => _AddTaskPageState();
}

class _AddTaskPageState extends State<AddTaskPage> {
  final TaskController _taskController = Get.put(TaskController());
  final TextEditingController _titleEditingController = TextEditingController();

  final TextEditingController _noteEditingController = TextEditingController();
  DateTime selectedDate = DateTime.now();
  String _startTime = DateFormat('hh:mm a').format(DateTime.now()).toString();

  String _endTime = DateFormat('hh:mm a')
      .format(DateTime.now().add(const Duration(minutes: 15)))
      .toString();
  int selectedRemind = 5;
  List<int> remindList = [5, 10, 15, 20];
  String selectedRepeat = 'None';
  List<String> repeatList = ['None', 'Daily', 'Weekly', 'Monthly'];
  int selectedColor = 0;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: buildAppBar(),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Text(
                'Add Task',
                style: headingStyle,
              ),
              InputField(
                title: 'Title',
                hint: 'Enter title here',
                controller: _titleEditingController,
              ),
              InputField(
                title: 'Note',
                hint: 'Enter note here',
                controller: _noteEditingController,
              ),
              InputField(
                title: 'Date',
                hint: DateFormat.yMd().format(selectedDate).toString(),
                widget: IconButton(
                  onPressed: () => getDateFromUser(),
                  icon: const Icon(
                    Icons.calendar_today_outlined,
                    color: Colors.grey,
                  ),
                ),
              ),
              Row(
                children: [
                  Expanded(
                      child: InputField(
                    title: 'Start Time',
                    hint: _startTime,
                    widget: IconButton(
                      onPressed: () => getTimeFromUser(isStartTime: true),
                      icon: const Icon(
                        Icons.access_time_rounded,
                        color: Colors.grey,
                      ),
                    ),
                  )),
                  const SizedBox(
                    width: 20,
                  ),
                  Expanded(
                      child: InputField(
                    title: 'End Time',
                    hint: _endTime,
                    widget: IconButton(
                      onPressed: () => getTimeFromUser(isStartTime: false),
                      icon: const Icon(
                        Icons.access_time_rounded,
                        color: Colors.grey,
                      ),
                    ),
                  ))
                ],
              ),
              InputField(
                title: 'Remind',
                hint: '$selectedRemind minutes early',
                widget: DropdownButton(
                  dropdownColor: Colors.blueGrey,
                  borderRadius: BorderRadius.circular(10),
                  icon: const Icon(
                    Icons.keyboard_arrow_down_sharp,
                    size: 35,
                  ),
                  elevation: 4,
                  underline: Container(
                    height: 0,
                  ),
                  style: subTitle,
                  onChanged: (String? newValue) {
                    setState(() {
                      selectedRemind = int.parse(newValue!);
                    });
                  },
                  items: remindList
                      .map<DropdownMenuItem<String>>(
                          (element) => DropdownMenuItem<String>(
                                child: Text('$element'),
                                value: element.toString(),
                              ))
                      .toList(),
                ),
              ),
              InputField(
                title: 'Remind',
                hint: '$selectedRepeat minutes early',
                widget: DropdownButton(
                  dropdownColor: Colors.blueGrey,
                  borderRadius: BorderRadius.circular(10),
                  icon: const Icon(
                    Icons.keyboard_arrow_down_sharp,
                    size: 35,
                  ),
                  elevation: 4,
                  underline: Container(
                    height: 0,
                  ),
                  style: subTitle,
                  onChanged: (String? newValue) {
                    setState(() {
                      selectedRepeat = newValue!;
                    });
                  },
                  items: repeatList
                      .map<DropdownMenuItem<String>>(
                          (element) => DropdownMenuItem<String>(
                                child: Text(element),
                                value: element.toString(),
                              ))
                      .toList(),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  colorPalette(),
                  MyButton(
                    label: 'Create Task',
                    onTap: () async{
                    await  _validateDate();
                    },
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  AppBar buildAppBar() {
    return AppBar(
      elevation: 0,
      backgroundColor: Theme.of(context).backgroundColor,
      leading: IconButton(
        onPressed: () => Get.back(),
        icon: const Icon(
          Icons.arrow_back_ios,
          color: primaryClr,
          size: 24,
        ),
      ),
      actions: const [
        CircleAvatar(
          backgroundImage: AssetImage('images/person.jpeg'),
          radius: 18,
        ),
        SizedBox(
          width: 10,
        )
      ],
    );
  }

  _validateDate() {
    if (_titleEditingController.text.isNotEmpty &&
        _noteEditingController.text.isNotEmpty) {
      addTaskToDb();
      Get.back();
    } else if (_titleEditingController.text.isEmpty ||
        _noteEditingController.text.isEmpty) {
      Get.snackbar('required', 'All field are required',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.white,
          colorText: pinkClr,
          icon: const Icon(
            Icons.warning_amber_rounded,
            color: Colors.red,
          ));
    } else {
      print('############ SOMETHING BAO HAPPENED ################');
    }
  }

  addTaskToDb() async {
    int vale = await _taskController.addTask(
      task:  Task(
            title: _titleEditingController.text,
            note: _noteEditingController.text,
            isCompleted: 0,
            startTime: _startTime,
            endTime: _endTime,
            date: DateFormat.yMd().format(selectedDate),
            color: selectedColor,
            remind: selectedRemind,
            repeat: selectedRepeat));

  }

  Column colorPalette() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Color',
          style: titleStyle,
        ),
        const SizedBox(
          height: 10,
        ),
        Wrap(
            children: List.generate(
          3,
          (index) => GestureDetector(
            onTap: () {
              setState(() {
                selectedColor = index;
              });
            },
            child: Padding(
              padding: const EdgeInsets.only(right: 7),
              child: CircleAvatar(
                backgroundColor: index == 0
                    ? primaryClr
                    : index == 1
                        ? pinkClr
                        : orangeClr,
                radius: 14,
                child: selectedColor == index
                    ? const Icon(
                        Icons.check,
                        size: 13,
                        color: Colors.white,
                      )
                    : null,
              ),
            ),
          ),
        ))
      ],
    );
  }

  getDateFromUser() async {
    DateTime? _pickedDate = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2015),
      lastDate: DateTime(2030),
    );
    setState(() {
      if (_pickedDate != null) {
        setState(() {
          selectedDate = _pickedDate;
        });
      } else {
        print('it\'s null or something is wrong ');
      }
    });
  }

  getTimeFromUser({required bool isStartTime}) async {
    TimeOfDay? _pickedTime = await showTimePicker(
      context: context,
      initialTime: isStartTime
          ? TimeOfDay.fromDateTime(DateTime.now())
          : TimeOfDay.fromDateTime(DateTime.now().add(const Duration(minutes: 15))),
    );
    String formattedTime = _pickedTime!.format(context);
    if(isStartTime){
      setState(() {
        _startTime =formattedTime;
      });
    }else if(!isStartTime){
      setState(() {
        _endTime =formattedTime;
      });

    }else{
      print('time cancel or something is wrong');
    }
  }
}
