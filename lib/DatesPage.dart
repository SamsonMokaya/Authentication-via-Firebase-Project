import 'package:flutter/material.dart';

class DatesPage extends StatelessWidget {
  final List<String> storedDates;

  const DatesPage({required this.storedDates});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueGrey[800],
        title: Text('Dates'),
      ),
      body: ListView.builder(
        itemCount: storedDates.length,
        itemBuilder: (BuildContext context, int index) {
          return Card(
            color: Colors.grey[300],
            child: ListTile(
              title: Text(
                storedDates[index],
                style: TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              subtitle: Text(
                'This date has been reached!',
                style: TextStyle(
                  fontSize: 14.0,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
