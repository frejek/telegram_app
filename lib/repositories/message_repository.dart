import 'package:firebase_database/firebase_database.dart';
import 'package:telegram_app/misc/mappers/firebase_mapper.dart';
import 'package:telegram_app/models/message.dart';

class MessageRepository {
  final FirebaseDatabase firebaseDatabase;
  final FirebaseMapper<Message> messageMapper;

  MessageRepository({
    required this.firebaseDatabase,
    required this.messageMapper,
  });

  // DataReference _message(String chat) => firebaseDatabase.reference().child('message/$chat');   // id della nostra chat in "RealTime Database"
                                                                                                   // NOTA: "reference()" è stat deprecata a favore di "ref()"
  DatabaseReference _messages(String chat) => firebaseDatabase.ref().child('message/$chat');

    Stream<List<Message>> messages(String chat) => _messages(chat).onValue.map((event) =>

    ((event.snapshot.value ?? {}) as Map).map<String, Message>(
      (key, value)=> MapEntry(
        key,
        messageMapper.fromFirebase(Map<String, dynamic>.from(value))
          .copyWith(id: key),
      ),
    )
    .values.toList(growable:false)
    .reversed
    .toList(growable: false),
  );
}