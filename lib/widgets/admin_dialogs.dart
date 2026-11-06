// // import 'package:cloud_firestore/cloud_firestore.dart';
// // import 'package:firebase_auth/firebase_auth.dart';
// // import 'package:flutter/material.dart';

// // import '../data/seed_data.dart';
// // import '../models/vehicle_model.dart';

// // const String kAdminEmail = 'm01151661324@gmail.com';

// // class AdminDialogs {
// //   static Future<void> showSignInDialog({
// //     required BuildContext context,
// //     required String Function(String ar, String en) t,
// //   }) async {
// //     final emailCtrl = TextEditingController();
// //     final passCtrl = TextEditingController();
// //     bool obscure = true;

// //     await showDialog(
// //       context: context,
// //       builder: (ctx) => StatefulBuilder(
// //         builder: (context, setDialogState) => AlertDialog(
// //           title: Row(
// //             children: [
// //               const Icon(Icons.lock_person, color: Colors.teal),
// //               const SizedBox(width: 8),
// //               Text(t('دخول الإدارة', 'Admin Sign In')),
// //             ],
// //           ),
// //           content: SingleChildScrollView(
// //             child: Column(
// //               mainAxisSize: MainAxisSize.min,
// //               children: [
// //                 Text(
// //                   t(
// //                     'قم بإدخال بيانات حساب الإدارة المعتمد لإدارة السيارات والشركات.',
// //                     'Enter authorized admin credentials to manage vehicles and companies.',
// //                   ),
// //                   style: const TextStyle(fontSize: 13),
// //                 ),
// //                 const SizedBox(height: 16),
// //                 TextField(
// //                   controller: emailCtrl,
// //                   keyboardType: TextInputType.emailAddress,
// //                   decoration: InputDecoration(
// //                     labelText: t('البريد الإلكتروني', 'Email'),
// //                     prefixIcon: const Icon(Icons.email_outlined),
// //                   ),
// //                 ),
// //                 const SizedBox(height: 12),
// //                 TextField(
// //                   controller: passCtrl,
// //                   obscureText: obscure,
// //                   decoration: InputDecoration(
// //                     labelText: t('كلمة المرور', 'Password'),
// //                     prefixIcon: const Icon(Icons.lock_outline),
// //                     suffixIcon: IconButton(
// //                       icon: Icon(
// //                         obscure ? Icons.visibility_off : Icons.visibility,
// //                       ),
// //                       onPressed: () =>
// //                           setDialogState(() => obscure = !obscure),
// //                     ),
// //                   ),
// //                 ),
// //               ],
// //             ),
// //           ),
// //           actions: [
// //             TextButton(
// //               onPressed: () => Navigator.pop(ctx),
// //               child: Text(t('إلغاء', 'Cancel')),
// //             ),
// //             FilledButton(
// //               onPressed: () async {
// //                 final email = emailCtrl.text.trim();
// //                 final password = passCtrl.text;

// //                 if (email.isEmpty || password.isEmpty) {
// //                   ScaffoldMessenger.of(context).showSnackBar(
// //                     SnackBar(
// //                       content: Text(
// //                         t('يرجى ملء كافة الحقول', 'Please fill all fields'),
// //                       ),
// //                     ),
// //                   );
// //                   return;
// //                 }

// //                 if (email.toLowerCase() != kAdminEmail.toLowerCase()) {
// //                   ScaffoldMessenger.of(context).showSnackBar(
// //                     SnackBar(
// //                       content: Text(
// //                         t(
// //                           'عذراً! هذا البريد غير مصرح له كمسؤول لنظام السيارات المشتركة.',
// //                           'Unauthorized email for this application.',
// //                         ),
// //                       ),
// //                     ),
// //                   );
// //                   return;
// //                 }

// //                 try {
// //                   await FirebaseAuth.instance.signInWithEmailAndPassword(
// //                     email: email,
// //                     password: password,
// //                   );
// //                   if (context.mounted) {
// //                     Navigator.pop(ctx);
// //                     ScaffoldMessenger.of(context).showSnackBar(
// //                       SnackBar(
// //                         backgroundColor: Colors.teal,
// //                         content: Text(
// //                           t(
// //                             'تم تسجيل الدخول كمسؤول بنجاح!',
// //                             'Successfully signed in as Administrator!',
// //                           ),
// //                         ),
// //                       ),
// //                     );
// //                   }
// //                 } on FirebaseAuthException catch (e) {
// //                   if (context.mounted) {
// //                     ScaffoldMessenger.of(context).showSnackBar(
// //                       SnackBar(
// //                         backgroundColor: Colors.red,
// //                         content: Text(
// //                           e.message ??
// //                               t('فشل تسجيل الدخول. تحقق من كلمة المرور.',
// //                                   'Sign-in failed. Check password.'),
// //                         ),
// //                       ),
// //                     );
// //                   }
// //                 }
// //               },
// //               child: Text(t('دخول', 'Sign In')),
// //             ),
// //           ],
// //         ),
// //       ),
// //     );
// //   }

// //   static Future<void> showAddEditVehicleDialog({
// //     required BuildContext context,
// //     required FirebaseFirestore db,
// //     required String Function(String ar, String en) t,
// //     VehicleItem? vehicleToEdit,
// //   }) async {
// //     final numberCtrl =
// //         TextEditingController(text: vehicleToEdit?.number ?? '');
// //     final lettersCtrl =
// //         TextEditingController(text: vehicleToEdit?.letters ?? '');

// //     // Build list of all 20 company names
// //     final List<String> allCompanyNames = SeedData.getInitialCompanies()
// //         .map((c) => c.name)
// //         .toList();

// //     String selectedCompany = vehicleToEdit?.companyName != null &&
// //             allCompanyNames.contains(vehicleToEdit!.companyName)
// //         ? vehicleToEdit.companyName
// //         : allCompanyNames.first;

// //     final formKey = GlobalKey<FormState>();

