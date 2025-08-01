import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:game/controller/controller.dart';

class FocusWidgetControllerAdapter<T> extends StatefulWidget {
  const FocusWidgetControllerAdapter({
    required Map<T, LogicalKeyboardKey> keyMap,
    required this.child,
    required this.onControllerEvent,
    this.focusNode,
    super.key,
  }) : _keyMap = keyMap;

  final FocusNode? focusNode;
  final Map<T, LogicalKeyboardKey> _keyMap;
  final void Function(T, ControllerEventType) onControllerEvent;
  final Widget child;

  @override
  State<FocusWidgetControllerAdapter<T>> createState() =>
      _FocusWidgetControllerAdapterState<T>();
}

class _FocusWidgetControllerAdapterState<T>
    extends State<FocusWidgetControllerAdapter<T>> {
  late final _node = widget.focusNode ?? FocusNode();

  @override
  void initState() {
    super.initState();

    _node.requestFocus();
  }

  @override
  void dispose() {
    if (widget.focusNode == null) {
      _node.dispose();
    }

    super.dispose();
  }

  KeyEventResult _onKey(FocusNode node, KeyEvent event) {
    final logicalKey = event.logicalKey;

    final mappedKey = widget._keyMap.findControl(logicalKey);

    if (mappedKey != null) {
      final eventType = event is KeyUpEvent
          ? ControllerEventType.up
          : ControllerEventType.down;

      widget.onControllerEvent(mappedKey, eventType);

      return KeyEventResult.handled;
    }

    return KeyEventResult.ignored;
  }

  @override
  Widget build(BuildContext context) {
    return Focus(focusNode: _node, onKeyEvent: _onKey, child: widget.child);
  }
}
