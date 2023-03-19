part of 'chat_bloc.dart';

abstract class ChatState extends Equatable {
  const ChatState();

  @override
  List<Object?> get props => [];
}

class FetchingChatState extends ChatState {}                                    // Si occuperà di caricare le informazioni sulla chat corrente

class NoChatAvailableState extends ChatState {}                                 // Ossia quando è stato interrogato il database e non abbiamo trovato alcuna chat all'interno della base di dati.

class ChatAvailableState extends ChatState {                                    // Ossia quando è stato interrogato il database e abbiamo trovato una chat all'interno della base di dati
  final Chat chat;
  final StreamSubscription? streamSubscription;                                 // Aggiungiamo una streamSubscription per poi rimuoverlo a valle per evitare memory leek potenziali perdite di memoria.

  ChatAvailableState(this.chat, {this.streamSubscription});

  @override
  List<Object?> get props => [chat, streamSubscription];
}

class ChatWithMessagesState extends ChatAvailableState {
  final List<Message> messages;

  ChatWithMessagesState(Chat chat, {
    this.messages = const [],                                                   // Qui Flutter mi suggerisce di mettere const altrimenti segnala errore / In modo opzionale di default la lista dei messaggi è vuota /  Qui Flutter mi suggerisce di mettere const [] altrimenti segnala errore
    StreamSubscription? streamSubscription,
  }) : super(chat, streamSubscription: streamSubscription);

  @override
  List<Object?> get props => [...super.props, messages];
}

class ErrorChatState extends ChatState {}                                       // Verrà emesso qualora si verificassero delle particolari condizioni di errore durante il Fetching dei dati