// //     final saved = await showDialog<bool>(
// //       context: context,
// //       builder: (ctx) => StatefulBuilder(
// //         builder: (context, setDialogState) => AlertDialog(
// //           title: Text(
// //             vehicleToEdit == null
// //                 ? t('إضافة سيارة جديدة', 'Add New Vehicle')
// //                 : t('تعديل بيانات السيارة', 'Edit Vehicle'),
// //           ),
// //           content: Form(
// //             key: formKey,
// //             child: SingleChildScrollView(
// //               child: Column(
// //                 mainAxisSize: MainAxisSize.min,
// //                 children: [
// //                   TextFormField(
// //                     controller: numberCtrl,
// //                     keyboardType: TextInputType.number,
// //                     decoration: InputDecoration(
// //                       labelText: t('رقم اللوحة', 'Plate Number'),
// //                       hintText: t('مثال: 1234 أو 985', 'e.g. 1234 or 985'),
// //                       prefixIcon: const Icon(Icons.tag),
// //                     ),
// //                     validator: (v) => v == null || v.trim().isEmpty
// //                         ? t('رقم اللوحة مطلوب', 'Plate number is required')
// //                         : null,
// //                   ),
// //                   const SizedBox(height: 12),
// //                   TextFormField(
// //                     controller: lettersCtrl,
// //                     decoration: InputDecoration(
// //                       labelText: t('حروف اللوحة', 'Plate Letters'),
// //                       hintText: t('مثال: أ ب ج أو س ص ع', 'e.g. A B C'),
// //                       prefixIcon: const Icon(Icons.sort_by_alpha),
// //                     ),
// //                     validator: (v) => v == null || v.trim().isEmpty
// //                         ? t('حروف اللوحة مطلوبة', 'Plate letters are required')
// //                         : null,
// //                   ),
// //                   const SizedBox(height: 12),
// //                   DropdownButtonFormField<String>(
// //                     value: selectedCompany,
// //                     isExpanded: true,
// //                     decoration: InputDecoration(
// //                       labelText: t('اسم الشركة', 'Company Name'),
// //                       prefixIcon: const Icon(Icons.apartment),
// //                     ),
// //                     items: allCompanyNames
// //                         .map((name) => DropdownMenuItem(
// //                               value: name,
// //                               child: Text(
// //                                 name,
// //                                 overflow: TextOverflow.ellipsis,
// //                                 style: const TextStyle(fontSize: 14),
// //                               ),
// //                             ))
// //                         .toList(),
// //                     onChanged: (val) {
// //                       if (val != null) {
// //                         setDialogState(() => selectedCompany = val);
// //                       }
// //                     },
// //                   ),
// //                 ],
// //               ),
// //             ),
// //           ),
// //           actions: [
// //             TextButton(
// //               onPressed: () => Navigator.pop(ctx, false),
// //               child: Text(t('إلغاء', 'Cancel')),
// //             ),
// //             FilledButton(
// //               onPressed: () {
// //                 if (formKey.currentState!.validate()) {
// //                   Navigator.pop(ctx, true);
// //                 }
// //               },
// //               child: Text(t('حفظ', 'Save')),
// //             ),
// //           ],
// //         ),
// //       ),
// //     );

// //     if (saved != true) return;

// //     final number = numberCtrl.text.trim();
// //     final letters = lettersCtrl.text.trim();
// //     final companyName = selectedCompany;

// //     try {
// //       final companyQuery = await db
// //           .collection('companies')
// //           .where('name', isEqualTo: companyName)
// //           .limit(1)
// //           .get();

// //       DocumentReference companyRef;
// //       if (companyQuery.docs.isEmpty) {
// //         companyRef = await db.collection('companies').add({
// //           'name': companyName,
// //           'vehicleCount': 0,
// //           'createdAt': FieldValue.serverTimestamp(),
// //         });
// //       } else {
// //         companyRef = companyQuery.docs.first.reference;
// //       }

// //       final payload = {
// //         'number': number,
// //         'letters': letters,
// //         'companyId': companyRef.id,
// //         'companyName': companyName,
// //         'updatedAt': FieldValue.serverTimestamp(),
// //       };

// //       if (vehicleToEdit == null || vehicleToEdit.id == null) {
// //         await db.collection('vehicles').add({
// //           ...payload,
// //           'createdAt': FieldValue.serverTimestamp(),
// //         });
// //         await companyRef.update({
// //           'vehicleCount': FieldValue.increment(1),
// //         });
// //       } else {
// //         await db.collection('vehicles').doc(vehicleToEdit.id).update(payload);
// //       }

// //       if (context.mounted) {
// //         ScaffoldMessenger.of(context).showSnackBar(
// //           SnackBar(
// //             backgroundColor: Colors.teal,
// //             content: Text(
// //               vehicleToEdit == null
// //                   ? t('تم إضافة السيارة بنجاح', 'Vehicle added successfully')
// //                   : t('تم تعديل بيانات السيارة', 'Vehicle updated successfully'),
// //             ),
// //           ),
// //         );
// //       }
// //     } catch (e) {
// //       if (context.mounted) {
// //         ScaffoldMessenger.of(context).showSnackBar(
// //           SnackBar(
// //             backgroundColor: Colors.red,
// //             content: Text('${t('حدث خطأ:', 'Error:')} $e'),
// //           ),
// //         );
// //       }
// //     }
// //   }

// //   static Future<void> showDeleteVehicleDialog({
// //     required BuildContext context,
// //     required FirebaseFirestore db,
// //     required VehicleItem vehicle,
// //     required String Function(String ar, String en) t,
// //   }) async {
// //     final confirmed = await showDialog<bool>(
// //       context: context,
// //       builder: (ctx) => AlertDialog(
// //         title: Text(t('حذف السيارة؟', 'Delete Vehicle?')),
// //         content: Text(
// //           '${t('هل أنت متأكد من حذف السيارة', 'Are you sure you want to delete')} ${vehicle.number} ${vehicle.letters} (${vehicle.companyName})؟',
// //         ),
// //         actions: [
// //           TextButton(
// //             onPressed: () => Navigator.pop(ctx, false),
// //             child: Text(t('إلغاء', 'Cancel')),
// //           ),
// //           FilledButton(
// //             style: FilledButton.styleFrom(backgroundColor: Colors.red),
// //             onPressed: () => Navigator.pop(ctx, true),
// //             child: Text(t('تأكيد الحذف', 'Confirm Delete')),
// //           ),
// //         ],
// //       ),
// //     );

