import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_essentials_kit/flutter_essentials_kit.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:telegram_app/cubits/search_cubit.dart';


class SearchComponentsMixin {
  Widget searchField(BuildContext context) =>
    TwoWayBindingBuilder<String>(                                               // Passiamo il "context" che ci servirà per Internazionalizzare le label.
      binding: context.watch<SearchCubit>().searchBinding,
      builder: (context, controller, data, onChanged, error) => TextField(
        controller: controller,
        onChanged: onChanged,
        decoration: InputDecoration(
          border: InputBorder.none,
          errorText: error?.localizedString(context),
          hintText: AppLocalizations.of(context)?.label_search ?? '',
          hintStyle: const TextStyle(color: Colors.white70),                    // Diamo un pò di alpha di trasparenza
        ),
        style: const TextStyle(color: Colors.white),                            // Imposto anche un colore del testo quando scrivo nel campo di testo
        keyboardType: TextInputType.text,
      ),
    );
}
