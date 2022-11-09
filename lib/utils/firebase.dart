// import 'dart:async';

// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'package:gtk_flutter/firebase_options.dart';

// class Categories {
//   Categories({required this.name});
//   final String name;
// }

// class Categoriesdata {
//   StreamSubscription<QuerySnapshot>? _categoriesListSubscription;
//   List<String> _categoriesList = [];
//   List<String> get categoriesList => _categoriesList;

//   Future<void> init() async {
//     Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

//     _categoriesListSubscription = FirebaseFirestore.instance
//         .collection('categories')
//         .orderBy('timestamp', descending: true)
//         .snapshots()
//         .listen((snapshot) {
//       _categoriesList = [];
//       for (final document in snapshot.docs) {
//         _categoriesList.add(
//           document.data()['name'] as String,
//         );
//       }
//     });
//   }

//   List<String> getCategoriesData() {
//     return categoriesList;
//   }
// }
