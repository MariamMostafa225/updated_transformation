// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';

// import '../data/seed_data.dart';
// import '../models/vehicle_model.dart';
// import '../widgets/admin_dialogs.dart';
// import '../widgets/vehicle_plate_card.dart';

// class HomeTab extends StatefulWidget {
//   final bool isAdmin;
//   final String Function(String ar, String en) t;
//   final FirebaseFirestore db;

//   const HomeTab({
//     super.key,
//     required this.isAdmin,
//     required this.t,
//     required this.db,
//   });

//   @override
//   State<HomeTab> createState() => _HomeTabState();
// }

// class _HomeTabState extends State<HomeTab> {
//   String query = '';
//   final TextEditingController _searchController = TextEditingController();

//   @override
//   void dispose() {
//     _searchController.dispose();
//     super.dispose();
//   }

//   String _normalize(String s) {
//     return s
//         .toLowerCase()
//         .replaceAll(RegExp(r'\s+'), '')
//         .replaceAll('أ', 'ا')
//         .replaceAll('إ', 'ا')
//         .replaceAll('آ', 'ا')
//         .replaceAll('ة', 'ه')
//         .replaceAll('ى', 'ي');
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.stretch,
//         children: [
//           Card(
//             child: Padding(
//               padding: const EdgeInsets.all(16),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     widget.t('ابحث عن سيارة', 'Search for a Vehicle'),
//                     style: Theme.of(context).textTheme.titleLarge?.copyWith(
//                           fontWeight: FontWeight.bold,
//                         ),
//                   ),
//                   const SizedBox(height: 6),
//                   Text(
//                     widget.t(
//                       'ابحث برقم اللوحة، حروفها، أو اسم الشركة المشتركة',
//                       'Search by plate number, letters, or company name',
//                     ),
//                     style: TextStyle(
//                       color: Theme.of(context).textTheme.bodySmall?.color,
//                     ),
//                   ),
//                   const SizedBox(height: 12),
//                   TextField(
//                     controller: _searchController,
//                     decoration: InputDecoration(
//                       prefixIcon: const Icon(Icons.search),
//                       border: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(12),
//                       ),
//                       suffixIcon: query.isNotEmpty
//                           ? IconButton(
//                               icon: const Icon(Icons.clear),
//                               onPressed: () {
//                                 _searchController.clear();
//                                 setState(() => query = '');
//                               },
//                             )
//                           : null,
//                       hintText: widget.t(
//                         'مثال: 716 أو السلام أو اللوتس أو المصرية',
//                         'e.g. 716 or Salam or Lotus or Egyptian',
//                       ),
//                     ),
//                     onChanged: (v) => setState(() => query = v.trim()),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//           const SizedBox(height: 8),
//           Expanded(
//             child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
//               stream: widget.db.collection('vehicles').snapshots(),
//               builder: (context, snapshot) {
//                 final term = _normalize(query);

//                 final List<VehicleItem> vehicleList = [];
//                 final Set<String> existingKeys = {};

//                 if (snapshot.hasData) {
//                   for (var doc in snapshot.data!.docs) {
//                     final data = doc.data();
//                     final num = '${data['number'] ?? ''}';
//                     final let = '${data['letters'] ?? ''}';
//                     final comp = '${data['companyName'] ?? ''}';
//                     final key = '${num}_${let}_$comp'.trim();
//                     existingKeys.add(key);

//                     vehicleList.add(VehicleItem(
//                       id: doc.id,
//                       number: num,
//                       letters: let,
//                       companyName: comp,
//                       isSeed: false,
//                     ));
//                   }
//                 }

//                 // Add built-in seed vehicles if not yet added to Firestore
//                 for (var s in SeedData.getAllVehicles()) {
//                   final key =
//                       '${s.number}_${s.letters}_${s.companyName}'.trim();
//                   if (!existingKeys.contains(key)) {
//                     vehicleList.add(s);
//                   }
//                 }

