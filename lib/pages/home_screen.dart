import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:todo_notification/data/database.dart';
import 'package:todo_notification/utils/dialog_box.dart';
import 'package:todo_notification/utils/edit_task.dart';
import 'package:todo_notification/utils/todo_tile.dart';

// ignore: must_be_immutable
class HomeScreen extends StatefulWidget {
  HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  //reference the database class
  Database db = Database();

  //object for databse
  final _mybox = Hive.box("mybox");

  //datetime for picker
  late DateTime taskAlertTime = DateTime.now();

  //initalize the data
  @override
  void initState() {
    //first time openingthe app,the create the demo data
    if (_mybox.get("todolist") == null) {
      db.createStatupData();
    } else {
      db.loadData();
    }
    super.initState();
  }

  //Task state change method
  void checkBoxChanged(bool? value, int index) {
    setState(() {
      db.toDoTask[index][1] = !db.toDoTask[index][1];
    });
    db.updateData();
  }

  //new task controller
  final _controller = TextEditingController();

  //Add new task
  void newTaskSave() {
    setState(() {
      db.toDoTask.add([_controller.text, false, taskAlertTime]);
      //close alertbox
      Navigator.of(context).pop();
      //welcome task
      if (!db.toDoTask[0][1]) {
        if (db.toDoTask[0][0] == "Add a new task") {
          db.toDoTask[0][1] = !db.toDoTask[0][1];
        }
      }
    });
    db.updateData();
    _controller.clear();
  }

  //create new task(Dialog)
  void createNewTask() {
    showDialog(
      context: context,
      builder: (context) {
        return DialogBox(
          controller: _controller,
          onCancel: Navigator.of(context).pop,
          onSave: newTaskSave,
          onDateChanged: (date) {
            taskAlertTime = date;
            print('Date set $taskAlertTime ');
          },
          taskDate: taskAlertTime,
        );
      },
    );
  }

  //delete task
  void deleteTask(int index) {
    setState(() {
      db.toDoTask.removeAt(index);
    });
    db.updateData();
  }

  //open dialog for edit
  void editTask(int index) {
    showDialog(
      context: context,
      builder: (context) {
        return EditTask(
          controller: _controller,
          onCancel: () => Navigator.of(context).pop(),
          onEdit: () {
            editTaskName(index, _controller.text);
            Navigator.of(context).pop();
          },
          taskDate: taskAlertTime,
          onDateChanged: (date) {
            db.toDoTask[index][2] = date;
            db.updateData();
          },
        );
      },
    );
  }

  //method to edit
  void editTaskName(int index, String updatedName) {
    setState(() {
      db.toDoTask[index][0] = updatedName;
    });
    db.updateData();
    _controller.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,

        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.done),
            SizedBox(width: 5),
            Text(
              "TODO",
              //used google fonts
              style: GoogleFonts.aDLaMDisplay(
                fontWeight: FontWeight.bold,
                color: Colors.black,
                letterSpacing: 2,
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        shape: CircleBorder(),
        backgroundColor: Colors.blue[300],
        onPressed: createNewTask,
        child: Icon(Icons.add, color: Colors.white),
      ),
      body: ListView.builder(
        itemCount: db.toDoTask.length,
        itemBuilder: (context, index) {
          return TodoTile(
            taskName: db.toDoTask[index][0],
            taskState: db.toDoTask[index][1],
            taskDateTime: db.toDoTask[index][2],
            onChanged: (value) => checkBoxChanged(value, index),
            deleteTask: (context) => deleteTask(index),
            editTask: (context) => editTask(index),
          );
        },
      ),
    );
  }
}
