// // import 'package:cloud_firestore/cloud_firestore.dart';
// // import 'package:firebase_auth/firebase_auth.dart';
// // import 'package:firebase_core/firebase_core.dart';
// // import 'package:flutter/material.dart';

// // import 'firebase_options.dart';
// // import 'screens/companies_tab.dart';
// // import 'screens/home_tab.dart';
// // import 'screens/settings_tab.dart';
// // import 'widgets/admin_dialogs.dart';

// // Future<void> main() async {
// //   WidgetsFlutterBinding.ensureInitialized();
// //   await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
// //   runApp(const FleetApp());
// // }

// // class FleetApp extends StatefulWidget {
// //   const FleetApp({super.key});

// //   @override
// //   State<FleetApp> createState() => _FleetAppState();
// // }

// // class _FleetAppState extends State<FleetApp> {
// //   ThemeMode mode = ThemeMode.light;
// //   String language = 'ar';

// //   @override
// //   Widget build(BuildContext context) {
// //     return MaterialApp(
// //       debugShowCheckedModeBanner: false,
// //       title: 'السيارات المشتركة',
// //       themeMode: mode,
// //       theme: ThemeData(
// //         colorScheme: ColorScheme.fromSeed(
// //           seedColor: const Color(0xff0d6e6e),
// //           brightness: Brightness.light,
// //         ),
// //         useMaterial3: true,
// //       ),
// //       darkTheme: ThemeData(
// //         colorScheme: ColorScheme.fromSeed(
// //           seedColor: const Color(0xff36b3b3),
// //           brightness: Brightness.dark,
// //         ),
// //         useMaterial3: true,
// //       ),
// //       home: FleetHome(
// //         isArabic: language == 'ar',
// //         dark: mode == ThemeMode.dark,
// //         onLanguage: (v) => setState(() => language = v),
// //         onTheme: (v) =>
// //             setState(() => mode = v ? ThemeMode.dark : ThemeMode.light),
// //       ),
// //     );
// //   }
// // }

// // class FleetHome extends StatefulWidget {
// //   const FleetHome({
// //     super.key,
// //     required this.isArabic,
// //     required this.dark,
// //     required this.onLanguage,
// //     required this.onTheme,
// //   });

// //   final bool isArabic;
// //   final bool dark;
// //   final ValueChanged<String> onLanguage;
// //   final ValueChanged<bool> onTheme;

// //   @override
// //   State<FleetHome> createState() => _FleetHomeState();
// // }

// // class _FleetHomeState extends State<FleetHome> {
// //   int tab = 0;
// //   final db = FirebaseFirestore.instance;

// //   bool get ar => widget.isArabic;
// //   String t(String a, String e) => ar ? a : e;

// //   bool _isAdminUser(User? user) {
// //     if (user == null || user.email == null) return false;
// //     return user.email!.trim().toLowerCase() == kAdminEmail.toLowerCase();
// //   }

// //   @override
// //   Widget build(BuildContext context) {
// //     return StreamBuilder<User?>(
// //       stream: FirebaseAuth.instance.authStateChanges(),
// //       builder: (context, authSnapshot) {
// //         final currentUser = authSnapshot.data;
// //         final isAdmin = _isAdminUser(currentUser);

