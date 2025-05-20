import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_delivery_resto_app/core/core.dart';
import 'package:food_delivery_resto_app/data/datasources/auth_local_datasources.dart';
import 'package:food_delivery_resto_app/presentation/auth/bloc/logout/logout_bloc.dart';
import 'package:food_delivery_resto_app/presentation/auth/pages/login_pages.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: BlocListener<LogoutBloc, LogoutState>(
        listener: (context, state) {
          state.maybeWhen(
            orElse: () {},
            success: () async {
              await AuthLocalDatasources().removeAuthData();
              context.pushReplacement(const LoginPage());
            },
            error: (error) {
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text(error)));
            },
          );
        },
        child: IconButton(
          icon: const Icon(Icons.logout),
          onPressed: () {
            context.read<LogoutBloc>().add(const LogoutEvent.logout());
          },
        ),
      ),
    );
  }
}
