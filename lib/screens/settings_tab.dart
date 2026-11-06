import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../widgets/admin_dialogs.dart';

class SettingsTab extends StatelessWidget {
  final bool isAdmin;
  final User? user;
  final bool dark;
  final bool isArabic;
  final String Function(String ar, String en) t;
  final ValueChanged<bool> onTheme;
  final ValueChanged<String> onLanguage;
  final VoidCallback onAdminTap;

  const SettingsTab({
    super.key,
    required this.isAdmin,
    required this.user,
    required this.dark,
    required this.isArabic,
    required this.t,
    required this.onTheme,
    required this.onLanguage,
    required this.onAdminTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundColor: isAdmin ? Colors.teal : Colors.grey,
                  child: Icon(
                    isAdmin ? Icons.admin_panel_settings : Icons.person_outline,
                    size: 32,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        isAdmin
                            ? t('مسؤول النظام', 'System Administrator')
                            : t('وضع الزائر (للقراءة فقط)',
                                'Guest Mode (Read-Only)'),
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        isAdmin
                            ? (user?.email ?? kAdminEmail)
                            : t(
                                'قم بتسجيل الدخول كمسؤول للإضافة والتعديل والحذف',
                                'Sign in as admin to add, edit, or delete',
                              ),
                        style: TextStyle(
                          fontSize: 13,
                          color: Theme.of(context).textTheme.bodySmall?.color,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 12),
        Card(
          child: Column(
            children: [
              SwitchListTile(
                secondary: Icon(
                  dark ? Icons.dark_mode : Icons.light_mode,
                ),
                title: Text(t('الوضع الداكن', 'Dark Mode')),
                subtitle: Text(
                  dark
                      ? t('الوضع الليلي مفعل', 'Dark theme enabled')
                      : t('الوضع الفاتح مفعل', 'Light theme enabled'),
                ),
                value: dark,
                onChanged: onTheme,
              ),
              const Divider(height: 1),
              ListTile(
                leading: const Icon(Icons.language),
                title: Text(t('لغة التطبيق', 'App Language')),
                subtitle: Text(
                  isArabic
                      ? 'اللغة الحالية: العربية'
                      : 'Current Language: English',
                ),
                trailing: DropdownButton<String>(
                  value: isArabic ? 'ar' : 'en',
                  underline: const SizedBox(),
                  items: const [
                    DropdownMenuItem(value: 'ar', child: Text('العربية')),
                    DropdownMenuItem(value: 'en', child: Text('English')),
                  ],
                  onChanged: (v) {
                    if (v != null) onLanguage(v);
                  },
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        Card(
          child: Column(
            children: [
              ListTile(
                leading: const Icon(Icons.info_outline),
                title: Text(t('عن التطبيق', 'About the Application')),
                subtitle: Text(
                  t(
                    'دليل السيارات المشتركة للبحث الفوري عن أرقام وحروف سيارات الشركات وإدارتها.',
                    'Shared Vehicles Directory for instant lookup and company fleet management.',
                  ),
                ),
              ),
              const Divider(height: 1),
              ListTile(
                leading: const Icon(Icons.verified),
                title: Text(t('الإصدار', 'Version')),
                trailing: const Text(
                  '1.0.0',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        Card(
          child: ListTile(
            leading: Icon(
              isAdmin ? Icons.logout : Icons.login,
              color: isAdmin ? Colors.red : Colors.teal,
            ),
            title: Text(
              isAdmin
                  ? t('تسجيل خروج الإدارة', 'Sign Out')
                  : t('تسجيل دخول الإدارة', 'Admin Sign In'),
            ),
            subtitle: Text(
              isAdmin
                  ? t('إنهاء جلسة الإدارة الحالية',
                      'End current admin session')
                  : t('الدخول بحساب المسؤول المعتمد',
                      'Log in with authorized admin email'),
            ),
            onTap: onAdminTap,
          ),
        ),
      ],
    );
  }
}
