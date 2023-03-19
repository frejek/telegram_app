part of 'chats_cubit.dart';

@immutable
abstract class ChatsState extends Equatable {
  const ChatsState();

  @override
  List<Object?> get props => [];
}

// class ChatsInitial extends ChatsState {}

class FetchingChatsState extends ChatsState {}                                  // STATO DI CARICAMENTO (verrà emesso nella fase di ottenimento dei dati delle nostre "Chat" in sostanza.

class FetchedChatsState extends ChatsState {                                    // STATO CHATS RFECUPERATE (corrisponde allo STATO in cui le chats sono state ottenute.)
  List<Chat> chats;

  FetchedChatsState(this. chats);

  @override
  List<Object?> get props => [chats];
}

class NoChatsState extends ChatsState {}                                        // STATO NO CI SONO CHATS dopo resultSet (risultato delle nostre Chats ottenute fosse vuoto).

class ErrorChatsState extends ChatsState {}                                     // STATO DI ERRORE (che verrà emesso in caso di condizione di errore).

