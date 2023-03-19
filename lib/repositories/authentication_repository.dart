// PER ESEGUIRE L'AUTENTICAZIONE IN Firebase DOBBIAMO MODELLARE UNA NUOVA "REPOSITORY"

import 'package:fimber/fimber.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:telegram_app/exceptions/already_existing_account_exception.dart';
import 'package:telegram_app/exceptions/sign_in_canceled_exception.dart';
import 'package:telegram_app/exceptions/wrong_credentials_exception.dart';

class AuthenticationRepository {
  final FirebaseAuth firebaseAuth;
  final GoogleSignIn googleSignIn;

  AuthenticationRepository({
    required this.firebaseAuth,
    required this.googleSignIn
  });

  Future<UserCredential> signIn({required String email, required String password}) async {
    try {
      return await firebaseAuth.signInWithEmailAndPassword(
          email: email,
          password: password
      );
    //  direttamente attraverso il suo "e.code"
    } on FirebaseAuthException catch(e) {
      if(e.code == 'User-not-found') {
        Fimber.e('No user found for the email.');
      } else if(e.code == 'wrong-password') {
        Fimber.e('Wrong password provided for the user.');
      }
      throw new WrongCredentialsException();
    }
  }

  Future<UserCredential> signInWithGoogle() async {
    final GoogleSignInAccount? googleUser = await googleSignIn.signIn();

    if (googleUser != null) {
      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

      final OAuthCredential credentials = GoogleAuthProvider.credential(

        accessToken: googleAuth.accessToken,
        idToken:  googleAuth.idToken,
      );
      return await firebaseAuth.signInWithCredential(credentials);
    }
    Fimber.e('User canceled the login process');
    throw new SignInCanceledException();
  }

  Future<UserCredential> signInUp({required String email, required String password}) async {
    return await firebaseAuth.createUserWithEmailAndPassword(email: email, password: password);

  }

  // Registrazione
  Future<UserCredential?> signUp({
    required String email,
    required String password
  }) async{
    try {
      return await firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch(e) {
      if (e.code == 'email-already-in-use') {
        Fimber.e('The account already exists for that email.');
        throw new AlreadyExisistingAccountException();
      }
    }
  }
}


