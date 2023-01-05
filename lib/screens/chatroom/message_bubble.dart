import 'package:flutter/material.dart';

class MessageBubble extends StatelessWidget {
  const MessageBubble({
    Key? key,
    required this.text,
    required this.time,
    required this.isCurrentUser,
  }) : super(key: key);
  final String text;
  final String time;
  final bool isCurrentUser;

  @override
  Widget build(BuildContext context) {
    return Padding(
      // asymmetric padding
      padding: EdgeInsets.fromLTRB(
        isCurrentUser ? 64.0 : 16.0,
        4,
        isCurrentUser ? 16.0 : 64.0,
        4,
      ),
      child: Align(
        // align the child within the container
        alignment: isCurrentUser ? Alignment.centerRight : Alignment.centerLeft,
        child: DecoratedBox(
          // chat bubble decoration
          decoration: BoxDecoration(
            color: isCurrentUser ? Colors.blue : Colors.grey[300],
            borderRadius: isCurrentUser
                            ? const BorderRadius.only(
                                      topLeft: Radius.circular(24),
                                      bottomLeft: Radius.circular(24),
                                      bottomRight: Radius.circular(24)
                                    )
                            : const BorderRadius.only(
                                      topRight: Radius.circular(24),
                                      bottomLeft: Radius.circular(24),
                                      bottomRight: Radius.circular(24)
                                    ),
          ),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(12, 12, 12, 8),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Flexible(
                  child: Text(
                    text,
                    style: Theme.of(context).textTheme.bodyText1!.copyWith(
                        color: isCurrentUser ? Colors.white : Colors.black87),
                  ),
                ),
                const SizedBox(width: 6),
                Text(
                  time,
                  style: Theme.of(context).textTheme.bodyText1!.copyWith(
                      color: isCurrentUser ? Colors.grey.shade200 : Colors.grey.shade800, fontSize: 10),
                )
              ],
            )
          ),
        ),
      ),
    );
  }
}
