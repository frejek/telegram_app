import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_essentials_kit/flutter_essentials_kit.dart';
import 'package:telegram_app/cubits/chats/chats_cubit.dart';
//import 'package:flutter_essentials_kit/misc/two_away_binding.dart';
import 'package:telegram_app/models/chat.dart';
import 'package:telegram_app/models/message.dart';
import 'package:telegram_app/repositories/chat_repository.dart';
import 'package:telegram_app/blocs/friend_status/friend_status_bloc.dart';
import 'package:telegram_app/repositories/message_repository.dart';


part 'chat_event.dart';
part 'chat_state.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
final FriendStatusBloc friendStatusBloc;                                        // Serve per verificare se effettivamente se abbiamo una RELAZIONE DI AMICIA con il nostro Interlocutore ed eventualmente costruire la chat.
  final ChatRepository chatRepository;                                          // per eseguire appunto le operazioni di "ricerca" e "creazione".
  final MessageRepository messageRepository;
  final messageBinding = TwoWayBinding<String>();                               // Mi serve per COLLEGARE in sostanza al nostro campo message.

  Stream<bool> get emptyChat => messageBinding.stream.map((message) =>          // Restituisce uno Stream<bool> e Verifica appunto se il messaggio è null oppure è una Stringa vuota
    message == null || message.isEmpty);
    ChatBloc({
      required this.friendStatusBloc,
      required this.chatRepository,
      required this.messageRepository,
    }) : super(FetchingChatState());                                            // Stato Iniziale del Bloc che si occuperà di caricare le informazioni sulla chat corrente

    @override
    Stream<ChatState> mapEventToState(                                          // Mappiamo gli eventi da tradurre in stati
      ChatEvent event,
    ) async* {
      if (event is SendMessageEvent) {                                          // Qualora si verificasse questa condizione invocheremo il metodo _mapSendMessageEvent()
        yield* _mapSendMessageEventToState(event);                              // Emetteremo poi tutti gli stati corrispondenti, questo vale per ogni metodo
      } else
      if (event is CreateChatEvent) {                                           // verrà utilizzato quando si invia il primo messaggio fra due interlocutori composto dal messaggio e i due interlocutori
        yield* _mapCreateChatEventToState(event);
      } else
      if (event is FindChatEvent) {                                             // Un evento che si occuperà di ricercare la chat dati gli uid dei due partecipanti
        yield* _mapFindChatEventToState(event);
      } else
      if (event is DeleteChatEvent) {                                           // UN evento che si occuperà di eliminare una Chat
        yield* _mapDeleteChatEventToState(event);
      } else if (event is NewMessagesEvent) {
        yield* _mapNewMessagesEventToState(event);
      } else if (event is EmitErrorChatEvent) {
        yield* _mapEmitErrorChatEventToState(event);
      }
    }

  // ADESSO ANDIAMO A MAPPARE LA LOGICA DI OGNUNO DI QUESTI METODI
  Stream<ChatState> _mapSendMessageEventToState(SendMessageEvent event) async* {
    try {
      // SE NON C'E' UNA RELAZIONE DI AMICIZIA LA CREIAMO
      if (!friendStatusBloc.friends) {
        friendStatusBloc.createFriendship(me: event.user, user: event.other);
      }

      // Dopo aver stabilito la "Relazione" andiamo ad aggiornare nella chat l'ultimo messaggio,
      // passeremo questi parametri che poi verranno aggiornati nel database
      await chatRepository.update(
        chat: event.chat,
        lastMessage: event.message,
      );
    } catch (error) {
      yield ErrorChatState();
    }
  }

  // Creiamo la Chat all'interno della nostra base di dati, ovviamnete qui passiamo i dati alla funzione create()
  // e la vera creazione all'interno del database avverrà all'interno della nostra dipendenza in ChatRepository,
  Stream<ChatState> _mapCreateChatEventToState(CreateChatEvent event) async* {
    Chat? chat;
    try {
      chat = await chatRepository.create(
        me: event.user,
        other: event.other,
        message: event.message,
      );
    } catch (error) {
      yield ErrorChatState();
    }

    // Una volta che abbiamo costruito la chat all'interno della nostra base di dati facciamo un controllo
    // ed emettiamo questo Evento aggiornando le informazioni all'interno della nostra chat
    if (chat != null) {
      add(
        SendMessageEvent(                                                       // Aggiorneremo le informazioni all'interno della nostra chat ed eventualmente creeremo anche una createFriendship()
          chat.id!,
          user: event.user,
          other: event.other,
          message: event.message,
        ),
      );

      // Una volta inviati i dati aggiornati all'interno della nostra chat avremo la chat disponibile
      // Ossia quando è stato interrogato il database e abbiamo trovato una chat all'interno della base di dati
      yield* _subscriptionForIncomingMessages(chat);                            // Qui invochiamo questo metodo Stream che abbiamo messo a FATTOR COMUNE al posto di "yield ChatAvailableState" per dire che la chat è stata creata è disponibile.
    }
  }

  Stream<ChatState> _mapFindChatEventToState(FindChatEvent event) async* {      // Mappiamo gli eventi da tradurre in stati per quanto riguarda FindChat
    yield FetchingChatState();                                                  // Emettiamo questo stato in attesa del caricamento dei dati della chat, dovremo caricare una Chat e non più di una Chat

    List<Chat>? chats;

    try {
      chats = await chatRepository.find(                                        // Cerchiamo di ottenere l'elenco delle chat disponibili
          event.user,
          other: event.other
      );
    } catch (error) {                                                           // In caso di errore emettiamo questo stato
      yield ErrorChatState();
    }

    if (chats != null) {
      if (chats.length == 1) {
        yield* _subscriptionForIncomingMessages(chats.first);                   // emetteremo questo metodo a fattor Comune


      } else if(chats.isEmpty) {                                                // Se la teremo questo stato
        yield NoChatAvailableState();
      } else {                                                                  // altrimenti se ci sono più chat o zero chat c'è qualcosa che non va, noi dobbiamo avere solo una chat disponibile.
        yield ErrorChatState();
      }
    }
  }

  Stream<ChatState> _mapDeleteChatEventToState(DeleteChatEvent event) async* {
    // Adesso ragioniamo per assurdo un po come si faceva alle medie quando si voleva dimostrtare i teoremio in matematica

    bool success = true;                                                        // Mi consentirà di sapere se la cancellazione è andata a buon fine.

    await event.streamSubscription?.cancel();                                   // cancelliamo lo streamSubscription per evitare memory leek

    try {
      await chatRepository.delete(event.id);                                    // Questo event.id lo passiamo come parametro all'argomento del metodo delete(String chat) che riceve appunto id della chat
    } catch(error) {
      success = false;                                                          // Qualora qualcosa fosse andato storto impostiamo "success = false" per dire che la cencellazione non è andata a buon fine
      yield ErrorChatState();         
    } finally {
      if(success) {                                                             // verifichiamo se si è verificato un errore e in caso di (success) emettiamo questo stato.
        yield NoChatAvailableState();                                           // Abbiamo cancellato questa chat quindi di fatto non è più presente.
      }
    }
  }

  // Metteremo a fattor comune tutti gli elementi quando emettiamo (yield ChatAvailableState) in modo da sottoscriverci
  // ai messaggi in arrivo su quella specifica chat.
  Stream<ChatState> _subscriptionForIncomingMessages(Chat chat) async* {
    StreamSubscription? streamSubscription;

    streamSubscription = messageRepository.messages(chat.id!).listen((messages) => add(  // Ci mettiamo in ascolto dei cambiamenti di stato dei nostri messaggi ed emetterremo questo evento per aggiornare le informazioni della chat xon questa lista di messaggi
        NewMessagesEvent(
          chat,
          streamSubscription: streamSubscription,
          messages: messages,
        ),
      ), onError: (_) => add(EmitErrorChatEvent(streamSubscription)),           // Emetteremo questo stato semplicemente per passare lo streamSubscription per poi chiudere a valle lo stream per evitare memory leek
    );

    yield ChatAvailableState(chat);
  }

  Stream<ChatState> _mapNewMessagesEventToState(NewMessagesEvent event) async* {   // Questo evento NewMessagesEvent fa da "passa carte" dove andrà a raccogliere i messaggi che verranno mappati all'interno di questo stato ChatWithMessagesState
    yield ChatWithMessagesState(
      event.chat,
      streamSubscription: event.streamSubscription,
      messages: event.messages,
    );
  }

  Stream<ChatState> _mapEmitErrorChatEventToState(EmitErrorChatEvent event) async* {
    await event.streamSubscription?.cancel();                                   // Cancelliamo eventualmente una streamSubscription

    yield ErrorChatState();
  }

  // Andiamo a registrare questo e andiamo ad aemettere questo evento per informare il ChatBloc per verificare se esiste una chat tra i due Interlocutori.
  void findChat({
    required String user,
    required String other,
  }) => add(FindChatEvent(user: user, other: other));


  void sendMessage({                                                            // Inviol il messaggio se la chat è disponibile
    required String user,
    required String other,
    String? chat,                                                               // id della chat del docuemnto chats: 1236873216123
    String? message,
  }) {
    add(
        (state is ChatAvailableState)
          ? SendMessageEvent(
              chat ?? (state as ChatAvailableState).chat.id!,                   // Dobbiamo gestire il fatto che "chat" è nullabile, se "chat" contiene qualcosa è "chat", altrimenti castiamo a ChatAvailableState per accedere "chat.id" ovvero all'id della chat

              user: user,
              other: other,
              message: message ?? messageBinding.value ?? '',                   // La funzione passa ci passa "message" che è nullabile per cui dovremo gestire appunto questa situazione altrimenti avremo un errore. Quindi "message" lo andiamo a prendere in questo modo:
                                                                                // se "message" non è vuoto allora "message" altrimenti "messageBinding" se anch'esso contiene qualcosa qualcosa altrimenti Stringa vuota
            )
          : CreateChatEvent(                                                    // altrimenti che la "ChatAvailableState" non è disponibile
              user: user,
              other: other,
              message: message ?? messageBinding.value ?? '',                   // su message devo gestire il fatto che sia nullabile e quindi lo prendiamo alla stessa maniera di prima.                                                           // In caso ChatAvailableState non sia disponibile, essendo che non è mai stata creata ne creeremo una nuova
            ),
      );
      // Alla fine dopo aver inviato il messaggio svuotiamo il contenuto di messageBinding
      messageBinding.value = '';
  }

  // Registriamo all'interno di ChatBloc un nuovo metodo che riceverà come parametro id della chat che vogliamo cancellare.
  // In questo modo diremo all'intermediario Bloc di andare a cancellare la chat e in base al risultato emettere l'evento corrispondente.
  void deleteChat(String id, {StreamSubscription? streamSubscription}) =>
    add(                                                                        // accetta come parametro (argomento) id della nostra chat da cancellare, passiamo lo streamSubscription per cancellare lo streamChat per evitare memory leek
      DeleteChatEvent(
          id,
          streamSubscription: streamSubscription,                               // Qui cancelliamo la sottoscrizione per evitare memory leek perchè quando andiamo ad eleminare una chat non vogliamo più metterci in ascolto di nuovi messaggi in arrivo in quanto la chat è stata eliminata.
      ),
    );


  @override
  Future<void> close() async {
    if(state is ChatAvailableState) {
      await (state as ChatAvailableState).streamSubscription?.cancel();         // lo castiamo a (chat as ChatAvailablestate) per poter accedere allo "streamSubscription.cancel()" per poi cancellarlo
    }

    await messageBinding.close();
    return super.close();
  }
}




