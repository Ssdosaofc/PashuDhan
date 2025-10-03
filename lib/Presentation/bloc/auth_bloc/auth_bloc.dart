import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../Domain/usecases/auth_usecase/login_usecase.dart';
import '../../../Domain/usecases/auth_usecase/signup_usecase.dart';
import '../../../Domain/usecases/auth_usecase/logout_usecase.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final SignupUseCase signupUseCase;
  final LoginUseCase loginUseCase;
  final LogoutUseCase logoutUseCase;

  AuthBloc({
    required this.signupUseCase,
    required this.loginUseCase,
    required this.logoutUseCase,
  }) : super(AuthInitial()) {
    on<SignupEvent>(_onSignup);
    on<LoginEvent>(_onLogin);
    on<LogoutEvent>(_onLogout);
  }

  Future<void> _onSignup(SignupEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      final user = await signupUseCase(
        event.email,
        event.password,
        event.confirmPassword,
        event.role,
      );
      emit(AuthSuccess(role: user.role, message: "User registered successfully"));
    } catch (e) {
      emit(AuthFailure(e.toString()));
    }
  }

  Future<void> _onLogin(LoginEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      final user = await loginUseCase(event.email, event.password,event.role);
      emit(AuthSuccess(token: user.token, role: user.role, message: "Login successful"));
    } catch (e) {
      emit(AuthFailure(e.toString()));
    }
  }

  Future<void> _onLogout(LogoutEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      await logoutUseCase(event.token);
      emit(AuthSuccess(message: "Logged out"));
    } catch (e) {
      emit(AuthFailure(e.toString()));
    }
  }
}
