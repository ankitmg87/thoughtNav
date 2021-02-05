import 'package:flutter/material.dart';
import 'package:thoughtnav/constants/color_constants.dart';
import 'package:thoughtnav/screens/researcher/models/categories.dart';
import 'package:thoughtnav/services/researcher_and_moderator_firestore_service.dart';

// class CustomCategoriesWidget extends StatefulWidget {
//   final String studyUID;
//   final Categories categories;
//
//   const CustomCategoriesWidget({Key key, this.categories, this.studyUID})
//       : super(key: key);
//
//   @override
//   _CustomCategoriesWidgetState createState() => _CustomCategoriesWidgetState();
// }
//
// class _CustomCategoriesWidgetState extends State<CustomCategoriesWidget> {
//   final _researcherAndModeratorFirestoreService =
//       ResearcherAndModeratorFirestoreService();
//
//   List<dynamic> _customCategories = [];
//   final List<TextEditingController> _controllers = [];
//
//   int _totalCustomCategories = 1;
//
//   @override
//   void initState() {
//     if (widget.categories.customCategories != null) {
//       if (widget.categories.customCategories.isNotEmpty) {
//         _totalCustomCategories = widget.categories.customCategories.length;
//         _customCategories = widget.categories.customCategories;
//       }
//     }
//     super.initState();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Expanded(
//       child: InkWell(
//         onTap: () async {
//           await showGeneralDialog(
//             context: context,
//             pageBuilder: (BuildContext generalDialogContext,
//                 Animation<double> animation,
//                 Animation<double> secondaryAnimation) {
//
//               if(_customCategories.isNotEmpty){
//                 for(var category in _customCategories){
//                   var textEditingController = TextEditingController();
//                   textEditingController.text = category.toString();
//                   _controllers.add(textEditingController);
//                 }
//               }
//               else {
//                 _controllers.add(TextEditingController());
//               }
//
//               return StatefulBuilder(
//                 builder: (BuildContext context,
//                     void Function(void Function()) setGeneralDialogState) {
//                   return Center(
//                     child: Container(
//                       constraints: BoxConstraints(
//                         maxWidth: MediaQuery.of(context).size.width * 0.2,
//                         maxHeight: MediaQuery.of(context).size.height * 0.5,
//                       ),
//                       child: Material(
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(10.0),
//                         ),
//                         child: Padding(
//                           padding: EdgeInsets.all(20.0),
//                           child: Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             mainAxisSize: MainAxisSize.min,
//                             children: [
//                               Row(
//                                 mainAxisAlignment:
//                                     MainAxisAlignment.spaceBetween,
//                                 children: [
//                                   Text(
//                                     'Make Custom Categories',
//                                     style: TextStyle(
//                                       color: Colors.black,
//                                       fontWeight: FontWeight.bold,
//                                       fontSize: 16.0,
//                                     ),
//                                   ),
//                                   InkWell(
//                                     onTap: () {
//                                       Navigator.of(generalDialogContext).pop();
//                                     },
//                                     child: Icon(
//                                       Icons.clear,
//                                       color: Colors.red[700],
//                                       size: 16.0,
//                                     ),
//                                     splashColor: Colors.transparent,
//                                     hoverColor: Colors.transparent,
//                                     focusColor: Colors.transparent,
//                                     highlightColor: Colors.transparent,
//                                   )
//                                 ],
//                               ),
//                               SizedBox(
//                                 height: 20.0,
//                               ),
//                               Container(
//                                 height: 1.0,
//                                 width: double.maxFinite,
//                                 color: Colors.grey[300],
//                               ),
//                               SizedBox(
//                                 height: 20.0,
//                               ),
//                               Expanded(
//                                 child: ListView.separated(
//                                   itemCount: _totalCustomCategories,
//                                   itemBuilder:
//                                       (BuildContext context, int index) {
//                                     return TextFormField(
//                                       controller: _controllers[index],
//                                       onChanged: (categoryName) {
//                                         // if (_customCategories.isNotEmpty) {
//                                         //   _customCategories.removeAt(index);
//                                         //   _customCategories.insert(
//                                         //       index, categoryName);
//                                         //   print(_customCategories[index]);
//                                         // } else {
//                                         //   _customCategories.insert(
//                                         //       index, categoryName);
//                                         // }
//                                       },
//                                       decoration: InputDecoration(
//                                         hintText: 'Enter Category Name',
//                                         border: OutlineInputBorder(
//                                           borderRadius:
//                                               BorderRadius.circular(4.0),
//                                           borderSide: BorderSide(
//                                             color: Colors.grey[300],
//                                           ),
//                                         ),
//                                         enabledBorder: OutlineInputBorder(
//                                           borderRadius:
//                                               BorderRadius.circular(4.0),
//                                           borderSide: BorderSide(
//                                             color: Colors.grey[300],
//                                           ),
//                                         ),
//                                         focusedBorder: OutlineInputBorder(
//                                           borderRadius:
//                                               BorderRadius.circular(4.0),
//                                           borderSide: BorderSide(
//                                             color: Colors.grey[300],
//                                           ),
//                                         ),
//                                       ),
//                                     );
//                                   },
//                                   separatorBuilder:
//                                       (BuildContext context, int index) {
//                                     return SizedBox(
//                                       height: 10.0,
//                                     );
//                                   },
//                                 ),
//                               ),
//                               SizedBox(
//                                 height: 20.0,
//                               ),
//                               Row(
//                                 children: [
//                                   Expanded(
//                                     child: Container(
//                                       height: 1.0,
//                                       color: Colors.grey[300],
//                                     ),
//                                   ),
//                                   SizedBox(
//                                     width: 6.0,
//                                   ),
//                                   _totalCustomCategories > 1
//                                       ? InkWell(
//                                           onTap: () {
//                                             setGeneralDialogState(() {
//                                               _totalCustomCategories--;
//                                               _controllers.removeLast();
//                                             });
//                                           },
//                                           splashColor: Colors.transparent,
//                                           hoverColor: Colors.transparent,
//                                           focusColor: Colors.transparent,
//                                           highlightColor: Colors.transparent,
//                                           child: Icon(
//                                             Icons.delete_outline_rounded,
//                                             size: 16.0,
//                                             color: Colors.red[700],
//                                           ),
//                                         )
//                                       : SizedBox(),
//                                   SizedBox(
//                                     width: 6.0,
//                                   ),
//                                   InkWell(
//                                     onTap: () {
//                                       setGeneralDialogState(() {
//                                         _totalCustomCategories++;
//                                         _controllers.add(TextEditingController());
//                                       });
//                                     },
//                                     splashColor: Colors.transparent,
//                                     hoverColor: Colors.transparent,
//                                     focusColor: Colors.transparent,
//                                     highlightColor: Colors.transparent,
//                                     child: Icon(
//                                       Icons.add,
//                                       size: 16.0,
//                                       color: PROJECT_GREEN,
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                               SizedBox(
//                                 height: 20.0,
//                               ),
//                               Align(
//                                 alignment: Alignment.centerRight,
//                                 child: RaisedButton(
//                                   onPressed: () async {
//
//                                     for(var controller in _controllers){
//                                       _customCategories.add(controller.text);
//                                     }
//
//                                     if(_customCategories.isNotEmpty){
//                                       widget.categories.customCategories = _customCategories;
//
//                                       await _researcherAndModeratorFirestoreService
//                                           .saveCategories(
//                                           widget.studyUID, widget.categories);
//                                       Navigator.of(generalDialogContext).pop();
//                                     }
//                                     else{
//                                       Navigator.of(generalDialogContext).pop();
//                                     }
//                                   },
//                                   color: PROJECT_GREEN,
//                                   shape: RoundedRectangleBorder(
//                                     borderRadius: BorderRadius.circular(4.0),
//                                   ),
//                                   child: Text(
//                                     'Create',
//                                     style: TextStyle(
//                                       color: Colors.white,
//                                       fontWeight: FontWeight.bold,
//                                       fontSize: 12.0,
//                                     ),
//                                   ),
//                                 ),
//                               )
//                             ],
//                           ),
//                         ),
//                       ),
//                     ),
//                   );
//                 },
//               );
//             },
//           );
//         },
//         child: Container(
//           padding: EdgeInsets.all(14.7),
//           decoration: BoxDecoration(
//             borderRadius: BorderRadius.circular(2.0),
//             border: Border.all(
//               width: 0.75,
//               color: Colors.grey[300],
//             ),
//           ),
//           child: Center(
//             child: Text(
//               'Custom Category',
//               style: TextStyle(
//                 color: Colors.black,
//                 fontWeight: FontWeight.bold,
//                 fontSize: 14.0,
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }


