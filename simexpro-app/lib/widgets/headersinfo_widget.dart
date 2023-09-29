import 'package:flutter/material.dart';

class HeadersInfoWidget extends StatelessWidget{
  final String title;
  final String text;

  const HeadersInfoWidget({
    Key? key,
    required this.text,
    required this.title
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => Text.rich(
    TextSpan(
      text: title,
      style: const TextStyle(
        color: Colors.grey,
      ),
      children: <TextSpan>[
        TextSpan(text: "\n$text",
                  style: const TextStyle(
                  color: Colors.black,
                ),
        )
      ]
    )
  );
} 