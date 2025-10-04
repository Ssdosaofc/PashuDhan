import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:pashu_dhan/Presentation/Screens/Auth/LoginScreen.dart';
import 'package:pashu_dhan/Presentation/Screens/Landing/HomeScreen.dart';

import 'Data/datasource/local/local_datasource.dart';
import 'Data/datasource/remote/animal_remote_datasource.dart';
import 'Data/datasource/remote/auth_remote_datasource.dart';
import 'Data/repository_impl/animal_repository_impl.dart';
import 'Data/repository_impl/auth_repository_impl.dart';
import 'Domain/usecases/animal_usecases/add_animal_usecase.dart';
import 'Domain/usecases/auth_usecase/login_usecase.dart';
import 'Domain/usecases/auth_usecase/logout_usecase.dart';
import 'Domain/usecases/auth_usecase/signup_usecase.dart';
import 'Domain/usecases/animal_usecases/delete_animal_usecase.dart';
import 'Domain/usecases/animal_usecases/get_animal_usecase.dart';
import 'Domain/usecases/auth_usecase/update_profile_usecase.dart';
import 'Presentation/Screens/Auth/SignUpScreen.dart';
import 'Presentation/bloc/animal_bloc/animal_bloc.dart';
import 'Presentation/bloc/auth_bloc/auth_bloc.dart';



Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final localDatasource = LocalDatasource();
  final isAuthenticated = await localDatasource.isUserAuthenticated;

  runApp(MyApp(isAuthenticated: isAuthenticated));
}

class MyApp extends StatelessWidget {
  final bool isAuthenticated;
  const MyApp({super.key, required this.isAuthenticated});

  @override
  Widget build(BuildContext context) {

    final remoteDS = AuthRemoteDataSource(http.Client());
    final localDS = LocalDatasource();
    final authRepo = AuthRepositoryImpl(remoteDS,localDS);

    final animalRemoteDS = AnimalRemoteDataSource(http.Client(),localDS);
    final animalRepo = AnimalRepositoryImpl(animalRemoteDS);

    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthBloc>(
          create: (_) => AuthBloc(
            signupUseCase: SignupUseCase(authRepo),
            loginUseCase: LoginUseCase(authRepo),
            logoutUseCase: LogoutUseCase(authRepo),
            updateProfileUseCase: UpdateProfileUseCase(authRepo),
          ),
        ),
        BlocProvider<AnimalBloc>(
          create: (_) => AnimalBloc(
            getAnimalsUseCase: GetAnimalsUseCase(animalRepo),
            addAnimalUseCase: AddAnimalUseCase(animalRepo),
            deleteAnimalUseCase: DeleteAnimalUseCase(animalRepo),
          ),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        ),
        home: isAuthenticated ?  HomeScreen() : const Loginscreen(),
      ),
    );
  }
}
