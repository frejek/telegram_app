part of 'chat_bloc.dart';

abstract class ChatEvent extends Equatable {
  const ChatEvent();

  @override
  List<Object?> get props => [];
}

class FindChatEvent extends ChatEvent {                                         // Un evento che si occuperà di ricercare la chat dati gli uid dei due partecipanti, infatti dichiariamo queste due proprietà uid di User e uid di other (interlocutore)
  final String user;
  final String other;

  FindChatEvent({required this.user, required this.other});                     // Costruttore Nominale

  @override
  List<Object?> get props => [user, other];
}

class CreateChatEvent extends FindChatEvent {                                   // Questa volta lo stato "CreateChatEvent extends FindChatEvent" in quanto questo evento "CreateChatEvent" avrà bisogno di "user" e "other"
  final String message;                                                         // oltre al messaggio da inviare e sostanzialmente questo evento verrà utilizzato quando si invia il primo messaggio fra due interlocutori.

  CreateChatEvent({
    required String user,
    required String other,
    required this.message,
  }) : super(user: user, other: other);                                         // Invochiamo il costruttore della sopraclasse inviando "user"e "other"

  @override
  List<Object?> get props => [...super.props, message];                         // oltre a ereditare ...super.props aggiungerà anche message
                                                                                // i ...serve per dire che non vogliamo un annidamento di un vettore all'interno di un'altro vettore ma vogliamo che restituisca un vettore con elementi separati.
}

// Abbiamo bisogno di user, other, message, per inviare la chat
class SendMessageEvent extends CreateChatEvent {                                // Questo evento avrà bisogno degli attributi precedentemente definiti e in più porterà a bordo "id della Chat" per inviare appunto un nuovo messaggio
  final String chat;                                                            // contine id della chat

  SendMessageEvent(
    this.chat, {                                                                // questa rappresenta id della chat
    required String user,
    required String other,
    required String message,
  }) : super(user: user, other: other, message: message);

  @override
  List<Object?> get props => [...super.props, chat];
}

class DeleteChatEvent extends ChatEvent {
  final String id;
  final StreamSubscription? streamSubscription;                                 // Aggiungiamo streamSubscription perchè quando andiamo ad eliminare una chat dobbiamo smettere di ascoltare i nuovi messaggi che arrivono all'interno della stessa, poichè la stessa non esiste più.

  DeleteChatEvent(this.id, {this.streamSubscription});

  @override
  List<Object?> get props => [id, streamSubscription];
}

//*** vedi sopra
class NewMessagesEvent extends ChatEvent {
  final Chat chat;                                                              // Avremo bisogno dell'istanza di Chat
  final List<Message> messages;                                                 // L'elenco dei messaggio che dovremo poi mappare in uno stato
  final StreamSubscription? streamSubscription;                                 // sottoscrizione al metodo message in MessageRepository per deallocarlo nel momento cui non ci serve più

  NewMessagesEvent(
    this.chat, {
    this.messages = const [],                                                   // Paramateri opzionali un array vuoto
    this.streamSubscription,
  });

  @override
  List<Object?> get props => [chat, messages, streamSubscription];
}

class EmitErrorChatEvent extends ChatEvent {
  StreamSubscription? streamSubscription;                                       // Servirà semplicemente per chiudere a valle la "StreamSubscription" per evitare memory leek perdite di emmoria.

  EmitErrorChatEvent(this.streamSubscription);

  @override
  List<Object?> get props => [streamSubscription];
}
