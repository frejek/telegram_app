part of 'users_bloc.dart';

abstract class UsersEvent extends Equatable {
  const UsersEvent();

  @override
  List<Object?> get props => [];
}

class ResetSearchEvent extends UsersEvent {}                                    // Questo evento sostanzialmente si occuperà di resettare il Bloc per riportarlo ad uno STATO INIZIALE.
                                                                                // E questo sarà particolarmente utile nella fase in cui andremo a "ricercare degli utenti" e successivamente torneremo indietro attraverso al ROLLBACK
                                                                                // per tornare ad una visualizzazione della "Lista dei nostri amici".

class SearchUserEvent extends UsersEvent {                                      // L'altro EVENTO ci consentirtà di avviare la ricerca e si chiamerà "SearchUserEvent"
  final String query;

  const SearchUserEvent(this.query);

  @override
  List<Object?> get props => [query];
}



