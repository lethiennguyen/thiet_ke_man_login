import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:ma_so_thue/app_routes.dart';
import 'package:ma_so_thue/blocs/auth/auth_bloc.dart';
import 'package:ma_so_thue/blocs/product/list_product_cubit.dart';
import 'package:ma_so_thue/blocs/product/product_detail_cubit.dart';
import 'package:ma_so_thue/data/core/constants.dart';
import 'package:ma_so_thue/data/repositories/users_repositories.dart';
import 'package:ma_so_thue/hive/hive_constants.dart';
import 'package:ma_so_thue/hive/shopping_cart/hive_shopping_cart.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();

  await Hive.openBox(HiveBoxNames.auth);
  final box = Hive.box(HiveBoxNames.auth);
  final bool isLoggedIn = box.get('isLoggedIn', defaultValue: false);

  Hive.registerAdapter(CartItemAdapter());
  await Hive.openBox<CartItem>(HiveBoxNames.cartbox);
  final dio = Dio(BaseOptions(baseUrl: ApiConfig.baseUrl));

  // lấy key trên server chứa aznhr
  await dotenv.load(fileName: '.env');

  final authRepo = AuthRepository(dio);
  runApp(
    BlocProvider(
      create: (_) => CartCubit(Hive.box<CartItem>(HiveBoxNames.cartbox)),
      child: MyApp(authRepo, initialRoute: isLoggedIn ? '/home' : '/login'),
    ),
  );
}

class MyApp extends StatelessWidget {
  final String initialRoute;
  final AuthRepository authRepo;
  const MyApp(this.authRepo, {super.key, required this.initialRoute});
  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider.value(value: authRepo),
        RepositoryProvider.value(value: productRepo),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(create: (_) => AuthBloc(authRepo)),
          BlocProvider(
            create: (_) {
              final cubit = ListProductCubit(productRepo);
              cubit.loadFirstPage();
              return cubit;
            },
          ),
        ],
        child: MaterialApp(
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.black),
            inputDecorationTheme: InputDecorationTheme(
              hintStyle: GoogleFonts.nunitoSans(
                fontWeight: FontWeight.w600,
                fontSize: 16,
                color: const Color(0xff5C6771),
              ),
            ),
            floatingActionButtonTheme: const FloatingActionButtonThemeData(
              shape: CircleBorder(),
              backgroundColor: Colors.white,
            ),
          ),
          darkTheme: ThemeData.dark(),
          routes: appRoutes,
          initialRoute: initialRoute,
          navigatorObservers: [HeroController()],
        ),
      ),
    );
  }
}
