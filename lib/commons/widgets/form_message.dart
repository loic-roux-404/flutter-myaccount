import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:formz/formz.dart';

class FormMessage extends StatelessWidget {
  const FormMessage(
      {Key? key,
      required this.status,
      required this.color,
      required this.validatedProperties,
      this.height})
      : super(key: key);
  final FormzStatus status;

  final Color color;

  final List<Object?>? validatedProperties;

  final double? height;

  String translateIssue(dynamic? f) => f?.toString().tr() ?? '';

  List<String> parseErrors(List<dynamic?>? errors) =>
      errors
          ?.where((e) => e != null)
          .where((e) => e is FormzInput && !e.pure)
          .map((e) => (e as FormzInput).error)
          .map(translateIssue)
          .where((e) => e.isNotEmpty)
          .toList() ??
      [];

  _getListFromErrors(List<String>? errors) {
    if (errors == null || errors.isEmpty) {
      return const Padding(padding: EdgeInsets.zero);
    }

    return ListView.builder(
      itemCount: errors.length,
      itemBuilder: (BuildContext context, int i) {
        return Text(
          errors.elementAt(i),
          textAlign: TextAlign.center,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final errors = parseErrors(validatedProperties);
    final double displayedHeight = errors.isNotEmpty ? height ?? 50 : 0;
    return Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        color: color,
        height: displayedHeight,
        child: Align(child: _getListFromErrors(errors)));
  }

  SnackBar getSnackBar(BuildContext context) {
    return SnackBar(
        padding: EdgeInsets.zero,
        duration: const Duration(seconds: 5),
        content: this);
  }
}
