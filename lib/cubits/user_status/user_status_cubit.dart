/*
In questo caso i cambiamenti di stato dello User vengono comunicati al Bloc al quale ci sottoscriveremo
per aggiornare di conseguenza la UI
*/
import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:telegram_app/models/user.dart';
import 'package:telegram_app/repositories/user_repository.dart';

part 'user_status_state.dart';

class UserStatusCubit extends Cubit<UserStatusState> {
  final UserRepository userRepository;

  StreamSubscription<User>? _streamSubscription;

  UserStatusCubit(
      User user, {                                                              // Dobbiamo passare anche l'utente del quale vogliamo conoscere i cambiamenti.
        required this.userRepository
      }) : super(UpdatedUserStatusState(user)) {
          _streamSubscription = userRepository.user(user.id!).listen(
            (user) =>
            emit(UpdatedUserStatusState(user),
            ),
        onError: (_) => emit(ErroUserStatusState()),
    );
  }

  @override
  Future<void> close() async {
    await _streamSubscription?.cancel();

    return super.close();
  }
}
