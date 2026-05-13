class AddressModel {
  final String id;
  final String label; // Home, Work, etc.
  final String fullAddress;
  final String? houseNo;
  final String? landmark;
  final bool isDefault;

  AddressModel({
    required this.id,
    required this.label,
    required this.fullAddress,
    this.houseNo,
    this.landmark,
    this.isDefault = false,
  });

  Map<String, dynamic> toFirestore() {
    return {
      'label': label,
      'fullAddress': fullAddress,
      'houseNo': houseNo,
      'landmark': landmark,
      'isDefault': isDefault,
    };
  }

  factory AddressModel.fromFirestore(Map<String, dynamic> json, String id) {
    return AddressModel(
      id: id,
      label: json['label'] ?? 'Home',
      fullAddress: json['fullAddress'] ?? '',
      houseNo: json['houseNo'],
      landmark: json['landmark'],
      isDefault: json['isDefault'] ?? false,
    );
  }
}
