import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:promas/classes/commit.dart';
import 'package:promas/classes/company_class.dart';
import 'package:promas/classes/project_class.dart';
import 'package:promas/components/alert_dialogues/add_project_dialog.dart';
import 'package:promas/components/buttons/main_button.dart';
import 'package:promas/constants/formats.dart';
import 'package:promas/constants/general_constants.dart';
import 'package:promas/main.dart';
import 'package:promas/providers/branch_provider.dart';
import 'package:promas/providers/chats_provider.dart';
import 'package:promas/providers/company_provider.dart';
import 'package:promas/providers/project_provider.dart';
import 'package:promas/providers/requests_provider.dart';
import 'package:promas/providers/theme_provider.dart';
import 'package:promas/providers/user_provider.dart';

class Dashboard extends StatefulWidget {
  final TextEditingController projectSearchController;
  const Dashboard({
    super.key,
    required this.projectSearchController,
  });

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  Future<CompanyClass?> getCompany() async {
    return await CompanyProvider().getMyCompany();
  }

  Future<void> getAllProjects() async {
    await ProjectProvider().getAllProjectsByCompany();
  }

  Future<void> getAllBranches() async {
    await BranchProvider().getBranchesByCompany();
  }

  Future<void> getAllRequests() async {
    await RequestsProvider().getRequestsByCompany();
  }

  Future<void> getAllUsers() async {
    await UserProvider().getAllCompanyUsers();
  }

  Future<void> initFuncs() async {
    // returnProject().toggleLoading(true);
    await getCompany();
    await getAllProjects();
    await getAllUsers();
    await getAllBranches();
    await getAllRequests();
    await ChatsProvider().getChatsByCompany();
    // returnProject().toggleLoading(false);
  }

  ProjectClass? selectedProject;

  void selectProject(ProjectClass? project) {
    setState(() {
      selectedProject = project;
    });
  }

  final buttonKey = GlobalKey();

  void showMenuAction() async {
    final RenderBox button =
        buttonKey.currentContext!.findRenderObject()
            as RenderBox;

    final Offset position = button.localToGlobal(
      Offset.zero,
    );

    final Size size = button.size;

    final screenSize = MediaQuery.of(context).size;

    await showMenu(
      context: context,
      color: Colors.white,
      constraints: BoxConstraints(
        maxWidth: 500,
        minWidth: 200,
      ),
      position: RelativeRect.fromLTRB(
        position.dx,
        position.dy + size.height + 10,
        screenSize.width - position.dx - size.width,
        screenSize.height - position.dy,
      ),
      items: returnProject().projectsMain
          .where((pro) => pro.githubUrl != null)
          .map((project) {
            return PopupMenuItem(
              onTap: () {
                selectProject(project);
              },
              // value: 'edit',
              child: Text(
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
                project.name,
              ),
            );
          })
          .toList(),
    );
  }

  List<Commit> data() {
    final commitsList = returnCommit(
      context: context,
    ).commits;

    if (commitsList.isEmpty) {
      return [
        Commit(
          sha: 'sha',
          repo: 'repo',
          message: 'message',
          authorName: 'authorName',
          authorEmail: 'authorEmail',
          date: DateTime.now(),
          additions: 0,
          deletions: 0,
          total: 0,
          files: [],
        ),
      ];
    }

    // Filter by selected project if needed
    final filtered = selectedProject == null
        ? commitsList
        : commitsList.where(
            (commit) =>
                commit.repo ==
                returnProject().projectGithubName(
                  projectUrl:
                      selectedProject?.githubUrl ?? '',
                ),
          );

    final today = normalize(DateTime.now());
    final sevenDaysAgo = today.subtract(
      const Duration(days: 6),
    );

    // Only keep commits between today and 7 days ago
    final recent = filtered.where((item) {
      final d = normalize(item.date);
      return d.isAfter(
            sevenDaysAgo.subtract(const Duration(days: 1)),
          ) &&
          d.isBefore(today.add(const Duration(days: 1)));
    }).toList();

    return recent.isEmpty
        ? [
            Commit(
              sha: 'sha',
              repo: 'repo',
              message: 'message',
              authorName: 'authorName',
              authorEmail: 'authorEmail',
              date: DateTime.now(),
              additions: 0,
              deletions: 0,
              total: 0,
              files: [],
            ),
          ]
        : recent;
  }

