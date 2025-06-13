import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc() : super(AuthInitial()) {
    on<AuthCheck>(_onCheck);
    on<AuthLogin>(_onLogin);
    on<AuthLogout>(_onLogout);
  }

  Future<void> _onCheck(AuthCheck event, Emitter<AuthState> emit) async {
    final prefs = await SharedPreferences.getInstance();
    final username = prefs.getString('username');
    if (username != null) {
      emit(Authenticated(username));
    } else {
      emit(Unauthenticated());
    }
  }

  Future<void> _onLogin(AuthLogin event, Emitter<AuthState> emit) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('username', event.username);
    emit(Authenticated(event.username));
  }

  Future<void> _onLogout(AuthLogout event, Emitter<AuthState> emit) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('username');
    emit(Unauthenticated());
  }
}