// //     if (confirmed != true) return;

// //     try {
// //       if (vehicle.id != null) {
// //         await db.collection('vehicles').doc(vehicle.id).delete();
// //       }
// //       if (context.mounted) {
// //         ScaffoldMessenger.of(context).showSnackBar(
// //           SnackBar(
// //             content: Text(
// //               t('تم حذف السيارة بنجاح', 'Vehicle deleted successfully'),
// //             ),
// //           ),
// //         );
// //       }
// //     } catch (e) {
// //       if (context.mounted) {
// //         ScaffoldMessenger.of(context).showSnackBar(
// //           SnackBar(
// //             backgroundColor: Colors.red,
// //             content: Text('${t('حدث خطأ أثناء الحذف:', 'Delete error:')} $e'),
// //           ),
// //         );
// //       }
// //     }
// //   }

// //   static Future<void> syncAllCompaniesToFirestore({
// //     required BuildContext context,
// //     required FirebaseFirestore db,
// //     required String Function(String ar, String en) t,
// //   }) async {
// //     showDialog(
// //       context: context,
// //       barrierDismissible: false,
// //       builder: (_) => AlertDialog(
// //         content: Row(
// //           children: [
// //             const CircularProgressIndicator(),
// //             const SizedBox(width: 20),
// //             Expanded(
// //               child: Text(
// //                 t('جاري مزامنة ورفع كافة الشركات والسيارات...',
// //                     'Uploading all companies & vehicles...'),
// //               ),
// //             ),
// //           ],
// //         ),
// //       ),
// //     );

// //     try {
// //       int totalAdded = 0;

// //       for (var compData in SeedData.getInitialCompanies()) {
// //         final cName = compData.name;
// //         final cVehicles = compData.vehicles;

// //         final compQuery = await db
// //             .collection('companies')
// //             .where('name', isEqualTo: cName)
// //             .limit(1)
// //             .get();

// //         DocumentReference compRef;
// //         if (compQuery.docs.isEmpty) {
// //           compRef = await db.collection('companies').add({
// //             'name': cName,
// //             'vehicleCount': cVehicles.length,
// //             'createdAt': FieldValue.serverTimestamp(),
// //           });
// //         } else {
// //           compRef = compQuery.docs.first.reference;
// //           await compRef.update({
// //             'vehicleCount': cVehicles.length,
// //           });
// //         }

// //         final existingCarsSnap = await db
// //             .collection('vehicles')
// //             .where('companyName', isEqualTo: cName)
// //             .get();

// //         final existingKeys = existingCarsSnap.docs
// //             .map((d) => '${d.data()['number']}_${d.data()['letters']}'.trim())
// //             .toSet();

// //         final toUpload = cVehicles.where((c) {
// //           final key = '${c.number}_${c.letters}'.trim();
// //           return !existingKeys.contains(key);
// //         }).toList();

// //         for (var i = 0; i < toUpload.length; i += 200) {
// //           final chunk = toUpload.sublist(
// //             i,
// //             (i + 200 > toUpload.length) ? toUpload.length : i + 200,
// //           );
// //           final batch = db.batch();
// //           for (var car in chunk) {
// //             final doc = db.collection('vehicles').doc();
// //             batch.set(doc, {
// //               'number': car.number,
// //               'letters': car.letters,
// //               'companyId': compRef.id,
// //               'companyName': cName,
// //               'createdAt': FieldValue.serverTimestamp(),
// //             });
// //             totalAdded++;
// //           }
// //           await batch.commit();
// //         }
// //       }

// //       if (context.mounted) {
// //         Navigator.pop(context);
// //         ScaffoldMessenger.of(context).showSnackBar(
// //           SnackBar(
// //             backgroundColor: Colors.teal,
// //             content: Text(
// //               t(
// //                 'تمت المزامنة بنجاح! تمت إضافة $totalAdded سيارة جديدة إلى فايرستور.',
// //                 'Sync successful! Added $totalAdded new vehicles to Firestore.',
// //               ),
// //             ),
// //           ),
// //         );
// //       }
// //     } catch (e) {
// //       if (context.mounted) {
// //         Navigator.pop(context);
// //         ScaffoldMessenger.of(context).showSnackBar(
// //           SnackBar(
// //             backgroundColor: Colors.red,
// //             content: Text('${t('فشلت المزامنة:', 'Sync failed:')} $e'),
// //           ),
// //         );
// //       }
// //     }
// //   }
// // }

// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';

// import '../data/seed_data.dart';
// import '../models/vehicle_model.dart';

// const String kAdminEmail = 'm01151661324@gmail.com';

// class AdminDialogs {
//   static Future<void> showSignInDialog({
//     required BuildContext context,
//     required String Function(String ar, String en) t,
//   }) async {
//     final emailCtrl = TextEditingController();
//     final passCtrl = TextEditingController();
//     bool obscure = true;

//     await showDialog(
//       context: context,
//       builder: (ctx) => StatefulBuilder(
//         builder: (context, setDialogState) => AlertDialog(
//           title: Row(
//             children: [
//               const Icon(Icons.lock_person, color: Colors.teal),
//               const SizedBox(width: 8),
//               Text(t('دخول الإدارة', 'Admin Sign In')),
//             ],
//           ),
//           content: SingleChildScrollView(
//             child: Column(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 Text(
//                   t(
//                     'قم بإدخال بيانات حساب الإدارة المعتمد لإدارة السيارات والشركات.',
//                     'Enter authorized admin credentials to manage vehicles and companies.',
//                   ),
//                   style: const TextStyle(fontSize: 13),
//                 ),
//                 const SizedBox(height: 16),
//                 TextField(
//                   controller: emailCtrl,
//                   keyboardType: TextInputType.emailAddress,
//                   decoration: InputDecoration(
//                     labelText: t('البريد الإلكتروني', 'Email'),
//                     prefixIcon: const Icon(Icons.email_outlined),
//                   ),
//                 ),
//                 const SizedBox(height: 12),
//                 TextField(
//                   controller: passCtrl,
//                   obscureText: obscure,
//                   decoration: InputDecoration(
//                     labelText: t('كلمة المرور', 'Password'),
//                     prefixIcon: const Icon(Icons.lock_outline),
//                     suffixIcon: IconButton(
//                       icon: Icon(
//                         obscure ? Icons.visibility_off : Icons.visibility,
//                       ),
//                       onPressed: () =>
//                           setDialogState(() => obscure = !obscure),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           actions: [
//             TextButton(
//               onPressed: () => Navigator.pop(ctx),
//               child: Text(t('إلغاء', 'Cancel')),
//             ),
//             FilledButton(
//               onPressed: () async {
//                 final email = emailCtrl.text.trim();
//                 final password = passCtrl.text;

