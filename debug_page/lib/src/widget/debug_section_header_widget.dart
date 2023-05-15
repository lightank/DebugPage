// Flutter imports:
import 'package:flutter/material.dart';

class DebugSectionHeaderWidget extends StatelessWidget {
  const DebugSectionHeaderWidget({Key? key, required this.title})
      : super(key: key);
  final String title;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 20, left: 20, right: 20, bottom: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
