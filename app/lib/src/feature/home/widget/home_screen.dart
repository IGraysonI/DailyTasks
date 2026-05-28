import 'package:flutter/material.dart';
import 'package:localization/localization.dart';
import 'package:novaforge_starter/src/common/widget/common_actions.dart';

/// {@template home_screen}
/// HomeScreen widget.
/// {@endtemplate}
class HomeScreen extends StatelessWidget {
  /// {@macro home_screen}
  const HomeScreen({
    super.key, // ignore: unused_element_parameter
  });

  @override
  Widget build(BuildContext context) => MaterialApp(
    home: Scaffold(
      appBar: AppBar(
        title: Text(Sheet1Localization.of(context).title),
        actions: CommonActions(),
      ),
      body: Center(child: Text(Sheet1Localization.of(context).title)),
    ),
  );
}
