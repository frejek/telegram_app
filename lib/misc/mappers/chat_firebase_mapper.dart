import 'package:telegram_app/misc/mappers/firebase_mapper.dart';
import 'package:telegram_app/models/chat.dart';

class ChatFirebaseMapper extends FirebaseMapper<Chat> {
  @override
  Chat fromFirebase(Map<String, dynamic> map) => Chat(                          // Amndiamo a Mappare i dati estraendo i dati dal Database dalla raccolta Chat che restiuirà un oggetto Chat
    lastMessage: map['last_message'],
    createdAt: map['created_at'] != null
      ? DateTime.fromMillisecondsSinceEpoch(map['created_at'])
      : null,

    updatedAt: map['updated_at'] != null
      ? DateTime.fromMillisecondsSinceEpoch(map['updated_at'])
      : null
  );

  @override
  Map<String, dynamic> toFirebase(Chat object) {                                // Andiamo a mappare i dati da un oggetto li converto in una Map<String, dynamic>
    // TODO: implement toFirebase
    throw UnimplementedError();
  }
}