import 'package:flutter/material.dart';

// TODO: Добавить LayoutBuilder для адаптивности
/// {@template no_data_widget}
/// Universal no data widget for the application
/// {@endtemplate}
class NoDataWidget extends StatelessWidget {
  /// {@macro no_data_widget}
  const NoDataWidget({
    required this.text,
    this.showPic = true,
    this.showButton = true,
    this.onPressed,
    this.buttonText,
    super.key,
  });

  /// Primary text for the widget
  final String text;

  /// Show image in the widget
  final bool showPic;

  /// Show button in the widget
  final bool showButton;

  /// On button pressed callback. Only works if [showButton] is true
  final VoidCallback? onPressed;

  /// Button text. Only works if [showButton] is true
  final String? buttonText;

  @override
  Widget build(BuildContext context) => Column(
    mainAxisAlignment: MainAxisAlignment.center,
    crossAxisAlignment: CrossAxisAlignment.center,
    mainAxisSize: MainAxisSize.min,
    children: [
      if (showPic)
        Padding(
          padding: const EdgeInsets.all(8),
          child: Container(
            height: MediaQuery.of(context).size.width * .6,
            width: MediaQuery.of(context).size.height * .6,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Theme.of(context).colorScheme.primary.withValues(alpha: .1),
            ),
            child: Container(
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: Theme.of(context).primaryColor.withValues(alpha: .05),
                    blurRadius: 55,
                    spreadRadius: 100,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              height: MediaQuery.of(context).size.width * .5,
              width: MediaQuery.of(context).size.height * .5,
              child: Image.asset('assets/images/empty_data.png', fit: BoxFit.contain),
            ),
          ),
        ),
      Text(text, textAlign: TextAlign.center, style: Theme.of(context).textTheme.titleLarge),
      if (showButton)
        Padding(
          padding: const EdgeInsets.all(8),
          child: TextButton(
            onPressed: onPressed,
            child: Text(
              buttonText ?? 'Try Again',
              style: Theme.of(context).textTheme.titleMedium!.copyWith(color: Theme.of(context).colorScheme.primary),
            ),
          ),
        ),
    ],
  );
}
