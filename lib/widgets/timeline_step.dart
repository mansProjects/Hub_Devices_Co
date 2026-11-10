import 'package:flutter/material.dart';

class TimelineStep {
  final String title;
  final String subtitle;

  const TimelineStep({
    required this.title, 
    required this.subtitle});
}

class TimelineCard extends StatelessWidget {
  final List<TimelineStep> steps;
  final int reachedSteps;

  const TimelineCard({
    super.key,
    required this.steps,
    required this.reachedSteps,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade400),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          for (int i = 0; i < steps.length; i++) _buildStep(i),
        ],
      ),
    );
  }

  Widget _buildStep(int index) {
    final step = steps[index];
    final bool isReached = index < reachedSteps;
    final bool isLast = index == steps.length - 1;
    final bool nextIsReached = index + 1 < reachedSteps;

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Column(
            children: [
              Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isReached ? Colors.green : Colors.white,
                  border: Border.all(
                    color: isReached ? Colors.green : Colors.grey.shade400,
                    width: 2,
                  ),
                ),
                child: isReached
                    ? const Icon(Icons.check, size: 14, color: Colors.white)
                    : null,
              ),
              if (!isLast)
                Expanded(
                  child: Container(
                    width: 3,
                    color: nextIsReached
                        ? Colors.green
                        : Colors.grey.shade300,
                  ),
                ),
            ],
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(bottom: isLast ? 0 : 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    step.title,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                      color: isReached ? Colors.black : Colors.black45,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    step.subtitle,
                    style: const TextStyle(color: Colors.black54, fontSize: 12),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}