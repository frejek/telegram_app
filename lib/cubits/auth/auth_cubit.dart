import 'dart:async';                                                            // StreamSubscription

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:fimber/fimber.dart';
import 'package:firebase_auth/firebase_auth.dart';

part 'auth_state.dart';


class AuthCubit extends Cubit<AuthState> {
  final FirebaseAuth firebaseAuth;
  late StreamSubscription<User?> _streamSubscription;



  // AuthCubit() : super(AuthInitial());

  AuthCubit({required this.firebaseAuth}) : super(LoadingAuthenticationState()) {
    // CI SOTTOSCRIVEREMO AI CAMBIAMENTI DI STATO DELL' UTENTE PER AGGIORNARE DI CONSEGUENZA INTERFACCIA UTENTE
    _streamSubscription = firebaseAuth.userChanges().listen(_onStateChanged);
                                                                                   // IMPORTANTE: la SOTTOSCRIZIONE AD UN LISTENER a questo metodo userChange() di FirebaseAuth   .listen  produce una "StreamSubscription" che è bene
                                                                                   // mettere da qualche parte per poterla successivamente chiudere e quindi liberare memoria nel momento in cui il nostro AuthCubit non ci servirà più.
                                                                                   // userChanges() restituisce  "stream<User?> user"  UTENTE AUTENTICATO
  }

  // Metodo che emette i cambiamenti di stato in fase di autenticazione dell'utente
  void _onStateChanged(User? user) {                                            // Contiene le informazioni dell'utente
    if(user == null) {
      emit(NotAuthenticatedState());

      Fimber.d('User not authenticated');                                       // Approfittiamo anche a mettere qualche riga di LOG così da non perderci questa informazioni. Che mi permette di registrare in modo ordinato le informazioni di eventuali errori.
    } else {
      emit(AuthenticatedState(user));

      Fimber.d("User is authenticated:  $user");                                // E facciamo lo stesso anche in caso di autenticazione. Andiamo quindi a registrare in modo ordinato queste informazioni.
    }
  }

  @override
  Future<void> close() async {
    await _streamSubscription.cancel();                                         // E all'interno di questo metodo andiamo a chiudere la "StreamSubscription"

    return super.close();
  }

  void signOut() async => await firebaseAuth.signOut();                         // Questo metodo utilizzeremo eventualmente per disconnetterci dal nostro account con il quale siamo autenticati.
                                                                                // SAREBBE PIU CORRETTO SCRIVERLO IN QUESTO MODO dato che signOut() restituisce una Future  -> Future<void> signOut() async => await firebaseAuth.signOut();

  void deleteUser(User user) async => await user.delete();                      // è necessario dare alla possibilità all'utente di cancellare il proprio account. LEGGE GBDR - delete è una (Future<void> delete)
}


