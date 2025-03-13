import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:task_synced/ui/common/app_colors.dart';

import 'notification_viewmodel.dart';

class NotificationView extends StackedView<NotificationViewModel> {
  final String taskId, taskTitle;

  const NotificationView({
    Key? key,
    required this.taskId,
    required this.taskTitle,
  }) : super(key: key);

  @override
  Widget builder(
    BuildContext context,
    NotificationViewModel viewModel,
    Widget? child,
  ) {
    return Scaffold(
      backgroundColor: kPureWhite,
      body: Center(
        child: Text(
          taskTitle,
          style: Theme.of(context)
              .textTheme
              .titleMedium!
              .copyWith(color: kPureBlack, fontSize: 17),
        ),
      ),
    );
  }

  @override
  NotificationViewModel viewModelBuilder(
    BuildContext context,
  ) =>
      NotificationViewModel();
}
