import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:promas/classes/branch_class.dart';
import 'package:promas/classes/commit.dart';
import 'package:promas/classes/user_class.dart';
import 'package:promas/components/alert_dialogues/delete_branch_dialog.dart';
import 'package:promas/components/main_divider.dart';
import 'package:promas/constants/formats.dart';
import 'package:promas/constants/general_constants.dart';
import 'package:promas/main.dart';
import 'package:promas/pages/projects/branch_page/components/commit_tile_widget.dart';
import 'package:promas/pages/projects/components/branch_staff_section.dart';
import 'package:promas/pages/projects/components/chat_main_widget.dart';
import 'package:promas/pages/projects/project_page.dart';

class BranchPage extends StatefulWidget {
  final TextEditingController descController;
  final TextEditingController nameController;
  final BranchClass branch;
  const BranchPage({
    super.key,
    required this.branch,
    required this.descController,
    required this.nameController,
  });

  @override
  State<BranchPage> createState() => _BranchPageState();
}

class _BranchPageState extends State<BranchPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey =
      GlobalKey<ScaffoldState>();

  // final companyId = CompanyProvider().currentCompany!.id;
  final branchSearchController = TextEditingController();
  final nameController = TextEditingController();
  final descController = TextEditingController();
  final urlController = TextEditingController();
  bool isLoading = false;

  void toggleLoading() {
    setState(() {
      isLoading = !isLoading;
    });
    // print('Loading is now $isLoading');
  }

  UserClass? selectedUser;

  void selectUser(UserClass? user) {
    setState(() {
      selectedUser = user;
    });
  }

  final buttonKey = GlobalKey();
  final buttonKey2 = GlobalKey();

  void showMenuAction({
    required BranchClass branch,
    required GlobalKey tempKey,
  }) async {
    if (branch.employees.isNotEmpty) {
      final RenderBox button =
          tempKey.currentContext!.findRenderObject()
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
        items: returnUser().users
            .where(
              (user) => branch.employees.contains(user.id),
            )
            .map((user) {
              return PopupMenuItem(
                onTap: () {
                  selectUser(user);
                },
                // value: 'edit',
                child: Text(
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                  user.name,
                ),
              );
            })
            .toList(),
      );
    }
  }

  List<Commit> data(BranchClass branch) {
    final commitsList = returnCommit(context: context)
        .getUserCommits(
          alias: returnUser(context: context).users
              .where(
                (user) =>
                    branch.employees.contains(user.id),
              )
              .map((user) => user.gitHubAlias ?? '')
              .toList(),
        )
        .where(
          (commit) =>
              commit.repo ==
              returnProject().projectGithubName(
                projectUrl:
                    returnProject().projectsMain
                        .firstWhere(
                          (pro) =>
                              pro.uuid == branch.projectId,
                        )
                        .githubUrl ??
                    '',
              ),
        );

    if (commitsList.isEmpty) {
      return [
        // Commit(
        //   sha: 'sha',
        //   repo: 'repo',
        //   message: 'message',
        //   authorName: 'authorName',
        //   authorEmail: 'authorEmail',
        //   date: DateTime.now(),
        //   additions: 0,
        //   deletions: 0,
        //   total: 0,
        //   files: [],
        // ),
      ];
    }

    // Filter by selected project if needed
    final filtered = selectedUser == null
        ? commitsList
        : commitsList.where(
            (commit) =>
                commit.authorEmail ==
                selectedUser?.gitHubAlias,
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
            // Commit(
            //   sha: 'sha',
            //   repo: 'repo',
            //   message: 'message',
            //   authorName: 'authorName',
            //   authorEmail: 'authorEmail',
            //   date: DateTime.now(),
            //   additions: 0,
            //   deletions: 0,
            //   total: 0,
            //   files: [],
            // ),
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
  Widget build(BuildContext context) {
    BranchClass branch = returnBranch(context: context)
        .branches
        .firstWhere(
          (br) => br.uuid == widget.branch.uuid,
          orElse: () => BranchClass(
            name: 'Branch Name',
            projectId: 'avsd',
            level: 0,
            employees: [],
            companyId: 2,
          ),
        );
    var theme = returnTheme(context: context);
    return Scaffold(
      key: _scaffoldKey,
      body: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: 1000),
          child: Column(
            children: [
              Expanded(
                child: Row(
                  mainAxisAlignment:
                      MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.all(15),
                        margin:
                            screenSize(context) >
                                tabletScreen
                            ? EdgeInsets.all(15)
                            : EdgeInsets.all(0),
                        decoration: BoxDecoration(
                          color: theme.white(),
                        ),
                        child: SizedBox(
                          height: double.infinity,
                          child: SingleChildScrollView(
                            child: Column(
                              mainAxisAlignment:
                                  MainAxisAlignment.center,
                              children: [
                                SizedBox(height: 10),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment
                                          .spaceBetween,
                                  children: [
                                    Material(
                                      color: Colors
                                          .transparent,
                                      child: InkWell(
                                        onTap: () {
                                          Navigator.of(
                                            context,
                                          ).pop();
                                        },
                                        child: Padding(
                                          padding:
                                              const EdgeInsets.all(
                                                4.0,
                                              ),
                                          child: Icon(
                                            size: 20,
                                            color: returnTheme(
                                              context:
                                                  context,
                                            ).darkGrey(),
                                            Icons
                                                .arrow_back_ios_new_rounded,
                                          ),
                                        ),
                                      ),
                                    ),
                                    Text(
                                      textAlign:
                                          TextAlign.center,
                                      style: TextStyle(
                                        fontSize: 17,
                                        fontWeight:
                                            FontWeight.bold,
                                        color: returnTheme(
                                          context: context,
                                        ).darkGrey(),
                                      ),
                                      branch.name,
                                    ),
                                    Material(
                                      color: Colors
                                          .transparent,
                                      child: InkWell(
                                        onTap: () {
                                          openChatPage(
                                            context:
                                                context,
                                            id:
                                                widget
                                                    .branch
                                                    .uuid ??
                                                '',
                                            index: 2,
                                          );
                                        },
                                        child: Padding(
                                          padding:
                                              const EdgeInsets.all(
                                                4.0,
                                              ),
                                          child: Row(
                                            spacing: 5,
                                            children: [
                                              Text(
                                                style: TextStyle(
                                                  fontSize:
                                                      11,
                                                  color: Colors
                                                      .grey,
                                                ),
                                                'Chat',
                                              ),
                                              Icon(
                                                size: 16,
                                                color: Colors
                                                    .grey,
                                                Icons.chat,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 5),
                                MainDivider(height: 10),
                                Visibility(
                                  visible:
                                      branch.desc != null &&
                                      branch
                                              .desc
                                              ?.isNotEmpty ==
                                          true,
                                  child: Padding(
                                    padding:
                                        const EdgeInsets.symmetric(
                                          vertical: 10.0,
                                        ),
                                    child: Row(
                                      children: [
                                        Flexible(
                                          child: Column(
                                            spacing: 2,
                                            crossAxisAlignment:
                                                CrossAxisAlignment
                                                    .start,
                                            children: [
                                              Text(
                                                style: TextStyle(
                                                  fontSize:
                                                      9,
                                                  color: returnTheme(
                                                    context:
                                                        context,
                                                  ).mediumGrey(),
                                                ),
                                                'Branch Description:',
                                              ),
                                              Text(
                                                style: TextStyle(
                                                  fontSize:
                                                      11,
                                                  color: returnTheme(
                                                    context:
                                                        context,
                                                  ).darkMediumGrey(),
                                                ),
                                                branch.desc ??
                                                    '',
                                                // branch.desc ?? '',
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding:
                                      EdgeInsets.fromLTRB(
                                        5,
                                        0,
                                        5,
                                        15,
                                      ),
                                  child: Column(
                                    children: [
                                      Visibility(
                                        visible:
                                            branch.desc !=
                                                null &&
                                            branch
                                                    .desc
                                                    ?.isNotEmpty ==
                                                true,
                                        child: MainDivider(
                                          height: 15,
                                        ),
                                      ),
                                      Padding(
                                        padding:
                                            const EdgeInsets.symmetric(
                                              vertical:
                                                  10.0,
                                            ),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment
                                                  .center,
                                          spacing: 0,
                                          children: [
                                            Padding(
                                              padding:
                                                  const EdgeInsets.only(
                                                    right:
                                                        10.0,
                                                  ),
                                              child: Column(
                                                spacing: 2,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment
                                                        .start,
                                                children: [
                                                  Text(
                                                    style: TextStyle(
                                                      fontSize:
                                                          8,
                                                      color:
                                                          theme.lightMediumGrey(),
                                                    ),
                                                    'Created Date:',
                                                  ),
                                                  Text(
                                                    style: TextStyle(
                                                      fontSize:
                                                          11,
                                                      color:
                                                          theme.lightMediumGrey(),
                                                      fontWeight:
                                                          FontWeight.normal,
                                                    ),
                                                    formateDate(
                                                      branch
                                                          .createdAt,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            IgnorePointer(
                                              ignoring: !returnUser(
                                                context:
                                                    context,
                                              ).currentUser!.isAdmin,
                                              child: Material(
                                                color: Colors
                                                    .transparent,
                                                child: InkWell(
                                                  onTap: () async {
                                                    await createBranch(
                                                      branch:
                                                          branch,
                                                      context:
                                                          context,
                                                      descController:
                                                          widget.descController,
                                                      nameController:
                                                          widget.nameController,
                                                      projectId:
                                                          branch.projectId,
                                                    );
                                                    // widget
                                                    //     .action();
                                                  },
                                                  child: Padding(
                                                    padding: const EdgeInsets.symmetric(
                                                      horizontal:
                                                          12.0,
                                                      vertical:
                                                          6,
                                                    ),
                                                    child: Row(
                                                      mainAxisSize:
                                                          MainAxisSize.min,
                                                      spacing:
                                                          3,
                                                      mainAxisAlignment:
                                                          MainAxisAlignment.center,
                                                      children: [
                                                        Icon(
                                                          size: 18,
                                                          color: returnTheme(
                                                            context: context,
                                                          ).mediumGrey(),
                                                          Icons.edit_outlined,
                                                        ),
                                                        Text(
                                                          style: TextStyle(
                                                            fontSize: 11,
                                                            color: returnTheme(
                                                              context: context,
                                                            ).mediumGrey(),
                                                          ),
                                                          'Edit',
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            IgnorePointer(
                                              ignoring: !returnUser(
                                                context:
                                                    context,
                                              ).currentUser!.isAdmin,
                                              child: Material(
                                                color: Colors
                                                    .transparent,
                                                child: InkWell(
                                                  onTap: () {
                                                    showDialog(
                                                      context:
                                                          context,
                                                      builder:
                                                          (
                                                            context,
                                                          ) {
                                                            return DeleteBranchDialog(
                                                              branch: branch,
                                                            );
                                                          },
                                                    ).then((
                                                      _,
                                                    ) {
                                                      Navigator.pop(
                                                        context,
                                                      );
                                                    });
                                                  },
                                                  child: Padding(
                                                    padding: const EdgeInsets.symmetric(
                                                      horizontal:
                                                          12.0,
                                                      vertical:
                                                          6,
                                                    ),
                                                    child: Row(
                                                      mainAxisSize:
                                                          MainAxisSize.min,
                                                      spacing:
                                                          3,
                                                      mainAxisAlignment:
                                                          MainAxisAlignment.center,
                                                      children: [
                                                        Icon(
                                                          size: 18,
                                                          color: const Color.fromARGB(
                                                            255,
                                                            255,
                                                            92,
                                                            92,
                                                          ),
                                                          Icons.delete_outlined,
                                                        ),
                                                        Text(
                                                          style: TextStyle(
                                                            fontSize: 11,
                                                            color: const Color.fromARGB(
                                                              255,
                                                              255,
                                                              92,
                                                              92,
                                                            ),
                                                          ),
                                                          'Delete ',
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      SizedBox(height: 10),
                                      BranchStaffSection(
                                        branch: branch,
                                      ),
                                      SizedBox(height: 15),
                                      Container(
                                        padding:
                                            EdgeInsets.all(
                                              8,
                                            ),
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(
                                                10,
                                              ),
                                          boxShadow: [
                                            BoxShadow(
                                              color:
                                                  const Color.fromARGB(
                                                    25,
                                                    0,
                                                    0,
                                                    0,
                                                  ),
                                              blurRadius:
                                                  10,
                                            ),
                                          ],
                                          color: theme
                                              .white(),
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
                                                          fontWeight: FontWeight.bold,
                                                          color: theme.darkMediumGrey(),
                                                        ),
                                                        'Work Done Chart',
                                                      ),
                                                      Builder(
                                                        builder:
                                                            (
                                                              context,
                                                            ) {
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
                                                                    color: theme.primaryColor(),
                                                                  ),
                                                                );
                                                              } else {
                                                                return Material(
                                                                  color: Colors.transparent,
                                                                  child: InkWell(
                                                                    onTap: () async {
                                                                      await returnProject().getSingleProject(
                                                                        projectUuid: widget.branch.projectId,
                                                                      );
                                                                    },
                                                                    borderRadius: BorderRadius.circular(
                                                                      5,
                                                                    ),
                                                                    child: Padding(
                                                                      padding: EdgeInsetsGeometry.all(
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
                                                                        color: theme.lightMediumGrey(),
                                                                        Icons.refresh,
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
                                                    spacing:
                                                        5,
                                                    children: [
                                                      Material(
                                                        key:
                                                            buttonKey,
                                                        color:
                                                            Colors.transparent,
                                                        child: Ink(
                                                          decoration: BoxDecoration(
                                                            borderRadius: BorderRadius.circular(
                                                              5,
                                                            ),
                                                            border: Border.all(
                                                              color: Colors.grey.shade300,
                                                            ),
                                                            color: Colors.grey.shade100,
                                                          ),
                                                          child: InkWell(
                                                            onTap: () async {
                                                              showMenuAction(
                                                                branch: branch,
                                                                tempKey: buttonKey,
                                                              );
                                                            },
                                                            borderRadius: BorderRadius.circular(
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
                                                                      selectedUser?.name ??
                                                                          'Select Staff',
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
                                                                    Icons.keyboard_arrow_down_rounded,
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                      Visibility(
                                                        visible:
                                                            selectedUser !=
                                                            null,
                                                        child: Material(
                                                          borderRadius: BorderRadius.circular(
                                                            10,
                                                          ),
                                                          color: Colors.transparent,
                                                          child: InkWell(
                                                            onTap: () {
                                                              selectUser(
                                                                null,
                                                              );
                                                            },
                                                            child: Padding(
                                                              padding: const EdgeInsets.symmetric(
                                                                vertical: 8.0,
                                                                horizontal: 5,
                                                              ),
                                                              child: Icon(
                                                                color: theme.lightMediumGrey(),
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
                                                if (screenSize(
                                                      context,
                                                    ) >
                                                    tabletScreen) {
                                                  return Container(
                                                    height:
                                                        350,
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
                                                            color: theme.lightMediumGrey(),
                                                          ),
                                                        ),
                                                        titlesData: FlTitlesData(
                                                          topTitles: AxisTitles(
                                                            sideTitles: SideTitles(
                                                              showTitles: false,
                                                            ),
                                                          ),
                                                          rightTitles: AxisTitles(
                                                            sideTitles: SideTitles(
                                                              showTitles: false,
                                                            ),
                                                          ),
                                                          leftTitles: AxisTitles(
                                                            sideTitles: SideTitles(
                                                              reservedSize:
                                                                  ((data(
                                                                                branch,
                                                                              ).length ==
                                                                              1 &&
                                                                          data(
                                                                                branch,
                                                                              ).first.total ==
                                                                              0) ||
                                                                      data(
                                                                        branch,
                                                                      ).isEmpty)
                                                                  ? 20
                                                                  : 50,
                                                              showTitles: true,
                                                              getTitlesWidget:
                                                                  (
                                                                    value,
                                                                    meta,
                                                                  ) {
                                                                    return Text(
                                                                      formatLargeNumber(
                                                                        value.toString(),
                                                                      ),
                                                                      style: TextStyle(
                                                                        fontSize: 11,
                                                                        fontWeight: FontWeight.bold,
                                                                        color: theme.lightMediumGrey(),
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
                                                              getTitlesWidget:
                                                                  (
                                                                    value,
                                                                    meta,
                                                                  ) {
                                                                    final days = getLast7Days(
                                                                      // data(branch),
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

                                                                    final date = days[value.toInt()];

                                                                    return Padding(
                                                                      padding: const EdgeInsets.fromLTRB(
                                                                        0,
                                                                        10,
                                                                        0,
                                                                        0,
                                                                      ),
                                                                      child: Column(
                                                                        mainAxisSize: MainAxisSize.min,
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
                                                            spots: groupedDataAction(
                                                              data(
                                                                branch,
                                                              ),
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
                                                          padding: EdgeInsets.fromLTRB(
                                                            15,
                                                            5,
                                                            40,
                                                            5,
                                                          ),
                                                          child: LineChart(
                                                            LineChartData(
                                                              borderData: FlBorderData(
                                                                border: Border.all(
                                                                  color: theme.lightMediumGrey(),
                                                                ),
                                                              ),
                                                              titlesData: FlTitlesData(
                                                                topTitles: AxisTitles(
                                                                  sideTitles: SideTitles(
                                                                    showTitles: false,
                                                                  ),
                                                                ),
                                                                rightTitles: AxisTitles(
                                                                  sideTitles: SideTitles(
                                                                    showTitles: false,
                                                                  ),
                                                                ),
                                                                leftTitles: AxisTitles(
                                                                  sideTitles: SideTitles(
                                                                    reservedSize:
                                                                        ((data(
                                                                                      branch,
                                                                                    ).length ==
                                                                                    1 &&
                                                                                data(
                                                                                      branch,
                                                                                    ).first.total ==
                                                                                    0) ||
                                                                            data(
                                                                              branch,
                                                                            ).isEmpty)
                                                                        ? 20
                                                                        : 50,
                                                                    showTitles: true,
                                                                    getTitlesWidget:
                                                                        (
                                                                          value,
                                                                          meta,
                                                                        ) {
                                                                          return Text(
                                                                            formatLargeNumber(
                                                                              value.toString(),
                                                                            ),
                                                                            style: TextStyle(
                                                                              fontSize: 11,
                                                                              fontWeight: FontWeight.bold,
                                                                              color: theme.lightMediumGrey(),
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
                                                                    getTitlesWidget:
                                                                        (
                                                                          value,
                                                                          meta,
                                                                        ) {
                                                                          final days = getLast7Days(
                                                                            // data(branch),
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

                                                                          final date = days[value.toInt()];

                                                                          return Padding(
                                                                            padding: const EdgeInsets.fromLTRB(
                                                                              0,
                                                                              10,
                                                                              0,
                                                                              0,
                                                                            ),
                                                                            child: Column(
                                                                              mainAxisSize: MainAxisSize.min,
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
                                                                  spots: groupedDataAction(
                                                                    data(
                                                                      branch,
                                                                    ),
                                                                  ),
                                                                  isCurved: false,
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
                                      SizedBox(height: 15),
                                      Container(
                                        padding:
                                            EdgeInsets.symmetric(
                                              vertical: 20,
                                            ),
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(
                                                10,
                                              ),
                                          boxShadow: [
                                            BoxShadow(
                                              color:
                                                  const Color.fromARGB(
                                                    25,
                                                    0,
                                                    0,
                                                    0,
                                                  ),
                                              blurRadius:
                                                  10,
                                            ),
                                          ],
                                          color: theme
                                              .white(),
                                        ),
                                        child: Column(
                                          spacing: 5,
                                          children: [
                                            Padding(
                                              padding:
                                                  const EdgeInsets.fromLTRB(
                                                    10.0,
                                                    10,
                                                    10,
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
                                                          fontWeight: FontWeight.bold,
                                                          color: theme.darkMediumGrey(),
                                                        ),
                                                        'Commits:',
                                                      ),
                                                      Builder(
                                                        builder:
                                                            (
                                                              context,
                                                            ) {
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
                                                                    color: theme.primaryColor(),
                                                                  ),
                                                                );
                                                              } else {
                                                                return Material(
                                                                  color: Colors.transparent,
                                                                  child: InkWell(
                                                                    onTap: () async {
                                                                      await returnProject().getSingleProject(
                                                                        projectUuid: widget.branch.projectId,
                                                                      );
                                                                    },
                                                                    borderRadius: BorderRadius.circular(
                                                                      5,
                                                                    ),
                                                                    child: Padding(
                                                                      padding: EdgeInsetsGeometry.all(
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
                                                                        color: theme.lightMediumGrey(),
                                                                        Icons.refresh,
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
                                                    spacing:
                                                        5,
                                                    children: [
                                                      Material(
                                                        key:
                                                            buttonKey2,
                                                        color:
                                                            Colors.transparent,
                                                        child: Ink(
                                                          decoration: BoxDecoration(
                                                            borderRadius: BorderRadius.circular(
                                                              5,
                                                            ),
                                                            border: Border.all(
                                                              color: Colors.grey.shade300,
                                                            ),
                                                            color: Colors.grey.shade100,
                                                          ),
                                                          child: InkWell(
                                                            onTap: () async {
                                                              showMenuAction(
                                                                branch: branch,
                                                                tempKey: buttonKey2,
                                                              );
                                                            },
                                                            borderRadius: BorderRadius.circular(
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
                                                                      selectedUser?.name ??
                                                                          'Select Staff',
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
                                                                    Icons.keyboard_arrow_down_rounded,
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                      Visibility(
                                                        visible:
                                                            selectedUser !=
                                                            null,
                                                        child: Material(
                                                          borderRadius: BorderRadius.circular(
                                                            10,
                                                          ),
                                                          color: Colors.transparent,
                                                          child: InkWell(
                                                            onTap: () {
                                                              selectUser(
                                                                null,
                                                              );
                                                            },
                                                            child: Padding(
                                                              padding: const EdgeInsets.symmetric(
                                                                vertical: 8.0,
                                                                horizontal: 5,
                                                              ),
                                                              child: Icon(
                                                                color: theme.lightMediumGrey(),
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
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(
                                                    10.0,
                                                  ),
                                              child: Column(
                                                children: [
                                                  Divider(
                                                    thickness:
                                                        1,
                                                  ),
                                                  Column(
                                                    spacing:
                                                        5,
                                                    children:
                                                        data(
                                                              branch,
                                                            )
                                                            .map(
                                                              (
                                                                item,
                                                              ) => CommitTileWidget(
                                                                commit: item,
                                                              ),
                                                            )
                                                            .toList(),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Future<Object?> openChatPage({
  required BuildContext context,
  required String id,
  required int index,
}) {
  return showGeneralDialog(
    context: context,
    pageBuilder: (context, animation, secondaryAnimation) {
      return MainChatWidget(chatType: index, id: id);
    },
  );
}
