import 'package:flutter/material.dart';

class ProgressCard extends StatelessWidget {
  final String valueDay;
  final String titleDay;
  final String subtitleDay;
  final double progressBar;
  final String progressBarLabel;

  const ProgressCard({
    super.key,
    required this.valueDay,
    required this.titleDay,
    required this.subtitleDay,
    required this.progressBar,
    required this.progressBarLabel,
  });
   @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(color: Color(0xEEE3F3FA)),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                valueDay,
                style: const TextStyle(
                  fontSize: 35,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      titleDay,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                    Text(
                      subtitleDay,
                      style: const TextStyle(color: Colors.black54, fontSize:12),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
           ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: LinearProgressIndicator(
              value: progressBar,
              minHeight: 12,
              backgroundColor: Colors.grey.shade300,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Text(
                '${(progressBar * 100).round()} %',
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  progressBarLabel,
                  style: const TextStyle(color: Colors.black54, fontSize: 12),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}