// //         return Directionality(
// //           textDirection: ar ? TextDirection.rtl : TextDirection.ltr,
// //           child: Scaffold(
// //             appBar: AppBar(
// //               title: Row(
// //                 children: [
// //                   const Icon(Icons.directions_car_filled, size: 28),
// //                   const SizedBox(width: 10),
// //                   Text(
// //                     t('السيارات المشتركة', 'Shared Vehicles'),
// //                     style: const TextStyle(fontWeight: FontWeight.bold),
// //                   ),
// //                 ],
// //               ),
// //               actions: [
// //                 if (isAdmin)
// //                   Container(
// //                     margin:
// //                         const EdgeInsets.symmetric(horizontal: 6, vertical: 8),
// //                     padding:
// //                         const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
// //                     decoration: BoxDecoration(
// //                       color: Theme.of(context).colorScheme.primaryContainer,
// //                       borderRadius: BorderRadius.circular(20),
// //                     ),
// //                     child: Row(
// //                       mainAxisSize: MainAxisSize.min,
// //                       children: [
// //                         Icon(
// //                           Icons.verified_user,
// //                           size: 16,
// //                           color:
// //                               Theme.of(context).colorScheme.onPrimaryContainer,
// //                         ),
// //                         const SizedBox(width: 4),
// //                         Text(
// //                           t('مسؤول', 'Admin'),
// //                           style: TextStyle(
// //                             fontSize: 12,
// //                             fontWeight: FontWeight.bold,
// //                             color: Theme.of(context)
// //                                 .colorScheme
// //                                 .onPrimaryContainer,
// //                           ),
// //                         ),
// //                       ],
// //                     ),
// //                   ),
// //                 IconButton(
// //                   tooltip: isAdmin
// //                       ? t('لوحة المسؤول', 'Admin Panel')
// //                       : t('دخول الإدارة', 'Admin Sign In'),
// //                   icon: Icon(
// //                     isAdmin
// //                         ? Icons.admin_panel_settings
// //                         : Icons.admin_panel_settings_outlined,
// //                     color:
// //                         isAdmin ? Theme.of(context).colorScheme.primary : null,
// //                   ),
// //                   onPressed: () => _handleAdminAction(isAdmin, currentUser),
// //                 ),
// //               ],
// //             ),
// //             body: IndexedStack(
// //               index: tab,
// //               children: [
// //                 HomeTab(isAdmin: isAdmin, t: t, db: db),
// //                 CompaniesTab(isAdmin: isAdmin, t: t, db: db),
// //                 SettingsTab(
// //                   isAdmin: isAdmin,
// //                   user: currentUser,
// //                   dark: widget.dark,
// //                   isArabic: ar,
// //                   t: t,
// //                   onTheme: widget.onTheme,
// //                   onLanguage: widget.onLanguage,
// //                   onAdminTap: () => _handleAdminAction(isAdmin, currentUser),
// //                 ),
// //               ],
// //             ),
// //             floatingActionButton: (isAdmin && tab < 2)
// //                 ? FloatingActionButton.extended(
// //                     onPressed: () => AdminDialogs.showAddEditVehicleDialog(
// //                       context: context,
// //                       db: db,
// //                       t: t,
// //                     ),
// //                     icon: const Icon(Icons.add),
// //                     label: Text(t('إضافة سيارة', 'Add Vehicle')),
// //                   )
// //                 : null,
// //             bottomNavigationBar: NavigationBar(
// //               selectedIndex: tab,
// //               onDestinationSelected: (v) => setState(() => tab = v),
// //               destinations: [
// //                 NavigationDestination(
// //                   icon: const Icon(Icons.search),
// //                   label: t('الرئيسية', 'Home'),
// //                 ),
// //                 NavigationDestination(
// //                   icon: const Icon(Icons.apartment),
// //                   label: t('الشركات', 'Companies'),
// //                 ),
// //                 NavigationDestination(
// //                   icon: const Icon(Icons.settings_outlined),
// //                   label: t('الإعدادات', 'Settings'),
// //                 ),
// //               ],
// //             ),
// //           ),
// //         );
// //       },
// //     );
// //   }

