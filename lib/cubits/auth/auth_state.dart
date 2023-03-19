part of 'auth_cubit.dart';

abstract class AuthState extends Equatable {
  const AuthState();

  @override                                                                     // Intanto facciamo "@override delle props" all'interno di "auth_state.dart" la classe astratta
  List<Object> get props => [];                                                 // in modo tale da non doverla proporre di volta in volta.
}


class LoadingAuthenticationState extends AuthState {}

class AuthenticatedState extends AuthState {
  final User user;

  const AuthenticatedState(this.user);

  @override
  // TODO: implement props
  List<Object> get props => [user];


}

class NotAuthenticatedState extends AuthState {}