// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:to_do_app/ui/pages/home_page.dart';
import 'package:to_do_app/ui/themes.dart';

class NotificationScreen extends StatefulWidget {
  final String payload;
  const NotificationScreen({
    super.key,
    required this.payload,
  });

  @override
  State<NotificationScreen> createState() => NotificationScreenState();
}

class NotificationScreenState extends State<NotificationScreen> {
  String _payload = '';
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _payload = widget.payload;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Get.off(() => MyHomePage());
          },
          icon: Icon(Icons.arrow_back_ios,
              color: Get.isDarkMode ? Colors.white : darkGreyClr),
        ),
        backgroundColor: Theme.of(context).primaryColor,
        centerTitle: true,
        title: Text(
          _payload.split('|')[0],
          style: TextStyle(
            color: Get.isDarkMode ? Colors.white : darkGreyClr,
          ),
        ),
      ),
      body: SafeArea(
        child: Center(
          child: Column(
            children: [
              SizedBox(height: 10),
              Column(
                children: [
                  Text(
                    "Hello Sir/Madam",
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.w900,
                      color: Get.isDarkMode ? Colors.white : darkGreyClr,
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    "You Have A New Reminder",
                    style: TextStyle(
                      fontSize: 18,
                      color: Get.isDarkMode ? Colors.grey[100] : darkGreyClr,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              //notification
              Expanded(
                  child: Container(
                padding: const EdgeInsetsDirectional.symmetric(
                    horizontal: 30, vertical: 10),
                margin: const EdgeInsetsDirectional.symmetric(horizontal: 30),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(25),
                  color: primaryClr,
                ),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.text_format,
                              size: 35, color: Colors.white),
                          const SizedBox(width: 10),
                          Text(
                            "Title",
                            style: TextStyle(
                              fontSize: 30,
                              color: Colors.white,
                            ),
                          )
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Text(
                        _payload.split('|')[0],
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      //description
                      Row(
                        children: [
                          Icon(Icons.description,
                              size: 35, color: Colors.white),
                          const SizedBox(width: 10),
                          Text(
                            "Description",
                            style: TextStyle(
                              fontSize: 30,
                              color: Colors.white,
                            ),
                          )
                        ],
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Text(
                        _payload.split('|')[1],
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                        ),
                        textAlign: TextAlign.justify,
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      //date
                      Row(
                        children: [
                          Icon(Icons.calendar_today_outlined,
                              size: 35, color: Colors.white),
                          const SizedBox(width: 10),
                          Text(
                            "Date",
                            style: TextStyle(
                              fontSize: 30,
                              color: Colors.white,
                            ),
                          )
                        ],
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Text(
                        _payload.split('|')[2],
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                        ),
                        textAlign: TextAlign.justify,
                      ),
                    ],
                  ),
                ),
              )),
            ],
          ),
        ),
      ),
    );
  }
}
