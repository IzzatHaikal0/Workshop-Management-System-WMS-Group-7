// ListSchedulePage.dart
import 'package:flutter/material.dart';

class SchedulePage extends StatelessWidget {
  const SchedulePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Foreman Schedule Page')),
      body: Container(
        color: Colors.white,
        padding: EdgeInsets.all(10),
        child: ListView(children: [

          //CURRENT SCHEDULE TITLE
          Padding(
            padding: EdgeInsets.symmetric(vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Current Schedule',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),

                //ADD SCHEDULE BUTTON (DIRECT TO ADD SCHEDULE PAGE)
               OutlinedButton(
                  onPressed: () {
                    print('Add button tapped');
                  },
                  style: OutlinedButton.styleFrom(
                    padding: EdgeInsets.all(10),
                    side: BorderSide(color: Color.fromARGB(255, 0, 163, 212), width: 2),
                    foregroundColor: Color.fromARGB(255, 95, 77, 172),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  child: Text(
                    'Add',
                    style: TextStyle(fontSize: 16),
                  ),
                ),

              ],
            ),
          ),


          //START OF SCHEDULE LIST 
          Card(
            child: ListTile(
              title: Text('Schedule 1'),
              subtitle: Text ('Date Schedule'),
              trailing: Icon(Icons.arrow_forward),
              leading: Icon(Icons.calendar_today),
              contentPadding: EdgeInsets.all(10),
              dense: true,
              onTap: () {print('schedule  tapped');},
            ),
          ),
          Card(
            child: ListTile(
              title: Text('Schedule 2'),
              subtitle: Text ('Date Schedule 2'),
              trailing: Icon(Icons.arrow_forward),
              leading: Icon(Icons.calendar_today),
              contentPadding: EdgeInsets.all(10),
              dense: true,
              onTap: () {print('schedule  tapped');},
            ),
          ),
          Card(
            child: ListTile(
              title: Text('Schedule 2'),
              subtitle: Text ('Date Schedule 2'),
              trailing: Icon(Icons.arrow_forward),
              leading: Icon(Icons.calendar_today),
              contentPadding: EdgeInsets.all(10),
              dense: true,
              onTap: () {print('schedule  tapped');},
            ),
          ),
          Card(
            child: ListTile(
              title: Text('Schedule 2'),
              subtitle: Text ('Date Schedule 2'),
              trailing: Icon(Icons.arrow_forward),
              leading: Icon(Icons.calendar_today),
              contentPadding: EdgeInsets.all(10),
              dense: true,
              onTap: () {print('schedule  tapped');},
            ),
          ),
          Card(
            child: ListTile(
              title: Text('Schedule 2'),
              subtitle: Text ('Date Schedule 2'),
              trailing: Icon(Icons.arrow_forward),
              leading: Icon(Icons.calendar_today),
              contentPadding: EdgeInsets.all(10),
              dense: true,
              onTap: () {print('schedule  tapped');},
            ),
          ),
          Card(
            child: ListTile(
              title: Text('Schedule 2'),
              subtitle: Text ('Date Schedule 2'),
              trailing: Icon(Icons.arrow_forward),
              leading: Icon(Icons.calendar_today),
              contentPadding: EdgeInsets.all(10),
              dense: true,
              onTap: () {print('schedule  tapped');},
            ),
          ),
        ], 
        ),
      ),
    );
  }
}