//                 final filtered = vehicleList.where((x) {
//                   if (term.isEmpty) return true;
//                   final combined =
//                       '${x.number} ${x.letters} ${x.companyName}';
//                   return _normalize(combined).contains(term);
//                 }).toList();

//                 if (filtered.isEmpty) {
//                   return Center(
//                     child: Padding(
//                       padding: const EdgeInsets.all(24),
//                       child: Column(
//                         mainAxisSize: MainAxisSize.min,
//                         children: [
//                           const Icon(Icons.search_off,
//                               size: 54, color: Colors.grey),
//                           const SizedBox(height: 12),
//                           Text(
//                             query.isEmpty
//                                 ? widget.t(
//                                     'لا توجد سيارات بعد', 'No vehicles found')
//                                 : widget.t('لا توجد نتائج مطابقة',
//                                     'No matching results'),
//                             textAlign: TextAlign.center,
//                             style: const TextStyle(
//                               fontSize: 18,
//                               fontWeight: FontWeight.bold,
//                             ),
//                           ),
//                           const SizedBox(height: 6),
//                           Text(
//                             query.isEmpty
//                                 ? widget.t('أضف سيارة جديدة للبدء',
//                                     'Add a vehicle to start')
//                                 : widget.t(
//                                     'تأكد من كتابة الرقم أو الحروف بشكل صحيح',
//                                     'Verify the number or letters are spelled correctly'),
//                             textAlign: TextAlign.center,
//                             style: TextStyle(
//                               color:
//                                   Theme.of(context).textTheme.bodySmall?.color,
//                               fontSize: 14,
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   );
//                 }

//                 return ListView.builder(
//                   padding: const EdgeInsets.only(top: 8, bottom: 80),
//                   itemCount: filtered.length,
//                   itemBuilder: (context, index) {
//                     final v = filtered[index];
//                     return VehiclePlateCard(
//                       vehicle: v,
//                       isAdmin: widget.isAdmin,
//                       t: widget.t,
//                       onEdit: (vehicle) =>
//                           AdminDialogs.showAddEditVehicleDialog(
//                         context: context,
//                         db: widget.db,
//                         t: widget.t,
//                         vehicleToEdit: vehicle,
//                       ),
//                       onDelete: (vehicle) =>
//                           AdminDialogs.showDeleteVehicleDialog(
//                         context: context,
//                         db: widget.db,
//                         vehicle: vehicle,
//                         t: widget.t,
//                       ),
//                     );
//                   },
//                 );
//               },
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }




import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../data/seed_data.dart';
import '../models/vehicle_model.dart';
import '../widgets/admin_dialogs.dart';
import '../widgets/vehicle_plate_card.dart';

class HomeTab extends StatefulWidget {
  final bool isAdmin;
  final String Function(String ar, String en) t;
  final FirebaseFirestore db;

  const HomeTab({
    super.key,
    required this.isAdmin,
    required this.t,
    required this.db,
  });

