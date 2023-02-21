import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:testingfb/DatesPage.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'myButton.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _titleController = TextEditingController();
  final _dateController = TextEditingController();
  final FirebaseAuth auth = FirebaseAuth.instance;

  void signUserOut() {
    auth.signOut();
  }

  void _saveReminder() async {
    print(_titleController.text);
    print(_dateController.text);

    if (_titleController.text.trim().isEmpty || _dateController.text.trim().isEmpty) {
      showErrorMessage("Fields should not be empty");
    } else {
      Navigator.pop(context);

      Map<String, dynamic> data = {
        "date": _dateController.text,
        "title": _titleController.text,
      };

      try {
        await FirebaseFirestore.instance.collection("reminders").add(data);

        //clear the fields
        _titleController.clear();
        _dateController.clear();


        Fluttertoast.showToast(
          msg: 'Reminder saved successfully!',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.grey[500],
          textColor: Colors.white,
          fontSize: 16.0,
        );

      } on FirebaseFirestore catch (error) {
        showErrorMessage("Try again");
      }
    }
  }

  Future<List<String>> _fetchDatesFromFirebase() async {
    final snapshots = await FirebaseFirestore.instance.collection('reminders').get();

    final dates = snapshots.docs.map((doc) => doc.data()['date'].toString()).toList();

    return dates;
  }

  Future<void> _navigateToDatesPage() async {
    List<String> storedDates = await _fetchDatesFromFirebase();

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DatesPage(storedDates: storedDates),
      ),
    );
  }

  void _openReminderForm(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextFormField(
                  controller: _titleController,
                  decoration: InputDecoration(
                    labelText: 'Title',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a title';
                    }
                    return null;
                  },
                ),
                GestureDetector(
                  onTap: () async {
                    DateTime? picked = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(2015, 8),
                      lastDate: DateTime(2101),
                    );
                    if (picked != null) {
                      _dateController.text = DateFormat.yMd().format(picked);
                    }
                  },
                  child: AbsorbPointer(
                    child: TextFormField(
                      controller: _dateController,
                      decoration: InputDecoration(
                        labelText: 'Date',
                      ),
                      validator: (value) {
                        if (value == null || value
                            .isEmpty) {
                          return 'Please enter a date';
                        }
                        return null;
                      },
                    ),
                  ),
                ),
                myButton(onTap: _saveReminder, text: "Save Reminder")
              ],
            ),
          ),
        );
      },
    );
  }

  void showErrorMessage(String message){
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            backgroundColor: Colors.grey,
            title: Center(
              child: Text(
                message,
              ),
            ),
          );
        }
    );
  }


  @override
  Widget build(BuildContext context) {
    final user = auth.currentUser!;
    return Scaffold(
      backgroundColor: Colors.grey[300],
      appBar: AppBar(
        backgroundColor: Colors.deepPurpleAccent,
        actions: [
          IconButton(onPressed: signUserOut, icon: Icon(Icons.logout))
        ],
      ),
      body: Container(
        child: Column(
          children: [
            Text("Welcome back " + user.email!),

          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _openReminderForm(context),
        child: Icon(Icons.add),
        backgroundColor: Colors.deepPurpleAccent,
      ),
      // New button added here
      bottomNavigationBar: BottomAppBar(
        color: Colors.grey[300],
        child: Container(
          height: 50,
          padding: const EdgeInsets.only(left: 16.0, right: 16, bottom: 8),
          child: ElevatedButton(
            onPressed: _navigateToDatesPage,
            style: ElevatedButton.styleFrom(
              primary: Colors.deepPurpleAccent,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: Text(
              'View Saved Reminders',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),

    );
  }
}
