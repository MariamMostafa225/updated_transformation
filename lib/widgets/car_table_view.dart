import 'package:flutter/material.dart';
import '../models/vehicle_model.dart';

class CarTableView extends StatelessWidget {
  final List<VehicleItem> cars;
  final String companyName;
  final bool isAdmin;
  final String Function(String ar, String en) t;
  final void Function(VehicleItem v)? onEdit;
  final void Function(VehicleItem v)? onDelete;

  const CarTableView({
    super.key,
    required this.cars,
    required this.companyName,
    required this.isAdmin,
    required this.t,
    this.onEdit,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    if (cars.isEmpty) {
      return Padding(
        padding: const EdgeInsets.all(20),
        child: Text(
          t(
            'لا توجد سيارات مسجلة لهذه الشركة حالياً.',
            'No vehicles registered for this company currently.',
          ),
          style: TextStyle(
            color: Theme.of(context).textTheme.bodySmall?.color,
          ),
        ),
      );
    }

    final isDark = Theme.of(context).brightness == Brightness.dark;
    final headerBg = isDark
        ? Theme.of(context).colorScheme.surfaceContainerHighest
        : Theme.of(context).colorScheme.primary.withOpacity(0.08);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: Theme.of(context).dividerColor.withOpacity(0.3),
        ),
      ),
      child: Column(
        children: [
          // Pinned 3-Columns Table Header
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              color: headerBg,
              borderRadius: const BorderRadius.vertical(top: Radius.circular(9)),
            ),
            child: Row(
              children: [
                Expanded(
                  flex: 2,
                  child: Text(
                    t('الرقم', 'Number'),
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Text(
                    t('الحروف', 'Letters'),
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: Text(
                    t('اسم الشركة', 'Company'),
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                if (isAdmin)
                  Expanded(
                    flex: 2,
                    child: Text(
                      t('إجراءات', 'Actions'),
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
              ],
            ),
          ),
          const Divider(height: 1),
          // Virtualized Smooth Scrollable Table Rows (Handles 389+ cars with 0 lag)
          SizedBox(
            height: cars.length > 8 ? 320 : (cars.length * 48.0),
            child: ListView.separated(
              itemCount: cars.length,
              separatorBuilder: (_, __) => const Divider(height: 1),
              itemBuilder: (context, index) {
                final v = cars[index];
                final isEven = index.isEven;
                final rowBg = isEven
                    ? Colors.transparent
                    : (isDark
                        ? Colors.white.withOpacity(0.02)
                        : Colors.black.withOpacity(0.02));

                return Container(
                  color: rowBg,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 8,
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        flex: 2,
                        child: Text(
                          v.number,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: Text(
                          v.letters,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 3,
                        child: Text(
                          v.companyName.isEmpty ? companyName : v.companyName,
                          style: const TextStyle(fontSize: 14),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      if (isAdmin)
                        Expanded(
                          flex: 2,
                          child: v.id != null
                              ? Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    IconButton(
                                      icon: const Icon(
                                        Icons.edit,
                                        size: 18,
                                        color: Colors.blue,
                                      ),
                                      tooltip: t('تعديل', 'Edit'),
                                      onPressed: () => onEdit?.call(v),
                                    ),
                                    IconButton(
                                      icon: const Icon(
                                        Icons.delete,
                                        size: 18,
                                        color: Colors.red,
                                      ),
                                      tooltip: t('حذف', 'Delete'),
                                      onPressed: () => onDelete?.call(v),
                                    ),
                                  ],
                                )
                              : Center(
                                  child: Text(
                                    t('أصلية', 'Default'),
                                    style: const TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ),
                        ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
