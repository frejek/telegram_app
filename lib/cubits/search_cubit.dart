import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_essentials_kit/flutter_essentials_kit.dart';

class SearchCubit extends Cubit<bool> {                                         // SE CI TROVIAMO NEL CONTESTO DI NAVIGAZIONE NORMALE DELLE CHAT OPPURE NEL CONTESTO DI RICERCA DELLE CHAT
  final searchBinding = TwoWayBinding<String>();

  SearchCubit(): super(false);                                                  // costruttore Lo stato iniziale sarà false quindi la ricerca sarà spenta, non ci troviamo quindi nel contesto di ricerca.

  void toggle() => emit(!state);                                                // E qui aggiungiamo un "metodo toggle()" per cambiare lo "STATE della nostra Ricerca" alla pressione
                                                                                // del relativo bottone. ! negazione (da true a false e viceversa)
  @override
  void onChange(Change<bool> change) {                                          // E successivamente facciamo @override anche del "metodo onChange()" in quanto vogliamo svuotare il contenuto di "searchBinding()" al variare dello STATE. In particolare quando spegniamo la "funzione di ricerca".
                                                                                // Perciò al variare del cambiamento di stato  allora il valore di seacrhBinding si svuoterà, in particolare quando premiamo sul bottone di ricerca.
    if(!change.nextState) {                                                     // Quindi quando la condizione è false allora svuoteremo la casella di testo devo facciamo la ricerca.
      searchBinding.value = null;
    }
    super.onChange(change);
  }

  @override
  Future<void> close() async {                                                  // In modo da chiudere eventualmente anche lo stream<SearchBinding> per evitare "memory leek" perdite di memoria.
     await searchBinding.close();

    return super.close();
  }
}