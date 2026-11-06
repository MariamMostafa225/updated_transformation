import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../data/seed_data.dart';
import '../models/company_model.dart';
import '../models/vehicle_model.dart';
import '../widgets/admin_dialogs.dart';
import '../widgets/car_table_view.dart';

class CompaniesTab extends StatelessWidget {
  final bool isAdmin;
  final String Function(String ar, String en) t;
  final FirebaseFirestore db;

  const CompaniesTab({
    super.key,
    required this.isAdmin,
    required this.t,
    required this.db,
  });

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
      stream: db.collection('meta').doc('seed').snapshots(),
      builder: (context, metaSnap) {
    // After the admin uploads everything to Firestore, Firestore is the
    // single source of truth (deleted cars must not come back from seed).
    final bool seedSynced = metaSnap.data?.data()?['synced'] == true;
    return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
      stream: db.collection('companies').orderBy('name').snapshots(),
      builder: (context, snap) {
        final List<CompanyItem> companies = [];
        final Set<String> firestoreCompanyNames = {};

        if (snap.hasData) {
          for (var doc in snap.data!.docs) {
            final data = doc.data();
            final name = '${data['name'] ?? ''}'.trim();
            final count = (data['vehicleCount'] as num?)?.toInt() ?? 0;
            firestoreCompanyNames.add(name);

            final seedMatch = SeedData.getInitialCompanies()
                .where((c) => c.name == name)
                .toList();
            final seedCount = seedMatch.isNotEmpty ? seedMatch.first.vehicleCount : 0;
            final finalCount =
                seedSynced ? count : ((count < seedCount) ? seedCount : count);

            companies.add(CompanyItem(
              id: doc.id,
              name: name,
              vehicleCount: finalCount,
              vehicles: const [],
              isSeed: false,
            ));
          }
        }

        // Add built-in companies if not yet recorded in Firestore
        if (!seedSynced) {
          for (var sc in SeedData.getInitialCompanies()) {
            if (!firestoreCompanyNames.contains(sc.name)) {
              companies.add(sc);
            }
          }
        }

        // Real counts: computed from the cars that are actually listed
        // (Firestore + built-in cars not yet uploaded), not from the stored
        // 'vehicleCount' field which can be stale.
        return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
          stream: db.collection('vehicles').snapshots(),
          builder: (context, vSnap) {
        final Map<String, int> liveCounts = {};
        if (vSnap.hasData) {
          final Map<String, Set<String>> fsKeys = {};
          for (var vd in vSnap.data!.docs) {
            final dd = vd.data();
            final cn = '${dd['companyName'] ?? ''}'.trim();
            liveCounts[cn] = (liveCounts[cn] ?? 0) + 1;
            (fsKeys[cn] ??= <String>{})
                .add('${dd['number']}_${dd['letters']}'.trim());
          }
          if (!seedSynced) {
            for (var sc in SeedData.getInitialCompanies()) {
              final keys = fsKeys[sc.name] ?? <String>{};
              final missing = sc.vehicles
                  .where((v) => !keys.contains('${v.number}_${v.letters}'.trim()))
                  .length;
              liveCounts[sc.name] = (liveCounts[sc.name] ?? 0) + missing;
            }
          }
        }
        final List<CompanyItem> shown = companies
            .map((c) => CompanyItem(
                  id: c.id,
                  name: c.name,
                  vehicleCount: vSnap.hasData
                      ? (liveCounts[c.name] ?? 0)
                      : c.vehicleCount,
                  vehicles: c.vehicles,
                  isSeed: c.isSeed,
                ))
            .toList();

        return ListView.builder(
          padding:
              const EdgeInsets.only(left: 14, right: 14, top: 14, bottom: 80),
          itemCount: shown.length,
          itemBuilder: (context, index) {
            final comp = shown[index];

            return Card(
              margin: const EdgeInsets.symmetric(vertical: 6),
              clipBehavior: Clip.antiAlias,
              child: ExpansionTile(
                leading: CircleAvatar(
                  backgroundColor:
                      Theme.of(context).colorScheme.primary.withOpacity(0.15),
                  child: Icon(
                    Icons.business,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
                title: Text(
                  comp.name,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                subtitle: Text(
                  '${comp.vehicleCount} ${t('سيارة', 'vehicles')}',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                trailing: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.secondaryContainer,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    '${comp.vehicleCount}',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.onSecondaryContainer,
                    ),
                  ),
                ),
                children: [
                  if (comp.isSeed)
                    CarTableView(
                      cars: comp.vehicles,
                      companyName: comp.name,
                      isAdmin: isAdmin,
                      t: t,
                      onEdit: (v) => AdminDialogs.showAddEditVehicleDialog(
                        context: context,
                        db: db,
                        t: t,
                        vehicleToEdit: v,
                      ),
                      onDelete: (v) => AdminDialogs.showDeleteVehicleDialog(
                        context: context,
                        db: db,
                        vehicle: v,
                        t: t,
                      ),
                    )
                  else
                    StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                      stream: db
                          .collection('vehicles')
                          .where('companyId', isEqualTo: comp.id)
                          .snapshots(),
                      builder: (context, carsSnap) {
                        if (!carsSnap.hasData) {
                          return const Padding(
                            padding: EdgeInsets.all(20),
                            child: Center(child: CircularProgressIndicator()),
                          );
                        }

                        final carDocs = carsSnap.data!.docs.map((d) {
                          final data = d.data();
                          return VehicleItem(
                            id: d.id,
                            number: '${data['number'] ?? ''}',
                            letters: '${data['letters'] ?? ''}',
                            companyName: '${data['companyName'] ?? comp.name}',
                            isSeed: false,
                          );
                        }).toList();

                        final seedMatch = SeedData.getInitialCompanies()
                            .where((c) => c.name == comp.name)
                            .toList();

                        final List<VehicleItem> effectiveCars = List.from(carDocs);
                        if (!seedSynced && seedMatch.isNotEmpty) {
                          final existingKeys = carDocs
                              .map((c) => '${c.number}_${c.letters}'.trim())
                              .toSet();
                          for (var sv in seedMatch.first.vehicles) {
                            final key = '${sv.number}_${sv.letters}'.trim();
                            if (!existingKeys.contains(key)) {
                              effectiveCars.add(sv);
                            }
                          }
                        }

                        effectiveCars.sort((a, b) => a.number.compareTo(b.number));

                        return CarTableView(
                          cars: effectiveCars,
                          companyName: comp.name,
                          isAdmin: isAdmin,
                          t: t,
                          onEdit: (v) => AdminDialogs.showAddEditVehicleDialog(
                            context: context,
                            db: db,
                            t: t,
                            vehicleToEdit: v,
                          ),
                          onDelete: (v) =>
                              AdminDialogs.showDeleteVehicleDialog(
                            context: context,
                            db: db,
                            vehicle: v,
                            t: t,
                          ),
                        );
                      },
                    ),
                ],
              ),
            );
          },
        );
          },
        );
      },
    );
      },
    );
  }
}