abstract class AuthState {}

class AuthInitial extends AuthState {}

class Authenticated extends AuthState {
  final String username;

  Authenticated(this.username);
}

class Unauthenticated extends AuthState {}
