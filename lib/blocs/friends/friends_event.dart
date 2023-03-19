part of 'friends_bloc.dart';

abstract class FriendsEvent extends Equatable {
  const FriendsEvent();
}

class FetchFriendsEvent extends FriendsEvent {                                  // Andremo ad EMETTERE questo unico evento in quanto vogliamo appunto ottenere la Lista dei nostri amici. Qundi informeremo Intermediario BLOC di farci restituire la lista dei nostri amici attraverso questo evento.
  final String uid;                                                             // Il parametro sarà il nostro uid

  FetchFriendsEvent(this.uid);

  @override
  List<Object?> get props => [uid];
}
