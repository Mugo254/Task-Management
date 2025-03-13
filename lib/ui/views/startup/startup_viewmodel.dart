import 'package:flutter/services.dart';
import 'package:stacked/stacked.dart';
import 'package:task_synced/app/app.locator.dart';
import 'package:task_synced/app/app.router.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:task_synced/services/reminder_service.dart';

class StartupViewModel extends BaseViewModel {
  final _navigationService = locator<NavigationService>();
  static const platform = MethodChannel('task_reminder_channel');

  // Place anything here that needs to happen before we get into the application
  Future runStartupLogic() async {
    await Future.delayed(const Duration(seconds: 1));

    // This is where you can make decisions on where your app should navigate when
    // you have custom startup logic

    _navigationService.replaceWithHomeView();
  }
}
