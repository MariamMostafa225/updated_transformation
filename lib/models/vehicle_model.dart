class VehicleItem {
  final String? id;
  final String number;
  final String letters;
  final String companyName;
  final bool isSeed;

  const VehicleItem({
    this.id,
    required this.number,
    required this.letters,
    required this.companyName,
    this.isSeed = false,
  });

  Map<String, dynamic> toMap(String companyId) => {
        'number': number,
        'letters': letters,
        'companyId': companyId,
        'companyName': companyName,
      };
}
