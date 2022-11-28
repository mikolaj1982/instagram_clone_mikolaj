import 'package:flutter/material.dart';
import 'package:instagram_clone_mikolaj/views/components/constants/strings.dart';

@immutable
class AlertDialogModel<T> {
  final String title;
  final String message;
  final Map<String, T> buttons;

  const AlertDialogModel({
    required this.title,
    required this.message,
    required this.buttons,
  });
}

// present layer of dialog
extension Present<T> on AlertDialogModel<T> {
  Future<T?> present(BuildContext context) {
    return showDialog<T?>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: buttons.entries.map(
            (entry) {
              return TextButton(
                child: Text(
                  entry.key,
                ),
                onPressed: () {
                  debugPrint('LogoutDialog extension: ${entry.value}');
                  Navigator.of(context).pop(
                    entry.value,
                  );
                },
              );
            },
          ).toList(),
        );
      },
    );
  }
}

class LogoutDialog extends AlertDialogModel<bool> {
  const LogoutDialog()
      : super(
          title: 'Logout',
          message: 'Are you sure you want to logout?',
          buttons: const {
            'Yes': true,
            'No': false,
          },
        );
}

class DeleteDialog extends AlertDialogModel<bool> {
  const DeleteDialog({required String titleOfObjectToDelete})
      : super(
          title: '${Strings.delete} $titleOfObjectToDelete?',
          message: 'Are you sure you want to delete this $titleOfObjectToDelete?',
          buttons: const {
            'Delete': true,
            'Cancel': false,
          },
        );
}
