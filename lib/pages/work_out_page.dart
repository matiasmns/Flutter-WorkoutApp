import 'package:flutter/material.dart';
import 'package:flutter_workout/components/exercise_tile.dart';
import 'package:flutter_workout/data/workout_data.dart';
import 'package:provider/provider.dart';

class WorkoutPage extends StatefulWidget {
  final String workoutName;
  const WorkoutPage({super.key, required this.workoutName});

  @override
  State<WorkoutPage> createState() => _WorkoutPageState();
}

class _WorkoutPageState extends State<WorkoutPage> {
  //checkbox was tapped
  void onCheckBoxChanged(String workoutName, String exerciseName) {
    Provider.of<WorkoutData>(context, listen: false)
        .checkOffExercise(workoutName, exerciseName);
  }

  //text controller
  final excersiceNameController = TextEditingController();
  final weightNameController = TextEditingController();
  final repsNameController = TextEditingController();
  final setsNameController = TextEditingController();

  //create a new excercise

  void createNewExercise() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Agregar nuevo ejercicio'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            //Exercise name
            TextField(
              controller: excersiceNameController,
            ),

            //Weight
            TextField(
              controller: weightNameController,
            ),

            //reps

            TextField(
              controller: repsNameController,
            ),

            //Sets

            TextField(
              controller: setsNameController,
            ),
          ],
        ),

        //action buttons
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

  //save workout
  void save() {
    // Get el name del Workout del textcontroller
    String newExerciseName = excersiceNameController.text;
    String weight = weightNameController.text;
    String reps = repsNameController.text;
    String sets = setsNameController.text;
    // add workout to workoutdata list
    Provider.of<WorkoutData>(context, listen: false)
        .addExercise(widget.workoutName, newExerciseName, weight, reps, sets);

    //pop dialog box
    Navigator.pop(context);
    excersiceNameController.clear();

    weightNameController.clear();
    repsNameController.clear();
    setsNameController.clear();
  }

  //cancel workout

  void cancel() {
    //pop dialog box
    Navigator.pop(context);
    excersiceNameController.clear();
  }

  //

  @override
  Widget build(BuildContext context) {
    return Consumer<WorkoutData>(
      builder: ((context, value, child) => Scaffold(
            appBar: AppBar(
              title: Text(widget.workoutName,),
              backgroundColor: const Color.fromARGB(255, 7, 143, 255),
              foregroundColor: Colors.white,
              
            ),
            floatingActionButton: FloatingActionButton(
              onPressed: createNewExercise,
              child: Icon(Icons.add),
            ),
            body: ListView.builder(
                itemCount: value.numberOfExercisesInWorkOut(widget.workoutName),
                itemBuilder: (context, index) => ExerciseTile(
                      exerciseName: value
                          .getRelevantWorkout(widget.workoutName)
                          .exercises[index]
                          .name,
                      weight: value
                          .getRelevantWorkout(widget.workoutName)
                          .exercises[index]
                          .weight,
                      reps: value
                          .getRelevantWorkout(widget.workoutName)
                          .exercises[index]
                          .reps,
                      sets: value
                          .getRelevantWorkout(widget.workoutName)
                          .exercises[index]
                          .sets,
                      isCompleted: value
                          .getRelevantWorkout(widget.workoutName)
                          .exercises[index]
                          .isCompleted,
                      onCheckBoxChanged: (val) => onCheckBoxChanged(
                          widget.workoutName,
                          value
                              .getRelevantWorkout(widget.workoutName)
                              .exercises[index]
                              .name),
                    )),
          )),
    );
  }
}
