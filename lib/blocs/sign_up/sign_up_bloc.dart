import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_essentials_kit/flutter_essentials_kit.dart';
import 'package:rxdart/rxdart.dart';

import 'package:telegram_app/cubits/auth/auth_cubit.dart';
import 'package:telegram_app/repositories/authentication_repository.dart';
import 'package:telegram_app/repositories/user_repository.dart';
import 'package:telegram_app/models/user.dart' as models;

part 'sign_up_event.dart';
part 'sign_up_state.dart';

class SignUpBloc extends Bloc<SignUpEvent, SignUpState> {
  final AuthenticationRepository authenticationRepository;                      // Aggiungiamo inanzitutto la DIPENDENZA in quanto dovremo sfruttarlo per eseguire appunto la Registrazione invocando il metodo di signUp()
  final AuthCubit authCubit;                                                    // Abbiamo bisogno di questa DIPENDENZA per accedere poi a queste informazioni ed eseguire la sottoscrizione per metterci in ascolto ed intercettare l'autenticazione dell'utente e di conseguenza modificargli le informazioni
  final UserRepository userRepository;                                          // Aggiungiamo la DIPENDENZA UserRepository per accedere al metodo create() per creare un nuovo user

  // LE COMPONENTI STREAM Binding per l'autovalidazione vanno ad ottenere il contenuto di input della TextField
  final firstNameBinding = TwoWayBinding<String>().bindDataRule(RequiredRule());
  final lastNameBinding = TwoWayBinding<String>().bindDataRule(RequiredRule());

  final emailBinding = TwoWayBinding<String>()                                  // Agganceremo sia la RequiredRule che EmailRule
    .bindDataRule(RequiredRule())
    .bindDataRule(EmailRule());

  final passwordBinding = TwoWayBinding<String>().bindDataRule(RequiredRule());

  final confirmEmailBinding = TwoWayBinding<String>()
    .bindDataRule(RequiredRule())
    .bindDataRule(EmailRule());

  final confirmPasswordBinding = TwoWayBinding<String>().bindDataRule(RequiredRule());

  // Stiamo dicendo che "confirmEmailBinding" deve ascoltare lo STREAM di "emailBinding" ed EMETTERE "STATO POSITIVO" quindi non mostrare uno "STATO DI ERRORE"  quando
  // i due campi sono uguali, quindi quando si verifica la "SameRule" REGOLA SPECIALE
  SignUpBloc({                                                                  // COSTRUTTORE
    required this.authenticationRepository,
    required this.authCubit,
    required this.userRepository,
  }) : super(SignUpInitialState()) {                                            // CASO INIZIALE quite, In questo momento non sta facendo nulla  REGOLA SPECIALE
    confirmEmailBinding.bindDataRule2(emailBinding, SameRule());
    confirmPasswordBinding.bindDataRule2(passwordBinding, SameRule());
  }

  // ADESSO DOBBIAMO VALIDARE TUTTI I CAMPI PER OTTENERE UNO STREAM CHE CI CONSENTA DI DESCRIMINARE L'ATTIVAZIONE DEL NOSTRO _signUpButton()
  Stream<bool> get areValidCredentials => Rx.combineLatest(
    [                                                                           // I Argomento è un array di Stream
      firstNameBinding.stream,
      lastNameBinding.stream,
      emailBinding.stream,
      confirmEmailBinding.stream,
      passwordBinding.stream,
      confirmPasswordBinding.stream,
    ], (_) =>
          firstNameBinding.value != null && firstNameBinding.value!.isNotEmpty &&   // II Argomento è una Funzione di callback con una Lista di valori presenti all'interno degli Stream. Questi valori non ci interessono in quanto faremo gli stessi controlli che abbiamo fatto in "signInPage"
          lastNameBinding.value != null && lastNameBinding.value!.isNotEmpty &&
          emailBinding.value != null && emailBinding.value!.isNotEmpty &&
          confirmEmailBinding.value != null && confirmEmailBinding.value!.isNotEmpty &&
          passwordBinding.value != null && passwordBinding.value!.isNotEmpty &&
          confirmPasswordBinding.value != null && confirmPasswordBinding.value!.isNotEmpty

  );

