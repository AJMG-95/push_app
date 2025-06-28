import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pushApp/config/router/router.dart';
import 'package:pushApp/config/theme/app_theme.dart';
import 'package:pushApp/presentation/blocs/notifications/notifications_bloc.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
  await NotificationsBloc.initializeFCM();

  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => NotificationsBloc(),
        ), // El parametro _ es el buildContes pero en es te caso no es necesario
      ],
      child: const MainApp(),
    ),
  );
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: appRouter,
      debugShowCheckedModeBanner: false,
      theme: AppTheme().getTheme(),
      builder: (context, child) => HandleNotificationInteraction(child: child!),
    );
  }
}

class HandleNotificationInteraction extends StatefulWidget {
  final Widget child;
  const HandleNotificationInteraction({super.key, required this.child});

  @override
  State<HandleNotificationInteraction> createState() =>
      _HandleNotificationInteractionState();
}

class _HandleNotificationInteractionState
    extends State<HandleNotificationInteraction> {
  Future<void> setupInteractedMessage() async {
    // Get any messages which caused the application to open from
    // a terminated state.
    RemoteMessage? initialMessage =
        await FirebaseMessaging.instance.getInitialMessage();

    // If the message also contains a data property with a "type" of "chat",
    // navigate to a chat screen
    if (initialMessage != null) {
      _handleMessage(initialMessage);
    }

    // Also handle any interaction when the app is in the background via a
    // Stream listener
    FirebaseMessaging.onMessageOpenedApp.listen(_handleMessage);
  }

  void _handleMessage(RemoteMessage message) {
    // almacenar la notificación en el estado del bloc cuando se pulsa sobre ella
    context.read<NotificationsBloc>().handleRemoteMessage(message);

    // Elimina los caracteres especiales del id que pueden interferir con la nevagación
    final messageId = message.messageId
        ?.replaceAll(':', '')
        .replaceAll('%', '');

    // Navega hasta la pantalla detalle de la notifición
    appRouter.push('/push-details/$messageId');
  }

  @override
  void initState() {
    super.initState();

    // Run code required to handle interacted messages in an async function
    // as initState() must not be async
    setupInteractedMessage();
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
