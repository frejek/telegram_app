
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:telegram_app/providers/shared_preferences_provider.dart';

class DarkModeCubit extends Cubit<bool> {                                       // MI serve per switchare lo stato da DarkMode a lightMode e viceversa
  final SharedPreferencesProvider preferencesProvider;                          // Prendiamo il riferimento di questa classe per richiamare i due metodi getter e setter per salvare i dati nel database e recuperare i dati in modo persistente
                                                                                // sharedPreference Provider DATABASE LOCALE PER SALVARE I DATI IN MODO PERSISTENTE OVVERO LO STATO ATTIVO O DISATTIVO DarkMode o LightMode

  // DarkModeCubit(bool initialState) : super(initialState);
  DarkModeCubit({required this.preferencesProvider}) : super(false);

  void init() async {
    emit(await preferencesProvider.darkModeEnabled);



  }

  void setDarkModeEnabled(bool mode) async {
    await preferencesProvider.setDarkMode(mode);

    emit(mode);

    // OPPURE POSSO SCRIVERLO IN QUESTO MODO
    // await preferencesProvider.setDarkMode(mode) => emit(mode);
  }

  void toggleDarkMode() => setDarkModeEnabled(!state);



}

