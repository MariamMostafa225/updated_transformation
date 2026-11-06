import 'package:flutter/material.dart';
import '../models/vehicle_model.dart';

class VehiclePlateCard extends StatelessWidget {
  final VehicleItem vehicle;
  final bool isAdmin;
  final String Function(String ar, String en) t;
  final void Function(VehicleItem v)? onEdit;
  final void Function(VehicleItem v)? onDelete;

  const VehiclePlateCard({
    super.key,
    required this.vehicle,
    required this.isAdmin,
    required this.t,
    this.onEdit,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 6),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            // Realistic Egyptian-style license plate representation
            Container(
              width: 140,
              decoration: BoxDecoration(
                color: isDark ? const Color(0xff1e293b) : const Color(0xfff8fafc),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: isDark ? const Color(0xff475569) : const Color.fromARGB(255, 157, 165, 169),
                  width: 2,
                ),
              ),
              child: Column(
                children: [
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 2),
                    decoration: const BoxDecoration(
                      color: Color.fromARGB(255, 134, 142, 146),
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(8),
                        topRight: Radius.circular(8),
                      ),
                    ),
                    child: const Center(
                      child: Text(
                        'مصر • EGYPT',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.2,
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Text(
                          vehicle.number,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w900,
                            letterSpacing: 2,
                            color: isDark ? Colors.white : Colors.black87,
                          ),
                        ),
                        Container(
                          width: 1.5,
                          height: 22,
                          color: isDark ? Colors.white24 : Colors.black26,
                        ),
                        Text(
                          vehicle.letters,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w900,
                            letterSpacing: 2,
                            color: isDark ? Colors.white : Colors.black87,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.business, size: 18, color: Colors.grey),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          vehicle.companyName,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    t('سيارة مشتركة مسجلة', 'Registered Shared Vehicle'),
                    style: TextStyle(
                      fontSize: 12,
                      color: Theme.of(context).textTheme.bodySmall?.color,
                    ),
                  ),
                ],
              ),
            ),
            if (isAdmin && vehicle.id != null)
              PopupMenuButton<String>(
                icon: const Icon(Icons.more_vert),
                onSelected: (action) {
                  if (action == 'edit' && onEdit != null) {
                    onEdit!(vehicle);
                  } else if (action == 'delete' && onDelete != null) {
                    onDelete!(vehicle);
                  }
                },
                itemBuilder: (ctx) => [
                  PopupMenuItem(
                    value: 'edit',
                    child: Row(
                      children: [
                        const Icon(Icons.edit, size: 20, color: Colors.blue),
                        const SizedBox(width: 8),
                        Text(t('تعديل', 'Edit')),
                      ],
                    ),
                  ),
                  PopupMenuItem(
                    value: 'delete',
                    child: Row(
                      children: [
                        const Icon(Icons.delete, size: 20, color: Colors.red),
                        const SizedBox(width: 8),
                        Text(t('حذف', 'Delete')),
                      ],
                    ),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
