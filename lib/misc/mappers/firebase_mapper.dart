// da Firebase dal database converto una Map in un Modello Oggetto
abstract class FirebaseMapper<T> {

  T fromFirebase(Map<String, dynamic> map);                                     // Il risultato di questi dati deve essere rimappato in un oggetto che verrà definito sulla base della specializzazione di questa classe.
                                                                                // Pertanto utilizzeremo la generics T per mantenere appunto un "Livello di astrazione generico" sul Tipo di ritorno di questo metodo.
                                                                                // Converto e Mappo i dati di una Map<String, dynamic> in un oggetto Model da restituire
  // verso il database converto un Oggetto in una mappa
  Map<String, dynamic> toFirebase(T object);                                    // Al CONTRARIO dobbiamo definire un metodo "toFirebase()" quando vogliamo "mappare dei dati" da inviare verso Firebase e che sostanzialmente prevede gli stessi Tipi ma invertiti.
}