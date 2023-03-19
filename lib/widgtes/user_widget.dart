import 'dart:io';

import 'package:flutter/material.dart';
import 'package:telegram_app/models/user.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class UserWidget extends StatelessWidget {
  // final String name;
  final User? user;
  final VoidCallback? onTap;

  // Costruisco un oggetto UserWidget() per la parte shimmed
  factory UserWidget.shimmed() => UserWidget(null);

  const UserWidget(this.user, {Key? key, this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) => ListTile(
    leading: CircleAvatar(
      // child: Text(friends[index].substring(0, 1)),
      child: Text(user!= null ? user!.initials : 'AA'),
    ),
    // title: Text(friends[index]),
    title: Text(user!= null ? user!.displayName : 'First Name'),
    subtitle: Text(
        user != null && user!.lastAccess != null
          ? timeago.format(user!.lastAccess!, locale: AppLocalizations.of(context)?.localeName)
          : AppLocalizations.of(context)?.label_last_access ?? ''),
      onTap: onTap,
  );

}