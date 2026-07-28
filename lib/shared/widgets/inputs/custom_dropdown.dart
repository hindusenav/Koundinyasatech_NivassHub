import 'package:flutter/material.dart';

/// A generic, typed dropdown — pass the list of [T] plus a function to
/// derive its display label, instead of building `DropdownMenuItem`s by
/// hand at every call site.
class CustomDropdown<T> extends StatelessWidget {
  const CustomDropdown({
    super.key,
    required this.items,
    required this.itemLabel,
    this.value,
    this.label,
    this.hint,
    this.onChanged,
    this.validator,
    this.enabled = true,
  });

  final List<T> items;
  final String Function(T item) itemLabel;
  final T? value;
  final String? label;
  final String? hint;
  final void Function(T?)? onChanged;
  final String? Function(T?)? validator;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<T>(
      initialValue: value,
      isExpanded: true,
      decoration: InputDecoration(labelText: label),
      hint: hint != null ? Text(hint!) : null,
      items: items
          .map(
            (item) => DropdownMenuItem<T>(
              value: item,
              child: Text(itemLabel(item)),
            ),
          )
          .toList(),
      onChanged: enabled ? onChanged : null,
      validator: validator,
    );
  }
}
