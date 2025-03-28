import 'package:equatable/equatable.dart';

class NotificationState extends Equatable {
  final String? message;
  // final NotificationType type;

  const NotificationState({
    this.message,
    // this.type
  });

  @override
  List<Object?> get props => [message, ];
}