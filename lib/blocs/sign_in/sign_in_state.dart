part of 'sign_in_bloc.dart';

abstract class SignInState extends Equatable {
  const SignInState();

  @override
  List<Object?> get props => [];
}

class initialSignInState extends SignInState {}                                 // Stato iniziale di quite

class SigningInState extends SignInState {}                                     // Lo stato SigningInState ossia quando eseguiremo il Login. Anche questo STATO non porta nulla in pancia con se, dovrà semplicemente mostrare lato Interfaccia Utente IU
                                                                                // ovvero il widget di caricamento SPINNER DI CARICAMENTO e bloccare le componenti attive come "campo email"  e "campo password"

class SuccessSignInState extends SignInState {                                  // Lo stato SuccessSignInState, questo STATO invece porterà con se le "userCredential" in quanto è l'argomento restituito dai due metodi:
  final UserCredential userCredential;                                          // "Future<UserCredential> signIn({required String email, required String password})" e  "Future<UserCredential> signInWithGoogle()" sono proprio le "UserCredential"

  SuccessSignInState(this.userCredential);                                      // Il Prof non mette const davanti ma Flutter mi chiede di metterlo

  @override
  List<Object?> get props => [userCredential];                                  // Serve per Identificare Univocamente questo STATO.
}

// IV STATO Errore
class ErrorSignInState extends SignInState {}                                   // Questo stato di tipo ErrorSignInState che nel nostro caso non porta nulla a bordo ma in realtà potremo mettere l'eccezione rilanciata per eventualmente visualizzare un messaggio di errore più dettagliato all'interno della nostra interfaccia.
                                                                                // In realtà ai fini di demo, alla fine del nostro caso di studio (case study) è irrilevante.