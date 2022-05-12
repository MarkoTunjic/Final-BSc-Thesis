import 'package:flutter/material.dart';
import 'package:zavrsni_rad/widgets/ingredient_filter_widget.dart';
import 'package:zavrsni_rad/widgets/input_field_widget.dart';
import '../models/constants/constants.dart' as constants;
import '../models/filter.dart';

class FilterWidget extends StatefulWidget {
  final void Function(String)? onChanged;
  final void Function()? onEditingcomplete;
  final void Function() onSubmit;
  final String? initialValue;
  final Filter filter;
  final bool showFilterIcon;

  const FilterWidget({
    Key? key,
    this.onChanged,
    this.initialValue,
    this.onEditingcomplete,
    required this.filter,
    required this.onSubmit,
    required this.showFilterIcon,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _FilterWidgetState();
  }
}

class _FilterWidgetState extends State<FilterWidget> {
  String currentMustContainInput = "";
  String currentMustNotContainInput = "";
  double _currentSliderValue = 30;
  late Filter filter;

  @override
  Widget build(BuildContext context) {
    filter = widget.filter;
    double availableWidth = MediaQuery.of(context).size.width - 20;
    return Row(
      children: [
        Container(
          child: TextFormField(
            onChanged: widget.onChanged,
            onEditingComplete: widget.onEditingcomplete,
            initialValue: widget.initialValue,
            decoration: const InputDecoration(
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
        widget.showFilterIcon
            ? InkWell(
                child: const Icon(
                  Icons.filter_alt_rounded,
                  color: constants.grey,
                ),
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return Column(
                        children: [
                          StatefulBuilder(
                            builder: (context, setState) {
                              return Dialog(
                                insetPadding: const EdgeInsets.all(0),
                                shape: const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(20),
                                    topRight: Radius.circular(20),
                                  ),
                                ),
                                child: Container(
                                  width: MediaQuery.of(context).size.width,
                                  height:
                                      MediaQuery.of(context).size.height / 2,
                                  decoration: const BoxDecoration(
                                    borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(40),
                                      topRight: Radius.circular(40),
                                    ),
                                  ),
                                  child: ListView(
                                    children: [
                                      const Center(
                                        child: Padding(
                                          padding: EdgeInsets.only(
                                              bottom: 10, top: 10),
                                          child: Text(
                                            "Add a filter",
                                            style: TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold,
                                              color: constants.darkBlue,
                                            ),
                                          ),
                                        ),
                                      ),
                                      const Divider(),
                                      const Padding(
                                        padding: EdgeInsets.only(bottom: 10),
                                        child: Text(
                                          "Must contain ingredients:",
                                          style: TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold,
                                            color: constants.darkBlue,
                                          ),
                                        ),
                                      ),
                                      InputFieldWidget(
                                        hintText: "Ingredient name",
                                        obscure: false,
                                        width:
                                            MediaQuery.of(context).size.width -
                                                20,
                                        type: TextInputType.text,
                                        onEditingCompleted: () {
                                          if (currentMustContainInput
                                              .isNotEmpty) {
                                            setState(() {
                                              filter.canContainIngredients!
                                                  .add(currentMustContainInput);
                                            });
                                          }
                                        },
                                        onChanged: (newValue) =>
                                            currentMustContainInput = newValue,
                                      ),
                                      filter.canContainIngredients!.isNotEmpty
                                          ? SizedBox(
                                              width: MediaQuery.of(context)
                                                  .size
                                                  .width,
                                              height: MediaQuery.of(context)
                                                      .size
                                                      .height /
                                                  10,
                                              child: ListView.builder(
                                                itemCount: filter
                                                    .canContainIngredients!
                                                    .length,
                                                shrinkWrap: true,
                                                scrollDirection:
                                                    Axis.horizontal,
                                                itemBuilder: (context, index) {
                                                  return IngredientFilterWidget(
                                                    ingredientName: filter
                                                            .canContainIngredients![
                                                        index],
                                                    onDelete: () {
                                                      setState(() {
                                                        filter
                                                            .canContainIngredients!
                                                            .removeAt(index);
                                                      });
                                                    },
                                                  );
                                                },
                                              ),
                                            )
                                          : Container(),
                                      const Divider(),
                                      const Padding(
                                        padding: EdgeInsets.only(bottom: 10),
                                        child: Text(
                                          "Must not contain ingredients:",
                                          style: TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold,
                                            color: constants.darkBlue,
                                          ),
                                        ),
                                      ),
                                      InputFieldWidget(
                                        hintText: "Ingredient name",
                                        obscure: false,
                                        width:
                                            MediaQuery.of(context).size.width -
                                                20,
                                        type: TextInputType.text,
                                        onEditingCompleted: () {
                                          if (currentMustNotContainInput
                                              .isNotEmpty) {
                                            setState(() {
                                              filter.mustNotContaintIngredients!
                                                  .add(
                                                      currentMustNotContainInput);
                                            });
                                          }
                                        },
                                        onChanged: (newValue) =>
                                            currentMustNotContainInput =
                                                newValue,
                                      ),
                                      filter.mustNotContaintIngredients!
                                              .isNotEmpty
                                          ? SizedBox(
                                              width: MediaQuery.of(context)
                                                  .size
                                                  .width,
                                              height: MediaQuery.of(context)
                                                      .size
                                                      .height /
                                                  10,
                                              child: ListView.builder(
                                                itemCount: filter
                                                    .mustNotContaintIngredients!
                                                    .length,
                                                shrinkWrap: true,
                                                scrollDirection:
                                                    Axis.horizontal,
                                                itemBuilder: (context, index) {
                                                  return IngredientFilterWidget(
                                                    ingredientName: filter
                                                            .mustNotContaintIngredients![
                                                        index],
                                                    onDelete: () {
                                                      setState(() {
                                                        filter
                                                            .mustNotContaintIngredients!
                                                            .removeAt(index);
                                                      });
                                                    },
                                                  );
                                                },
                                              ),
                                            )
                                          : Container(),
                                      const Divider(),
                                      const Padding(
                                        padding: EdgeInsets.only(bottom: 10),
                                        child: Text(
                                          "Maximal cooking duration:",
                                          style: TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold,
                                            color: constants.darkBlue,
                                          ),
                                        ),
                                      ),
                                      Row(
                                        children: [
                                          "<0",
                                          "30",
                                          "60",
                                          "90",
                                          "120>"
                                        ]
                                            .map((e) => Text(
                                                  e,
                                                  style: const TextStyle(
                                                      color: constants.green,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ))
                                            .toList(),
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceAround,
                                      ),
                                      Slider(
                                        value: _currentSliderValue,
                                        max: 120,
                                        divisions: 4,
                                        min: 0,
                                        onChanged: (double value) {
                                          filter.maxCookingDuration =
                                              value.toInt();
                                          setState(() {
                                            _currentSliderValue = value;
                                          });
                                        },
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(top: 20),
                                        child: Row(
                                          children: [
                                            ElevatedButton(
                                              onPressed: () {
                                                filter.canContainIngredients =
                                                    null;
                                                filter.mustNotContaintIngredients =
                                                    null;
                                                filter.maxCookingDuration = 120;
                                                Navigator.pop(context);
                                              },
                                              child: SizedBox(
                                                child: const Text("Cancel",
                                                    textAlign:
                                                        TextAlign.center),
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width /
                                                    3,
                                              ),
                                              style: ButtonStyle(
                                                shape:
                                                    MaterialStateProperty.all(
                                                  RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            30),
                                                  ),
                                                ),
                                                backgroundColor:
                                                    MaterialStateProperty.all(
                                                  constants.grey,
                                                ),
                                              ),
                                            ),
                                            ElevatedButton(
                                              onPressed: () {
                                                widget.onSubmit();
                                                Navigator.pop(context);
                                              },
                                              child: SizedBox(
                                                child: const Text("Submit",
                                                    textAlign:
                                                        TextAlign.center),
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width /
                                                    3,
                                              ),
                                              style: ButtonStyle(
                                                shape:
                                                    MaterialStateProperty.all(
                                                  RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            30),
                                                  ),
                                                ),
                                                backgroundColor:
                                                    MaterialStateProperty.all(
                                                  constants.green,
                                                ),
                                              ),
                                            ),
                                          ],
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceAround,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        ],
                        mainAxisAlignment: MainAxisAlignment.end,
                      );
                    },
                  );
                },
              )
            : Container(),
      ],
      mainAxisAlignment: MainAxisAlignment.center,
    );
  }
}
