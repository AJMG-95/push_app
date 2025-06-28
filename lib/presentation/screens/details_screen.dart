import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pushApp/domain/entities/push_message.dart';
import 'package:pushApp/presentation/blocs/notifications/notifications_bloc.dart';

class DetailsScreen extends StatelessWidget {
  static const String name = 'DetailsScreen';
  final String pushMessageId;
  const DetailsScreen({super.key, required this.pushMessageId});

  @override
  Widget build(BuildContext context) {
    final textStyle = Theme.of(context).textTheme;

    final PushMessage? message = context
        .watch<NotificationsBloc>()
        .getMessageById(pushMessageId);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Detalles push",
          textScaler: MediaQuery.textScalerOf(context),
        ),
      ),
      body:
          (message != null)
              ? _DetailsView(message: message)
              : Center(
                child: Text(
                  "Esta noficicación no existe",
                  style: textStyle.titleMedium,
                  textScaler: MediaQuery.textScalerOf(context),
                ),
              ),
    );
  }
}

class _DetailsView extends StatelessWidget {
  final PushMessage message;

  const _DetailsView({required this.message});

  @override
  Widget build(BuildContext context) {
    final textStyle = Theme.of(context).textTheme;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
      child: Column(
        children: [
          if (message.imageUrl != null) Image.network(message.imageUrl!),
          SizedBox(height: 30),
          Text(
            message.title,
            style: textStyle.titleMedium,
            textScaler: MediaQuery.textScalerOf(context),
          ),
          Text(message.body, textScaler: MediaQuery.textScalerOf(context)),
          const Divider(),
          Text(
            message.data.toString(),
            textScaler: MediaQuery.textScalerOf(context),
          ),
        ],
      ),
    );
  }
}
