part of 'sign_up_bloc.dart';

abstract class SignUpState extends Equatable {
  const SignUpState();

  @override
  List<Object?> get props => [];                                                // Facciamo subito @override della props in modo tale da definirlo una volta.
}

class SignUpInitialState extends SignUpState {}                                  // Stato iniziale di quite, quindi non porta con se nessun parametro di classe


class SigningUpState extends SignUpState {}                                     // stato Spinne di caricamento

class SuccessSignUpState extends SignUpState {                                  // Stato di successo, porta in grembo una proprietà di classe da FirebaseAuth ovvero l'utente che si è registrato
  final UserCredential userCredential;

  const SuccessSignUpState(this.userCredential);                                // A me viene chiesto di aggiungere il modificvatore const

  @override
  List<Object?> get props => [userCredential];
}

class ErrorSignUpState extends SignUpState {}                                   // Statto di Errore
