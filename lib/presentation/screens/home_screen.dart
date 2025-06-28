import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:pushApp/presentation/blocs/notifications/notifications_bloc.dart';

class HomeScreen extends StatelessWidget {
  static const String name = 'HomeScreen';

  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: context.select(
          (NotificationsBloc bloc) => Text(bloc.state.status.name),
        ),
        actions: [
          IconButton(
            onPressed: () {
              context.read<NotificationsBloc>().requestPermision();
            },
            icon: Icon(Icons.settings),
          ),
        ],
      ),
      body: HomeView(),
    );
  }
}

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final notifications =
        context.watch<NotificationsBloc>().state.notifications;

    return ListView.builder(
      itemCount: notifications.length,
      itemBuilder: (BuildContext ctx, int index) {
        final message = notifications[index];
        return Semantics(
          label:
              'Notificación: ${message.title}. ${message.body}. Tipo: ${message.type ?? "sin especificar"}',
          child: ListTile(
            title: Text(
              message.title,
              textScaler: MediaQuery.textScalerOf(context),
            ),
            subtitle: Text(
              message.body,
              textScaler: MediaQuery.textScalerOf(context),
            ),
            leading:
                message.imageUrl != null
                    ? Image.network(message.imageUrl!)
                    : null,
            onTap: () {
              context.push('/push-details/${message.messageId}');
            },
          ),
        );
      },
    );
  }
}
