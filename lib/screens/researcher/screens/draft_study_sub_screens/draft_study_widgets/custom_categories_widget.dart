import 'package:flutter/material.dart';
import 'package:thoughtnav/constants/color_constants.dart';
import 'package:thoughtnav/screens/researcher/models/categories.dart';

class CustomCategoriesWidget extends StatefulWidget {
  final Categories categories;

  const CustomCategoriesWidget({Key key, this.categories}) : super(key: key);

  @override
  _CustomCategoriesWidgetState createState() => _CustomCategoriesWidgetState();
}

class _CustomCategoriesWidgetState extends State<CustomCategoriesWidget> {
  final List<String> _customCategories = [];

  int _totalCustomCategories = 1;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: InkWell(
        onTap: () async {
          await showGeneralDialog(
            context: context,
            pageBuilder: (BuildContext generalDialogContext,
                Animation<double> animation,
                Animation<double> secondaryAnimation) {
              return StatefulBuilder(
                builder: (BuildContext context,
                    void Function(void Function()) setGeneralDialogState) {
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
                                    onTap: (){
                                      Navigator.of(generalDialogContext).pop();
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
                                  )
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
                                  separatorBuilder:
                                      (BuildContext context, int index) {
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
                                  _totalCustomCategories > 1 ?
                                  InkWell(
                                    onTap: (){
                                      setGeneralDialogState((){
                                        _totalCustomCategories--;
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
                                  ) : SizedBox(),
                                  SizedBox(
                                    width: 6.0,
                                  ),
                                  InkWell(
                                    onTap: (){
                                      setGeneralDialogState((){
                                        _totalCustomCategories++;
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
                                  ) ,
                                ],
                              ),
                              SizedBox(
                                height: 20.0,
                              ),
                              Align(
                                alignment: Alignment.centerRight,
                                child: RaisedButton(
                                  onPressed: () {
                                    Navigator.of(generalDialogContext).pop();
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
                },
              );
            },
          );
        },
        child: Container(
          padding: EdgeInsets.all(14.7),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(2.0),
            border: Border.all(
              width: 0.75,
              color: Colors.grey[300],
            ),
          ),
          child: Center(
            child: Text(
              'Custom Category',
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 14.0,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
