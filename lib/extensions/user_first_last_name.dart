import 'package:firebase_auth/firebase_auth.dart';

extension UserFirstLastName on User {
  String get firstName {
    if(displayName == null || displayName!.isEmpty) {
      return '';
    }

    final split = displayName!.split(' ');                                      // Dato che ogni parola ha uno spazio noi gli stiamo dicendo di troncare la parola ad ogni spazio
    if(split.length < 1) {                                                      // se non sono contenuti degli spazi e quindi split.length sarà 0 dobbiamo nuovamente restituire return ''
      return '';
    }

    return split[0];                                                            // Se invece lo split contiene uno o più elementi allora finalmente possiamo restituire il I elemento utile che verosomilmente sarà il nostro "nome".
  }


  String get lastName {
    if(displayName == null || displayName!.isEmpty) {
      return '';
    }

    final split = displayName!.split(' ');

    if(split.length <= 1) {                                                     // Questa volta però non andremo a controllare se lo (split < 1) ma se è (split <= 1), in quanto se è presente almeno un elemento
                                                                                // allora non potremo estrarre il "cognome" di conseguenza restituiremo un elemento vuoto.
                                                                                // Viceversa potremo restituire il II elemento che sarà per forza di cose contenuto all'interno dello "split".
      return '';
    }
    return split[1];
  }
}