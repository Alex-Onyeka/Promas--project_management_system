import 'package:flutter/material.dart';
import 'package:promas/pages/base_page.dart';
import 'package:promas/pages/landing_page/landing_page.dart';
import 'package:promas/providers/branch_provider.dart';
import 'package:promas/providers/company_provider.dart';
import 'package:promas/providers/nav_provider.dart';
import 'package:promas/providers/project_provider.dart';
import 'package:promas/providers/requests_provider.dart';
import 'package:promas/providers/theme_provider.dart';
import 'package:promas/providers/user_provider.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // initialize supabase before runApp
  await Supabase.initialize(
    url: 'https://iudrocbtlupuxehuhcfi.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Iml1ZHJvY2J0bHVwdXhlaHVoY2ZpIiwicm9sZSI6ImFub24iLCJpYXQiOjE3Nzg0Mzk3MjQsImV4cCI6MjA5NDAxNTcyNH0.2KH4fye59YQrFljSZh8tpnpVW-rbQ-Ivcgi7USOJMmk',
  );
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<UserProvider>.value(
          value: UserProvider(),
        ),
        ChangeNotifierProvider<CompanyProvider>.value(
          value: CompanyProvider(),
        ),
        ChangeNotifierProvider<ThemeProvider>.value(
          value: ThemeProvider(),
        ),
        ChangeNotifierProvider<RequestsProvider>.value(
          value: RequestsProvider(),
        ),
        ChangeNotifierProvider<ProjectProvider>.value(
          value: ProjectProvider(),
        ),
        ChangeNotifierProvider<BranchProvider>.value(
          value: BranchProvider(),
        ),
        ChangeNotifierProvider<NavProvider>.value(
          value: NavProvider(),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

ThemeProvider returnTheme(
  BuildContext context, {
  bool listen = true,
}) {
  return Provider.of<ThemeProvider>(
    context,
    listen: listen,
  );
}

NavProvider returnNav(
  BuildContext context, {
  bool listen = true,
}) {
  return Provider.of<NavProvider>(context, listen: listen);
}

RequestsProvider returnRequest(
  BuildContext context, {
  bool listen = true,
}) {
  return Provider.of<RequestsProvider>(
    context,
    listen: listen,
  );
}

UserProvider returnUser(
  BuildContext context, {
  bool listen = true,
}) {
  return Provider.of<UserProvider>(context, listen: listen);
}

CompanyProvider returnCompany(
  BuildContext context, {
  bool listen = true,
}) {
  return Provider.of<CompanyProvider>(
    context,
    listen: listen,
  );
}

ProjectProvider returnProject(
  BuildContext context, {
  bool listen = true,
}) {
  return Provider.of<ProjectProvider>(
    context,
    listen: listen,
  );
}

BranchProvider returnBranch(
  BuildContext context, {
  bool listen = true,
}) {
  return Provider.of<BranchProvider>(
    context,
    listen: listen,
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Project Management System',
      theme: ThemeData(
        scaffoldBackgroundColor: returnTheme(
          context,
        ).containerColor(),
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue,
        ),
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => BasePage(),
        '/delete-account': (context) =>
            LandingPage(pageIndex: 4),
        '/privacy-policy': (context) =>
            LandingPage(pageIndex: 5),
      },
    );
  }
}