//                 if (email.isEmpty || password.isEmpty) {
//                   ScaffoldMessenger.of(context).showSnackBar(
//                     SnackBar(
//                       content: Text(
//                         t('يرجى ملء كافة الحقول', 'Please fill all fields'),
//                       ),
//                     ),
//                   );
//                   return;
//                 }

//                 if (email.toLowerCase() != kAdminEmail.toLowerCase()) {
//                   ScaffoldMessenger.of(context).showSnackBar(
//                     SnackBar(
//                       content: Text(
//                         t(
//                           'عذراً! هذا البريد غير مصرح له كمسؤول لنظام السيارات المشتركة.',
//                           'Unauthorized email for this application.',
//                         ),
//                       ),
//                     ),
//                   );
//                   return;
//                 }

//                 try {
//                   await FirebaseAuth.instance.signInWithEmailAndPassword(
//                     email: email,
//                     password: password,
//                   );
//                   if (context.mounted) {
//                     Navigator.pop(ctx);
//                     ScaffoldMessenger.of(context).showSnackBar(
//                       SnackBar(
//                         backgroundColor: Colors.teal,
//                         content: Text(
//                           t(
//                             'تم تسجيل الدخول كمسؤول بنجاح!',
//                             'Successfully signed in as Administrator!',
//                           ),
//                         ),
//                       ),
//                     );
//                   }
//                 } on FirebaseAuthException catch (e) {
//                   if (context.mounted) {
//                     ScaffoldMessenger.of(context).showSnackBar(
//                       SnackBar(
//                         backgroundColor: Colors.red,
//                         content: Text(
//                           e.message ??
//                               t('فشل تسجيل الدخول. تحقق من كلمة المرور.',
//                                   'Sign-in failed. Check password.'),
//                         ),
//                       ),
//                     );
//                   }
//                 }
//               },
//               child: Text(t('دخول', 'Sign In')),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   static Future<void> showAddEditVehicleDialog({
//     required BuildContext context,
//     required FirebaseFirestore db,
//     required String Function(String ar, String en) t,
//     VehicleItem? vehicleToEdit,
//   }) async {
//     final numberCtrl =
//         TextEditingController(text: vehicleToEdit?.number ?? '');
//     final lettersCtrl =
//         TextEditingController(text: vehicleToEdit?.letters ?? '');

//     // Build list of all 20 company names
//     final List<String> allCompanyNames = SeedData.getInitialCompanies()
//         .map((c) => c.name)
//         .toList();

//     String selectedCompany = vehicleToEdit?.companyName != null &&
//             allCompanyNames.contains(vehicleToEdit!.companyName)
//         ? vehicleToEdit.companyName
//         : allCompanyNames.first;

//     final formKey = GlobalKey<FormState>();

//     final saved = await showDialog<bool>(
//       context: context,
//       builder: (ctx) => StatefulBuilder(
//         builder: (context, setDialogState) => AlertDialog(
//           title: Text(
//             vehicleToEdit == null
//                 ? t('إضافة سيارة جديدة', 'Add New Vehicle')
//                 : t('تعديل بيانات السيارة', 'Edit Vehicle'),
//           ),
//           content: Form(
//             key: formKey,
//             child: SingleChildScrollView(
//               child: Column(
//                 mainAxisSize: MainAxisSize.min,
//                 children: [
//                   TextFormField(
//                     controller: numberCtrl,
//                     keyboardType: TextInputType.number,
//                     decoration: InputDecoration(
//                       labelText: t('رقم اللوحة', 'Plate Number'),
//                       hintText: t('مثال: 1234 أو 985', 'e.g. 1234 or 985'),
//                       prefixIcon: const Icon(Icons.tag),
//                     ),
//                     validator: (v) => v == null || v.trim().isEmpty
//                         ? t('رقم اللوحة مطلوب', 'Plate number is required')
//                         : null,
//                   ),
//                   const SizedBox(height: 12),
//                   TextFormField(
//                     controller: lettersCtrl,
//                     decoration: InputDecoration(
//                       labelText: t('حروف اللوحة', 'Plate Letters'),
//                       hintText: t('مثال: أ ب ج أو س ص ع', 'e.g. A B C'),
//                       prefixIcon: const Icon(Icons.sort_by_alpha),
//                     ),
//                     validator: (v) => v == null || v.trim().isEmpty
//                         ? t('حروف اللوحة مطلوبة', 'Plate letters are required')
//                         : null,
//                   ),
//                   const SizedBox(height: 12),
//                   DropdownButtonFormField<String>(
//                     value: selectedCompany,
//                     isExpanded: true,
//                     decoration: InputDecoration(
//                       labelText: t('اسم الشركة', 'Company Name'),
//                       prefixIcon: const Icon(Icons.apartment),
//                     ),
//                     items: allCompanyNames
//                         .map((name) => DropdownMenuItem(
//                               value: name,
//                               child: Text(
//                                 name,
//                                 overflow: TextOverflow.ellipsis,
//                                 style: const TextStyle(fontSize: 14),
//                               ),
//                             ))
//                         .toList(),
//                     onChanged: (val) {
//                       if (val != null) {
//                         setDialogState(() => selectedCompany = val);
//                       }
//                     },
//                   ),
//                 ],
//               ),
//             ),
//           ),
//           actions: [
//             TextButton(
//               onPressed: () => Navigator.pop(ctx, false),
//               child: Text(t('إلغاء', 'Cancel')),
//             ),
//             FilledButton(
//               onPressed: () {
//                 if (formKey.currentState!.validate()) {
//                   Navigator.pop(ctx, true);
//                 }
//               },
//               child: Text(t('حفظ', 'Save')),
//             ),
//           ],
//         ),
//       ),
//     );

