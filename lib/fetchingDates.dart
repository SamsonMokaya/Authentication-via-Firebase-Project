import 'package:cloud_firestore/cloud_firestore.dart';

Future<List<String>> _fetchDatesFromFirebase() async {
  final now = DateTime.now();
  final today = DateTime(now.year, now.month, now.day);

  final snapshot = await FirebaseFirestore.instance.collection('reminders').get();
  final documents = snapshot.docs;
  final storedDates = documents.map((doc) => doc.get('date')).toList().cast<String>();

  final todayFormatted = '${today.month}/${today.day}/${today.year}';
  final matchingDates = storedDates.where((date) => date == todayFormatted).toList();

  return matchingDates;
}
