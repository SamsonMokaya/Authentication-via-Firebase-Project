import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:testingfb/myButton.dart';

class ReminderForm extends StatefulWidget {

  final Function()? onTap;

  ReminderForm({required this.onTap});

  @override
  _ReminderFormState createState() => _ReminderFormState();
}

class _ReminderFormState extends State<ReminderForm> {
  final _titleController = TextEditingController();
  final _dateController = TextEditingController();

  void _saveReminder() {
    print("Data saved");
  }

  @override
  Widget build(BuildContext context) {

    return Column(
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
            DateTime? date = await showDatePicker(
              context: context,
              initialDate: DateTime.now(),
              firstDate: DateTime.now(),
              lastDate: DateTime(3000),
            );
            if (date != null) {
              TimeOfDay? time = await showTimePicker(
                context: context,
                initialTime: TimeOfDay.now(),
              );
              if (time != null) {
                DateTime dateTime = DateTime(
                  date.year,
                  date.month,
                  date.day,
                  time.hour,
                  time.minute,
                );
                _dateController.text = DateFormat.yMd().add_jm().format(dateTime);
              }
            }
          },
          child: AbsorbPointer(
            child: TextFormField(
              controller: _dateController,
              decoration: InputDecoration(
                labelText: 'Date and Time',
              ),
            ),
          ),
        ),

        myButton(onTap: _saveReminder, text: "Save Reminder")
      ],
    );
  }
}
