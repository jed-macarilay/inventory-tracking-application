class DeliveryModel {
  int? id;
  String? receiver;
  String? contact_number;
  String? origin;
  String? origin_latitude;
  String? origin_longtitude;
  String? destination;
  String? destination_latitude;
  String? destination_longtitude;
  String? status;

  DeliveryModel({
    this.id,
    this.receiver,
    this.contact_number,
    this.origin,
    this.origin_latitude,
    this.origin_longtitude,
    this.destination,
    this.destination_latitude,
    this.destination_longtitude,
    this.status,
  });

  factory DeliveryModel.fromJson(Map<String, dynamic> json) {
    return DeliveryModel(
      id: json['id'],
      receiver: json['receiver'],
      contact_number: json['contact_number'],
      origin: json['origin'],
      origin_latitude: json['origin_latitude'],
      origin_longtitude: json['origin_longtitude'],
      destination: json['destination'],
      destination_latitude: json['destination_latitude'],
      destination_longtitude: json['destination_longtitude'],
      status: json['status'],
    );
  }
}