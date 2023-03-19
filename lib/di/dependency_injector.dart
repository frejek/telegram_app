/*
  Andremo a scolpire un widget di nome "dependency_injector.dart" attraverso il quale inietteremo all'interno
  della "Gerarchia Dei Widget" della nostra applicazione tutte le dipendenze dell'app IN MODO CHE SIANO VISIBILI
  A LIVELLO DI APP. Siano esse quindi:  Repositories, Mappers, Providers, BloC e Cubit
*/

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';                              // Importiamo "Firebase" da "firebase_core.dart"
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:telegram_app/cubits/auth/auth_cubit.dart';
import 'package:telegram_app/cubits/dark_mode_cubit.dart';
import 'package:telegram_app/misc/mappers/chat_firebase_mapper.dart';
import 'package:telegram_app/misc/mappers/firebase_mapper.dart';
import 'package:telegram_app/misc/mappers/friend_firebase_mapper.dart';
import 'package:telegram_app/misc/mappers/message_firebase_mapper.dart';
import 'package:telegram_app/misc/mappers/user_firebase_mapper.dart';
import 'package:telegram_app/models/chat.dart';
import 'package:telegram_app/models/friend.dart';
import 'package:telegram_app/models/message.dart';
import 'package:telegram_app/providers/shared_preferences_provider.dart';
import 'package:telegram_app/repositories/authentication_repository.dart';
import 'package:telegram_app/models/user.dart' as models;
import 'package:telegram_app/repositories/chat_repository.dart';
import 'package:telegram_app/repositories/friend_repository.dart';
import 'package:telegram_app/repositories/message_repository.dart';
import 'package:telegram_app/repositories/user_repository.dart';


// GERARCHIA: 1 providers - 2 mappers - 3 repositories - 4 bloc Cubit


class DependencyInjector extends StatelessWidget {
  final Widget child;

