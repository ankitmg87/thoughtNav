import 'package:flutter/material.dart';
import 'package:thoughtnav/constants/color_constants.dart';
import 'package:thoughtnav/screens/researcher/models/categories.dart';
import 'package:thoughtnav/services/firebase_firestore_service.dart';

class StudySetupScreenCategoryCheckBox extends StatefulWidget {
  final String studyUID;
  final String categoryName;
  final Categories categories;

  const StudySetupScreenCategoryCheckBox({
    Key key,
    this.categoryName, this.categories, this.studyUID,
  }) : super(key: key);

  @override
  _StudySetupScreenCategoryCheckBoxState createState() =>
      _StudySetupScreenCategoryCheckBoxState();
}

class _StudySetupScreenCategoryCheckBoxState
    extends State<StudySetupScreenCategoryCheckBox> {

  final _firebaseFirestoreService = FirebaseFirestoreService();

  bool categorySelected = false;

  @override
  void initState() {
    super.initState();
  }

  void _saveCategories() async {
    await _firebaseFirestoreService.saveCategories(widget.studyUID, widget.categories);
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(2.0),
          border: Border.all(
            width: 0.75,
            color: Colors.grey[300],
          ),
        ),
        child: InkWell(
          child: Padding(
            padding: EdgeInsets.only(
              left: 4.0,
              right: 10.0,
              top: 8.0,
              bottom: 8.0,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Theme(
                  data: ThemeData(
                    accentColor: PROJECT_NAVY_BLUE,
                    unselectedWidgetColor: Colors.grey[300],
                  ),
                  child: Checkbox(
                    // TODO -> Change tick colour
                    value: widget.categories.checkCategoryStatus(widget.categoryName) ?? false,
                    onChanged: (bool value) {
                      setState(() {
                        categorySelected = value;
                        widget.categories.setCategoryStatus(widget.categoryName, categorySelected);
                        _saveCategories();
                      });
                    },
                  ),
                ),
                Text(
                  widget.categoryName,
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 14.0,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}