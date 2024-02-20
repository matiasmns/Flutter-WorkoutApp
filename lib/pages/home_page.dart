import 'package:flutter/material.dart';
import 'package:flutter_workout/data/workout_data.dart';
import 'package:provider/provider.dart';

import 'work_out_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    Provider.of<WorkoutData>(context, listen: false).initializeWorkoutList();
  }

  //Text Controller
  final newWorkoutNameController = TextEditingController();
  //create a new workout
  void createNewWorkout() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Crear nuevo WorkOut"),
        content: TextField(
          controller: newWorkoutNameController,
        ),
        actions: [
          //Save button
          MaterialButton(
            onPressed: save,
            child: Text("save"),
          ),

          //Cancel button
          MaterialButton(
            onPressed: cancel,
            child: Text("cancel"),
          ),
        ],
      ),
    );
  }

  //save workout
  void save() {
    // Get el name del Workout del textcontroller
    String newWorkoutName = newWorkoutNameController.text;
    // add workout to workoutdata list
    Provider.of<WorkoutData>(context, listen: false).addWorkout(newWorkoutName);

    //pop dialog box
    Navigator.pop(context);
    clear();
  }

  //cancel workout

  void cancel() {
    //pop dialog box
    Navigator.pop(context);
    clear();
  }

  //go to workout page

  void goToWorkoutPage(String workoutName) {
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => WorkoutPage(
            workoutName: workoutName,
          ),
        ));
  }

  //Clear controllers Field
  void clear() {
    newWorkoutNameController.clear();
  }

  //
  @override
  Widget build(BuildContext context) {
    return Consumer<WorkoutData>(
      builder: (context, value, child) => Scaffold(
        appBar: AppBar(
          title: const Text("Workout Tracker",
              style: TextStyle(fontWeight: FontWeight.w500)),
          backgroundColor: const Color.fromARGB(255, 7, 143, 255),
          foregroundColor: Colors.white,
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: createNewWorkout,
          child: Icon(Icons.add),
        ),
        body: ListView.builder(
            itemCount: value.getWorkoutList().length,
            itemBuilder: (context, index) => ListTile(
                title: Text(value.getWorkoutList()[index].name),
                trailing: IconButton(
                    icon: Icon(Icons.arrow_forward_ios),
                    onPressed: () =>
                        goToWorkoutPage(value.getWorkoutList()[index].name)))),
      ),
    );
  }
}
