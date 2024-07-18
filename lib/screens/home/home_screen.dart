import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  HomePage({Key? key}) : super(key: key);

  final Query dbRef = FirebaseDatabase.instance.reference().child('Attendance');

  Widget eventTypeContainer({required String eventType, required List<Map> entries}) {
    return Container(
      margin: const EdgeInsets.all(10),
      padding: const EdgeInsets.all(10),
      color: Colors.amberAccent,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Lesson Name: $eventType',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          Column(
            children: entries
                .map(
                  (entry) => listItem(
                attendance: entry,
              ),
            )
                .toList(),
          ),
        ],
      ),
    );
  }

  Widget listItem({required Map attendance}) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(10),
      color: Colors.amberAccent,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: [ const Text(
            'Name: ',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold), // Bold label
          ),
            Text(
              '${attendance['name']}',
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w400), // Original name value style
            ),],),

      const SizedBox(height: 5),
Row(children: [  const Text(
  'Time: ',
  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold), // Bold label
),
  Text(
    '${attendance['time']}',
    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w400), // Original time value style
  ),],),

      const SizedBox(height: 5),
      Row(children: [const Text(
        'Confidence: ',
        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold), // Bold label
      ),
        Text(
          '${attendance['confidence'].substring(0,2)}%',
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w400), // Original confidence value style
        ),],),


        ],

      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 40),
              Padding(
                padding: const EdgeInsets.all(20),
                child: Center(
                  child: Text(
                    "Attendance History",
                    style: Theme.of(context)
                        .textTheme
                        .headlineMedium!
                        .copyWith(color: Colors.black, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              SizedBox(
                height: 500,
                child: FirebaseAnimatedList(
                  query: dbRef,
                  itemBuilder: (BuildContext context, DataSnapshot snapshot,
                      Animation<double> animation, int index) {
                    // Get the event type (IOT, ME101, etc.)
                    String? eventType = snapshot.key;

                    // Get the attendance data for the specific event type
                    Map attendanceData = snapshot.value as Map;

                    // Create a list of entries for the event type
                    List<Map> entries = attendanceData.entries
                        .map(
                          (entry) => {
                        'name': entry.value['name'],
                        'time': entry.value['time'],
                        'confidence': entry.value['confidence'],
                      },
                    )
                        .toList();

                    // Build the container for the event type
                    return eventTypeContainer(eventType: eventType!, entries: entries);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
