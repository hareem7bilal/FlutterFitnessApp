import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:meta/meta.dart';
import '../../utils/color_extension.dart';

class NotificationView extends StatefulWidget{
  const NotificationView({super.key});

  @override
  State<NotificationView> createState() => _NotificationViewState();

}

class _NotificationViewState extends State<NotificationView> {

  List notificationArr= [{"image": "app/assets/images/icons/Workout1.png", "Let's add your meal.": "", "time": "about 1 minute ago"},
  {"image": "app/assets/images/icons/Workout2.png", "title": "It's time for lunch!", "time": "about 10 minutes ago"},
  {"image": "app/assets/images/icons/Workout3.png", "title": "Don't miss your lowerbody workout!", "time": "1 hour ago"},
  {"image": "app/assets/images/icons/Workout1.png", "title": "How many calories did you eat today?", "time": "1 hour ago"},
  {"image": "app/assets/images/icons/Workout2.png", "title": "Did you reach your exercise goals today?", "time": "2 hours ago"},
  {"image": "app/assets/images/icons/Workout3.png", "title": "Oops you have missed your lowerbody workout.", "time": "2 hours ago"}];


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        leading: InkWell(
          onTap: (){
            Navigator.pop(context);
          },
        child: Container(
          margin: const EdgeInsets.all(8),
          width: 40,
          height: 40,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: TColor.lightGrey, borderRadius: BorderRadius.circular(10)),
            child: Image.asset("app/assets/images/icons/black_btn.png", width: 12, height:12, fit: BoxFit.contain),
        ),
        ),
        title: Text("Notification", 
        style: TextStyle(color: TColor.black, fontSize: 16, fontWeight: FontWeight.w700),),
        actions: [
          InkWell(
          onTap: (){
          
          },
        child: Container(
          margin: const EdgeInsets.all(8),
          width: 40,
          height: 40,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: TColor.lightGrey, borderRadius: BorderRadius.circular(10)),
            child: Image.asset("app/assets/images/icons/more_btn.png", width: 12, height:12, fit: BoxFit.contain),
        ),
        ),
        ]),
      
        backgroundColor: TColor.white,
        body: ListView.separated(itemBuilder: ((context, index) {
          var nObj = notificationArr[index] as Map? ?? {};
          return Container(
            decoration: BoxDecoration(
            color: TColor.lightGrey, borderRadius: BorderRadius.circular(10)),
          )

        }),
        separatorBuilder: (context, index){
          return Divider(color: TColor.lightGrey, height: 1,);
        }, 
        itemCount: notificationArr.length),
        
    );
  }
}