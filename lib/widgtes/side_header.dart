import 'package:flutter/material.dart';

class SideHeader extends StatelessWidget {
  final String letter;

  const SideHeader(this.letter, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(
      horizontal: 8.0,
      vertical: 4.0,
    ),
    child: Align(
      alignment: Alignment.centerLeft,
      child: SizedBox(
        height: 56,
        width: 56,
        child: Center(
          child: Text(
            // friends.first.substring(0, 1),
            letter,
            style: Theme.of(context).textTheme.headline5?.copyWith(
              color: Colors.grey,
            ),
          ),
        ),
      ),
    ),
  );
}