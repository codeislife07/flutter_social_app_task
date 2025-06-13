abstract class AuthEvent {}

class AuthLogin extends AuthEvent {
  final String username;

  AuthLogin(this.username);
}

class AuthLogout extends AuthEvent {}

class AuthCheck extends AuthEvent {}
