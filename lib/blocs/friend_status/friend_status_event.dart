/*
  Aggiungiamo un EVENTO di nome "FetchFriendStatusEvent" con il quale richiederemo appunto
  al Bloc (intermediario) se la RELAZIONE con Interlocutore è di amicizia o no.
*/
part of 'friend_status_bloc.dart';

abstract class FriendStatusEvent extends Equatable {
  const FriendStatusEvent();

  @override
  List<Object?> get props => [];
}

class FetchFriendsStatusEvent extends FriendStatusEvent {                       // EVENTO
  final String me;                                                              // il nostro uid
  final String user;                                                            // uid dell'interlocutore

  const FetchFriendsStatusEvent({required this.me, required this.user});        // uid dell'interlcocutore

  @override
  List<Object?> get props => [me, user];
}

class CreateFriendshipEvent extends FriendStatusEvent {
  final String me;
  final String user;

  const CreateFriendshipEvent({required this.me, required this.user});

  @override
  List<Object?> get props => [me, user];
}