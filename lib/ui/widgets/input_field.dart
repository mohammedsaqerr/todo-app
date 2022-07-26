import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../size_config.dart';
import '../theme.dart';

class InputField extends StatelessWidget {
  final String title;
  final String hint;
  final TextEditingController? controller;
  final Widget? widget;

  const InputField(
      {Key? key,
      required this.title,
      required this.hint,
      this.widget,
      this.controller})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: titleStyle),
          Container(
            alignment: Alignment.center,
            width: SizeConfig.screenWidth,
             margin: const EdgeInsets.only(top: 10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              border: Border.all(color: Colors.grey, width: 1),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(

                  children: [

                    Expanded(
                        child: SizedBox(
                          height: 52,
                          child: TextFormField(
                            readOnly: widget!=null?true:false,
                            cursorColor: Get.isDarkMode?Colors.grey[100]:Colors.grey,
                            expands: true,
                            maxLines: null,
                            minLines: null,
                            controller: controller,
                            autofocus: false,
                            decoration:  InputDecoration(
                              contentPadding: const EdgeInsets.all(10),
                              hintText: hint,
                              hintStyle: subTitle,
                              labelStyle:subTitle ,
                              focusedBorder:
                                const  UnderlineInputBorder(borderSide: BorderSide.none),
                              enabledBorder:
                                const  UnderlineInputBorder(borderSide: BorderSide.none),
                            ),
                          ),
                        )),
                    widget??Container()
                  ],
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
