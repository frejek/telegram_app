import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:telegram_app/models/model.dart';

part 'message.g.dart';

@CopyWith()                                                                     // Notazione @CopyWith nel quale potremo costruire una copia esatta di questo oggetto con gli stessi attributi ma con valori diversi.
class Message extends Model {
  final String message;                                                         // testo del messaggio scambiato
  final String sender;                                                          // ossia uid di chi invia il messaggio

  Message({
    String? id,
    required this.message,
    required this.sender,
    DateTime? createdAt,
    DateTime? updateAt,
  }): super(id, createdAt: createdAt, updatedAt: updateAt);

  @override
  List<Object?> get props => [...super.props, message, sender];
}