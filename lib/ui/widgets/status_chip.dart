import 'package:flutter/material.dart';

import '../../models/connection_status.dart';

class StatusChip extends StatelessWidget {
  final ConnectionStatus status;

  const StatusChip({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    final c = status.color;
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: c.withAlpha(30),
        border: Border.all(color: c.withAlpha(100)),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (status == ConnectionStatus.connecting)
            SizedBox(
              width: 10,
              height: 10,
              child: CircularProgressIndicator(
                strokeWidth: 1.5,
                color: c,
              ),
            )
          else
            Icon(status.icon, size: 12, color: c),
          const SizedBox(width: 6),
          Text(
            status.label,
            style: TextStyle(color: c, fontSize: 12, fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }
}
