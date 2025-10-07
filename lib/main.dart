import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;

// Domain Repositories
import 'Domain/repository/product_repository.dart';

// Data Repositories & Datasources
import 'Data/datasource/local/local_datasource.dart';
import 'Data/datasource/remote/auth_remote_datasource.dart';
import 'Data/datasource/remote/animal_remote_datasource.dart';
import 'Data/datasource/remote/product_remote_datasource.dart';
import 'Data/repository_impl/auth_repository_impl.dart';
import 'Data/repository_impl/animal_repository_impl.dart';
import 'Data/repository_impl/product_repository_impl.dart';

// Usecases
import 'Domain/usecases/animal_usecases/get_animal_by_id_usecase.dart';
import 'Domain/usecases/auth_usecase/signup_usecase.dart';
import 'Domain/usecases/auth_usecase/login_usecase.dart';
import 'Domain/usecases/auth_usecase/logout_usecase.dart';
import 'Domain/usecases/auth_usecase/update_profile_usecase.dart';
import 'Domain/usecases/animal_usecases/get_animal_usecase.dart';
import 'Domain/usecases/animal_usecases/add_animal_usecase.dart';
import 'Domain/usecases/animal_usecases/delete_animal_usecase.dart';
import 'Domain/usecases/product_usecases/add_product_usecase.dart';
import 'Domain/usecases/product_usecases/fetch_product_usecase.dart';

// Presentation
import 'Presentation/Screens/Landing/Veterinarian/VetHomeScreen.dart';
import 'Presentation/Screens/Shopkeeper/HomeScreen.dart';
import 'Presentation/bloc/auth_bloc/auth_bloc.dart';
import 'Presentation/bloc/animal_bloc/animal_bloc.dart';
import 'Presentation/bloc/product_bloc/product_bloc.dart';
import 'Presentation/Screens/Landing/HomeScreen.dart';
import 'Presentation/Screens/Auth/LoginScreen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final localDatasource = LocalDatasource();
  final isAuthenticated = await localDatasource.isUserAuthenticated;
  final userRole = await localDatasource.getUserRole();

  print("Role: $userRole");

  runApp(MyApp(isAuthenticated: isAuthenticated, userRole: userRole));
}

class MyApp extends StatelessWidget {
  final bool isAuthenticated;
  final String? userRole;

  const MyApp({super.key, required this.isAuthenticated, this.userRole});

  @override
  Widget build(BuildContext context) {
    // --- Datasources ---
    final authRemoteDS = AuthRemoteDataSource(http.Client());
    final animalRemoteDS = AnimalRemoteDataSource(http.Client(), LocalDatasource());
    final productRemoteDS = ProductRemoteDataSource(http.Client());

    // --- Repositories ---
    final authRepo = AuthRepositoryImpl(authRemoteDS, LocalDatasource());
    final animalRepo = AnimalRepositoryImpl(animalRemoteDS);
    final productRepo = ProductRepositoryImpl(productRemoteDS);

    // --- Usecases ---
    final signupUseCase = SignupUseCase(authRepo);
    final loginUseCase = LoginUseCase(authRepo);
    final logoutUseCase = LogoutUseCase(authRepo);
    final updateProfileUseCase = UpdateProfileUseCase(authRepo);

    final getAnimalsUseCase = GetAnimalsUseCase(animalRepo);
    final addAnimalUseCase = AddAnimalUseCase(animalRepo);
    final deleteAnimalUseCase = DeleteAnimalUseCase(animalRepo);
    final getIdsUseCase = GetAnimalIdsByNameUseCase(animalRepo);


    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthBloc>(
          create: (_) => AuthBloc(
            signupUseCase: signupUseCase,
            loginUseCase: loginUseCase,
            logoutUseCase: logoutUseCase,
            updateProfileUseCase: updateProfileUseCase,
          ),
        ),
        BlocProvider<AnimalBloc>(
          create: (_) => AnimalBloc(
            getAnimalsUseCase: getAnimalsUseCase,
            addAnimalUseCase: addAnimalUseCase,
            deleteAnimalUseCase: deleteAnimalUseCase,
            getIdsUseCase: getIdsUseCase,
          ),
        ),
        BlocProvider<ProductBloc>(
          create: (context) => ProductBloc(
            addProductUseCase: AddProductUseCase(productRepo),
            fetchProductsUseCase: FetchProductsUseCase(productRepo),
          ),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        ),
        home: isAuthenticated
            ? _getInitialScreen(userRole)
            : const Loginscreen(),
      ),
    );
  }

  Widget _getInitialScreen(String? role) {
    switch (role) {
      case 'Farmer':
        return HomeScreen();
      case 'Shopkeeper':
        return ShopkeeperScreen();
      case 'Veterinarian':
        return VetHomeScreen();
      default:
        return const Loginscreen();
    }
  }
}

