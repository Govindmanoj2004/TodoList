import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

// ignore: must_be_immutable
class TodoTile extends StatelessWidget {
  final String taskName;
  final bool taskState;
  final DateTime taskDateTime;
  Function(bool?)? onChanged;
  Function(BuildContext)? deleteTask;
  Function(BuildContext)? editTask;

  TodoTile({
    super.key,
    required this.taskName,
    required this.taskState,
    required this.onChanged,
    required this.deleteTask,
    required this.editTask,
    required this.taskDateTime,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 25, left: 25, right: 25),
      child: Slidable(
        endActionPane: ActionPane(
          motion: DrawerMotion(),
          children: [
            if (!taskState) ...[
              SlidableAction(
                onPressed: editTask,
                icon: Icons.edit,
                backgroundColor: Colors.green.shade400,
                borderRadius: BorderRadius.all(Radius.circular(12)),
              ),
            ],
            SlidableAction(
              onPressed: deleteTask,
              icon: Icons.delete,
              backgroundColor: Colors.red.shade400,
              borderRadius: BorderRadius.all(Radius.circular(12)),
            ),
          ],
        ),
        child: AnimatedContainer(
          padding: EdgeInsets.all(24),
          duration: Duration(milliseconds: 300),
          curve: Curves.ease,
          decoration: BoxDecoration(
            color: taskState
                ? Colors.teal[400] // Checked task
                : DateTime.now().isAfter(taskDateTime)
                ? Colors.grey[400] // Missed task
                : Colors.blue[300],

            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              Checkbox(
                value: taskState,
                onChanged: onChanged,
                activeColor: Colors.white,
                checkColor: Colors.blue[300],
                side: WidgetStateBorderSide.resolveWith(
                  (states) => BorderSide(width: 2.0, color: Colors.white),
                ),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  //Task name
                  Padding(
                    padding: EdgeInsets.only(bottom: taskState ? 3 : 1),
                    child: Text(
                      taskName,
                      style: GoogleFonts.abel(
                        color: Colors.white,
                        fontSize: 16,
                        decoration: taskState
                            ? TextDecoration.lineThrough
                            : TextDecoration.none,
                      ),
                    ),
                  ),
                  //Task date
                  if (!taskState) ...[
                    Text(
                      DateFormat('hh:mm a MMM  d ').format(taskDateTime),
                      style: GoogleFonts.abel(
                        color: Colors.white,
                        fontSize: 11,
                      ),
                    ),
                  ],
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
