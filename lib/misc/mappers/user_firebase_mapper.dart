import 'package:telegram_app/misc/mappers/firebase_mapper.dart';
import 'package:telegram_app/models/user.dart';

class UserFirebaseMapper extends FirebaseMapper<User> {                         // definisce come Tipo T il nostro <User> il nostro Model
                                                                                // facciamo @override dei metodi che abbiamo definito nella nostra sopraclasse FirebaseMapper per andare a sovrascrivre questi metodi come vogliamo noi in questa classe

  // riceve i dati di Tipo Map<String, dynamic>, facciamo il mapping dei dati estrandoli dalla mappa e restituisco
  // un oggetto di Tipo User con i dati aggiortnati
  @override
  User fromFirebase(Map<String, dynamic> map) =>
    User(
      firstName: map['first_name'],
      lastName: map['last_name'],
      lastAccess: map['last_access'] != null ? DateTime.fromMillisecondsSinceEpoch(map['last_access']) : null,
      createdAt: map['created_at'] != null ? DateTime.fromMillisecondsSinceEpoch(map['created_at']) : null,
      updatedAt: map['updated_at'] != null ? DateTime.fromMillisecondsSinceEpoch(map['updated_at']): null,
    );

  // A partire da un oggetto User user dobbiamo rimappare i dati in una Mappa in Firebase nel nostro database
  @override
  // Map<String, dynamic> toFirebase(User object) => {
  Map<String, dynamic> toFirebase(User user) => {                               // Convertiamo i dati che riceviamo dall'esterno ovvero una una istanza di User e mappiamo i dati di User nel database con i dati aggiornati.
    'first_name': user.firstName,
    'last_name': user.lastName,
    'last_access': user.lastAccess?.millisecondsSinceEpoch,
    'create_at':  user.createdAt.millisecondsSinceEpoch,
    'update_at': user.updatedAt?.millisecondsSinceEpoch,

  };
}