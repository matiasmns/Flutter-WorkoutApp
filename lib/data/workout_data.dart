import 'package:flutter/material.dart';
import 'package:flutter_workout/data/hive_database.dart';
import 'package:flutter_workout/models/exercise.dart';
import '../models/workout.dart';

class WorkoutData extends ChangeNotifier {
  final db = HiveDataBase();

//Estructura de datos del WorkoutData

  List<Workout> workoutList = [
    Workout(
      name: "Upper Body",
      exercises: [
        Exercise(name: "Workout Name", weight: "10", reps: "10", sets: "3"),
      ],
    ),
    Workout(
      name: "Lower Body",
      exercises: [
        Exercise(name: "Workout Name", weight: "10", reps: "10", sets: "3"),
      ],
    ),
  ];

  // if there are workout already in database, then get that workout list, otherwise (INICION DE LA BASE DE DATOS)
  void initializeWorkoutList() {
    if (db.previousDataExists()) {
      workoutList = db.readFromDataBase();
    }

    //otherwise use default workouts
    else {
      db.saveToDatebase(workoutList);
    }
  }

  //
  List<Workout> getWorkoutList() {
    return workoutList;
  }

  // get length of a given workout
  int numberOfExercisesInWorkOut(String workoutName) {
    Workout relevantWorkout = getRelevantWorkout(workoutName);

    return relevantWorkout.exercises.length;
  }

  //add a workout
  void addWorkout(String name) {
    //Add an excersive to a  workout
    workoutList.add(Workout(name: name, exercises: []));

    notifyListeners();

    //save to a data base
    db.saveToDatebase(workoutList);
  }

  //Add an excersive to a  workout
  void addExercise(String workoutName, String exerciseName, String weight,
      String reps, String sets) {
    // find the relevant workout
    Workout relevantWorkout = getRelevantWorkout(workoutName);

    relevantWorkout.exercises.add(
      Exercise(name: exerciseName, weight: weight, reps: reps, sets: sets),
    );

    notifyListeners();

    //save to a data base
    db.saveToDatebase(workoutList);
  }

  //check off exercise
  void checkOffExercise(String workoutName, String exerciseName) {
    //find the relevant workout y el relevant exercise in that workout
    Exercise relevantExercise = getRelevantExercise(workoutName, exerciseName);

    // check off boolean to show user completed the execise
    relevantExercise.isCompleted = !relevantExercise.isCompleted;
    print('tapped');

    notifyListeners();
    //save to a data base
    db.saveToDatebase(workoutList);
  }

  //return relevant workout object, given a workout name
  Workout getRelevantWorkout(String workoutName) {
    Workout relevantWorkout =
        workoutList.firstWhere((workout) => workout.name == workoutName);

    return relevantWorkout;
  }

  // return relevant exercise object, given a workout name + name
  Exercise getRelevantExercise(String workoutName, String exerciseName) {
    //find relevant workout first
    Workout relevantWorkout = getRelevantWorkout(workoutName);

    //then find the relevant exercise in that workout.
    Exercise relevantExercise = relevantWorkout.exercises
        .firstWhere((exercise) => exercise.name == exerciseName);

    return relevantExercise;
  }
}