class CustomCategoriesButton extends StatefulWidget {

  final String studyUID;
  final Categories categories;

  const CustomCategoriesButton({Key key, this.studyUID, this.categories}) : super(key: key);

  @override
  _CustomCategoriesButtonState createState() => _CustomCategoriesButtonState();
}

class _CustomCategoriesButtonState extends State<CustomCategoriesButton> {

  final _researcherAndModeratorFirestoreService =
  ResearcherAndModeratorFirestoreService();

  List<dynamic> _customCategories = [];
  final List<TextEditingController> _controllers = [];

  int _totalCustomCategories = 1;

  @override
  void initState() {
    if (widget.categories.customCategories != null) {
      if (widget.categories.customCategories.isNotEmpty) {
        _totalCustomCategories = widget.categories.customCategories.length;
        _customCategories = widget.categories.customCategories;
      }
    }
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        await showGeneralDialog(
          context: context,
          pageBuilder: (BuildContext generalDialogContext,
              Animation<double> animation,
              Animation<double> secondaryAnimation) {

            if(_customCategories.isNotEmpty){
              for(var category in _customCategories){
                var textEditingController = TextEditingController();
                textEditingController.text = category.toString();
                _controllers.add(textEditingController);
              }
            }
            else {
              _controllers.add(TextEditingController());
            }

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
                              mainAxisAlignment:
                              MainAxisAlignment.spaceBetween,
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
                                itemBuilder:
                                    (BuildContext context, int index) {
                                  return TextFormField(
                                    key: UniqueKey(),
                                    controller: _controllers[index],
                                    onChanged: (categoryName) {

                                    },
                                    decoration: InputDecoration(
                                      hintText: 'Enter Category Name',
                                      border: OutlineInputBorder(
                                        borderRadius:
                                        BorderRadius.circular(4.0),
                                        borderSide: BorderSide(
                                          color: Colors.grey[300],
                                        ),
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius:
                                        BorderRadius.circular(4.0),
                                        borderSide: BorderSide(
                                          color: Colors.grey[300],
                                        ),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius:
                                        BorderRadius.circular(4.0),
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
                                _totalCustomCategories > 1
                                    ? InkWell(
                                  onTap: () {
                                    setGeneralDialogState(() {
                                      _totalCustomCategories--;
                                      _controllers.removeLast();
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
                                    setGeneralDialogState(() {
                                      _totalCustomCategories++;
                                      _controllers.add(TextEditingController());
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

                                  for(var controller in _controllers){
                                    _customCategories.add(controller.text);
                                  }

                                  if(_customCategories.isNotEmpty){
                                    widget.categories.customCategories = _customCategories;

                                    await _researcherAndModeratorFirestoreService
                                        .saveCategories(
                                        widget.studyUID, widget.categories);
                                    Navigator.of(generalDialogContext).pop();
                                  }
                                  else{
                                    Navigator.of(generalDialogContext).pop();
                                  }
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
      child: Text(
        'Custom Category',
        style: TextStyle(
          color: PROJECT_GREEN,
          fontWeight: FontWeight.bold,
          fontSize: 13.0,
        ),
      ),
    );
  }
}