  DateTime normalize(DateTime d) {
    return DateTime(d.year, d.month, d.day);
  }

  Map<DateTime, double> groupByDay(List<Commit> data) {
    final Map<DateTime, double> grouped = {};

    for (final item in data) {
      final day = normalize(item.date);
      grouped[day] = (grouped[day] ?? 0) + item.total;
    }

    return grouped;
  }

  List<DateTime> getLast7Days() {
    final today = normalize(DateTime.now());
    return List.generate(
      7,
      (i) => today.subtract(Duration(days: i)),
    ).reversed.toList();
  }

  List<FlSpot> groupedDataAction(List<Commit> data) {
    final grouped = groupByDay(data);
    final last7Days = getLast7Days();

    return List.generate(7, (index) {
      final day = last7Days[index];
      return FlSpot(index.toDouble(), grouped[day] ?? 0);
    });
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await initFuncs();
      if (mounted) {
        setState(() {});
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    var theme = returnTheme(context: context);
    return Scaffold(
      body: Builder(
        builder: (context) {
          return RefreshIndicator(
            onRefresh: () async {
              await initFuncs();
            },
            backgroundColor: Colors.white,
            color: theme.tertiaryLight(),
            displacement: 10,
            child: SingleChildScrollView(
              child: Column(
                spacing: 2,
                children: [
                  SizedBox(height: 10),
                  Column(
                    children: [
                      SizedBox(
                        height:
                            returnUser()
                                    .currentUser
                                    ?.isAdmin ==
                                true
                            ? 200
                            : 120,
                        child: Row(
                          mainAxisAlignment:
                              MainAxisAlignment
                                  .spaceBetween,
                          crossAxisAlignment:
                              CrossAxisAlignment.start,
                          spacing: 15,
                          children: [
                            Expanded(
                              flex: 10,
                              child: Column(
                                spacing: 15,
                                children: [
                                  Expanded(
                                    child: Row(
                                      spacing: 15,
                                      children: [
                                        DashboardContainerTilesWidget(
                                          icon: Icon(
                                            size:
                                                screenSize(
                                                      context,
                                                    ) >
                                                    tabletScreen
                                                ? 30
                                                : 22,
                                            color: theme
                                                .secondaryLight(),
                                            Icons.add_chart,
                                          ),
                                          title:
                                              'Total Projects',
                                          value:
                                              returnProject(
                                                    context:
                                                        context,
                                                  )
                                                  .projectsMain
                                                  .length
                                                  .toString(),
                                          action: () {
                                            returnNav()
                                                .navigate(
                                                  1,
                                                );
                                          },
                                        ),
                                        DashboardContainerTilesWidget(
                                          icon: Icon(
                                            size:
                                                screenSize(
                                                      context,
                                                    ) >
                                                    tabletScreen
                                                ? 30
                                                : 22,
                                            color: theme
                                                .tertiaryColor(),
                                            Icons
                                                .account_tree_outlined,
                                          ),
                                          title:
                                              'Total Branches',
                                          value:
                                              returnBranch(
                                                    context:
                                                        context,
                                                  )
                                                  .branches
                                                  .length
                                                  .toString(),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Visibility(
                                    visible:
                                        returnUser()
                                            .currentUser
                                            ?.isAdmin ==
                                        true,
                                    child: Expanded(
                                      child: Row(
                                        spacing: 15,
                                        children: [
                                          DashboardContainerTilesWidget(
                                            icon: Icon(
                                              size:
                                                  screenSize(
                                                        context,
                                                      ) >
                                                      tabletScreen
                                                  ? 35
                                                  : 25,
                                              color: theme
                                                  .primaryLight(),
                                              Icons
                                                  .people_outline_outlined,
                                            ),
                                            title:
                                                'Total Staffs',
                                            value:
                                                returnUser(
                                                      context:
                                                          context,
                                                    ).users
                                                    .where(
                                                      (
                                                        user,
                                                      ) =>
                                                          user.id !=
                                                          returnUser().currentUser?.id,
                                                    )
                                                    .length
                                                    .toString(),
                                            action: () {
                                              returnNav()
                                                  .navigate(
                                                    2,
                                                  );
                                            },
                                          ),
                                          DashboardContainerTilesWidget(
                                            icon: Icon(
                                              size:
                                                  screenSize(
                                                        context,
                                                      ) >
                                                      tabletScreen
                                                  ? 28
                                                  : 18,
                                              color: theme
                                                  .secondaryLight(),
                                              Icons.message,
                                            ),
                                            title:
                                                'Total Requests',
                                            value:
                                                returnRequest(
                                                      context:
                                                          context,
                                                    )
                                                    .unAcceptedRequests()
                                                    .length
                                                    .toString(),
                                            action: () {
                                              returnNav()
                                                  .navigate(
                                                    3,
                                                  );
                                            },
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Visibility(
                              visible:
                                  screenSize(context) >
                                      tabletScreen &&
                                  returnUser()
                                          .currentUser
                                          ?.isAdmin ==
                                      true,
                              child: Expanded(
                                flex: 8,
                                child:
                                    CreateProjectWidgetDashboard(
                                      theme: theme,
                                    ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Visibility(
                        visible:
                            screenSize(context) <=
                                tabletScreen &&
                            returnUser()
                                    .currentUser
                                    ?.isAdmin ==
                                true,
                        child: Column(
                          children: [
                            SizedBox(height: 15),
                            SizedBox(
                              height: 180,
                              child:
                                  CreateProjectWidgetDashboard(
                                    theme: theme,
                                  ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 15),
                  Container(
                    padding: EdgeInsets.all(15),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(
                        10,
                      ),
                      color: theme.white(),
                    ),
                    child: Column(
                      children: [
                        Padding(
                          padding:
                              const EdgeInsets.fromLTRB(
                                5.0,
                                10,
                                5,
                                20,
                              ),
                          child: Row(
                            mainAxisAlignment:
                                MainAxisAlignment
                                    .spaceBetween,
                            children: [
                              Row(
                                spacing:
                                    returnProject(
                                      context: context,
                                    ).isLoading
                                    ? 8
                                    : 4,
                                children: [
                                  Text(
                                    style: TextStyle(
                                      fontSize:
                                          screenSize(
                                                context,
                                              ) >
                                              tabletScreen
                                          ? 14
                                          : 12,
                                      fontWeight:
                                          FontWeight.bold,
                                      color: theme
                                          .darkMediumGrey(),
                                    ),
                                    'Work Done Chart',
                                  ),
                                  Builder(
                                    builder: (context) {
                                      if (returnProject(
                                        context: context,
                                      ).isLoading) {
                                        return SizedBox(
                                          height:
                                              screenSize(
                                                    context,
                                                  ) >
                                                  tabletScreen
                                              ? 13
                                              : 11,
                                          width:
                                              screenSize(
                                                    context,
                                                  ) >
                                                  tabletScreen
                                              ? 13
                                              : 11,
                                          child: CircularProgressIndicator(
                                            strokeWidth: 2,
                                            color: theme
                                                .primaryColor(),
                                          ),
                                        );
                                      } else {
                                        return Material(
                                          color: Colors
                                              .transparent,
                                          child: InkWell(
                                            onTap: () async {
                                              await returnProject()
                                                  .getAllProjectsByCompany();
                                            },
                                            borderRadius:
                                                BorderRadius.circular(
                                                  5,
                                                ),
                                            child: Padding(
                                              padding:
                                                  EdgeInsetsGeometry.all(
                                                    5,
                                                  ),
                                              child: Icon(
                                                size:
                                                    screenSize(
                                                          context,
                                                        ) >
                                                        tabletScreen
                                                    ? 18
                                                    : 15,
                                                color: theme
                                                    .lightMediumGrey(),
                                                Icons
                                                    .refresh,
                                              ),
                                            ),
                                          ),
                                        );
                                      }
                                    },
                                  ),
                                ],
                              ),
                              Row(
                                spacing: 5,
                                children: [
                                  Material(
                                    key: buttonKey,
                                    color:
                                        Colors.transparent,
                                    child: Ink(
                                      decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(
                                              5,
                                            ),
                                        border: Border.all(
                                          color: Colors
                                              .grey
                                              .shade300,
                                        ),
                                        color: Colors
                                            .grey
                                            .shade100,
                                      ),
                                      child: InkWell(
                                        onTap: () async {
                                          showMenuAction();
                                        },
                                        borderRadius:
                                            BorderRadius.circular(
                                              5,
                                            ),
                                        child: Container(
                                          padding: EdgeInsets.symmetric(
                                            vertical:
                                                screenSize(
                                                      context,
                                                    ) >
                                                    tabletScreen
                                                ? 5
                                                : 3,
                                            horizontal:
                                                screenSize(
                                                      context,
                                                    ) >
                                                    tabletScreen
                                                ? 10
                                                : 6,
                                          ),

                                          child: Row(
                                            spacing: 5,
                                            children: [
                                              Text(
                                                style: TextStyle(
                                                  fontSize:
                                                      screenSize(
                                                            context,
                                                          ) >
                                                          tabletScreen
                                                      ? 11
                                                      : 9,
                                                ),
                                                cutLongText(
                                                  16,
                                                  selectedProject
                                                          ?.name ??
                                                      'Select Project',
                                                ),
                                              ),
                                              Icon(
                                                size:
                                                    screenSize(
                                                          context,
                                                        ) >
                                                        tabletScreen
                                                    ? 20
                                                    : 18,
                                                Icons
                                                    .keyboard_arrow_down_rounded,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Visibility(
                                    visible:
                                        selectedProject !=
                                        null,
                                    child: Material(
                                      borderRadius:
                                          BorderRadius.circular(
                                            10,
                                          ),
                                      color: Colors
                                          .transparent,
                                      child: InkWell(
                                        onTap: () {
                                          selectProject(
                                            null,
                                          );
                                        },
                                        child: Padding(
                                          padding:
                                              const EdgeInsets.symmetric(
                                                vertical:
                                                    8.0,
                                                horizontal:
                                                    5,
                                              ),
                                          child: Icon(
                                            color: theme
                                                .lightMediumGrey(),
                                            size: 18,
                                            Icons.clear,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        Builder(
                          builder: (context) {
                            if (screenSize(context) >
                                tabletScreen) {
                              return Container(
                                height: 350,
                                padding:
                                    EdgeInsets.fromLTRB(
                                      15,
                                      5,
                                      40,
                                      5,
                                    ),
                                child: LineChart(
                                  LineChartData(
                                    borderData: FlBorderData(
                                      border: Border.all(
                                        color: theme
                                            .lightMediumGrey(),
                                      ),
                                    ),
                                    titlesData: FlTitlesData(
                                      topTitles: AxisTitles(
                                        sideTitles:
                                            SideTitles(
                                              showTitles:
                                                  false,
                                            ),
                                      ),
                                      rightTitles:
                                          AxisTitles(
                                            sideTitles:
                                                SideTitles(
                                                  showTitles:
                                                      false,
                                                ),
                                          ),
                                      leftTitles: AxisTitles(
                                        sideTitles: SideTitles(
                                          reservedSize: 50,
                                          showTitles: true,
                                          getTitlesWidget: (value, meta) {
                                            return Text(
                                              formatLargeNumber(
                                                value
                                                    .toString(),
                                              ),
                                              style: TextStyle(
                                                fontSize:
                                                    11,
                                                fontWeight:
                                                    FontWeight
                                                        .bold,
                                                color: theme
                                                    .lightMediumGrey(),
                                              ),
                                            );
                                          },
                                        ),
                                      ),
                                      bottomTitles: AxisTitles(
                                        sideTitles: SideTitles(
                                          showTitles: true,
                                          reservedSize: 60,
                                          interval: 1,
                                          getTitlesWidget: (value, meta) {
                                            final days =
                                                getLast7Days(
                                                  // data(),
                                                );

                                            if (value < 0 ||
                                                value > 6) {
                                              return const SizedBox();
                                            }
                                            final daysName =
                                                [
                                                  "Mon",
                                                  "Tue",
                                                  "Wed",
                                                  "Thu",
                                                  "Fri",
                                                  "Sat",
                                                  "Sun",
                                                ];
                                            final months = [
                                              "Jan",
                                              "Feb",
                                              "Mar",
                                              "Apr",
                                              "May",
                                              "June",
                                              "July",
                                              "Aug",
                                              "Sept",
                                              "Oct",
                                              "Nov",
                                              "Dec",
                                            ];

                                            final date =
                                                days[value
                                                    .toInt()];

                                            return Padding(
                                              padding:
                                                  const EdgeInsets.fromLTRB(
                                                    0,
                                                    10,
                                                    0,
                                                    0,
                                                  ),
                                              child: Column(
                                                mainAxisSize:
                                                    MainAxisSize
                                                        .min,
                                                children: [
                                                  Text(
                                                    style: TextStyle(
                                                      fontSize:
                                                          11,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color:
                                                          theme.lightMediumGrey(),
                                                    ),
                                                    "${daysName[date.weekday - 1]} - ${date.day}",
                                                  ),
                                                  Text(
                                                    style: TextStyle(
                                                      fontSize:
                                                          11,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color:
                                                          theme.lightMediumGrey(),
                                                    ),
                                                    "(${months[date.month - 1]} - ${date.year})",
                                                  ),
                                                ],
                                              ),
                                            );
                                          },
                                        ),
                                      ),
                                    ),
                                    lineBarsData: [
                                      LineChartBarData(
                                        spots:
                                            groupedDataAction(
                                              data(),
                                            ),
                                        isCurved: false,
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            } else {
                              return SingleChildScrollView(
                                scrollDirection:
                                    Axis.horizontal,
                                child: Row(
                                  children: [
                                    Container(
                                      height: 350,
                                      width: 800,
                                      padding:
                                          EdgeInsets.fromLTRB(
                                            15,
                                            5,
                                            40,
                                            5,
                                          ),
                                      child: LineChart(
                                        LineChartData(
                                          borderData: FlBorderData(
                                            border: Border.all(
                                              color: theme
                                                  .lightMediumGrey(),
                                            ),
                                          ),
                                          titlesData: FlTitlesData(
                                            topTitles: AxisTitles(
                                              sideTitles:
                                                  SideTitles(
                                                    showTitles:
                                                        false,
                                                  ),
                                            ),
                                            rightTitles: AxisTitles(
                                              sideTitles:
                                                  SideTitles(
                                                    showTitles:
                                                        false,
                                                  ),
                                            ),
                                            leftTitles: AxisTitles(
                                              sideTitles: SideTitles(
                                                reservedSize:
                                                    50,
                                                showTitles:
                                                    true,
                                                getTitlesWidget: (value, meta) {
                                                  return Text(
                                                    formatLargeNumber(
                                                      value
                                                          .toString(),
                                                    ),
                                                    style: TextStyle(
                                                      fontSize:
                                                          11,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color:
                                                          theme.lightMediumGrey(),
                                                    ),
                                                  );
                                                },
                                              ),
                                            ),
                                            bottomTitles: AxisTitles(
                                              sideTitles: SideTitles(
                                                showTitles:
                                                    true,
                                                reservedSize:
                                                    60,
                                                interval: 1,
                                                getTitlesWidget: (value, meta) {
                                                  final days =
                                                      getLast7Days(
                                                        // data(),
                                                      );

                                                  if (value <
                                                          0 ||
                                                      value >
                                                          6) {
                                                    return const SizedBox();
                                                  }
                                                  final daysName = [
                                                    "Mon",
                                                    "Tue",
                                                    "Wed",
                                                    "Thu",
                                                    "Fri",
                                                    "Sat",
                                                    "Sun",
                                                  ];
                                                  final months = [
                                                    "Jan",
                                                    "Feb",
                                                    "Mar",
                                                    "Apr",
                                                    "May",
                                                    "June",
                                                    "July",
                                                    "Aug",
                                                    "Sept",
                                                    "Oct",
                                                    "Nov",
                                                    "Dec",
                                                  ];

                                                  final date =
                                                      days[value
                                                          .toInt()];

                                                  return Padding(
                                                    padding:
                                                        const EdgeInsets.fromLTRB(
                                                          0,
                                                          10,
                                                          0,
                                                          0,
                                                        ),
                                                    child: Column(
                                                      mainAxisSize:
                                                          MainAxisSize.min,
                                                      children: [
                                                        Text(
                                                          style: TextStyle(
                                                            fontSize: 11,
                                                            fontWeight: FontWeight.bold,
                                                            color: theme.lightMediumGrey(),
                                                          ),
                                                          "${daysName[date.weekday - 1]} - ${date.day}",
                                                        ),
                                                        Text(
                                                          style: TextStyle(
                                                            fontSize: 11,
                                                            fontWeight: FontWeight.bold,
                                                            color: theme.lightMediumGrey(),
                                                          ),
                                                          "(${months[date.month - 1]} - ${date.year})",
                                                        ),
                                                      ],
                                                    ),
                                                  );
                                                },
                                              ),
                                            ),
                                          ),
                                          lineBarsData: [
                                            LineChartBarData(
                                              spots:
                                                  groupedDataAction(
                                                    data(),
                                                  ),
                                              isCurved:
                                                  false,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
        // },
      ),
    );
  }
}

class CreateProjectWidgetDashboard extends StatefulWidget {
  const CreateProjectWidgetDashboard({
    super.key,
    required this.theme,
  });

  final ThemeProvider theme;

  @override
  State<CreateProjectWidgetDashboard> createState() =>
      _CreateProjectWidgetDashboardState();
}

class _CreateProjectWidgetDashboardState
    extends State<CreateProjectWidgetDashboard> {
  final nameController = TextEditingController();
  final urlController = TextEditingController();
  final descController = TextEditingController();
  Future<void> createProject() async {
    await showDialog(
      context: context,
      builder: (context) {
        return AddProjectDialog(
          urlController: urlController,
          descController: descController,
          nameController: nameController,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    var theme = returnTheme(context: context);
    if (screenSize(context) > tabletScreen) {
      return Container(
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: widget.theme.white(),
          boxShadow: [
            BoxShadow(
              color: const Color.fromARGB(18, 0, 0, 0),
              blurRadius: 10,
            ),
          ],
        ),
        child: Stack(
          children: [
            Row(
              children: [
                Expanded(
                  flex: 4,
                  child: Column(
                    spacing: 10,
                    children: [
                      Expanded(
                        child: SingleChildScrollView(
                          child: Column(
                            spacing: 5,
                            children: [
                              Text(
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight:
                                      FontWeight.bold,
                                  color: theme
                                      .darkMediumGrey(),
                                ),
                                'Create A New Software Project!',
                              ),
                              Text(
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight:
                                      FontWeight.normal,
                                  color: theme
                                      .lightMediumGrey(),
                                ),
                                'Click on the button to create a new Software Project.',
                              ),
                            ],
                          ),
                        ),
                      ),
                      MainButton(
                        action: () {
                          // returnCommit()
                          //     .fetchCommits(
                          //       owner:
                          //           'Alex-Onyeka',
                          //       repo:
                          //           'Stockall-CRM',
                          //     );
                          createProject();
                        },
                        title: 'Create New Project',
                      ),
                    ],
                  ),
                ),
                Expanded(flex: 3, child: SizedBox()),
              ],
            ),
            Row(
              children: [
                Expanded(flex: 8, child: SizedBox()),
                Expanded(
                  flex: 6,
                  child: Image.asset(workingMan),
                ),
              ],
            ),
          ],
        ),
      );
    } else {
      return Container(
        padding: EdgeInsets.fromLTRB(15, 15, 5, 20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: widget.theme.white(),
          boxShadow: [
            BoxShadow(
              color: const Color.fromARGB(18, 0, 0, 0),
              blurRadius: 10,
            ),
          ],
        ),
        child: Stack(
          alignment: AlignmentGeometry.center,
          children: [
            Row(
              children: [
                Expanded(
                  flex: 6,
                  child: Column(
                    crossAxisAlignment:
                        CrossAxisAlignment.start,
                    spacing: 10,
                    children: [
                      Expanded(
                        child: SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment:
                                CrossAxisAlignment.start,
                            spacing: 5,
                            children: [
                              Text(
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight:
                                      FontWeight.bold,
                                  color: theme
                                      .darkMediumGrey(),
                                ),
                                'Create A New Software Project!',
                              ),
                              Text(
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight:
                                      FontWeight.normal,
                                  color: theme
                                      .lightMediumGrey(),
                                ),
                                'Click on the button to create a new Software Project.',
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 180,
                        child: MainButton(
                          action: () {
                            createProject();
                          },
                          title: 'Create New Project',
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(flex: 3, child: SizedBox()),
              ],
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(flex: 9, child: SizedBox()),
                Expanded(
                  flex: 5,
                  child: Image.asset(workingMan),
                ),
              ],
            ),
          ],
        ),
      );
    }
  }
}

class DashboardContainerTilesWidget
    extends StatelessWidget {
  final String title;
  final Icon icon;
  final String value;
  final Function()? action;

  const DashboardContainerTilesWidget({
    super.key,
    required this.title,
    required this.icon,
    required this.value,
    this.action,
  });

  @override
  Widget build(BuildContext context) {
    var theme = returnTheme(context: context);
    return Expanded(
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          boxShadow: [
            BoxShadow(
              color: const Color.fromARGB(18, 0, 0, 0),
              blurRadius: 20,
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: Ink(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              color: theme.white(),
            ),
            child: InkWell(
              borderRadius: BorderRadius.circular(5),
              onTap: action,
              child: Container(
                padding: EdgeInsets.all(15),
                child: Row(
                  spacing: 5,
                  crossAxisAlignment:
                      CrossAxisAlignment.end,
                  mainAxisAlignment:
                      MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment:
                          CrossAxisAlignment.start,
                      spacing: 5,
                      children: [
                        Text(
                          style: TextStyle(
                            fontSize:
                                screenSize(context) >
                                    tabletScreen
                                ? 20
                                : 16,
                            fontWeight: FontWeight.bold,
                            color: theme.darkMediumGrey(),
                          ),
                          formatLargeNumber(value),
                        ),
                        Text(
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            color: theme.mediumGrey(),
                          ),
                          title,
                        ),
                      ],
                    ),
                    icon,
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// class WorkEntry {
//   final DateTime date;
//   final double value;

//   WorkEntry(this.date, this.value);
// }
