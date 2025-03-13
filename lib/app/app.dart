import 'package:task_synced/ui/bottom_sheets/notice/notice_sheet.dart';
import 'package:task_synced/ui/dialogs/info_alert/info_alert_dialog.dart';
import 'package:task_synced/ui/views/home/home_view.dart';
import 'package:task_synced/ui/views/startup/startup_view.dart';
import 'package:stacked/stacked_annotations.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:task_synced/services/api_service.dart';
import 'package:task_synced/ui/views/add_task/add_task_view.dart';
import 'package:task_synced/ui/views/update_task/update_task_view.dart';
import 'package:task_synced/services/reminder_service.dart';
import 'package:task_synced/ui/views/notification/notification_view.dart';
// @stacked-import

@StackedApp(
  routes: [
    MaterialRoute(page: HomeView),
    MaterialRoute(page: StartupView),
    MaterialRoute(page: AddTaskView),
    MaterialRoute(page: UpdateTaskView),
    MaterialRoute(page: NotificationView),
// @stacked-route
  ],
  dependencies: [
    LazySingleton(classType: BottomSheetService),
    LazySingleton(classType: DialogService),
    LazySingleton(classType: NavigationService),
    LazySingleton(classType: ApiService),
    LazySingleton(classType: ReminderService),
// @stacked-service
  ],
  bottomsheets: [
    StackedBottomsheet(classType: NoticeSheet),
    // @stacked-bottom-sheet
  ],
  dialogs: [
    StackedDialog(classType: InfoAlertDialog),
    // @stacked-dialog
  ],
)
class App {}
