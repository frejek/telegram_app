part of 'sign_in_bloc.dart';

abstract class SignInEvent extends Equatable {
  const SignInEvent();

  @override                                                                     // Intanto facciamo "@override delle props" all'interno di "auth_event.dart" la classe astratta in modo tale da non doverla proporre di volta in volta.
  List<Object?> get props => [];
}

class PerformSignInEvent extends SignInEvent {                                  // EVENTO di Login standard con email e password
  final String email;
  final String password;

  PerformSignInEvent({required this.email, required this.password});            // Il Prof non mette const davanti ma Flutter mi chiede di metterlo

  @override
  List<Object?> get props => [email, password];
}

// II EVENTO Login di terze parti con Google
class PerformSignInWithGoogleEvent extends SignInEvent {}                       // non porta nulla con se in quanto il processo di Autenticazione di terze parti ha già tutto a bordo all'interno dei sui servizi come abbiamo visto in precedenza, l'autenticazione la gestisce automaticamente Google.