//     if (saved != true) return;

//     final number = numberCtrl.text.trim();
//     final letters = lettersCtrl.text.trim();
//     final companyName = selectedCompany;

//     try {
//       final companyQuery = await db
//           .collection('companies')
//           .where('name', isEqualTo: companyName)
//           .limit(1)
//           .get();

//       DocumentReference companyRef;
//       if (companyQuery.docs.isEmpty) {
//         companyRef = await db.collection('companies').add({
//           'name': companyName,
//           'vehicleCount': 0,
//           'createdAt': FieldValue.serverTimestamp(),
//         });
//       } else {
//         companyRef = companyQuery.docs.first.reference;
//       }

//       final payload = {
//         'number': number,
//         'letters': letters,
//         'companyId': companyRef.id,
//         'companyName': companyName,
//         'updatedAt': FieldValue.serverTimestamp(),
//       };

//       if (vehicleToEdit == null || vehicleToEdit.id == null) {
//         await db.collection('vehicles').add({
//           ...payload,
//           'createdAt': FieldValue.serverTimestamp(),
//         });
//         await companyRef.update({
//           'vehicleCount': FieldValue.increment(1),
//         });
//       } else {
//         await db.collection('vehicles').doc(vehicleToEdit.id).update(payload);
//         if (vehicleToEdit.companyName != companyName) {
//           final oldQ = await db
//               .collection('companies')
//               .where('name', isEqualTo: vehicleToEdit.companyName)
//               .limit(1)
//               .get();
//           if (oldQ.docs.isNotEmpty) {
//             await oldQ.docs.first.reference
//                 .update({'vehicleCount': FieldValue.increment(-1)});
//           }
//           await companyRef.update({'vehicleCount': FieldValue.increment(1)});
//         }
//       }

//       if (context.mounted) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(
//             backgroundColor: Colors.teal,
//             content: Text(
//               vehicleToEdit == null
//                   ? t('تم إضافة السيارة بنجاح', 'Vehicle added successfully')
//                   : t('تم تعديل بيانات السيارة', 'Vehicle updated successfully'),
//             ),
//           ),
//         );
//       }
//     } catch (e) {
//       if (context.mounted) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(
//             backgroundColor: Colors.red,
//             content: Text('${t('حدث خطأ:', 'Error:')} $e'),
//           ),
//         );
//       }
//     }
//   }

//   static Future<void> showDeleteVehicleDialog({
//     required BuildContext context,
//     required FirebaseFirestore db,
//     required VehicleItem vehicle,
//     required String Function(String ar, String en) t,
//   }) async {
//     final confirmed = await showDialog<bool>(
//       context: context,
//       builder: (ctx) => AlertDialog(
//         title: Text(t('حذف السيارة؟', 'Delete Vehicle?')),
//         content: Text(
//           '${t('هل أنت متأكد من حذف السيارة', 'Are you sure you want to delete')} ${vehicle.number} ${vehicle.letters} (${vehicle.companyName})؟',
//         ),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.pop(ctx, false),
//             child: Text(t('إلغاء', 'Cancel')),
//           ),
//           FilledButton(
//             style: FilledButton.styleFrom(backgroundColor: Colors.red),
//             onPressed: () => Navigator.pop(ctx, true),
//             child: Text(t('تأكيد الحذف', 'Confirm Delete')),
//           ),
//         ],
//       ),
//     );

//     if (confirmed != true) return;

//     try {
//       if (vehicle.id != null) {
//         final batch = db.batch();
//         batch.delete(db.collection('vehicles').doc(vehicle.id));
//         final cq = await db
//             .collection('companies')
//             .where('name', isEqualTo: vehicle.companyName)
//             .limit(1)
//             .get();
//         if (cq.docs.isNotEmpty) {
//           batch.update(cq.docs.first.reference,
//               {'vehicleCount': FieldValue.increment(-1)});
//         }
//         await batch.commit();
//       }
//       if (context.mounted) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(
//             content: Text(
//               t('تم حذف السيارة بنجاح', 'Vehicle deleted successfully'),
//             ),
//           ),
//         );
//       }
//     } catch (e) {
//       if (context.mounted) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(
//             backgroundColor: Colors.red,
//             content: Text('${t('حدث خطأ أثناء الحذف:', 'Delete error:')} $e'),
//           ),
//         );
//       }
//     }
//   }

//   static Future<void> syncAllCompaniesToFirestore({
//     required BuildContext context,
//     required FirebaseFirestore db,
//     required String Function(String ar, String en) t,
//   }) async {
//     showDialog(
//       context: context,
//       barrierDismissible: false,
//       builder: (_) => AlertDialog(
//         content: Row(
//           children: [
//             const CircularProgressIndicator(),
//             const SizedBox(width: 20),
//             Expanded(
//               child: Text(
//                 t('جاري مزامنة ورفع كافة الشركات والسيارات...',
//                     'Uploading all companies & vehicles...'),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );

//     try {
//       int totalAdded = 0;

//       for (var compData in SeedData.getInitialCompanies()) {
//         final cName = compData.name;
//         final cVehicles = compData.vehicles;

//         final compQuery = await db
//             .collection('companies')
//             .where('name', isEqualTo: cName)
//             .limit(1)
//             .get();

//         DocumentReference compRef;
//         if (compQuery.docs.isEmpty) {
//           compRef = await db.collection('companies').add({
//             'name': cName,
//             'vehicleCount': cVehicles.length,
//             'createdAt': FieldValue.serverTimestamp(),
//           });
//         } else {
//           compRef = compQuery.docs.first.reference;
//         }

