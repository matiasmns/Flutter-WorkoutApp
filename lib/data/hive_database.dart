import 'package:flutter_workout/datetime/date_time.dart';
import 'package:flutter_workout/models/exercise.dart';
import 'package:flutter_workout/models/workout.dart';
import 'package:hive_flutter/hive_flutter.dart';

class HiveDataBase {
  //reference hive box ----(PARTE 3)----
  final _myBox = Hive.box("workout_database1");

  //check si la data esta en la store
  bool previousDataExists() {
    if (_myBox.isEmpty) {
     
      _myBox.put("START_DATE", todaysDateYYYYMMDD());
      return false;
    } else {
      
      return true;
    }
  }

  //return data como yyyymmdd
  String getStartDate() {
    return _myBox.get("START_DATE");
  }

  //write data
  void saveToDatebase(List<Workout> workouts) {
    //
    final workoutList = convertObjectToWorkoutList(workouts);
    final exerciseList = convertObjectToExerciseList(workouts);

    //
    if (exerciseCompleted(workouts)) {
      _myBox.put("COMPLETION_STATUS_${todaysDateYYYYMMDD()}", 1);
    } else {
      _myBox.put("COMPLETION_STATUS_${todaysDateYYYYMMDD()}", 0);
    }

    //save into hive
    _myBox.put("WORKOUTS", workoutList);
    _myBox.put("EXERCISES", exerciseList);
  }

  //read data AND return a list of workouts
  List<Workout> readFromDataBase() {
    List<Workout> mySavedWorkouts = [];

    List<String> workoutNames = _myBox.get("WORKOUTS");
    final exerciseDetails = _myBox.get("EXERCISES");

    //Create workout object
    for (int i = 0; i < workoutNames.length; i++) {
      //each workout can have multiples exercises
      List<Exercise> exercisesInEachWorkout = [];
      for (int j = 0; j < exerciseDetails[i].length; j++) {
        //
        exercisesInEachWorkout.add(
          Exercise(
            name: exerciseDetails[i][j][0],
            weight: exerciseDetails[i][j][1],
            reps: exerciseDetails[i][j][2],
            sets: exerciseDetails[i][j][3],
            isCompleted: exerciseDetails[i][j][4] == "true" ? true : false,
          ),
        );
      }

      //Create a individual workout
      Workout workout =
          Workout(name: workoutNames[i], exercises: exercisesInEachWorkout);
      //add individual workout to overall list
      mySavedWorkouts.add(workout);
    }

    return mySavedWorkouts;
  }

  //check si el workout is done

  bool exerciseCompleted(List<Workout> workouts) {
    //
    for (var workout in workouts) {
      for (var exercise in workout.exercises) {
        if (exercise.isCompleted) {
          return true;
        }
      }
    }
    return false;
  }

  //return completion status of a given date yyyymmdd
  int getCompletionStatus(String yyyymmdd) {
    int completionStatus = _myBox.get("COMPLETION_STATUS_$yyyymmdd") ?? 0;
    return completionStatus;
  }
}

// convert workout object into a list ----(PARTE 1)----
List<String> convertObjectToWorkoutList(List<Workout> workouts) {
  List<String> workoutList = [
    //
  ];

  for (int i = 0; i < workouts.length; i++) {
    workoutList.add(
      workouts[i].name,
    );
  }
  return workoutList;
}

//converts the exercises in a workout object into a list of string ----(PARTE 2)----
List<List<List<String>>> convertObjectToExerciseList(List<Workout> workouts) {
  List<List<List<String>>> exerciseList = [
    //

    //
  ];

  //go through each workout
  for (int i = 0; i < workouts.length; i++) {
    //get
    List<Exercise> exercisesInWorkout = workouts[i].exercises;

    List<List<String>> individualWorkout = [
      //

      //
    ];

// go though each exercise in exerciselist
    for (int j = 0; j < exercisesInWorkout.length; j++) {
      List<String> individualExercise = [
        //bicep,kg,reps,sets
      ];
      individualExercise.addAll(
        [
          exercisesInWorkout[j].name,
          exercisesInWorkout[j].weight,
          exercisesInWorkout[j].reps,
          exercisesInWorkout[j].sets,
          exercisesInWorkout[j].isCompleted.toString(),
        ],
      );
      individualWorkout.add(individualExercise);
    }

    exerciseList.add(individualWorkout);
  }
  return exerciseList;
}
