import 'package:flutter/material.dart';
import '../models/constants/constants.dart' as constants;

class PaginationWidget extends StatefulWidget {
  final int maxPages;
  final int currentPage;
  final void Function(int) pageChange;

  const PaginationWidget(
      {Key? key,
      required this.maxPages,
      required this.currentPage,
      required this.pageChange})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _PaginationWidgetState();
  }
}

class _PaginationWidgetState extends State<PaginationWidget> {
  int currentInput = 0;
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Padding(
          padding: const EdgeInsets.all(5),
          child: IconButton(
            icon: const Icon(Icons.chevron_left_rounded),
            onPressed: () {
              if (widget.currentPage <= 2) return;
              widget.pageChange(widget.currentPage - 1);
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(5),
          child: SizedBox(
            width: MediaQuery.of(context).size.width / 8,
            height: MediaQuery.of(context).size.width / 8,
            child: TextField(
              keyboardType: TextInputType.number,
              onChanged: (newValue) => currentInput = int.parse(newValue),
              onEditingComplete: () {
                if (currentInput <= 0 || currentInput > widget.maxPages) {
                  return;
                }
                widget.pageChange(currentInput);
              },
              decoration: const InputDecoration(
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
            onPressed: () {
              if (widget.currentPage >= widget.maxPages) return;
              widget.pageChange(widget.currentPage + 1);
            },
          ),
        ),
      ],
      mainAxisAlignment: MainAxisAlignment.spaceAround,
    );
  }
}