// //   Future<void> _handleAdminAction(bool isAdmin, User? user) async {
// //     if (isAdmin) {
// //       showModalBottomSheet(
// //         context: context,
// //         builder: (ctx) => SafeArea(
// //           child: Column(
// //             mainAxisSize: MainAxisSize.min,
// //             children: [
// //               ListTile(
// //                 leading: const CircleAvatar(
// //                   backgroundColor: Colors.teal,
// //                   child: Icon(Icons.admin_panel_settings, color: Colors.white),
// //                 ),
// //                 title: Text(t('لوحة تحكم المسؤول', 'Admin Control Panel')),
// //                 subtitle: Text(user?.email ?? kAdminEmail),
// //               ),
// //               const Divider(),
// //               ListTile(
// //                 leading: const Icon(Icons.cloud_upload_outlined,
// //                     color: Colors.blue),
// //                 title: Text(
// //                   t(
// //                     'مزامنة جميع الشركات والسيارات مع فايرستور',
// //                     'Sync All Companies & Vehicles to Firestore',
// //                   ),
// //                 ),
// //                 subtitle: Text(
// //                   t(
// //                     'رفع بيانات الشركات المسجلة بالكامل إلى قاعدة بيانات Firebase',
// //                     'Upload all registered companies and vehicles to Firebase',
// //                   ),
// //                 ),
// //                 onTap: () {
// //                   Navigator.pop(ctx);
// //                   AdminDialogs.syncAllCompaniesToFirestore(
// //                     context: context,
// //                     db: db,
// //                     t: t,
// //                   );
// //                 },
// //               ),
// //               ListTile(
// //                 leading:
// //                     const Icon(Icons.add_circle_outline, color: Colors.teal),
// //                 title: Text(t('إضافة سيارة جديدة', 'Add New Vehicle')),
// //                 onTap: () {
// //                   Navigator.pop(ctx);
// //                   AdminDialogs.showAddEditVehicleDialog(
// //                     context: context,
// //                     db: db,
// //                     t: t,
// //                   );
// //                 },
// //               ),
// //               ListTile(
// //                 leading: const Icon(Icons.logout, color: Colors.red),
// //                 title: Text(t('تسجيل الخروج', 'Sign Out')),
// //                 onTap: () async {
// //                   await FirebaseAuth.instance.signOut();
// //                   if (mounted) {
// //                     Navigator.pop(ctx);
// //                     ScaffoldMessenger.of(context).showSnackBar(
// //                       SnackBar(
// //                         content: Text(
// //                           t('تم تسجيل الخروج بنجاح',
// //                               'Signed out successfully'),
// //                         ),
// //                       ),
// //                     );
// //                   }
// //                 },
// //               ),
// //             ],
// //           ),
// //         ),
// //       );
// //       return;
// //     }

// //     await AdminDialogs.showSignInDialog(context: context, t: t);
// //   }
// // }




// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'package:flutter/material.dart';

// import 'firebase_options.dart';
// import 'screens/companies_tab.dart';
// import 'screens/home_tab.dart';
// import 'screens/settings_tab.dart';
// import 'widgets/admin_dialogs.dart';

// Future<void> main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
//   // Offline cache: data stays available without internet and queued
//   // changes sync automatically when the phone reconnects.
//   FirebaseFirestore.instance.settings = const Settings(
//     persistenceEnabled: true,
//     cacheSizeBytes: Settings.CACHE_SIZE_UNLIMITED,
//   );
//   runApp(const FleetApp());
// }

// class FleetApp extends StatefulWidget {
//   const FleetApp({super.key});

//   @override
//   State<FleetApp> createState() => _FleetAppState();
// }

// class _FleetAppState extends State<FleetApp> {
//   ThemeMode mode = ThemeMode.light;
//   String language = 'ar';

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       title: 'السيارات المشتركة',
//       themeMode: mode,
//       theme: ThemeData(
//         colorScheme: ColorScheme.fromSeed(
//           seedColor: const Color(0xff0d6e6e),
//           brightness: Brightness.light,
//         ),
//         useMaterial3: true,
//       ),
//       darkTheme: ThemeData(
//         colorScheme: ColorScheme.fromSeed(
//           seedColor: const Color(0xff36b3b3),
//           brightness: Brightness.dark,
//         ),
//         useMaterial3: true,
//       ),
//       home: FleetHome(
//         isArabic: language == 'ar',
//         dark: mode == ThemeMode.dark,
//         onLanguage: (v) => setState(() => language = v),
//         onTheme: (v) =>
//             setState(() => mode = v ? ThemeMode.dark : ThemeMode.light),
//       ),
//     );
//   }
// }

