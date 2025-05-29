import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:push_app/presentation/screens/screens.dart';

final appRouter = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const HomeScreen(),
    ),
     /*
    GoRoute(
      path: '/page',
      name: PageScreen.name,
      builder: (context, state) => const PageScreen(),
    ), */
    // Agrega más rutas aquí
  ],
);
