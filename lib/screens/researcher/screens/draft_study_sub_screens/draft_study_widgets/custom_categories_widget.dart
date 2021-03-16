import 'package:flutter/material.dart';
import 'package:thoughtnav/constants/color_constants.dart';
import 'package:thoughtnav/screens/researcher/models/categories.dart';
import 'package:thoughtnav/services/researcher_and_moderator_firestore_service.dart';

class CustomCategoriesWidget extends StatefulWidget {
  final String studyUID;
  final Categories categories;

  const CustomCategoriesWidget({Key key, this.studyUID, this.categories})
      : super(key: key);

  @override
  _CustomCategoriesWidgetState createState() => _CustomCategoriesWidgetState();
}

class _CustomCategoriesWidgetState extends State<CustomCategoriesWidget> {
  final _researcherAndModeratorFirestoreService =
  ResearcherAndModeratorFirestoreService();

  final List<CustomCategory> _customCategories = [];
  final List<TextEditingController> _controllers = [];

  int _totalCustomCategories = 1;

  @override
  void initState() {
    _customCategories.clear();
    _controllers.clear();
    _totalCustomCategories = 1;

    if (widget.categories.customCategories.isNotEmpty) {
      for (var category in widget.categories.customCategories) {
        _customCategories.add(CustomCategory.fromMap(category));
      }
    }

    if (_customCategories.isNotEmpty) {
      _totalCustomCategories = _customCategories.length;
      for (var customCategory in _customCategories) {
        var textEditingController = TextEditingController();
        textEditingController.text = customCategory.category;
        _controllers.add(textEditingController);
      }
    } else {
      _controllers.add(TextEditingController());
      _customCategories.add(CustomCategory(selected: false));
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.2,
          maxHeight: MediaQuery.of(context).size.height * 0.5,
        ),
        child: Material(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: Padding(
            padding: EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Make Custom Categories',
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 16.0,
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.of(context).pop();
                      },
                      child: Icon(
                        Icons.clear,
                        color: Colors.red[700],
                        size: 16.0,
                      ),
                      splashColor: Colors.transparent,
                      hoverColor: Colors.transparent,
                      focusColor: Colors.transparent,
                      highlightColor: Colors.transparent,
                    ),
                  ],
                ),
                SizedBox(
                  height: 20.0,
                ),
                Container(
                  height: 1.0,
                  width: double.maxFinite,
                  color: Colors.grey[300],
                ),
                SizedBox(
                  height: 20.0,
                ),
                Expanded(
                  child: ListView.separated(
                    itemCount: _totalCustomCategories,
                    itemBuilder: (BuildContext context, int index) {
                      return TextFormField(
                        key: UniqueKey(),
                        controller: _controllers[index],
                        onChanged: (categoryName) {
                          _customCategories[index].category = categoryName;
                        },
                        decoration: InputDecoration(
                          hintText: 'Enter Category Name',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(4.0),
                            borderSide: BorderSide(
                              color: Colors.grey[300],
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(4.0),
                            borderSide: BorderSide(
                              color: Colors.grey[300],
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(4.0),
                            borderSide: BorderSide(
                              color: Colors.grey[300],
                            ),
                          ),
                        ),
                      );
                    },
                    separatorBuilder: (BuildContext context, int index) {
                      return SizedBox(
                        height: 10.0,
                      );
                    },
                  ),
                ),
                SizedBox(
                  height: 20.0,
                ),
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        height: 1.0,
                        color: Colors.grey[300],
                      ),
                    ),
                    SizedBox(
                      width: 6.0,
                    ),
                    _customCategories.length > 1
                        ? InkWell(
                      onTap: () {
                        setState(() {
                          _totalCustomCategories--;
                          _controllers.removeLast();
                          _customCategories.removeLast();
                        });
                      },
                      splashColor: Colors.transparent,
                      hoverColor: Colors.transparent,
                      focusColor: Colors.transparent,
                      highlightColor: Colors.transparent,
                      child: Icon(
                        Icons.delete_outline_rounded,
                        size: 16.0,
                        color: Colors.red[700],
                      ),
                    )
                        : SizedBox(),
                    SizedBox(
                      width: 6.0,
                    ),
                    InkWell(
                      onTap: () {
                        setState(() {
                          _totalCustomCategories++;
                          _controllers.add(TextEditingController());
                          _customCategories
                              .add(CustomCategory(selected: false));
                        });
                      },
                      splashColor: Colors.transparent,
                      hoverColor: Colors.transparent,
                      focusColor: Colors.transparent,
                      highlightColor: Colors.transparent,
                      child: Icon(
                        Icons.add,
                        size: 16.0,
                        color: PROJECT_GREEN,
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 20.0,
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: RaisedButton(
                    onPressed: () async {
                      widget.categories.customCategories.clear();

                      for (var customCategory in _customCategories) {
                        if (customCategory.selected != null) {
                          if (customCategory.category.isNotEmpty) {
                            widget.categories.customCategories
                                .add(customCategory.toMap(customCategory));
                          }
                        }
                      }

                      await _researcherAndModeratorFirestoreService
                          .saveCategories(widget.studyUID, widget.categories);

                      Navigator.of(context).pop();
                    },
                    color: PROJECT_GREEN,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4.0),
                    ),
                    child: Text(
                      'Create',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 12.0,
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