//         final existingCarsSnap = await db
//             .collection('vehicles')
//             .where('companyName', isEqualTo: cName)
//             .get();

//         final existingKeys = existingCarsSnap.docs
//             .map((d) => '${d.data()['number']}_${d.data()['letters']}'.trim())
//             .toSet();

//         final toUpload = cVehicles.where((c) {
//           final key = '${c.number}_${c.letters}'.trim();
//           return !existingKeys.contains(key);
//         }).toList();

//         for (var i = 0; i < toUpload.length; i += 200) {
//           final chunk = toUpload.sublist(
//             i,
//             (i + 200 > toUpload.length) ? toUpload.length : i + 200,
//           );
//           final batch = db.batch();
//           for (var car in chunk) {
//             final doc = db.collection('vehicles').doc();
//             batch.set(doc, {
//               'number': car.number,
//               'letters': car.letters,
//               'companyId': compRef.id,
//               'companyName': cName,
//               'createdAt': FieldValue.serverTimestamp(),
//             });
//             totalAdded++;
//           }
//           await batch.commit();
//         }

//         // Real count = what is actually in Firestore for this company now.
//         final total = await db
//             .collection('vehicles')
//             .where('companyName', isEqualTo: cName)
//             .count()
//             .get();
//         await compRef.update({'vehicleCount': total.count ?? 0});
//       }

//       // Mark seed as uploaded so deleted cars never come back from seed data.
//       await db.collection('meta').doc('seed').set({
//         'synced': true,
//         'syncedAt': FieldValue.serverTimestamp(),
//       });

