import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:telegram_app/repositories/friend_repository.dart';

part 'friend_status_event.dart';
part 'friend_status_state.dart';

class FriendStatusBloc extends Bloc<FriendStatusEvent, FriendStatusState> {
  final FriendRepository friendRepository;

  FriendStatusBloc({required this.friendRepository}) : super(FetchingFriendStatusState());

  // verifichiamo se siamo amici attraverso questo metodo get che ci servirà poi
  // per costruire le condizioni amici o non amici in "chat_bloc.dart"
  bool get friends => state is FetchedFriendStatusState &&                      // Sono amici se lo stato è FetchedFriendStatusState vuol dire che abbiamo recuperato i dati dei due interlocutori e la loro relazione
      (state as FetchedFriendStatusState).friends;                              // e soprattutto se lo state è di "(Tipo FetchedFriendStatusState)" con "friends" che è true

  @override
  Stream<FriendStatusState> mapEventToState(                                    // MAPPARE GLI EVENTI DA TRADURRE IN STATI (come lo si può intuire dal nomne del metodo)
    FriendStatusEvent event
  ) async* {
      if(event is FetchFriendsStatusEvent) {
        yield* _mapFetchFriendStatusEventToState(event);
      } else if(event is CreateFriendshipEvent) {
        yield* _mapCreateFriendshipEventToState(event);
      }
  }

  Stream<FriendStatusState> _mapFetchFriendStatusEventToState(FetchFriendsStatusEvent event) async* {
    if(event is FetchFriendsStatusEvent) {
      yield FetchingFriendStatusState();

      bool? friends;

      try {
        friends = await friendRepository.isFriend(me: event.me, user: event.user);
      } catch(error) {
        yield ErrorFriendStatusState();

        if(friends != null) {
          yield FetchedFriendStatusState(friends);
        }
      }
    }
  }

  Stream<FriendStatusState> _mapCreateFriendshipEventToState(
      CreateFriendshipEvent event
  ) async* {
    yield FetchingFriendStatusState();                                          // che si occuperà di segnalare lo stato di caricamento della relazione, quindi quando stiamo interrogando il nostro db.

    // Dopo il caricamento e stabilito la relazione andiamo a costruirla
    try {
      await friendRepository.create(me: event.me, user: event.user);
    } catch(error) {
      yield ErrorFriendStatusState();
    }
  }

  void createFriendship({required String me, required String user}) =>
      add(CreateFriendshipEvent(me:me, user: user));

  void fetchStatus({required String me, required String user}) =>
    add(FetchFriendsStatusEvent(me: me, user: user),
  );
}