// class FleetHome extends StatefulWidget {
//   const FleetHome({
//     super.key,
//     required this.isArabic,
//     required this.dark,
//     required this.onLanguage,
//     required this.onTheme,
//   });

//   final bool isArabic;
//   final bool dark;
//   final ValueChanged<String> onLanguage;
//   final ValueChanged<bool> onTheme;

//   @override
//   State<FleetHome> createState() => _FleetHomeState();
// }

// class _FleetHomeState extends State<FleetHome> {
//   int tab = 0;
//   final db = FirebaseFirestore.instance;

//   bool get ar => widget.isArabic;
//   String t(String a, String e) => ar ? a : e;

//   bool _isAdminUser(User? user) {
//     if (user == null || user.email == null) return false;
//     return user.email!.trim().toLowerCase() == kAdminEmail.toLowerCase();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return StreamBuilder<User?>(
//       stream: FirebaseAuth.instance.authStateChanges(),
//       builder: (context, authSnapshot) {
//         final currentUser = authSnapshot.data;
//         final isAdmin = _isAdminUser(currentUser);

//         return Directionality(
//           textDirection: ar ? TextDirection.rtl : TextDirection.ltr,
//           child: Scaffold(
//             appBar: AppBar(
//               title: Row(
//                 children: [
//                   const Icon(Icons.directions_car_filled, size: 28),
//                   const SizedBox(width: 10),
//                   Text(
//                     t('السيارات المشتركة', 'Shared Vehicles'),
//                     style: const TextStyle(fontWeight: FontWeight.bold),
//                   ),
//                 ],
//               ),
//               actions: [
//                 if (isAdmin)
//                   Container(
//                     margin:
//                         const EdgeInsets.symmetric(horizontal: 6, vertical: 8),
//                     padding:
//                         const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
//                     decoration: BoxDecoration(
//                       color: Theme.of(context).colorScheme.primaryContainer,
//                       borderRadius: BorderRadius.circular(20),
//                     ),
//                     child: Row(
//                       mainAxisSize: MainAxisSize.min,
//                       children: [
//                         Icon(
//                           Icons.verified_user,
//                           size: 16,
//                           color:
//                               Theme.of(context).colorScheme.onPrimaryContainer,
//                         ),
//                         const SizedBox(width: 4),
//                         Text(
//                           t('مسؤول', 'Admin'),
//                           style: TextStyle(
//                             fontSize: 12,
//                             fontWeight: FontWeight.bold,
//                             color: Theme.of(context)
//                                 .colorScheme
//                                 .onPrimaryContainer,
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 IconButton(
//                   tooltip: isAdmin
//                       ? t('لوحة المسؤول', 'Admin Panel')
//                       : t('دخول الإدارة', 'Admin Sign In'),
//                   icon: Icon(
//                     isAdmin
//                         ? Icons.admin_panel_settings
//                         : Icons.admin_panel_settings_outlined,
//                     color:
//                         isAdmin ? Theme.of(context).colorScheme.primary : null,
//                   ),
//                   onPressed: () => _handleAdminAction(isAdmin, currentUser),
//                 ),
//               ],
//             ),
//             body: IndexedStack(
//               index: tab,
//               children: [
//                 HomeTab(isAdmin: isAdmin, t: t, db: db),
//                 CompaniesTab(isAdmin: isAdmin, t: t, db: db),
//                 SettingsTab(
//                   isAdmin: isAdmin,
//                   user: currentUser,
//                   dark: widget.dark,
//                   isArabic: ar,
//                   t: t,
//                   onTheme: widget.onTheme,
//                   onLanguage: widget.onLanguage,
//                   onAdminTap: () => _handleAdminAction(isAdmin, currentUser),
//                 ),
//               ],
//             ),
//             floatingActionButton: (isAdmin && tab < 2)
//                 ? FloatingActionButton.extended(
//                     onPressed: () => AdminDialogs.showAddEditVehicleDialog(
//                       context: context,
//                       db: db,
//                       t: t,
//                     ),
//                     icon: const Icon(Icons.add),
//                     label: Text(t('إضافة سيارة', 'Add Vehicle')),
//                   )
//                 : null,
//             bottomNavigationBar: NavigationBar(
//               selectedIndex: tab,
//               onDestinationSelected: (v) => setState(() => tab = v),
//               destinations: [
//                 NavigationDestination(
//                   icon: const Icon(Icons.search),
//                   label: t('الرئيسية', 'Home'),
//                 ),
//                 NavigationDestination(
//                   icon: const Icon(Icons.apartment),
//                   label: t('الشركات', 'Companies'),
//                 ),
//                 NavigationDestination(
//                   icon: const Icon(Icons.settings_outlined),
//                   label: t('الإعدادات', 'Settings'),
//                 ),
//               ],
//             ),
//           ),
//         );
//       },
//     );
//   }

//   Future<void> _handleAdminAction(bool isAdmin, User? user) async {
//     if (isAdmin) {
//       showModalBottomSheet(
//         context: context,
//         builder: (ctx) => SafeArea(
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               ListTile(
//                 leading: const CircleAvatar(
//                   backgroundColor: Colors.teal,
//                   child: Icon(Icons.admin_panel_settings, color: Colors.white),
//                 ),
//                 title: Text(t('لوحة تحكم المسؤول', 'Admin Control Panel')),
//                 subtitle: Text(user?.email ?? kAdminEmail),
//               ),
//               const Divider(),
//               ListTile(
//                 leading: const Icon(Icons.cloud_upload_outlined,
//                     color: Colors.blue),
//                 title: Text(
//                   t(
//                     'مزامنة جميع الشركات والسيارات مع فايرستور',
//                     'Sync All Companies & Vehicles to Firestore',
//                   ),
//                 ),
//                 subtitle: Text(
//                   t(
//                     'رفع بيانات الشركات المسجلة بالكامل إلى قاعدة بيانات Firebase',
//                     'Upload all registered companies and vehicles to Firebase',
//                   ),
//                 ),
//                 onTap: () {
//                   Navigator.pop(ctx);
//                   AdminDialogs.syncAllCompaniesToFirestore(
//                     context: context,
//                     db: db,
//                     t: t,
//                   );
//                 },
//               ),
//               ListTile(
//                 leading:
//                     const Icon(Icons.add_circle_outline, color: Colors.teal),
//                 title: Text(t('إضافة سيارة جديدة', 'Add New Vehicle')),
//                 onTap: () {
//                   Navigator.pop(ctx);
//                   AdminDialogs.showAddEditVehicleDialog(
//                     context: context,
//                     db: db,
//                     t: t,
//                   );
//                 },
//               ),
//               ListTile(
//                 leading: const Icon(Icons.logout, color: Colors.red),
//                 title: Text(t('تسجيل الخروج', 'Sign Out')),
//                 onTap: () async {
//                   await FirebaseAuth.instance.signOut();
//                   if (mounted) {
//                     Navigator.pop(ctx);
//                     ScaffoldMessenger.of(context).showSnackBar(
//                       SnackBar(
//                         content: Text(
//                           t('تم تسجيل الخروج بنجاح',
//                               'Signed out successfully'),
//                         ),
//                       ),
//                     );
//                   }
//                 },
//               ),
//             ],
//           ),
//         ),
//       );
//       return;
//     }

//     await AdminDialogs.showSignInDialog(context: context, t: t);
//   }
// }




import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'firebase_options.dart';
import 'screens/companies_tab.dart';
import 'screens/home_tab.dart';
import 'screens/settings_tab.dart';
import 'widgets/admin_dialogs.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  // Offline cache: data stays available without internet and queued
  // changes sync automatically when the phone reconnects.
  FirebaseFirestore.instance.settings = const Settings(
    persistenceEnabled: true,
    cacheSizeBytes: Settings.CACHE_SIZE_UNLIMITED,
  );
  runApp(const FleetApp());
}

class FleetApp extends StatefulWidget {
  const FleetApp({super.key});

  @override
  State<FleetApp> createState() => _FleetAppState();
}

class _FleetAppState extends State<FleetApp> {
  ThemeMode mode = ThemeMode.light;
  String language = 'ar';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'السيارات المشتركة',
      themeMode: mode,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xff0d6e6e),
          brightness: Brightness.light,
        ),
        useMaterial3: true,
      ),
      darkTheme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xff36b3b3),
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
      ),
      home: FleetHome(
        isArabic: language == 'ar',
        dark: mode == ThemeMode.dark,
        onLanguage: (v) => setState(() => language = v),
        onTheme: (v) =>
            setState(() => mode = v ? ThemeMode.dark : ThemeMode.light),
      ),
    );
  }
}