  const DependencyInjector({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) => _providers(                             // Un volta iniettati i metodi all'interno della "Gerarchia dei Widegt" li andremo a CABLARE-CONNETTERE all'interno del metodo build() seguendo questa gerarchia.
    child: _mappers(
      child: _repositories(
        child: _blocs(
          child: child,
        ),
      ),
    ),
  );

  Widget _providers({required Widget child}) => MultiProvider(



    providers: [
        Provider<SharedPreferencesProvider>(
          create: (_) => SharedPreferencesProvider(
              sharedPreferences: SharedPreferences.getInstance(),








          ),
        ),
        Provider<FirebaseAuth>(                                                 // Iniettato all'interno della "Gerarchia Dei Widget"
          create: (_) => FirebaseAuth.instance,
        ),
        // GUIDA AMBITI: Questi "scopes"- AMBITI sono in sostanza, dobbiamo dichiarare quali dati dobbiamo prelevare
        // nel momento in cui andremo ad eseguire l'autenticazione con il "GoogleSignIn".
        // GUIDA: https://cloud.google.com/apigee/docs/api-platform/security/oauth/working-scopes?hl=it
        // PROF: https://developers.google.com/identity/protocols/oauth2/scopes
        Provider<GoogleSignIn>(                                                 // Lo Iniettiamo all'interno della "Gerarchia Dei Widget"
          create: (_) => GoogleSignIn(
            scopes: [                                                           // Quindi possiamo prelevare anche dati più sensibili
              'https://www.googleapis.com/auth/userinfo.email',
              'https:www.googleapis.com/auth/userinfo/profile',
            ],
          ),
        ),
        Provider<FirebaseFirestore>(                                            // Nulla di più nulla di meno, in questo modo potremo sfruttare appunto gli strumenti messi a dispsozione dalla "dependency_injector.dart" e quindi navigare a ritroso
                                                                                // dalla "Gerarchia Dei widget" per andare a recuperare il nostro FirebaseFirestore e utilizzarlo all'interno dei nostri Repository per sfruttare appunto il nostro
                                                                                // database di Firestore.
          create: (_) => FirebaseFirestore.instance,
        ),
        Provider<FirebaseDatabase>(
          create: (_) => FirebaseDatabase(app: Firebase.app()),                 // importiamo "Firebase da "firebase_core.dart"
        ),
      ],
      child: child,
  );

  Widget _mappers({required Widget child}) => MultiProvider(
      providers: [
        Provider<FirebaseMapper<models.User>>(                                  // Ci riferiamo allo User del modello e non quello di FirebaseAuth altrimenti non contiene le informazioni di extension "firstName" e "lastName"
          create: (_) => UserFirebaseMapper()                                   // <models.User> sarebbe <T> Pertanto utilizzeremo la generics T per mantenere appunto un "Livello di astrazione generico" sul Tipo di ritorno di questo metodo.
        ),
        Provider<FirebaseMapper<Chat>>(
          create: (_)  => ChatFirebaseMapper(),
        ),
        Provider<FirebaseMapper<Friend>>(
          create: (_) => FriendFirebaseMapper(),                                // Nella create inializziamo costruiamo questo mapper
        ),
        Provider<FirebaseMapper<Message>>(                                      // Iniettiamo MessageFirebaseMapper() in modo tale da mappare i dati da Firebase (database) o verso Firebase
          create: (_) => MessageFirebaseMapper(),
        ),
      ],
      child: child,                                                             // Questo child sarà il widget immediatamente sucessivo che sarà contenuto da "dependency_injector.dart"
                                                                                // affinche gli stessi possano accedere successivamente a tutti  gli elementi INIETTATI all'interno della
                                                                                // "Gerarchia Dei Widget".
  );

  Widget _repositories({required Widget child}) => MultiRepositoryProvider(
    providers: [
      RepositoryProvider(
        create: (context) => AuthenticationRepository(                          // - Contiene i metodi di signIn (autenticazione standard) - signInWithGoogle (Autenticazione con Google) - SignUp (Registrazione)
                                                                                // Dipendenza che mi permette di accedere i diversi metodi signInWithEmailAndPassword() (Per Autenticazione e la Registrazione) - signInWithGoogle() -
            firebaseAuth: context.read(),                                       // "firebaseAuth" e "googleSignIn" sono stati già precedentemente INIETTATI all'interno dei "Provider" quindi sono già presenti all'interno della "Gerarchia Dei Widget" pertanto per ottenerli basta accedervi in questo modo: context.read()
            googleSignIn: context.read(),                                       // Mi permette di effettuare l'autenticazione con Google automaticamente
        ),
      ),
      RepositoryProvider(
        create: (context) => UserRepository(
            firebaseFirestore: context.read(),                                  // FirebaseFirestore e userMapper li otterremo mediante  "context.read()"  attraverso l'accesso della "Gerarchia Dei Widget" dato che sono già stati INIETTATI precedentemente. - Mi permette di accesso al mio database quindi saranno presenti tutti per gestire -
            userMapper: context.read()                                          // Quindi UserFirebaseMapper() è già stato INIETTATO all'interno del metodo _mappers()   - Mi permette di creare  un nuovo utente nel database -
        ),
      ),
      RepositoryProvider(
        create: (context) => ChatRepository(
          firebaseFirestore: context.read(),                                    // firebaseFirestore è già stato iniettato all'interno della "Gerarchia Dei Widget" quindi per accedervi faccio context.read()
          chatMapper: context.read(),
          userMapper: context.read(),
        ),
      ),
      RepositoryProvider(
        create: (context) => FriendRepository(
          firebaseFirestore: context.read(),
          friendMapper: context.read(),
          userMapper: context.read(),
        ),
      ),
      RepositoryProvider(
        create: (context) => MessageRepository(
          firebaseDatabase: context.read(),
          messageMapper: context.read(),
        ),
      ),
    ],
    child: child,
  );

  Widget _blocs({required Widget child}) => MultiBlocProvider(
    providers: [
      BlocProvider<DarkModeCubit>(                                              // Il metodo create: () ha come parametro (context) e in questa particolarte istanza LO UTILIZZEREMO PER COSTRUIRE il nostro DarkModeCubit  accetta come parametro
                                                                                // il "preferencesProvider:" dato che anche il costruttore lo richiede. Poichè "preferencesProvider"  è stato dichiarato ad un LIVELLO SUPERIORE ossia al Livello dei _providers() lo otterremo attarverso
                                                                                // la risoluzione dell'elemento all'interno della "Gerarchia Dei Widget" e per far ciò facciamo context.read(). Il context.read() andrà a risolvere la "Gerarchia Dei Widget"
                                                                                // alla ricerca del primo preferencesProvider utile.
        create: (context) => DarkModeCubit(                                     // Mi permette di passare dallo stato del Tema chiaro o scuro e viceversa
            preferencesProvider: context.read()                                 // l'attributo preferencesProvider: fa riferimento alla classe SharedPreferencesProvider() DATABASE LOCALE dove andiamo a impostare e recuperare lo stato del cubit qundi possiamo accedrvi attraverso la "Gerarchia Dei Widget" facendo context.read()
        )..init(),                                                              // Non dimentichiamoci tuttavia di invocare il metodo init() sul DarkModeCubit() per far si che lo stesso inizializzi lo stato del Cubit sulla base delle sharedPreferences.
                                                                                // Per far ciò a seguito della costruzione del DarkModecubit() scriviamo ..init(),
      ),
      BlocProvider<AuthCubit>(
        create: (context) => AuthCubit(firebaseAuth: context.read()),           // "firebaseAuth" è stato precedentemente INIETTATO all'interno dei "Provider" quindi è già presente all'interno della "Gerarchia Dei Widget" pertanto per ottenerlo basta accedervi in questo modo: context.read()
                                                                                // Contine il metodo per gestire gli stati ed emetterli durante la fase di autenticazione
      ),
    ],
    child: child,                                                               // Questo child sarà il widget immediatamente sucessivo che sarà contenuto da "dependency_injector.dart"
                                                                                // affinche gli stessi widget possano accedere successivamente a tutti  gli elementi INIETTATI all'interno della
                                                                                // "Gerarchia Dei Widget".
  );


}

