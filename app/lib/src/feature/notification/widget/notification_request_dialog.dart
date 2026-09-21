// ignore_for_file: experimental_member_use

import 'package:flutter/material.dart';
import 'package:octopus/octopus.dart';

/// {@template notification_request_dialog}
/// NotificationRequestDialog widget.
/// {@endtemplate}
class NotificationRequestDialog extends StatelessWidget {
  /// {@macro notification_request_dialog}
  const NotificationRequestDialog({
    super.key, // ignore: unused_element_parameter
  });

  static Future<void> show(BuildContext context) =>
      Octopus.instance.showDialog<void>((context) => const NotificationRequestDialog());

  @override
  Widget build(BuildContext context) => const Dialog(
    elevation: 8,
    insetPadding: EdgeInsets.all(36),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(16))),
    child: _NotificationRequestDialogContent(),
  );
}

class _NotificationRequestDialogContent extends StatefulWidget {
  const _NotificationRequestDialogContent({
    super.key, // ignore: unused_element_parameter
  });

  @override
  State<_NotificationRequestDialogContent> createState() => _NotificationRequestDialogContentState();
}

class _NotificationRequestDialogContentState extends State<_NotificationRequestDialogContent> {
  /* #region Lifecycle */
  @override
  void initState() {
    super.initState();
    // Initial state initialization
  }

  @override
  void didUpdateWidget(covariant _NotificationRequestDialogContent oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Widget configuration changed
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // The configuration of InheritedWidgets has changed
    // Also called after initState but before build
  }

  @override
  void dispose() {
    // Permanent removal of a tree stent
    super.dispose();
  }
  /* #endregion */

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return SizedBox(
      width: MediaQuery.sizeOf(context).width > 600 ? 600 : double.infinity,
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          spacing: 24,
          children: [
            Column(
              mainAxisSize: MainAxisSize.min,
              spacing: 12,
              children: [
                Icon(
                  Icons.notifications_active_outlined,
                  size: 48,
                  color: Theme.of(context).colorScheme.primary,
                ),
                Text('Enable Notifications', style: textTheme.titleLarge),
                Text(
                  'Stay updated with your daily tasks and habits. We\'ll send you reminders to keep you on track.',
                  textAlign: TextAlign.center,
                  style: textTheme.bodyMedium,
                ),
              ],
            ),
            Row(
              spacing: 12,
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: Text('Not Now', style: textTheme.labelLarge),
                  ),
                ),
                Expanded(
                  child: FilledButton(
                    onPressed: () async {
                      // Request notification permission
                      // final granted = await NotificationsScope.requestNotificationPermissions(context);
                      // if (granted) {
                      //   if (!context.mounted) return;
                      //   Navigator.of(context).pop();
                      // } else {
                      //   if (!context.mounted) return;
                      //   ScaffoldMessenger.of(context)
                      //     ..removeCurrentSnackBar()
                      //     ..showSnackBar(
                      //       const SnackBar(content: Text('Notification permission denied')),
                      //     );
                      // }
                    },
                    child: const Text('Request Permission'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
