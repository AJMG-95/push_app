//* Bloc -> El núcleo que controla la lógica

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart'; // BLoC: patrón para manejar estados
import 'package:equatable/equatable.dart'; // para comparar objetos fácilmente
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart'; // Notificaciones push
import 'package:pushapp/config/local_notifications/local_notifications.dart';
import 'package:pushapp/domain/entities/push_message.dart'; // Nuestra entidad
import 'package:pushapp/firebase_options.dart'; // Configuración de Firebase

part 'notifications_event.dart'; // importa eventos
part 'notifications_state.dart'; // importa estados

/// Función que se ejecuta cuando llega una notificación mientras la app está en segundo plano
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp(); // necesitas esto para usar Firebase

  print("Handling a background message: ${message.messageId}");
}

/// BLoC que maneja las notificaciones
class NotificationsBloc extends Bloc<NotificationsEvent, NotificationsState> {
  /// Crea una instancia para acceder a Firebase Messaging
  FirebaseMessaging messaging = FirebaseMessaging.instance;

  int pushNumberId = 0;

  /// Constructor del BLoC
  NotificationsBloc() : super(const NotificationsState()) {
    // Vincula eventos con sus funciones manejadoras
    on<NotificationStatusChanged>(_notificationStatusChanged);
    on<NotificationReceived>(_onPushMessageReceived);

    // Comprueba el estado de permisos al iniciar
    _initialStatusCheck();

    // Escucha notificaciones que llegan con la app abierta (foreground)
    _onForegroundMessage();
  }

  /// Inicializa Firebase cuando quieras usarlo al arrancar la app
  static Future<void> initializeFCM() async {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  }

  /// Se llama cuando cambia el estado de permisos (ej. el usuario da permiso o lo rechaza)
  void _notificationStatusChanged(
    NotificationStatusChanged event,
    Emitter<NotificationsState> emit,
  ) {
    emit(
      state.copyWith(status: event.status),
    ); // actualiza el estado con el nuevo permiso
    _getFCMToken(); // si está autorizado, pide el token
  }

  /// Se llama cuando se recibe una notificación push
  void _onPushMessageReceived(
    NotificationReceived event,
    Emitter<NotificationsState> emit,
  ) {
    emit(
      state.copyWith(
        notifications: [
          event.pushMessage,
          ...state.notifications,
        ], // añade al principio de la lista
      ),
    );
  }

  /// Comprueba si el usuario ya dio permiso para recibir notificaciones
  void _initialStatusCheck() async {
    final settings = await messaging.getNotificationSettings();
    add(
      NotificationStatusChanged(settings.authorizationStatus),
    ); // lanza el evento con el resultado
  }

  /// Obtiene el token FCM si el usuario ha dado permiso
  void _getFCMToken() async {
    if (state.status != AuthorizationStatus.authorized) return;

    final token =
        await messaging
            .getToken(); // este token se usa para enviar notificaciones a este dispositivo
    debugPrint(token); // puedes copiarlo y usarlo desde Firebase Console
  }

  /// Procesa una notificación que llega cuando la app está abierta
  void handleRemoteMessage(RemoteMessage message) {
    if (message.notification == null) return;

    final notification = PushMessage(
      messageId:
          message.messageId?.replaceAll(':', '').replaceAll('%', '') ?? '',
      title: message.notification!.title ?? '',
      body: message.notification!.body ?? '',
      sentDate: message.sentTime ?? DateTime.now(),
      data: message.data,
      type:
          message
              .data['type'], // muy importante: extrae el tipo de notificación desde los datos
      imageUrl:
          Platform.isAndroid
              ? message.notification!.android?.imageUrl
              : message.notification!.apple?.imageUrl,
    );

    LocalNotifications.showLocalNotifications(
      id: ++pushNumberId,
      body: notification.body,
      data: notification.data.toString(),
      title: notification.title,
    );

    add(
      NotificationReceived(notification),
    ); // lanza el evento para que el BLoC lo procese
  }

  /// Activa el listener para notificaciones cuando la app está abierta
  void _onForegroundMessage() {
    FirebaseMessaging.onMessage.listen(handleRemoteMessage);
  }

  /// Solicita permiso al usuario para recibir notificaciones push
  void requestPermission() async {
    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: true,
      provisional: false,
      sound: true,
    );

    // Soliciatar pemisos a las localNotifications
    await LocalNotifications.requesPermissionLocalNotifications();

    add(
      NotificationStatusChanged(settings.authorizationStatus),
    ); // lanza evento con resultado
  }

  // Para obtener una notificación push (detalle)
  PushMessage? getMessageById(String pushMessageId) {
    final exist = state.notifications.any(
      (element) => element.messageId == pushMessageId,
    );
    if (!exist) return null;
    return state.notifications.firstWhere(
      (element) => element.messageId == pushMessageId,
    );
  }
}
