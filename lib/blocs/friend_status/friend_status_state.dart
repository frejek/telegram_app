part of 'friend_status_bloc.dart';

abstract class FriendStatusState extends Equatable {
  const FriendStatusState();

  @override
  // TODO: implement props
  List<Object?> get props => throw UnimplementedError();
}

class FetchingFriendStatusState extends FriendStatusState {}                    // Questo stato  si occuperà di segnalare lo stato di caricamento della relazione, quindi quando stiamo interrogando il nostro db.

class FetchedFriendStatusState extends FriendStatusState {                      // uno STATE che indica se abbiamo recuperato al RELAZIONE con Interlocutore
  final bool friends;

  const FetchedFriendStatusState(this.friends);

  @override
  List<Object?> get props => [friends];
}

class ErrorFriendStatusState extends FriendStatusState {}                       // Il solito stato di errore dove in casoi die rrore mostrerà una finestra di dialogo una SnackBar

