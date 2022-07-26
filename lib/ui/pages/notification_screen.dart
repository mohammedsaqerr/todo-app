import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../theme.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({Key? key, required this.payLod}) : super(key: key);
  final String payLod;

  @override
  _NotificationScreenState createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  String _payLod = '';

  @override
  void initState() {
    super.initState();
    _payLod = widget.payLod;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: Icon(Icons.arrow_back_ios,
              color: Get.isDarkMode ? Colors.white : darkGreyClr),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Theme.of(context).backgroundColor,
        title: Text(
          _payLod.toString().split('|')[0],
          style: TextStyle(color: Get.isDarkMode ? Colors.white : Colors.black),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(
              height: 20,
            ),
            Column(
              children: [
                Text(
                  'Hello Mohammed ',
                  style: TextStyle(
                    fontSize: 19,
                    fontWeight: FontWeight.w900,
                    color: Get.isDarkMode ? Colors.white : darkGreyClr,
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Text(
                  'You have a new reminder ',
                  style: TextStyle(
                    fontSize: 19,
                    color: Get.isDarkMode ? Colors.grey[100] : darkGreyClr,
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            Expanded(
                child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 30),
              margin: const EdgeInsets.symmetric(horizontal: 30),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                color: bluishClr,
              ),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    buildRow(Icons.text_format, 'Title',
                        _payLod.toString().split('|')[0]),
                    buildRow(Icons.description, 'Description',
                        _payLod.toString().split('|')[1]),
                    buildRow(Icons.date_range, 'Date',
                        _payLod.toString().split('|')[2]),
                  ],
                ),
              ),
            )),
            const SizedBox(
              height: 30,
            )
          ],
        ),
      ),
    );
  }

  Column buildRow(IconData icon, String title, String text) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              icon,
              size: 35,
              color: Colors.white,
            ),
            const SizedBox(
              width: 15,
            ),
            Text(
              title,
              style: const TextStyle(color: Colors.white, fontSize: 30),
            )
          ],
        ),
        const SizedBox(
          height: 15,
        ),
        Text(
          text,
          style: const TextStyle(color: Colors.white, fontSize: 20),
        ),
        const SizedBox(
          height: 15,
        ),
      ],
    );
  }
}
