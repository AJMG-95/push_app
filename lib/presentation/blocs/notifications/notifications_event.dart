//* Event -> Eventos que puede recibir el BLoC

part of 'notifications_bloc.dart'; // esto hace que estas clases estén "dentro" del mismo archivo BLoC

/// Clase base para todos los eventos del bloc
sealed class NotificationsEvent {
  const NotificationsEvent();
}

/// Evento que se lanza cuando cambia el estado de permisos del usuario
class NotificationStatusChanged extends NotificationsEvent {
  final AuthorizationStatus status;
  NotificationStatusChanged(this.status);
}

/// Evento que se lanza cuando se recibe una notificación push
class NotificationReceived extends NotificationsEvent {
  final PushMessage pushMessage;
  NotificationReceived(this.pushMessage);
}
