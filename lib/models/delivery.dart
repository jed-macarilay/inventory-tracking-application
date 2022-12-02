class DeliveryModel {
  int? id;
  String? receiver;
  String? contact_number;
  String? origin;
  String? destination;
  String? status;

  DeliveryModel({
    this.id,
    this.receiver,
    this.contact_number,
    this.origin,
    this.destination,
    this.status,
  });

  factory DeliveryModel.fromJson(Map<String, dynamic> json) {
    return DeliveryModel(
      id: json['id'],
      receiver: json['receiver'],
      contact_number: json['contact_number'],
      origin: json['origin'],
      destination: json['destination'],
      status: json['status'],
    );
  }
}