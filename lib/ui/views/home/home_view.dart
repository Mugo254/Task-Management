import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:stacked/stacked.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:task_synced/app/app.router.dart';
import 'package:task_synced/ui/common/app_colors.dart';

import 'home_viewmodel.dart';

class HomeView extends StackedView<HomeViewModel> {
  const HomeView({Key? key}) : super(key: key);

  @override
  Widget builder(BuildContext context, HomeViewModel viewModel, Widget? child) {
    return Scaffold(
      body: viewModel.isBusy
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Stack(
              children: [
                Container(
                  color: kHeavyBlueColor,
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                ),
                Positioned(
                  top: 30,
                  left: 0,
                  right: 0,
                  bottom: 0,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(15),
                        child: _buildProfileSection(context, viewModel),
                      ),
                      Expanded(
                        child: Container(
                          width: double.infinity,
                          decoration: const BoxDecoration(
                            color: kPureWhite,
                            borderRadius: BorderRadiusDirectional.only(
                              topStart: Radius.circular(20),
                              topEnd: Radius.circular(20),
                            ),
                          ),
                          child: Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 13.0),
                            child: ListView(
                              children: [
                                // == start of you agenda UI ====
                                _buildAgendaSummary(context, viewModel),
                                const SizedBox(
                                  height: 15,
                                ),
                                // == end of you agenda UI ====

                                // == start of you metrics summary UI ====
                                _buildMetricsSummary(context, viewModel),
                                const SizedBox(
                                  height: 15,
                                ),
                                // == end of you metrics summary UI ====

                                // == start of you tasks summary UI ====
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "Tasks Summary",
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleMedium!
                                          .copyWith(color: kPureBlack),
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        viewModel.navigationService
                                            .navigateToAddTaskView();
                                      },
                                      child: Image.asset(
                                        "assets/icons/add.png",
                                        width: 25,
                                        height: 25,
                                      ),
                                    )
                                  ],
                                ),
                                const SizedBox(
                                  height: 12,
                                ),
                                ListView.builder(
                                  physics: const NeverScrollableScrollPhysics(),
                                  shrinkWrap: true,
                                  itemCount: viewModel.tasks.length,
                                  itemBuilder: (context, index) {
                                    return GestureDetector(
                                      onTap: () {
                                        viewModel.navigationService
                                            .navigateToUpdateTaskView(
                                                taskId:
                                                    viewModel.tasks[index].id);
                                      },
                                      child: Container(
                                        height: 86,
                                        margin:
                                            const EdgeInsets.only(bottom: 10.0),
                                        width:
                                            MediaQuery.of(context).size.width,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(15),
                                          border: Border.all(
                                            color: Colors.blueGrey,
                                          ),
                                          color: kPureWhite,
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 15.0, vertical: 14.0),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Text(
                                                    viewModel
                                                        .tasks[index].title,
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .titleMedium!
                                                        .copyWith(
                                                            color: viewModel
                                                                    .tasks[
                                                                        index]
                                                                    .completed
                                                                ? kcLightGrey
                                                                : kPureBlack),
                                                  ),
                                                  Row(
                                                    children: [
                                                      if (viewModel.tasks[index]
                                                              .completed ==
                                                          true) ...[
                                                        Image.asset(
                                                          "assets/icons/check.png",
                                                          width: 25,
                                                          height: 25,
                                                        ),
                                                        const SizedBox(
                                                            width: 7.0),
                                                      ],
                                                      GestureDetector(
                                                        onTap: () async {
                                                          await viewModel
                                                              .deleteAndFetchTasks(
                                                                  viewModel
                                                                      .tasks[
                                                                          index]
                                                                      .id
                                                                      .toString());
                                                        },
                                                        child: Image.asset(
                                                          "assets/icons/delete.png",
                                                          width: 20,
                                                          height: 20,
                                                        ),
                                                      ),
                                                    ],
                                                  )
                                                ],
                                              ),
                                              const SizedBox(height: 2),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Container(
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              50),
                                                      color: viewModel
                                                                  .tasks[index]
                                                                  .priority
                                                                  .toLowerCase() ==
                                                              "low"
                                                          ? const Color(
                                                              0xFFfcede7)
                                                          : viewModel
                                                                      .tasks[
                                                                          index]
                                                                      .priority
                                                                      .toLowerCase() ==
                                                                  "medium"
                                                              ? const Color(
                                                                  0xFFe8f7f3)
                                                              : const Color(
                                                                  0xFFFFE5E9),
                                                    ),
                                                    child: Padding(
                                                      padding: const EdgeInsets
                                                          .symmetric(
                                                          horizontal: 8.0,
                                                          vertical: 1),
                                                      child: Text(
                                                        viewModel.tasks[index]
                                                            .priority,
                                                        style: Theme.of(context)
                                                            .textTheme
                                                            .titleSmall!
                                                            .copyWith(
                                                                color: viewModel
                                                                            .tasks[
                                                                                index]
                                                                            .priority
                                                                            .toLowerCase() ==
                                                                        "low"
                                                                    ? const Color(
                                                                        0xFFf19e7b)
                                                                    : viewModel.tasks[index].priority.toLowerCase() ==
                                                                            "medium"
                                                                        ? const Color(
                                                                            0xFF41aa8d)
                                                                        : const Color(
                                                                            0xFFB71C1C),
                                                                fontSize: 14.5),
                                                      ),
                                                    ),
                                                  ),
                                                  if (viewModel.tasks[index]
                                                          .dueDate !=
                                                      null) ...[
                                                    Text(
                                                      "Due: ${viewModel.formattedDueDateAndDueTime(index)}",
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .titleSmall!
                                                          .copyWith(
                                                            color: kcLightGrey,
                                                            fontSize: 14,
                                                          ),
                                                    ),
                                                  ],
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                ),
                                // == end of you tasks summary UI ====
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
    );
  }

  @override
  void onViewModelReady(HomeViewModel viewModel) {
    viewModel.runstartUpLogic();

    super.onViewModelReady(viewModel);
  }

  Widget _buildProfileSection(BuildContext context, viewModel) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const CircleAvatar(
              radius: 25,
              foregroundImage: AssetImage("assets/icons/person.png"),
            ),
            const SizedBox(height: 8),
            Text(
              DateFormat('EEEE, dd MMMM').format(DateTime.now()),
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    color: kPureWhite,
                  ),
            ),
            const SizedBox(height: 4),
            Text(
              "Hello Bruce",
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w400,
                    color: kPureWhite,
                    fontSize: 27,
                  ),
            ),
          ],
        ),
        Column(
          children: [
            SizedBox(
              width: 95,
              height: 95,
              child: Stack(
                children: [
                  SfCircularChart(
                    margin: EdgeInsets.zero,
                    series: <CircularSeries>[
                      DoughnutSeries<ChartData, String>(
                        dataSource: [
                          ChartData('Progress', viewModel.percentCompleted,
                              const Color(0xFFFF9800)),
                          ChartData('Remaining',
                              100.0 - viewModel.percentCompleted, kPureWhite),
                        ],
                        xValueMapper: (ChartData data, _) => data.label,
                        yValueMapper: (ChartData data, _) => data.value,
                        pointColorMapper: (ChartData data, _) => data.color,
                        innerRadius: '75%',
                      ),
                    ],
                  ),
                  Positioned(
                    top: 36,
                    left: 27,
                    child: Text(
                      "${viewModel.percentCompleted}%",
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w300,
                            color: kPureWhite,
                            fontSize: 17,
                          ),
                    ),
                  )
                ],
              ),
            ),
            Text(
              "Completed",
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w300,
                    color: kPureWhite,
                    fontSize: 16,
                  ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildMetricsSummary(BuildContext context, viewModel) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Metrics Summary",
          style: Theme.of(context)
              .textTheme
              .titleMedium!
              .copyWith(color: kPureBlack),
        ),
        SizedBox(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height * 0.135,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: ["total", "high Priority"].length,
            itemBuilder: (context, index) {
              return Container(
                margin: const EdgeInsets.only(right: 10.0),
                width: MediaQuery.of(context).size.width * 0.45,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: index == 1 ? Colors.green : Colors.amber,
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      //number
                      Text(
                        index == 1
                            ? viewModel.totalTasks.toString()
                            : viewModel.highPriorityTasks.toString(),
                        style: Theme.of(context).textTheme.titleLarge!.copyWith(
                              color: kPureWhite,
                              fontSize: 55,
                              fontWeight: FontWeight.w500,
                            ),
                      ),
                      //title
                      Text(
                        index == 1 ? "Total Tasks" : "High Priority",
                        style:
                            Theme.of(context).textTheme.titleMedium!.copyWith(
                                  color: kPureWhite,
                                ),
                      )
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildAgendaSummary(BuildContext context, viewModel) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Your Agenda",
          style: Theme.of(context)
              .textTheme
              .titleMedium!
              .copyWith(color: kPureBlack),
        ),
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.25,
          child: Row(
            children: [
              //Todays Metrics
              Container(
                width: MediaQuery.of(context).size.width * 0.5,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [kLightBlueColor, kPurpleColor], // Gradient colors
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Padding(
                  padding: const EdgeInsets.only(left: 6.0),
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.5,
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2), // Shadow color
                          spreadRadius: 2, // Spread of the shadow
                          blurRadius: 10, // Blurriness of the shadow
                          offset: const Offset(4, 4), // Offset (x, y)
                        ),
                      ],
                      borderRadius: BorderRadius.circular(15),
                      color: kPureWhite,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: Column(
                        children: [
                          //forward arrow,

                          //number
                          Text(
                            viewModel.dueTodayTasks.toString(),
                            style: Theme.of(context)
                                .textTheme
                                .titleLarge!
                                .copyWith(
                                  color: kPureBlack,
                                  fontSize: 140,
                                  fontWeight: FontWeight.w500,
                                ),
                          ),
                          //title
                          Text(
                            "Due Today",
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium!
                                .copyWith(color: kPureBlack),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8.0),
              Column(
                children: [
                  // Tomorrows Metrics
                  Container(
                    width: MediaQuery.of(context).size.width * 0.4,
                    height: MediaQuery.of(context).size.width * 0.26,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [
                          kLightBlueColor,
                          kPurpleColor
                        ], // Gradient colors
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 6.0),
                      child: Container(
                        width: MediaQuery.of(context).size.width * 0.4,
                        height: MediaQuery.of(context).size.width * 0.28,
                        decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                              color:
                                  Colors.black.withOpacity(0.2), // Shadow color
                              spreadRadius: 2, // Spread of the shadow
                              blurRadius: 10, // Blurriness of the shadow
                              offset: const Offset(4, 4), // Offset (x, y)
                            ),
                          ],
                          borderRadius: BorderRadius.circular(15),
                          color: kPureWhite,
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: [
                              //number
                              Text(
                                viewModel.dueTomorrowTasks.toString(),
                                style: Theme.of(context)
                                    .textTheme
                                    .titleLarge!
                                    .copyWith(
                                      color: kPureBlack,
                                      fontSize: 50,
                                      fontWeight: FontWeight.w500,
                                    ),
                              ),
                              //title
                              Text(
                                "Due Tomorrow",
                                style: Theme.of(context)
                                    .textTheme
                                    .titleSmall!
                                    .copyWith(
                                      color: kPureBlack,
                                      fontSize: 15,
                                    ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8.0),

                  Container(
                    width: MediaQuery.of(context).size.width * 0.4,
                    height: MediaQuery.of(context).size.width * 0.26,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [
                          kLightBlueColor,
                          kPurpleColor
                        ], // Gradient colors
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 6.0),
                      child: Container(
                        width: MediaQuery.of(context).size.width * 0.4,
                        height: MediaQuery.of(context).size.width * 0.28,
                        decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                              color:
                                  Colors.black.withOpacity(0.2), // Shadow color
                              spreadRadius: 2, // Spread of the shadow
                              blurRadius: 10, // Blurriness of the shadow
                              offset: const Offset(4, 4), // Offset (x, y)
                            ),
                          ],
                          borderRadius: BorderRadius.circular(15),
                          color: kPureWhite,
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: [
                              //number
                              Text(
                                viewModel.dueInSevenDaysTasks.toString(),
                                style: Theme.of(context)
                                    .textTheme
                                    .titleLarge!
                                    .copyWith(
                                      color: kPureBlack,
                                      fontSize: 50,
                                      fontWeight: FontWeight.w500,
                                    ),
                              ),
                              //title
                              Text(
                                "Due In Seven Days",
                                style: Theme.of(context)
                                    .textTheme
                                    .titleSmall!
                                    .copyWith(color: kPureBlack, fontSize: 15),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ],
    );
  }

  @override
  HomeViewModel viewModelBuilder(BuildContext context) => HomeViewModel();
}

class ChartData {
  final String label;
  final double value;
  final Color color;
  ChartData(this.label, this.value, this.color);
}
