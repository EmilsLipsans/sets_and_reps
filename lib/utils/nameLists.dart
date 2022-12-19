import 'package:gtk_flutter/pages/workout_create.dart';
import 'package:gtk_flutter/pages/workouts.dart';

List<Exrecises> updateList(Workout workout, List<Exrecises> exercises) {
  List<Exrecises> list = [];
  for (var count = 0; count < workout.exerciseRef.length; count++)
    for (var value in exercises) {
      if (value.docID == workout.exerciseRef[count])
        list.add(Exrecises(
            docID: value.docID,
            name: value.name,
            url: value.url,
            description: value.description,
            category: value.category));
      continue;
    }
  return list;
}

List<String> workoutNames(recordedWorkouts, workouts) {
  List<String> list = [];
  for (var count = 0; count < recordedWorkouts.length; count++) {
    for (var value in workouts) {
      if (value.docID == recordedWorkouts[count].workoutID) {
        list.add(value.name);
        break;
      }
      if (workouts.indexOf(value) == workouts.length - 1) {
        list.add('[Deleted]');
      }
    }
  }
  return list;
}

String workoutName(workoutID, workouts) {
  for (var value in workouts) if (workoutID == value.docID) return value.name;
  return '[Deleted]';
}
