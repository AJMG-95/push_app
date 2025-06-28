//* State ->  Estado de la aplicación de notificaciones

part of 'notifications_bloc.dart'; // permite usar las clases como parte del archivo principal

/// Estado que representa cómo están las notificaciones actualmente
class NotificationsState extends Equatable {
  final AuthorizationStatus status; // indica si el usuario dio permisos
  final List<PushMessage> notifications; // lista de notificaciones recibidas

  const NotificationsState({
    this.status =
        AuthorizationStatus.notDetermined, // por defecto, aún no se sabe
    this.notifications = const [], // lista vacía por defecto
  });

  /// Método para copiar el estado actual y modificar solo lo que necesitemos
  NotificationsState copyWith({
    AuthorizationStatus? status,
    List<PushMessage>? notifications,
  }) => NotificationsState(
    status: status ?? this.status,
    notifications: notifications ?? this.notifications,
  );

  /// Necesario para que Bloc sepa cuándo ha cambiado el estado (compara valores)
  @override
  List<Object> get props => [status, notifications];
}
