import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class MedicationIntakeScreen extends StatelessWidget {
  final CollectionReference _medicationsRef =
      FirebaseFirestore.instance.collection('medication_reminder');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Medication Intake"),
        centerTitle: true,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color.fromARGB(255, 255, 223, 88),
                Color.fromARGB(255, 255, 153, 51),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _medicationsRef.snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text("No medication data available."));
          }

          var medications = snapshot.data!.docs;

          return ListView.builder(
            itemCount: medications.length,
            itemBuilder: (context, index) {
              var medication = medications[index];
              var data = medication.data() as Map<String, dynamic>;

              bool confirmed = data['confirmedByUser'] ?? false;
              String medicationName = data['medicationName'] ?? "Unknown";
              String dosageSchedule = data['dosageSchedule'] ?? "N/A";

              // ✅ Fix: Convert String Timestamp to DateTime safely
              DateTime? confirmationDateTime;
              if (data['confirmationTimestamp'] is Timestamp) {
                confirmationDateTime =
                    (data['confirmationTimestamp'] as Timestamp).toDate();
              } else if (data['confirmationTimestamp'] is String) {
                try {
                  confirmationDateTime =
                      DateTime.parse(data['confirmationTimestamp']);
                } catch (e) {
                  confirmationDateTime = null;
                }
              }

              DateTime? reminderDateTime;
              if (data['reminderTime'] is Timestamp) {
                reminderDateTime = (data['reminderTime'] as Timestamp).toDate();
              } else if (data['reminderTime'] is String) {
                try {
                  reminderDateTime = DateTime.parse(data['reminderTime']);
                } catch (e) {
                  reminderDateTime = null;
                }
              }

              // Format timestamps for display
              String formattedConfirmationTime = confirmationDateTime != null
                  ? DateFormat('dd MMM yyyy, hh:mm a')
                      .format(confirmationDateTime)
                  : "Not Taken";

              String formattedReminderTime = reminderDateTime != null
                  ? DateFormat('dd MMM yyyy, hh:mm a').format(reminderDateTime)
                  : "No Reminder Set";

              return Card(
                margin: const EdgeInsets.all(10),
                child: ListTile(
                  title: Text(medicationName,
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Dosage: $dosageSchedule"),
                      Text("Reminder: $formattedReminderTime"),
                      Text("Status: ${confirmed ? '✅ Taken' : '❌ Not Taken'}"),
                    ],
                  ),
                  trailing: Text(
                    confirmed
                        ? "Taken at:\n$formattedConfirmationTime"
                        : "Not Taken Yet",
                    textAlign: TextAlign.right,
                    style:
                        TextStyle(color: confirmed ? Colors.green : Colors.red),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
