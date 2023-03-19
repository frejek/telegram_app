import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:telegram_app/cubits/auth/auth_cubit.dart';
import 'package:telegram_app/pages/home_page.dart';
import 'package:telegram_app/pages/welcome_page.dart';
import 'package:telegram_app/widgtes/connectivity_widget.dart';

class MainPage extends ConnectivityWidget {
  const MainPage({super.key});

  // Ci mettiamop in ascolto dei cambiamenti di stato di AuthCubit ovvero se l'utente è autenticato o meno
  @override
  Widget connectedBuild(BuildContext context) =>
      BlocBuilder<AuthCubit, AuthState>(
        builder: (context, state) => state is LoadingAuthenticationState
          ? _loadingStateWidget()
          : state is AuthenticatedState
            ? HomePage(user: state.user)
          : const WelcomePage(),
      );

  Widget _loadingStateWidget() => Scaffold(
    body: Container(),
  );
}