  // Qui controlliamo inanzitutto che EVENTO propagato sia "event is performSignUpEvent", L'EVENTO contiene le credenziali. Se SI! andiamo ad eseguire questo stato.
  @override
  Stream<SignUpState> mapEventToState(SignUpEvent event) async* {               // MAPPARE GLI EVENTI DA TRADURRE IN STATI - QUESTO METODO LO USO MA E' STATO DEPRECATO
    if(event is PerformSignUpEvent) {
      yield SigningUpState();                                                   // EMETTIAMO QUESTO STATO CHE MOSTRA LO SPINNER DI CARICAMENTO CirculaProgresIndicator()

      // Dato che informazioni dello "User user" per estrarre le informazioni di name e cognome sono presenti in authCubit, quindi, poi potremo passarle.
      // Quindi ha senso sottoscriverci a questo AuthCubit all'interno del nostro SignInBloc() in modo tale da intercettare l'utente autenticato e di conseguenza modificare le informazioni.
      // Prima di avviare il processo di signInUp() costruiamo una subscription (SOTTOSCRIZIONE) e in particolare ci metteremo IN ASCOLTO (e FILTREREMO)
      // soltanto gli stati di "Tipo AuthenticatedState" e succesivamente invocare una funzione che dovrà aggiornare le informazioni dell'utente autenticato
      // alla quale passeremo EVENTO (che conterrà le informazioni dell'utente autenticato) in quanto dobbiamo necessariamente passare le informazioni appunto
      // di "firstName" e "lastName", e lo "state" che dovremo castatare che sia  state: (state as AuthenticatedState).
      // QUINDI IN SOSTANZA DOVREMO PASSARE TUTTE LE INFORMAZIONI DELL'UTENTE DI CHI SI E' REGISTRATO IN QUEL MOMENTO PRIMA DI EFFETTUARE LA REGISTRAZIONE.

      // filtro
      final authSubscription = authCubit.stream
          .where((state) => state is AuthenticatedState)
          .listen((state) => _updateUserProfile(event, state: (state as AuthenticatedState)));

      UserCredential? userCredential;

      try {
        userCredential = await authenticationRepository.signInUp(
          email: event.email,
          password: event.password,
        );
      } catch(error) {
        yield ErrorSignUpState();
      } finally {
        authSubscription.cancel();

      }

      if(userCredential != null) {
        yield SuccessSignUpState(userCredential);
      }
    }
  }

  void _updateUserProfile(
      PerformSignUpEvent event, {
        required AuthenticatedState state,
  }) async {
    final user = state.user;
    final firstName = event.firstName;
    final lastName = event.lastName;
    final displayName = '$firstName $lastName';

    // ATTENZIONE passiamo al metodo create l'oggetto user e poi lo rimapperà in una Map<String, dynamic> per salvare lo user nel DB
    await userRepository.create(                                                // Creiamo uno Utente all'interno del database
      models.User(                                                              // Se metto solo User va in conflitto con lo User dell'Autenticazione, mentre noi dobbiamo far riferimento allo User presente nel modello, per cui abbiamo importato user come alias "as models" e poi lo abbiamo anteposto "models.User"
        id: user.uid,
        firstName: firstName,
        lastName: lastName,
        lastAccess: DateTime.now(),
      ),
    );
    await user.updateDisplayName(displayName);                                  // Invochiamo questo metodo di Flutter per aggiornare l'informazione dell'utente autenticato ovvero il "nome" e il "cognome", oppure anche un "secondo nome" e così via.
  }                                                                             // updateDisplayName è una Future<void> andrà ad aggiornare le informazioni dell'utente autenticato

  @override
  Future<void> close() async{
    await firstNameBinding.close();
    await lastNameBinding.close();
    await emailBinding.close();
    await confirmEmailBinding.close();
    await passwordBinding.close();
    await confirmPasswordBinding.close();

    return super.close();
  }


  // Registriamo all'interno di SignUpBloc anche il metodo performSignUp() che dato questi parametri poi andrà ad EMETTERE EVENTO PerformSignUpEvent attarverso il metodo add()
  // In questo modo diremo a SignUpBloc (intermediario) di andare a recuperare i dati di input dell'utente e in funzione di ciò che sarà recuperato
  // EMETTERE LO STATO CORRISPONDENTE.
  void performSignUp({
    String? firstName,
    String? lastName,
    String? email,
    String? password,
  }) =>
    add(
      PerformSignUpEvent(
        firstName: (firstName ?? firstNameBinding.value) ?? '',                 // se c'è firstName è firstname, se non c'è firstname sarà firstNameBinding e se non c'è firstNameBinding sarà vuoto che eviteremo
        lastName: (lastName ?? lastNameBinding.value) ?? '',
        email: (email ?? emailBinding.value) ?? '',
        password: (password ?? passwordBinding.value) ?? '',
      ),
    );
}
