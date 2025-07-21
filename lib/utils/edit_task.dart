import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart';
import 'package:intl/intl.dart';
import 'package:todo_notification/utils/action_button.dart';

// ignore: must_be_immutable
class EditTask extends StatefulWidget {
  //methods and variables
  DateTime taskDate;
  final Function(DateTime) onDateChanged;

  void Function() onCancel;
  void Function() onEdit;
  final controller;

  EditTask({
    super.key,
    required this.onCancel,
    required this.onEdit,
    required this.controller,
    required this.taskDate,
    required this.onDateChanged,
  });

  @override
  State<EditTask> createState() => _EditTaskState();
}

class _EditTaskState extends State<EditTask> {
  //local storage for storing date time
  late DateTime tempDateTimeOfTask;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    tempDateTimeOfTask = widget.taskDate;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.white,
      content: Container(
        height: 180,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            TextField(
              controller: widget.controller,
              decoration: InputDecoration(
                hint: Text("Edit Task", textAlign: TextAlign.left),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(),
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.only(left: 5, right: 5),
              margin: EdgeInsets.only(top: 8),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.all(Radius.circular(12)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    // tempDateTimeOfTask.toString()
                    DateFormat('hh:mm a MMM  d ').format(tempDateTimeOfTask),
                    ),
                  IconButton(
                    onPressed: () {
                      DatePicker.showDateTimePicker(
                        context,
                        showTitleActions: true,
                        minTime: DateTime.now(),
                        maxTime: DateTime(2026, 6, 7),
                        onChanged: (date) {
                          print('change $date');
                        },
                        onConfirm: (date) {
                          setState(() {
                            tempDateTimeOfTask = date;
                          });
                          widget.onDateChanged(tempDateTimeOfTask);
                        },
                        currentTime: DateTime.now(),
                        locale: LocaleType.en,
                      );
                    },
                    icon: Icon(Icons.timer_sharp, color: Colors.black),
                  ),
                ],
              ),
            ),
            //Action buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                //cancel button
                ActionButton(
                  buttonName: "Cancel",
                  onPressed: widget.onCancel,
                  buttonColor: Colors.redAccent,
                ),
                //Add button
                ActionButton(
                  buttonName: "Edit",
                  onPressed: widget.onEdit,
                  buttonColor: Colors.green,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
