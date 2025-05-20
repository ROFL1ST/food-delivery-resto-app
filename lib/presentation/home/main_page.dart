import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_delivery_resto_app/data/datasources/auth_local_datasources.dart';
import 'package:food_delivery_resto_app/presentation/auth/bloc/logout/logout_bloc.dart';
import 'package:food_delivery_resto_app/presentation/auth/pages/login_pages.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Main Page'),
        actions: [
          BlocListener<LogoutBloc, LogoutState>(
            listener: (context, state) {
              state.maybeWhen(
                orElse: () {},
                success: () {
                  AuthLocalDatasources().removeAuthData();
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => const LoginPage()),
                  );
                },
                error: (message) {
                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(SnackBar(content: Text(message),));
                },
              );
            },
            child: IconButton(
              icon: const Icon(Icons.logout),
              onPressed: () {
                context.read<LogoutBloc>().add(LogoutEvent.logout());
              },
            ),
          ),
        ],
      ),
      body: Center(child: Text('Welcome to the Main Page!')),
    );
  }
}
