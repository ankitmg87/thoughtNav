import 'dart:ui';

import 'package:flutter/material.dart';


/// This class will enable us to create a [TextField] with inline text editing
/// capabilities.

/// Basic functionalities ->
///   1. Selectable text
///   2. Cursor should be visible.
///   3. Selected text should be formatted and rendered inside textField


class _TextFieldSelectionGestureDetectorBuilder extends TextSelectionGestureDetectorBuilder {

  _TextFieldSelectionGestureDetectorBuilder({
    _CustomTextFieldState state,
}) : _state = state, super(delegate: state);

  final _CustomTextFieldState _state;

  @override
  void onForcePressStart(ForcePressDetails details) {
    super.onForcePressStart(details);
    if(delegate.selectionEnabled && shouldShowSelectionToolbar){
      editableText?.showToolbar();
    }
  }

  @override
  void onForcePressEnd(ForcePressDetails details) {
    super.onForcePressEnd(details);
  }

  @override
  void onSingleLongTapMoveUpdate(LongPressMoveUpdateDetails details) {
    if (delegate.selectionEnabled) {
      switch (Theme.of(_state.context).platform) {
        case TargetPlatform.iOS:
        case TargetPlatform.macOS:
          renderEditable.selectPositionAt(
            from: details.globalPosition,
            cause: SelectionChangedCause.longPress,
          );
          break;
        case TargetPlatform.android:
        case TargetPlatform.fuchsia:
        case TargetPlatform.linux:
        case TargetPlatform.windows:
          renderEditable.selectWordsInRange(
            from: details.globalPosition - details.offsetFromOrigin,
            to: details.globalPosition,
            cause: SelectionChangedCause.longPress,
          );
          break;
      }
    }
  }

  @override
  void onSingleTapUp(TapUpDetails details) {
    editableText.hideToolbar();
    if (delegate.selectionEnabled) {
      switch (Theme.of(_state.context).platform) {
        case TargetPlatform.iOS:
        case TargetPlatform.macOS:
          switch (details.kind) {
            case PointerDeviceKind.mouse:
            case PointerDeviceKind.stylus:
            case PointerDeviceKind.invertedStylus:
            // Precise devices should place the cursor at a precise position.
              renderEditable.selectPosition(cause: SelectionChangedCause.tap);
              break;
            case PointerDeviceKind.touch:
              break;
            case PointerDeviceKind.unknown:
            // On macOS/iOS/iPadOS a touch tap places the cursor at the edge
            // of the word.
              renderEditable.selectWordEdge(cause: SelectionChangedCause.tap);
              break;
          }
          break;
        case TargetPlatform.android:
          break;
        case TargetPlatform.fuchsia:
        case TargetPlatform.linux:
        case TargetPlatform.windows:
          renderEditable.selectPosition(cause: SelectionChangedCause.tap);
          break;

      }
    }
  }

}


class CustomTextField extends StatefulWidget {

  final TextEditingController controller;
  final FocusNode focusNode;
  final int maxLength;
  final InputDecoration decoration;

  const CustomTextField({Key key, this.controller, this.focusNode, this.maxLength, this.decoration,}) : super(key: key);

  @override
  _CustomTextFieldState createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> with RestorationMixin implements TextSelectionGestureDetectorBuilderDelegate {

  RestorableTextEditingController _controller;
  TextEditingController get _effectiveController => widget.controller ?? _controller.value;

  FocusNode _focusNode;
  FocusNode get _effectiveFocusNode => widget.focusNode ?? (_focusNode ??= FocusNode());

  bool _isHovering = false;

  bool get needsCounter => widget.maxLength != null && widget.decoration != null && widget.decoration.counterText == null;

  bool _showSelectionHandles = false;

   _TextFieldSelectionGestureDetectorBuilder _selectionGestureDetectorBuilder;

  @override
  GlobalKey<EditableTextState> get editableTextKey => GlobalKey<EditableTextState>();

  EditableTextState get _editableText => editableTextKey.currentState;

  void _requestKeyboard() {
    _editableText.requestKeyboard();
  }

   String string;
  @override
  // TODO: implement forcePressEnabled
  bool get forcePressEnabled => throw UnimplementedError();

  @override
  // TODO: implement restorationId
  String get restorationId => throw UnimplementedError();

  @override
  void restoreState(RestorationBucket oldBucket, bool initialRestore) {
    // TODO: implement restoreState
  }

  @override
  // TODO: implement selectionEnabled
  bool get selectionEnabled => throw UnimplementedError();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20.0),
    );
  }


}
