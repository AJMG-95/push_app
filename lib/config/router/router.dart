import 'package:go_router/go_router.dart';
import 'package:pushApp/presentation/screens/screens.dart';

final appRouter = GoRouter(
  routes: [
    GoRoute(path: '/', builder: (context, state) => const HomeScreen()),
    GoRoute(
      path: '/push-details/:messageId',
      name: DetailsScreen.name,
      builder:
          (context, state) =>
             DetailsScreen(pushMessageId: state.pathParameters['messageId'] ?? ''),
    ),
    // Agrega más rutas aquí
  ],
);
