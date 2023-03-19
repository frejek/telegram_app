part of 'users_bloc.dart';

abstract class UsersState extends Equatable {
  const UsersState();

  @override
  List<Object?> get props => [];
}

class InitialUsersState extends UsersState {}                                   // Stato iniziale

class SearchingUsersState extends UsersState {}                                 // Stato Intermedio di caricamento di loading

class FetchedUsersState extends UsersState {                                    // Lo Stato all'interno delo quale scaricheremo la "Lista degli utenti" che abbiamo trovato.
  final List<User> users;

  const FetchedUsersState(this.users);

  @override
  List<Object?> get props => [users];
}

class NoUsersState extends UsersState {}                                        // Quando non abbiamo trovato praticamente nulla

class ErrorUsersState extends UsersState {}                                     // Quando si verifica qualche errore.