class FleetHome extends StatefulWidget {
  const FleetHome({
    super.key,
    required this.isArabic,
    required this.dark,
    required this.onLanguage,
    required this.onTheme,
  });

  final bool isArabic;
  final bool dark;
  final ValueChanged<String> onLanguage;
  final ValueChanged<bool> onTheme;

  @override
  State<FleetHome> createState() => _FleetHomeState();
}

class _FleetHomeState extends State<FleetHome> {
  int tab = 0;
  final db = FirebaseFirestore.instance;

  bool get ar => widget.isArabic;
  String t(String a, String e) => ar ? a : e;

  bool _isAdminUser(User? user) {
    if (user == null || user.email == null) return false;
    return user.email!.trim().toLowerCase() == kAdminEmail.toLowerCase();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, authSnapshot) {
        final currentUser = authSnapshot.data;
        final isAdmin = _isAdminUser(currentUser);

        return Directionality(
          textDirection: ar ? TextDirection.rtl : TextDirection.ltr,
          child: Scaffold(
            appBar: AppBar(
              title: Row(
                children: [
                  const Icon(Icons.directions_car_filled, size: 28),
                  const SizedBox(width: 10),
                  Text(
                    t('السيارات المشتركة', 'Shared Vehicles'),
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              actions: [
                if (isAdmin)
                  Container(
                    margin:
                        const EdgeInsets.symmetric(horizontal: 6, vertical: 8),
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primaryContainer,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.verified_user,
                          size: 16,
                          color:
                              Theme.of(context).colorScheme.onPrimaryContainer,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          t('مسؤول', 'Admin'),
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context)
                                .colorScheme
                                .onPrimaryContainer,
                          ),
                        ),
                      ],
                    ),
                  ),
                IconButton(
                  tooltip: isAdmin
                      ? t('لوحة المسؤول', 'Admin Panel')
                      : t('دخول الإدارة', 'Admin Sign In'),
                  icon: Icon(
                    isAdmin
                        ? Icons.admin_panel_settings
                        : Icons.admin_panel_settings_outlined,
                    color:
                        isAdmin ? Theme.of(context).colorScheme.primary : null,
                  ),
                  onPressed: () => _handleAdminAction(isAdmin, currentUser),
                ),
              ],
            ),
            body: IndexedStack(
              index: tab,
              children: [
                HomeTab(isAdmin: isAdmin, t: t, db: db),
                CompaniesTab(isAdmin: isAdmin, t: t, db: db),
                SettingsTab(
                  isAdmin: isAdmin,
                  user: currentUser,
                  dark: widget.dark,
                  isArabic: ar,
                  t: t,
                  onTheme: widget.onTheme,
                  onLanguage: widget.onLanguage,
                  onAdminTap: () => _handleAdminAction(isAdmin, currentUser),
                ),
              ],
            ),
            floatingActionButton: (isAdmin && tab < 2)
                ? FloatingActionButton.extended(
                    onPressed: () => AdminDialogs.showAddEditVehicleDialog(
                      context: context,
                      db: db,
                      t: t,
                    ),
                    icon: const Icon(Icons.add),
                    label: Text(t('إضافة سيارة', 'Add Vehicle')),
                  )
                : null,
            bottomNavigationBar: NavigationBar(
              selectedIndex: tab,
              onDestinationSelected: (v) => setState(() => tab = v),
              destinations: [
                NavigationDestination(
                  icon: const Icon(Icons.search),
                  label: t('الرئيسية', 'Home'),
                ),
                NavigationDestination(
                  icon: const Icon(Icons.apartment),
                  label: t('الشركات', 'Companies'),
                ),
                NavigationDestination(
                  icon: const Icon(Icons.settings_outlined),
                  label: t('الإعدادات', 'Settings'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _handleAdminAction(bool isAdmin, User? user) async {
    if (isAdmin) {
      showModalBottomSheet(
        context: context,
        builder: (ctx) => SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const CircleAvatar(
                  backgroundColor: Colors.teal,
                  child: Icon(Icons.admin_panel_settings, color: Colors.white),
                ),
                title: Text(t('لوحة تحكم المسؤول', 'Admin Control Panel')),
                subtitle: Text(user?.email ?? kAdminEmail),
              ),
              const Divider(),
              ListTile(
                leading: const Icon(Icons.cloud_upload_outlined,
                    color: Colors.blue),
                title: Text(
                  t(
                    'مزامنة جميع الشركات والسيارات مع فايرستور',
                    'Sync All Companies & Vehicles to Firestore',
                  ),
                ),
                subtitle: Text(
                  t(
                    'رفع بيانات الشركات المسجلة بالكامل إلى قاعدة بيانات Firebase',
                    'Upload all registered companies and vehicles to Firebase',
                  ),
                ),
                onTap: () {
                  Navigator.pop(ctx);
                  AdminDialogs.syncAllCompaniesToFirestore(
                    context: context,
                    db: db,
                    t: t,
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.restart_alt, color: Colors.orange),
                title: Text(
                  t(
                    'إعادة رفع كل البيانات (حذف وإعادة بناء)',
                    'Re-upload All Data (Reset & Rebuild)',
                  ),
                ),
                subtitle: Text(
                  t(
                    'يمسح السيارات القديمة ويرفع الـ 20 شركة من جديد ويصحح الأعداد',
                    'Wipes old vehicles, re-uploads all 20 companies, fixes counts',
                  ),
                ),
                onTap: () {
                  Navigator.pop(ctx);
                  AdminDialogs.resetAndReuploadAll(
                    context: context,
                    db: db,
                    t: t,
                  );
                },
              ),
              ListTile(
                leading:
                    const Icon(Icons.add_circle_outline, color: Colors.teal),
                title: Text(t('إضافة سيارة جديدة', 'Add New Vehicle')),
                onTap: () {
                  Navigator.pop(ctx);
                  AdminDialogs.showAddEditVehicleDialog(
                    context: context,
                    db: db,
                    t: t,
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.logout, color: Colors.red),
                title: Text(t('تسجيل الخروج', 'Sign Out')),
                onTap: () async {
                  await FirebaseAuth.instance.signOut();
                  if (mounted) {
                    Navigator.pop(ctx);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          t('تم تسجيل الخروج بنجاح',
                              'Signed out successfully'),
                        ),
                      ),
                    );
                  }
                },
              ),
            ],
          ),
        ),
      );
      return;
    }

    await AdminDialogs.showSignInDialog(context: context, t: t);
  }
}