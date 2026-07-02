import 'package:flutter/material.dart';

class PremiumDialog extends StatelessWidget {
  const PremiumDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      title: const Row(
        children: [
          Icon(Icons.star, color: Colors.amber),
          SizedBox(width: 10),
          Text('Upgrade to Premium'),
        ],
      ),
      content: const Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'You have reached the free limit of 3 saved books on Reference Radar.',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 12),
          Text('Unlock Premium for just RM 9.90/month to get:'),
          SizedBox(height: 8),
          Text(
            '• Unlimited reference bookmarks\n• Offline study access\n• Ad-free research experience',
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context, false);
          },
          child: const Text('Stay Free', style: TextStyle(color: Colors.grey)),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.amber,
            foregroundColor: Colors.black,
          ),
          onPressed: () {
            Navigator.pop(context, true);
          },
          child: const Text('Upgrade Now (RM 9.90)'),
        ),
      ],
    );
  }
}
