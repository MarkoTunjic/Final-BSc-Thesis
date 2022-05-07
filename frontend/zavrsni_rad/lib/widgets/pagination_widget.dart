import 'package:flutter/material.dart';
import '../models/constants/constants.dart' as constants;

class PaginationWidget extends StatelessWidget {
  final int maxPages;

  const PaginationWidget({Key? key, required this.maxPages}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Padding(
          padding: const EdgeInsets.all(5),
          child: IconButton(
            icon: const Icon(Icons.chevron_left_rounded),
            onPressed: () {},
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(5),
          child: SizedBox(
            width: MediaQuery.of(context).size.width / 8,
            height: MediaQuery.of(context).size.width / 8,
            child: const TextField(
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                fillColor: Color.fromARGB(64, 158, 158, 158),
                filled: true,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(20),
                  ),
                  borderSide: BorderSide(
                    color: constants.inputBorder,
                    style: BorderStyle.solid,
                    width: 2,
                  ),
                ),
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(5),
          child: IconButton(
            icon: const Icon(Icons.chevron_right_rounded),
            onPressed: () {},
          ),
        ),
      ],
      mainAxisAlignment: MainAxisAlignment.spaceAround,
    );
  }
}
