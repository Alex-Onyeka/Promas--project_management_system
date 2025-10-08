import 'package:flutter/material.dart';
import 'package:promas/pages/base_page.dart';
import 'package:promas/providers/branch_provider.dart';
import 'package:promas/providers/company_provider.dart';
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
    url: 'https://kutrcxsojatauupkgypp.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Imt1dHJjeHNvamF0YXV1cGtneXBwIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTk0MTU4NDAsImV4cCI6MjA3NDk5MTg0MH0.Zb2do9wWLfwf7kU5buavd4H7f_3FR9rqYy7hJRQvU9g',
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
      routes: {'/': (context) => BasePage()},
    );
  }
}
