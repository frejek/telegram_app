import 'package:telegram_app/misc/mappers/firebase_mapper.dart';
import 'package:telegram_app/models/friend.dart';

class FriendFirebaseMapper extends FirebaseMapper<Friend> {
  @override
  Friend fromFirebase(Map<String, dynamic> map) => Friend(                      // Andiandiamo ad estrarre i dati da una mappa contenete dati passati dall'esterno per covertirli e restituire un oggetto di Tipo Friend
    allowed: map['allowed'],
    createdAt: map['created_at'] != null
      ? DateTime.fromMillisecondsSinceEpoch(map['created_at'])
      : null,

      updatedAt: map['update_at'] != null
      ? DateTime.fromMillisecondsSinceEpoch(map['updated_at'])
      : null
  );

  @override
  Map<String, dynamic> toFirebase(object) {
    // TODO: implement toFirebase
    throw UnimplementedError();
  }

}