  @override
  State<HomeTab> createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> {
  String query = '';
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  String _normalize(String s) {
    return s
        .toLowerCase()
        .replaceAll(RegExp(r'\s+'), '')
        .replaceAll('أ', 'ا')
        .replaceAll('إ', 'ا')
        .replaceAll('آ', 'ا')
        .replaceAll('ة', 'ه')
        .replaceAll('ى', 'ي');
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.t('ابحث عن سيارة', 'Search for a Vehicle'),
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    widget.t(
                      'ابحث برقم اللوحة، حروفها، أو اسم الشركة المشتركة',
                      'Search by plate number, letters, or company name',
                    ),
                    style: TextStyle(
                      color: Theme.of(context).textTheme.bodySmall?.color,
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      suffixIcon: query.isNotEmpty
                          ? IconButton(
                              icon: const Icon(Icons.clear),
                              onPressed: () {
                                _searchController.clear();
                                setState(() => query = '');
                              },
                            )
                          : null,
                      hintText: widget.t(
                        'مثال: 716 أو السلام أو اللوتس أو المصرية',
                        'e.g. 716 or Salam or Lotus or Egyptian',
                      ),
                    ),
                    onChanged: (v) => setState(() => query = v.trim()),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
              stream: widget.db.collection('meta').doc('seed').snapshots(),
              builder: (context, metaSnap) {
            final bool seedSynced = metaSnap.data?.data()?['synced'] == true;
            return Column(
              children: [
                if (widget.isAdmin && !seedSynced)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Card(
                      color: Theme.of(context).colorScheme.tertiaryContainer,
                      child: ListTile(
                        leading: const Icon(Icons.cloud_upload_outlined),
                        title: Text(widget.t(
                            'السيارات لم تُرفع إلى فايرستور بعد',
                            'Vehicles are not uploaded to Firestore yet')),
                        subtitle: Text(widget.t(
                            'اضغط لرفع كل السيارات حتى تتمكن من تعديلها وحذفها',
                            'Tap to upload all so you can edit and delete them')),
                        onTap: () =>
                            AdminDialogs.syncAllCompaniesToFirestore(
                          context: context,
                          db: widget.db,
                          t: widget.t,
                        ),
                      ),
                    ),
                  ),
                Expanded(
            child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
              stream: widget.db.collection('vehicles').snapshots(),
              builder: (context, snapshot) {
                final term = _normalize(query);

                final List<VehicleItem> vehicleList = [];
                final Set<String> existingKeys = {};

                if (snapshot.hasData) {
                  for (var doc in snapshot.data!.docs) {
                    final data = doc.data();
                    final num = '${data['number'] ?? ''}';
                    final let = '${data['letters'] ?? ''}';
                    final comp = '${data['companyName'] ?? ''}';
                    final key = '${num}_${let}_$comp'.trim();
                    existingKeys.add(key);

                    vehicleList.add(VehicleItem(
                      id: doc.id,
                      number: num,
                      letters: let,
                      companyName: comp,
                      isSeed: false,
                    ));
                  }
                }

                // Add built-in seed vehicles if not yet added to Firestore
                if (!seedSynced) {
                  for (var s in SeedData.getAllVehicles()) {
                    final key =
                        '${s.number}_${s.letters}_${s.companyName}'.trim();
                    if (!existingKeys.contains(key)) {
                      vehicleList.add(s);
                    }
                  }
                }

                final filtered = vehicleList.where((x) {
                  if (term.isEmpty) return true;
                  final combined =
                      '${x.number} ${x.letters} ${x.companyName}';
                  return _normalize(combined).contains(term);
                }).toList();

                if (filtered.isEmpty) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.search_off,
                              size: 54, color: Colors.grey),
                          const SizedBox(height: 12),
                          Text(
                            query.isEmpty
                                ? widget.t(
                                    'لا توجد سيارات بعد', 'No vehicles found')
                                : widget.t('لا توجد نتائج مطابقة',
                                    'No matching results'),
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            query.isEmpty
                                ? widget.t('أضف سيارة جديدة للبدء',
                                    'Add a vehicle to start')
                                : widget.t(
                                    'تأكد من كتابة الرقم أو الحروف بشكل صحيح',
                                    'Verify the number or letters are spelled correctly'),
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color:
                                  Theme.of(context).textTheme.bodySmall?.color,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.only(top: 8, bottom: 80),
                  itemCount: filtered.length,
                  itemBuilder: (context, index) {
                    final v = filtered[index];
                    return VehiclePlateCard(
                      vehicle: v,
                      isAdmin: widget.isAdmin,
                      t: widget.t,
                      onEdit: (vehicle) =>
                          AdminDialogs.showAddEditVehicleDialog(
                        context: context,
                        db: widget.db,
                        t: widget.t,
                        vehicleToEdit: vehicle,
                      ),
                      onDelete: (vehicle) =>
                          AdminDialogs.showDeleteVehicleDialog(
                        context: context,
                        db: widget.db,
                        vehicle: vehicle,
                        t: widget.t,
                      ),
                    );
                  },
                );
              },
            ),
                ),
              ],
            );
              },
            ),
          ),
        ],
      ),
    );
  }
}