import 'package:firebase_auth/firebase_auth.dart';

extension userDisplayNameInitials  on User {                                    // andiamo a costruire le iniziali di nome e cognome

  String get displayNameInitials {
    if(displayName == null || displayName!.isEmpty) {
      return '';
    }

    final split = displayName!.split(' ');                                      // Prima di tutto separiamo NomeCognome da 'AngeloCassano' in 'Angelo Caassano'

    if(displayName!.length == 1) {                                              // E poi controlliamo se gli elementi splittati quindi che compongono il displayName ovvero "nome", "cognome", "secondo nome"  e via dicendo...
      return displayName!.substring(0, 1).toUpperCase();                        // Quindi se è presente un solo nome allora facciamo return quindi prendiamo il primo carattere e poi lo trasformiano in toUpperCase() a indice "0" prendo  il  primo carattere "1"

    }
    return (split[0].substring(0, 1) + split[1].substring(0, 1)).toUpperCase(); // Prendo il I nome e prendo la I lettera del I nome + CONCATENO
                                                                                // Prendo il II nome e prendo la I lettera del II nome e poi tutto il resto lo faremo in toUpperCase in modo tale da portare in maiuscolo le INBIZIALI
  }
}