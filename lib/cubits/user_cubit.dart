/*
Mi serve per aggiornare l'ultimo accesso dell'utente e quando eseguiremo delle operazioni con ChatBloc aggiorneremo
il nostro ultimo accesso, per fare questo dobbiamo sottoscriverci e metterci in ascolto su chatBloc.
Per non sovraccaricare troppo il server user usiamo _debounce, ovvero andremo ad impostare un nuovo Timer dopo dio chè
andremo ad aggiornare uid dell'utente Ultimo acesso - lastAccess.
*/

import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:telegram_app/blocs/chat/chat_bloc.dart';
import 'package:telegram_app/repositories/user_repository.dart';

class UserCubit extends Cubit<void> {
  final String uid;
  final UserRepository userRepository;
  final ChatBloc chatBloc;

  StreamSubscription<ChatState>? _streamSubscription;
  Timer? _debounce;

  UserCubit(
    this.uid,{
    required this.userRepository,
    required this.chatBloc,
  }) : super(null) {
    _streamSubscription = chatBloc.stream.listen((_) {                          // Ci mettiamo in ascolto dei cambiamenti di stato di ChatBloc. l'argomento non mi interessa perchè di fatto dobbiamo eseguire solo un aggiornamento
      if(_debounce != null && _debounce!.isActive) _debounce?.cancel();         // Se l'ultima istanza di "_debounce?" è attiva la cancelliamo per poterlo reimpostare. Quindi ogni volta cancelliamo il Timer precedente.
        _debounce = Timer(                                                      // Al costruttore di Timer dobbiamo passare una Duratione e una funzione di callback() "() =>"
            const Duration(milliseconds: 250),
            () async => await userRepository.update(uid),                       // Aggiorneremo last_access e update_at
        );
    });
  }
  @override
  Future<void> close() async {                                                  // Non dimentichiamoci di CHIUDERE "_debounce" e lo "_streamSubscription" dalla memoria altrimenti avremo dei "memory leek" perdite di memoria.
    _debounce?.cancel();
    await _streamSubscription?.cancel();
    return super.close();
  }
}