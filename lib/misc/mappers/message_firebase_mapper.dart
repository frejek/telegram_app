import 'package:telegram_app/misc/mappers/firebase_mapper.dart';
import 'package:telegram_app/models/message.dart';

class MessageFirebaseMapper extends FirebaseMapper<Message> {
  @override
  Message fromFirebase(Map<String, dynamic> map) => Message(
    message: map['message'],
    sender: map['sender'],
    createdAt: map['createdAt'] != null
        ? DateTime.fromMillisecondsSinceEpoch(map['createdAt'])                 // converto la data da Stringa a un numero
        : null,

    updateAt: map['updateAt'] != null
      ? DateTime.fromMillisecondsSinceEpoch(map['updateAt'])
      : null,
  );

  @override
  Map<String, dynamic> toFirebase(Message object) {
    // TODO: implement toFirebase
    throw UnimplementedError();
  }

}