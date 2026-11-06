import 'vehicle_model.dart';

class CompanyItem {
  final String id;
  final String name;
  final int vehicleCount;
  final List<VehicleItem> vehicles;
  final bool isSeed;

  const CompanyItem({
    required this.id,
    required this.name,
    required this.vehicleCount,
    required this.vehicles,
    this.isSeed = false,
  });
}
