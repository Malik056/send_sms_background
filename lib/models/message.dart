import 'dart:convert';

class Message {
  final int id;
  final String message;
  final int priority;
  final String status;
  final String number;

  Message({
    required this.id,
    required this.message,
    required this.priority,
    required this.status,
    required this.number,
  });

  factory Message.fromMap(Map<String, dynamic> map) {
    return Message(
      id: map['id']?.toInt() ?? 0,
      message: map['message'] ?? '',
      priority: map['priority']?.toInt() ?? 0,
      status: map['status'] ?? '',
      number: map['number'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};
  
    result.addAll({'id': id});
    result.addAll({'message': message});
    result.addAll({'priority': priority});
    result.addAll({'status': status});
    result.addAll({'number': number});
  
    return result;
  }

  Message copyWith({
    int? id,
    String? message,
    int? priority,
    String? status,
    String? number,
  }) {
    return Message(
      id: id ?? this.id,
      message: message ?? this.message,
      priority: priority ?? this.priority,
      status: status ?? this.status,
      number: number ?? this.number,
    );
  }
}
