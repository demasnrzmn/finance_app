import 'package:flutter/material.dart';

class NotificationScreen extends StatelessWidget {
  final List<String> notifications;

  const NotificationScreen({super.key, required this.notifications});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications'),
        backgroundColor: const Color(0xFF0D47A1),
        foregroundColor: Colors.white,
      ),
      body: notifications.isEmpty
          ? const Center(
              child: Text(
                'Tidak ada notifikasi baru.',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            )
          : ListView.builder(
              itemCount: notifications.length,
              itemBuilder: (context, index) {
                return ListTile(
                  leading: const Icon(Icons.info_outline, color: Colors.blue),
                  title: Text(notifications[index]),
                  subtitle: Text('New - ${DateTime.now().hour}:${DateTime.now().minute}'),
                  onTap: () {
                    
                  },
                );
              },
            ),
    );
  }
}