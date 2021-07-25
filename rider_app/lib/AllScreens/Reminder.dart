// import 'package:event_tool/model/event.dart';
//
//
// import 'package:flutter/cupertino.dart';
// import 'package:event_tool/event_tool.dart';
// import 'package:flutter/material.dart';
//
//
//
// class AddReminder extends StatelessWidget {
//   final GlobalKey<ScaffoldState> scaffoldState = GlobalKey();
//
//   @override
//   Widget build(BuildContext context) {
//     Event event = Event(
//       title: 'yo nae ho',
//       notes: 'from Even Tool',
//       location: 'your position',
//       startDate: DateTime.now().add(Duration(minutes: 1)),
//       endDate: DateTime.now().add(Duration(minutes: 7)),
//       allDay: false,
//       alarmBefore: 5,
//     );
//
//     return CupertinoPageScaffold(
//       navigationBar: CupertinoNavigationBar(
//         middle: const Text('Event Tool'),
//       ),
//       child: Container(
//         child: Padding(
//           padding: const EdgeInsets.all(8.0),
//           child: Center(
//               child: CupertinoButton(
//                 child: Text('Try add event to calendar'),
//                 color: Colors.black45,
//                 onPressed: () {
//                   EventTool.addEvent(event).then((success) {
//                     showCupertinoDialog(
//                       context: context,
//                       builder: (context) {
//                         return CupertinoAlertDialog(
//                           title: Text('Test event'),
//                           content: Text(success ? 'Success' : 'Error'),
//                           actions: <Widget>[
//                             CupertinoDialogAction(
//                               child: Text('OK'),
//                               onPressed: () {
//                                 Navigator.of(context).pop();
//                               },
//                             ),
//                           ],
//                         );
//                       },
//                     );
//                   });
//                 },
//               )),
//         ),
//       ),
//     );
//   }
// }