import 'user.dart';

class DeliveryModel {
  int id = 0;
  String? receiver;
  String? contact_number;
  String? origin;
  String? destination;
  String? status;
  User? user;

  DeliveryModel({
    required this.id,
    this.receiver,
    this.contact_number,
    this.origin,
    this.destination,
    this.status,
    this.user,
  });

factory DeliveryModel.fromJson(Map<String, dynamic> json) {
  return DeliveryModel(
    id: json['id'],
    receiver: json['receiver'],
    contact_number: json['contact_number'],
    origin: json['origin'],
    destination: json['destination'],
    status: json['status'],
    user: User(
      id: json['user']['id'],
      name: json['user']['name'],
    )
  );
}

}