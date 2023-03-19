/*
All'interno del Cubit ci SOTTOSCRIVEREMO al metodo chat() che abbiamo costruito all'interno di "chat_repository.dart"
Il metodo chat() si aspetta di ricevere un "uid" dell'utente, per questo motivo lo andremo a prendere dall'esterno e poi questo "uid" lo passiamo al costruttore.

E successivamente ci mettiamo in ASCOLTO attraverso un "ASCOLTATORE listen" ai cambiamenti di stato delle chat e ci sottoscriverremo a chat,
e a seconda dei casi emetteremo gli stati corrispondenti.
*/
import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:telegram_app/models/chat.dart';
import 'package:telegram_app/repositories/chat_repository.dart';

part 'chats_state.dart';

class ChatsCubit extends Cubit<ChatsState> {
  final String uid;
  final ChatRepository chatRepository;
  StreamSubscription<List<Chat>>? _streamSubscription;

  // ChatsCubit() : super(ChatsInitial());
  ChatsCubit(this.uid, {required this.chatRepository}) : super(FetchingChatsState()) {
    _streamSubscription = chatRepository.chat(uid).listen(
        (chats) =>  emit(
            chats.isEmpty ? NoChatsState() : FetchedChatsState(chats)
        ),
        onError: (_) => emit(ErrorChatsState()),
    );
  }

  @override
  Future<void> close() {
    _streamSubscription?.cancel();

    return super.close();
  }
}
