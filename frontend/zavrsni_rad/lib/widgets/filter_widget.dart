import 'package:flutter/material.dart';
import '../models/constants/constants.dart' as constants;

class FilterWidget extends StatelessWidget {
  const FilterWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double availableWidth = MediaQuery.of(context).size.width - 20;
    return Row(
      children: [
        Container(
          child: const TextField(
            decoration: InputDecoration(
              filled: true,
              hintText: "Search",
              prefixIcon: Icon(Icons.search),
              fillColor: Color.fromARGB(64, 158, 158, 158),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(100),
                ),
                borderSide: BorderSide(
                  style: BorderStyle.solid,
                ),
              ),
            ),
          ),
          width: availableWidth * 3 / 4,
          margin: const EdgeInsets.only(right: 10),
        ),
        const InkWell(
          child: Icon(
            Icons.filter_alt_rounded,
            color: constants.grey,
          ),
        ),
      ],
      mainAxisAlignment: MainAxisAlignment.center,
    );
  }
}
