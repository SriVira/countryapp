import 'package:flutter/material.dart';

class PrimarySearchBar extends StatelessWidget {
  final void Function(String)? onChanged;
  final void Function(String)? onSubmitted;
  final String? hintText;
  final TextEditingController? controller;
  final void Function()? onTap;
  final Iterable<Widget>? trailing;
  const PrimarySearchBar(
      {super.key,
      this.onChanged,
      this.onSubmitted,
      this.hintText,
      this.trailing,
      this.controller,
      this.onTap});

  @override
  Widget build(BuildContext context) {
    return SearchBar(
      controller: controller,
      autoFocus: false,
      onSubmitted: onSubmitted,
      textInputAction: TextInputAction.done,
      leading: const Icon(Icons.search),
      padding: WidgetStateProperty.all<EdgeInsetsGeometry?>(
        const EdgeInsets.symmetric(vertical: 0, horizontal: 8),
      ),
      onTap: onTap,
      focusNode: FocusNode(),
      trailing: trailing,
      hintText: hintText ?? "Search Products",
      elevation: WidgetStateProperty.all<double>(2),
      shape: WidgetStateProperty.all(
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
      onChanged: onChanged,
    );
  }
}
