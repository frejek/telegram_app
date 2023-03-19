import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class WelcomeCubit extends Cubit<int> {                                         // Cubit<int> emetterà EVENTI di Tipo Intero per la Pagina 1-2-3-4-5-6... scorrevole
  final PageController controller = PageController();                           // Prima di tutto definiamo controller che ci permetterà di selezionare la pagina corrente e avere il controllo su quale pagina mostrare.
                                                                                // Questo widget è molto utile quando si deve fare lo slide sulle diverse pagine.

  // Predisponiamo questo Cubit ad EMETTERE DEGLI STATI AL CAMBIO PAGINA.
  // Per far ciò aggiungiamo un Listener al controller. E questa funzione di fatto farà emit() della Pagina Corrente
  WelcomeCubit() : super(0) {                                                   // costruttore senza parametri ma initialState sarà zero la prima pagina
    controller.addListener(() {
      emit(controller.page != null ? controller.page!.toInt() : 0);             // se c'è il controller sulla pagina allora emetteremo controller.page.toInt() altrimenti emetteremo 0.
    });                                                                         // Gisuto a metterci a parte civile ed evitare eventuali situazioni imbarazzanti nel caso in cui la page sia null MEGLIO PREVENIRE CHE CURARE
  }                                                                             // Infatti se faccio  "ctrl + clic"  -> "page" è un metodo getter  [double? get page {}] quindi dobbiamo gestiore il fatto che sia anche nullabile

  Future<void> close() {                                                        // Aggiungiamo anche il metodo di close() ex dispose() per chiudere il nostro controller e deallocare le risorse non più utilizzate per liberare memoria affinchè non si appesantisca per eviatre memory leek.
    controller.dispose();

    return super.close();
  }
}