//       if (context.mounted) {
//         Navigator.pop(context);
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(
//             backgroundColor: Colors.teal,
//             content: Text(
//               t(
//                 'تمت المزامنة بنجاح! تمت إضافة $totalAdded سيارة جديدة إلى فايرستور.',
//                 'Sync successful! Added $totalAdded new vehicles to Firestore.',
//               ),
//             ),
//           ),
//         );
//       }
//     } catch (e) {
//       if (context.mounted) {
//         Navigator.pop(context);
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(
//             backgroundColor: Colors.red,
//             content: Text('${t('فشلت المزامنة:', 'Sync failed:')} $e'),
//           ),
//         );
//       }
//     }
//   }
// }





import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../data/seed_data.dart';
import '../models/vehicle_model.dart';

const String kAdminEmail = 'm01151661324@gmail.com';

class AdminDialogs {
  static Future<void> showSignInDialog({
    required BuildContext context,
    required String Function(String ar, String en) t,
  }) async {
    final emailCtrl = TextEditingController();
    final passCtrl = TextEditingController();
    bool obscure = true;

    await showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: Row(
            children: [
              const Icon(Icons.lock_person, color: Colors.teal),
              const SizedBox(width: 8),
              Text(t('دخول الإدارة', 'Admin Sign In')),
            ],
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  t(
                    'قم بإدخال بيانات حساب الإدارة المعتمد لإدارة السيارات والشركات.',
                    'Enter authorized admin credentials to manage vehicles and companies.',
                  ),
                  style: const TextStyle(fontSize: 13),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: emailCtrl,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    labelText: t('البريد الإلكتروني', 'Email'),
                    prefixIcon: const Icon(Icons.email_outlined),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: passCtrl,
                  obscureText: obscure,
                  decoration: InputDecoration(
                    labelText: t('كلمة المرور', 'Password'),
                    prefixIcon: const Icon(Icons.lock_outline),
                    suffixIcon: IconButton(
                      icon: Icon(
                        obscure ? Icons.visibility_off : Icons.visibility,
                      ),
                      onPressed: () =>
                          setDialogState(() => obscure = !obscure),
                    ),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: Text(t('إلغاء', 'Cancel')),
            ),
            FilledButton(
              onPressed: () async {
                final email = emailCtrl.text.trim();
                final password = passCtrl.text;

                if (email.isEmpty || password.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        t('يرجى ملء كافة الحقول', 'Please fill all fields'),
                      ),
                    ),
                  );
                  return;
                }

                if (email.toLowerCase() != kAdminEmail.toLowerCase()) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        t(
                          'عذراً! هذا البريد غير مصرح له كمسؤول لنظام السيارات المشتركة.',
                          'Unauthorized email for this application.',
                        ),
                      ),
                    ),
                  );
                  return;
                }

                try {
                  await FirebaseAuth.instance.signInWithEmailAndPassword(
                    email: email,
                    password: password,
                  );
                  if (context.mounted) {
                    Navigator.pop(ctx);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        backgroundColor: Colors.teal,
                        content: Text(
                          t(
                            'تم تسجيل الدخول كمسؤول بنجاح!',
                            'Successfully signed in as Administrator!',
                          ),
                        ),
                      ),
                    );
                  }
                } on FirebaseAuthException catch (e) {
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        backgroundColor: Colors.red,
                        content: Text(
                          e.message ??
                              t('فشل تسجيل الدخول. تحقق من كلمة المرور.',
                                  'Sign-in failed. Check password.'),
                        ),
                      ),
                    );
                  }
                }
              },
              child: Text(t('دخول', 'Sign In')),
            ),
          ],
        ),
      ),
    );
  }

  static Future<void> showAddEditVehicleDialog({
    required BuildContext context,
    required FirebaseFirestore db,
    required String Function(String ar, String en) t,
    VehicleItem? vehicleToEdit,
  }) async {
    final numberCtrl =
        TextEditingController(text: vehicleToEdit?.number ?? '');
    final lettersCtrl =
        TextEditingController(text: vehicleToEdit?.letters ?? '');

    // Build list of all 20 company names
    final List<String> allCompanyNames = SeedData.getInitialCompanies()
        .map((c) => c.name)
        .toList();

    String selectedCompany = vehicleToEdit?.companyName != null &&
            allCompanyNames.contains(vehicleToEdit!.companyName)
        ? vehicleToEdit.companyName
        : allCompanyNames.first;

    final formKey = GlobalKey<FormState>();

    final saved = await showDialog<bool>(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: Text(
            vehicleToEdit == null
                ? t('إضافة سيارة جديدة', 'Add New Vehicle')
                : t('تعديل بيانات السيارة', 'Edit Vehicle'),
          ),
          content: Form(
            key: formKey,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    controller: numberCtrl,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: t('رقم اللوحة', 'Plate Number'),
                      hintText: t('مثال: 1234 أو 985', 'e.g. 1234 or 985'),
                      prefixIcon: const Icon(Icons.tag),
                    ),
                    validator: (v) => v == null || v.trim().isEmpty
                        ? t('رقم اللوحة مطلوب', 'Plate number is required')
                        : null,
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: lettersCtrl,
                    decoration: InputDecoration(
                      labelText: t('حروف اللوحة', 'Plate Letters'),
                      hintText: t('مثال: أ ب ج أو س ص ع', 'e.g. A B C'),
                      prefixIcon: const Icon(Icons.sort_by_alpha),
                    ),
                    validator: (v) => v == null || v.trim().isEmpty
                        ? t('حروف اللوحة مطلوبة', 'Plate letters are required')
                        : null,
                  ),
                  const SizedBox(height: 12),
                  DropdownButtonFormField<String>(
                    value: selectedCompany,
                    isExpanded: true,
                    decoration: InputDecoration(
                      labelText: t('اسم الشركة', 'Company Name'),
                      prefixIcon: const Icon(Icons.apartment),
                    ),
                    items: allCompanyNames
                        .map((name) => DropdownMenuItem(
                              value: name,
                              child: Text(
                                name,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(fontSize: 14),
                              ),
                            ))
                        .toList(),
                    onChanged: (val) {
                      if (val != null) {
                        setDialogState(() => selectedCompany = val);
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: Text(t('إلغاء', 'Cancel')),
            ),
            FilledButton(
              onPressed: () {
                if (formKey.currentState!.validate()) {
                  Navigator.pop(ctx, true);
                }
              },
              child: Text(t('حفظ', 'Save')),
            ),
          ],
        ),
      ),
    );

    if (saved != true) return;

    final number = numberCtrl.text.trim();
    final letters = lettersCtrl.text.trim();
    final companyName = selectedCompany;

    try {
      final companyQuery = await db
          .collection('companies')
          .where('name', isEqualTo: companyName)
          .limit(1)
          .get();

      DocumentReference companyRef;
      if (companyQuery.docs.isEmpty) {
        companyRef = await db.collection('companies').add({
          'name': companyName,
          'vehicleCount': 0,
          'createdAt': FieldValue.serverTimestamp(),
        });
      } else {
        companyRef = companyQuery.docs.first.reference;
      }

      final payload = {
        'number': number,
        'letters': letters,
        'companyId': companyRef.id,
        'companyName': companyName,
        'updatedAt': FieldValue.serverTimestamp(),
      };

      if (vehicleToEdit == null || vehicleToEdit.id == null) {
        await db.collection('vehicles').add({
          ...payload,
          'createdAt': FieldValue.serverTimestamp(),
        });
        await companyRef.update({
          'vehicleCount': FieldValue.increment(1),
        });
      } else {
        await db.collection('vehicles').doc(vehicleToEdit.id).update(payload);
        if (vehicleToEdit.companyName != companyName) {
          final oldQ = await db
              .collection('companies')
              .where('name', isEqualTo: vehicleToEdit.companyName)
              .limit(1)
              .get();
          if (oldQ.docs.isNotEmpty) {
            await oldQ.docs.first.reference
                .update({'vehicleCount': FieldValue.increment(-1)});
          }
          await companyRef.update({'vehicleCount': FieldValue.increment(1)});
        }
      }

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Colors.teal,
            content: Text(
              vehicleToEdit == null
                  ? t('تم إضافة السيارة بنجاح', 'Vehicle added successfully')
                  : t('تم تعديل بيانات السيارة', 'Vehicle updated successfully'),
            ),
          ),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Colors.red,
            content: Text('${t('حدث خطأ:', 'Error:')} $e'),
          ),
        );
      }
    }
  }

  static Future<void> showDeleteVehicleDialog({
    required BuildContext context,
    required FirebaseFirestore db,
    required VehicleItem vehicle,
    required String Function(String ar, String en) t,
  }) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(t('حذف السيارة؟', 'Delete Vehicle?')),
        content: Text(
          '${t('هل أنت متأكد من حذف السيارة', 'Are you sure you want to delete')} ${vehicle.number} ${vehicle.letters} (${vehicle.companyName})؟',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text(t('إلغاء', 'Cancel')),
          ),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () => Navigator.pop(ctx, true),
            child: Text(t('تأكيد الحذف', 'Confirm Delete')),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    try {
      if (vehicle.id != null) {
        final batch = db.batch();
        batch.delete(db.collection('vehicles').doc(vehicle.id));
        final cq = await db
            .collection('companies')
            .where('name', isEqualTo: vehicle.companyName)
            .limit(1)
            .get();
        if (cq.docs.isNotEmpty) {
          batch.update(cq.docs.first.reference,
              {'vehicleCount': FieldValue.increment(-1)});
        }
        await batch.commit();
      }
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              t('تم حذف السيارة بنجاح', 'Vehicle deleted successfully'),
            ),
          ),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Colors.red,
            content: Text('${t('حدث خطأ أثناء الحذف:', 'Delete error:')} $e'),
          ),
        );
      }
    }
  }

  static Future<void> syncAllCompaniesToFirestore({
    required BuildContext context,
    required FirebaseFirestore db,
    required String Function(String ar, String en) t,
  }) async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        content: Row(
          children: [
            const CircularProgressIndicator(),
            const SizedBox(width: 20),
            Expanded(
              child: Text(
                t('جاري مزامنة ورفع كافة الشركات والسيارات...',
                    'Uploading all companies & vehicles...'),
              ),
            ),
          ],
        ),
      ),
    );

    try {
      int totalAdded = 0;

      for (var compData in SeedData.getInitialCompanies()) {
        final cName = compData.name;
        final cVehicles = compData.vehicles;

        final compQuery = await db
            .collection('companies')
            .where('name', isEqualTo: cName)
            .limit(1)
            .get();

        DocumentReference compRef;
        if (compQuery.docs.isEmpty) {
          compRef = await db.collection('companies').add({
            'name': cName,
            'vehicleCount': cVehicles.length,
            'createdAt': FieldValue.serverTimestamp(),
          });
        } else {
          compRef = compQuery.docs.first.reference;
        }

        final existingCarsSnap = await db
            .collection('vehicles')
            .where('companyName', isEqualTo: cName)
            .get();

        final existingKeys = existingCarsSnap.docs
            .map((d) => '${d.data()['number']}_${d.data()['letters']}'.trim())
            .toSet();

        final toUpload = cVehicles.where((c) {
          final key = '${c.number}_${c.letters}'.trim();
          return !existingKeys.contains(key);
        }).toList();

        for (var i = 0; i < toUpload.length; i += 200) {
          final chunk = toUpload.sublist(
            i,
            (i + 200 > toUpload.length) ? toUpload.length : i + 200,
          );
          final batch = db.batch();
          for (var car in chunk) {
            final doc = db.collection('vehicles').doc();
            batch.set(doc, {
              'number': car.number,
              'letters': car.letters,
              'companyId': compRef.id,
              'companyName': cName,
              'createdAt': FieldValue.serverTimestamp(),
            });
            totalAdded++;
          }
          await batch.commit();
        }

        // Real count = what is actually in Firestore for this company now.
        final total = await db
            .collection('vehicles')
            .where('companyName', isEqualTo: cName)
            .count()
            .get();
        await compRef.update({'vehicleCount': total.count ?? 0});
      }

      // Mark seed as uploaded so deleted cars never come back from seed data.
      await db.collection('meta').doc('seed').set({
        'synced': true,
        'syncedAt': FieldValue.serverTimestamp(),
      });

      if (context.mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Colors.teal,
            content: Text(
              t(
                'تمت المزامنة بنجاح! تمت إضافة $totalAdded سيارة جديدة إلى فايرستور.',
                'Sync successful! Added $totalAdded new vehicles to Firestore.',
              ),
            ),
          ),
        );
      }
    } catch (e) {
      if (context.mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Colors.red,
            content: Text('${t('فشلت المزامنة:', 'Sync failed:')} $e'),
          ),
        );
      }
    }
  }

  /// Deletes every vehicle in Firestore and re-uploads the built-in data
  /// from scratch, then rewrites each company's vehicleCount.
  static Future<void> resetAndReuploadAll({
    required BuildContext context,
    required FirebaseFirestore db,
    required String Function(String ar, String en) t,
  }) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(t('إعادة رفع كل البيانات؟', 'Re-upload all data?')),
        content: Text(
          t(
            'سيتم حذف كل السيارات الموجودة حالياً في فايرستور (بما فيها أي سيارات أضفتها يدوياً) ثم رفع بيانات الـ 20 شركة من جديد وتصحيح الأعداد. تأكد أن الإنترنت يعمل ولا تغلق التطبيق أثناء العملية.',
            'This deletes ALL vehicles currently in Firestore (including any you added manually), then uploads the 20 companies again and fixes the counts. Make sure you are online and do not close the app meanwhile.',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text(t('إلغاء', 'Cancel')),
          ),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () => Navigator.pop(ctx, true),
            child: Text(t('حذف وإعادة الرفع', 'Delete & Re-upload')),
          ),
        ],
      ),
    );
    if (confirmed != true) return;
    if (!context.mounted) return;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        content: Row(
          children: [
            const CircularProgressIndicator(),
            const SizedBox(width: 20),
            Expanded(
              child: Text(
                t('جاري حذف القديم ورفع كل السيارات... قد يستغرق دقيقة',
                    'Deleting old data and uploading everything... may take a minute'),
              ),
            ),
          ],
        ),
      ),
    );

    try {
      // 1) Delete all existing vehicles (chunks of 400, limit is 500).
      final allCars = await db.collection('vehicles').get();
      final docs = allCars.docs;
      for (var i = 0; i < docs.length; i += 400) {
        final batch = db.batch();
        for (var d in docs.skip(i).take(400)) {
          batch.delete(d.reference);
        }
        await batch.commit();
      }

      // 2) Upload every company and its vehicles (no duplicates).
      int total = 0;
      for (var comp in SeedData.getInitialCompanies()) {
        final seen = <String>{};
        final cars = comp.vehicles
            .where((v) => seen.add('${v.number}_${v.letters}'.trim()))
            .toList();

        final q = await db
            .collection('companies')
            .where('name', isEqualTo: comp.name)
            .get();

        DocumentReference compRef;
        if (q.docs.isEmpty) {
          compRef = await db.collection('companies').add({
            'name': comp.name,
            'vehicleCount': cars.length,
            'createdAt': FieldValue.serverTimestamp(),
          });
        } else {
          compRef = q.docs.first.reference;
          // remove duplicate company documents if any
          for (var extra in q.docs.skip(1)) {
            await extra.reference.delete();
          }
        }

        for (var i = 0; i < cars.length; i += 400) {
          final chunk =
              cars.sublist(i, (i + 400 > cars.length) ? cars.length : i + 400);
          final batch = db.batch();
          for (var car in chunk) {
            batch.set(db.collection('vehicles').doc(), {
              'number': car.number,
              'letters': car.letters,
              'companyId': compRef.id,
              'companyName': comp.name,
              'createdAt': FieldValue.serverTimestamp(),
            });
          }
          await batch.commit();
        }

        await compRef.update({'vehicleCount': cars.length});
        total += cars.length;
      }

      await db.collection('meta').doc('seed').set({
        'synced': true,
        'syncedAt': FieldValue.serverTimestamp(),
      });

      if (context.mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Colors.teal,
            content: Text(
              t(
                'تمت إعادة الرفع بنجاح! إجمالي السيارات: $total',
                'Re-upload done! Total vehicles: $total',
              ),
            ),
          ),
        );
      }
    } catch (e) {
      if (context.mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Colors.red,
            content: Text('${t('فشلت العملية:', 'Operation failed:')} $e'),
          ),
        );
      }
    }
  }
}