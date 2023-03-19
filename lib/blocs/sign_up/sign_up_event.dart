part of 'sign_up_bloc.dart';

abstract class SignUpEvent extends Equatable {
  const SignUpEvent();
}

class PerformSignUpEvent extends SignUpEvent {                                  // Aggiungiamo Evento
  final String firstName;
  final String lastName;
  final String email;
  final String password;

  PerformSignUpEvent({
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.password,
  });

  @override
  List<Object?> get props => [firstName, lastName, email, password];            // props decide quali oggetti dobbiamo considerare per il confronto degli oggetti. Quindi aggiungiamo tutti quegli attributi di una istanza che permettono di identificarla univocamente una classe rispetto ad un'altra.
                                                                                // Poi facciamo @override di props che conterrà tutti questi campi per descriminare appunto un Evento dall'altro
}