import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:promas/pages/base_page.dart';
import 'package:promas/pages/landing_page/landing_page.dart';
import 'package:promas/providers/branch_provider.dart';
import 'package:promas/providers/chats_provider.dart';
import 'package:promas/providers/commit_provider.dart';
import 'package:promas/providers/company_provider.dart';
import 'package:promas/providers/nav_provider.dart';
import 'package:promas/providers/project_provider.dart';
import 'package:promas/providers/requests_provider.dart';
import 'package:promas/providers/theme_provider.dart';
import 'package:promas/providers/user_provider.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

// promas_super_secret_webhook_key_2026
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
        ChangeNotifierProvider<CommitProvider>.value(
          value: CommitProvider(),
        ),
        ChangeNotifierProvider<ChatsProvider>.value(
          value: ChatsProvider(),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

ThemeProvider returnTheme({BuildContext? context}) {
  if (context == null) {
    return ThemeProvider();
  } else {
    return Provider.of<ThemeProvider>(context);
  }
}

ChatsProvider returnChats({BuildContext? context}) {
  if (context == null) {
    return ChatsProvider();
  } else {
    return Provider.of<ChatsProvider>(context);
  }
}

NavProvider returnNav({BuildContext? context}) {
  if (context == null) {
    return NavProvider();
  } else {
    return Provider.of<NavProvider>(context);
  }
}

RequestsProvider returnRequest({BuildContext? context}) {
  if (context == null) {
    return RequestsProvider();
  } else {
    return Provider.of<RequestsProvider>(context);
  }
}

UserProvider returnUser({BuildContext? context}) {
  if (context == null) {
    return UserProvider();
  } else {
    return Provider.of<UserProvider>(context);
  }
}

CompanyProvider returnCompany({BuildContext? context}) {
  if (context == null) {
    return CompanyProvider();
  } else {
    return Provider.of<CompanyProvider>(context);
  }
}

ProjectProvider returnProject({BuildContext? context}) {
  if (context == null) {
    return ProjectProvider();
  } else {
    return Provider.of<ProjectProvider>(context);
  }
}

BranchProvider returnBranch({BuildContext? context}) {
  if (context == null) {
    return BranchProvider();
  } else {
    return Provider.of<BranchProvider>(context);
  }
}

CommitProvider returnCommit({BuildContext? context}) {
  if (context != null) {
    return Provider.of<CommitProvider>(context);
  } else {
    return CommitProvider();
  }
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
          context: context,
        ).containerColor(),
        useMaterial3: true,
        fontFamily: GoogleFonts.poppins().fontFamily,
        textTheme: GoogleFonts.poppinsTextTheme(),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color.fromARGB(255, 98, 42, 255),
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
