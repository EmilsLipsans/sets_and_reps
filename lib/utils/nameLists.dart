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
