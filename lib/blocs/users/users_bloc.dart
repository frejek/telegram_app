import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:telegram_app/cubits/search_cubit.dart';
import 'package:telegram_app/models/user.dart';
import 'package:telegram_app/repositories/user_repository.dart';

part 'users_event.dart';
part 'users_state.dart';

class UsersBloc extends Bloc<UsersEvent, UsersState> {
  final SearchCubit searchCubit;
  final UserRepository userRepository;

  StreamSubscription<String?>? _searchStreamSubscription;
  StreamSubscription<bool>? _toggleStreamSubscription;                           // Qui ci sottoscriveremo ai cambiamenti di stato della ricerca se è attiva o meno

  Timer? _debounce;                                                              // Evita di stressare troppo il server a seguto di troppe richieste, basti pensare che ogni lettera che scriviamo sul campo di ricerca viene inviata una query. Possiamo evitare questo definendo un debounce un Timer che si attiverà quando abbiamo finito di scrivere sul campo di ricverca e farà scattare la query.

  UsersBloc({
    required this.searchCubit,
    required this.userRepository,
  }) : super(InitialUsersState()) {
    // ATTENZIONE: qui ci siamo SOTTOSCRITTI ai CAMBIAMENTI DI STATO del "Testo della ricerca".
    _searchStreamSubscription =
        searchCubit.searchBinding.stream
            .where((query) => query != null)
            .listen((query) {

          if (_debounce != null && _debounce!.isActive) _debounce?.cancel();
          _debounce = Timer(
              const Duration(milliseconds: 250), () => _searchUsers(query!));
        });

        // ATTENZIONE: qui invece ci siamo SOTTOSCRITTI ai "CAMBIAMENTI DI STATO DELLA RICERCA", ossia se la "Ricerca è attiva o meno".
        _toggleStreamSubscription =
            searchCubit.stream.where((enable) => !enable).listen((_) => _reset());  // Qui mi SOTTOSCRIVO e mi metto in ascolto solamente degli EVENTI di spegnimento della modalità di ricerca. E quando si verifica questa condizione EVENT non ci serve quindi lo ignoriamo (_), dovremo RESETTARE appunto il nostro Bloc.
  }

  @override
  Stream<UsersState> mapEventToState(                                           // MAPPARE GLI EVENTI DA TRADURRE IN STATI
    UsersEvent event,
  ) async* {
    if(event is SearchUserEvent) {
      yield SearchingUsersState();                                              // per mostrare nella UI la ShimmedList()

      List<User>? users;
      try {
        users = await userRepository.search(event.query);
      } catch(exception) {
        yield ErrorUsersState();
      }

      if(users != null) {
        yield users.isEmpty ? NoUsersState() : FetchedUsersState(users);
      }

      if(event is ResetSearchEvent) {
        yield InitialUsersState();                                              // In questa maniera riporteremo la nostra pagina newMessagePage() allo stato iniziale.
      }
    }
  }

  @override
  Future<void> close() async {
    await _searchStreamSubscription?.cancel();
    await _toggleStreamSubscription?.cancel();
    return super.close();
  }

  void _searchUsers(String query) => add(SearchUserEvent(query));

  void _reset() => add(ResetSearchEvent());
}
