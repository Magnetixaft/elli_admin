import 'package:flutter/material.dart';

class Faq extends StatefulWidget {
  const Faq({Key? key}) : super(key: key);

  @override
  State<Faq> createState() => _FaqState();
}

//Widget for selecting office, picking day, picking room and then booking a timeslot
class _FaqState extends State<Faq> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: const <Widget>[
        SizedBox(height: 10),
      ],
    );
  }
}
