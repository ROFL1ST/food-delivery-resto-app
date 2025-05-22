import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_delivery_resto_app/data/datasources/auth_remote_datasources.dart';
import 'package:food_delivery_resto_app/data/datasources/order_remote_datasource.dart';
import 'package:food_delivery_resto_app/data/datasources/product_remote_datasources.dart';
import 'package:food_delivery_resto_app/presentation/auth/bloc/login/login_bloc.dart';
import 'package:food_delivery_resto_app/presentation/auth/bloc/logout/logout_bloc.dart';
import 'package:food_delivery_resto_app/presentation/auth/bloc/register/register_bloc.dart';
import 'package:food_delivery_resto_app/presentation/auth/pages/splash_pages.dart';
import 'package:food_delivery_resto_app/presentation/menu/bloc/add_product/add_product_bloc.dart';
import 'package:food_delivery_resto_app/presentation/menu/bloc/delete_product/delete_product_bloc.dart';
import 'package:food_delivery_resto_app/presentation/menu/bloc/get_order/get_order_bloc.dart';
import 'package:food_delivery_resto_app/presentation/menu/bloc/get_order_detail/get_order_detail_bloc.dart';
import 'package:food_delivery_resto_app/presentation/menu/bloc/get_product/get_product_bloc.dart';
import 'package:food_delivery_resto_app/presentation/menu/bloc/update_order_status/update_oder_status_bloc.dart';
import 'package:food_delivery_resto_app/presentation/menu/bloc/update_product/update_product_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'core/constants/colors.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  await dotenv.load(fileName: ".env");
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => RegisterBloc(AuthRemoteDataSource())),
        BlocProvider(create: (context) => LoginBloc(AuthRemoteDataSource())),
        BlocProvider(create: (context) => LogoutBloc(AuthRemoteDataSource())),
        BlocProvider(create: (context) => GetProductBloc(ProductRemoteDatasources())),
        BlocProvider(create: (context) => AddProductBloc(ProductRemoteDatasources())),
        BlocProvider(create: (context) => DeleteProductBloc(ProductRemoteDatasources())),
        BlocProvider(create: (context) => UpdateProductBloc(ProductRemoteDatasources())),
        BlocProvider(create: (context) => GetOrderBloc(OrderRemoteDatasource())),
        BlocProvider(create: (context) => GetOrderDetailBloc(OrderRemoteDatasource())),
        BlocProvider(create: (context) => UpdateOderStatusBloc(OrderRemoteDatasource())),
        
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: AppColors.primary),
          scaffoldBackgroundColor: AppColors.white,
          dividerTheme: const DividerThemeData(color: AppColors.divider),
          textTheme: GoogleFonts.interTextTheme(Theme.of(context).textTheme),
          appBarTheme: AppBarTheme(
            color: AppColors.primary,
            elevation: 0,
            titleTextStyle: GoogleFonts.inter(
              color: AppColors.white,
              fontSize: 16.0,
              fontWeight: FontWeight.w500,
            ),
            iconTheme: const IconThemeData(color: AppColors.white),
            centerTitle: true,
          ),
        ),
        home: const SplashPages(),
      ),
    );
  }
}
