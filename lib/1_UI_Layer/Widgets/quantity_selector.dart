import 'package:flutter/material.dart';

/// A simple, reusable quantity selector widget with +/- buttons, an editable field,
/// and support for a keyboard "Done" button to submit changes and dismiss.
/// Dynamically adapts the input field width based on available space.
class QuantitySelector extends StatefulWidget {
  /// Current quantity value.
  final int quantity;

  /// Called whenever the quantity is changed.
  final ValueChanged<int> onChanged;

  /// Minimum allowed quantity (inclusive).
  final int min;

  /// Maximum allowed quantity (inclusive).
  final int? max;

  /// Fraction of parent width to assign to the text field (0 < widthFactor <= 1).
  final double widthFactor;

  /// Bounds for the computed field width.
  final double minFieldWidth;
  final double maxFieldWidth;

  const QuantitySelector({
    super.key,
    required this.quantity,
    required this.onChanged,
    this.min = 0,
    this.max,
    this.widthFactor = 0.2,
    this.minFieldWidth = 40,
    this.maxFieldWidth = 70,
  }) : assert(widthFactor > 0 && widthFactor <= 1);

  @override
  _QuantitySelectorState createState() => _QuantitySelectorState();
}

class _QuantitySelectorState extends State<QuantitySelector> {
  late TextEditingController _controller;
  late FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.quantity.toString());
    _focusNode = FocusNode();
  }

  @override
  void didUpdateWidget(covariant QuantitySelector oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.quantity != widget.quantity) {
      _controller.text = widget.quantity.toString();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _increment() {
    final newVal =
        (widget.quantity < (widget.max ?? double.infinity))
            ? widget.quantity + 1
            : widget.quantity;
    widget.onChanged(newVal);
  }

  void _decrement() {
    final newVal =
        (widget.quantity > widget.min) ? widget.quantity - 1 : widget.quantity;
    widget.onChanged(newVal);
  }

  void _submit() {
    final parsed = int.tryParse(_controller.text);
    final valid =
        parsed != null
            ? parsed.clamp(widget.min, widget.max ?? parsed)
            : widget.quantity;
    widget.onChanged(valid as int);
    _focusNode.unfocus();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = (constraints.maxWidth * widget.widthFactor).clamp(
          widget.minFieldWidth,
          widget.maxFieldWidth,
        );
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: Icon(Icons.remove_circle_outline),
              onPressed: _decrement,
              tooltip: 'Decrease quantity',
            ),
            SizedBox(
              width: width,
              child: TextField(
                onTapOutside: (event) {
                  _focusNode.unfocus();
                },
                controller: _controller,
                focusNode: _focusNode,
                textAlign: TextAlign.center,
                //keyboardType: TextInputType.number,
                textInputAction: TextInputAction.done,
                onEditingComplete: _submit,
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.symmetric(
                    vertical: 8,
                    horizontal: 4,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ),

            IconButton(
              icon: Icon(Icons.add_circle_outline),
              onPressed: _increment,
              tooltip: 'Increase quantity',
            ),
          ],
        );
      },
    );
  }
}
