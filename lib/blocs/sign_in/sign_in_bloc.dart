import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_essentials_kit/flutter_essentials_kit.dart';
import 'package:rxdart/rxdart.dart';

import 'package:telegram_app/cubits/auth/auth_cubit.dart';
import 'package:telegram_app/repositories/authentication_repository.dart';
import 'package:telegram_app/repositories/user_repository.dart';
import 'package:telegram_app/extensions/user_first_last_name.dart';             // abbiamo importanto extensione overo un file che contiene delle informazioni aggiuntive allo User che ora è di Tipo FirebaseAuth per poter usufruire anche in questo file user.firstName e user.lastName
import 'package:telegram_app/models/user.dart' as models;                       // In questo modo User fa riferimento al modello


part 'sign_in_event.dart';

part 'sign_in_state.dart';

class SignInBloc extends Bloc<SignInEvent, SignInState> {
  final AuthenticationRepository authenticationRepository;
  final UserRepository userRepository;
  final AuthCubit authCubit;

  final emailBinding = TwoWayBinding<String>()
      .bindDataRule(RequiredRule())
      .bindDataRule(EmailRule());
  final passwordBinding = TwoWayBinding<String>().bindDataRule(
      RequiredRule()); // campo email

  SignInBloc(
      {required this.authenticationRepository, required this.userRepository, required this.authCubit}) // E' il I stato iniziale del nostro Bloc è InitialSignInState (Quite), è il I STATO, ci sta bene perchè appunto è il nostro STATO di quite.
      : super(initialSignInState());

  // ADESSO DOBBIAMO VALIDARE TUTTI I CAMPI PER OTTENERE UNO STREAM CHE CI CONSENTA DI DESCRIMINARE L'ATTIVAZIONE DEL NOSTRO _signInButton()
  //Stream<bool> get areValidCredentials => Rx.combineLatest2(
  get areValidCredentials => Rx.combineLatest2 (
      emailBinding.stream,
      passwordBinding.stream,
          (_, __) =>                                                            // III parametro è una funzione di callback. I valori non ci interessono. Andiamo a verificare che i valori di "emailBinding" e "passwordBinding" NON SIANO VUOTI E NULL
          emailBinding.value != null &&                                         // Ci assicuriamo che email e password non contengono un valore null (in quanto è un valore che non esiste) oppure vuoto '' che cmq però in questo caso contiene un valore seppur vuoto un carattere vuoto
          emailBinding.value!.isNotEmpty &&
          passwordBinding.value != null &&
          passwordBinding.value!.isNotEmpty
  );

  @override
  Stream<SignInState> mapEventToState(
    SignInEvent event,
  ) async* {
    if (event is PerformSignInEvent || event is PerformSignInWithGoogleEvent) {
      yield SigningInState();

      UserCredential? userCredential;

      StreamSubscription? authSubscription;

      try {
        if(event is PerformSignInEvent) {
          userCredential = await authenticationRepository.signIn(
              email: event.email,
              password: event.password,
            );
        } else {
          authSubscription = authCubit.stream
              .where((state) => state is AuthenticatedState)
              .listen((state) => _updateUserProfile(state as AuthenticatedState));

          userCredential = await authenticationRepository.signInWithGoogle();
        }
      } catch (error) {
          yield ErrorSignInState();
      } finally {
        authSubscription?.cancel();
      }

      if (userCredential != null) {
        yield SuccessSignInState(userCredential);
      }
    }
  }

  @override
  Future<void> close() async {
    await emailBinding.close();
    await passwordBinding.close();

    return super.close();
  }

  void performSignIn({                                                          // Metodo Login Standard
    String? email,
    String? password,
  }) =>
      add(
        PerformSignInEvent(
          email: (email ?? emailBinding.value) ?? '',
          password: (password ?? passwordBinding.value) ?? '',
        ),
      );


  void performSignInWithGoogle() => add(PerformSignInWithGoogleEvent());        // login e registrazioen con Google

  void _updateUserProfile(AuthenticatedState state) async {
      final User user = state.user;
      final firstName = user.firstName;
      final lastName = user.lastName;

      // Passo al metodo create un Oggetto User del modello che voglio costruire nel database
      await userRepository.create(
        models.User(
          id: user.uid,
          firstName: firstName,
          lastName: lastName,
          lastAccess: DateTime.now(),
        ),
      );
  }
}