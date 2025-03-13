import 'package:stacked_services/stacked_services.dart';
import 'package:task_synced/app/app.locator.dart';
import 'package:task_synced/models/task.dart';
import 'package:task_synced/services/api_service.dart';
import 'package:stacked/stacked.dart';
import 'package:task_synced/services/reminder_service.dart';

class HomeViewModel extends StreamViewModel {
  @override
  Stream<void> get stream =>
      Stream.periodic(const Duration(seconds: 10), (_) => fetchTasks());

  final _apiService = locator<ApiService>();
  final navigationService = locator<NavigationService>();
  final _reminderService = locator<ReminderService>();

  List<Task> tasks = [];
  int completedTasks = 0;
  int totalTasks = 0;
  int highPriorityTasks = 0;
  int dueTodayTasks = 0;
  int dueTomorrowTasks = 0;
  int dueInSevenDaysTasks = 0;
  double percentCompleted = 0.0;

  Future<void> fetchTasks() async {
    tasks = await _apiService.getTasks();

    DateTime now = DateTime.now();
    DateTime tomorrow = now.add(const Duration(days: 1));
    DateTime sevenDaysLater = now.add(const Duration(days: 7));

    totalTasks = tasks.length;
    completedTasks = tasks.where((task) => task.completed).length;
    highPriorityTasks = tasks.where((task) => task.priority == "High").length;
    dueTodayTasks = tasks
        .where((task) => isSameDate(task.dueDate, now) && !task.completed)
        .length;
    dueTomorrowTasks =
        tasks.where((task) => isSameDate(task.dueDate, tomorrow)).length;
    dueInSevenDaysTasks = tasks
        .where(
            (task) => isWithinNextSevenDays(task.dueDate, now, sevenDaysLater))
        .length;

    percentCompleted =
        double.parse(((completedTasks / totalTasks) * 100).toStringAsFixed(1));

    // when first fetching then schedule all tasks that have due dates
    // for (var task in tasks) {
    //   if (task.dueDate != null) {
    //     await _reminderService.setReminder(
    //         task.id.hashCode, task.title, "Task is due!", task.dueDate!);
    //   }
    // }

    setBusy(false);
    notifyListeners();
  }

  Future<void> deleteAndFetchTasks(String taskId) async {
    setBusy(true);
    await _apiService.deleteTask(taskId);
    await fetchTasks(); // Reload tasks after deletion

    // once a task is deleted deleted the specific task scheduled reminder. You do not need to be reminded of task that are not on your list
    await _reminderService.cancelReminder(int.parse(taskId));

    setBusy(false);
    notifyListeners();
  }

  bool isSameDate(DateTime? date1, DateTime date2) {
    if (date1 == null) return false;
    return date1.year == date2.year &&
        date1.month == date2.month &&
        date1.day == date2.day;
  }

  bool isWithinNextSevenDays(
      DateTime? date, DateTime now, DateTime sevenDaysLater) {
    if (date == null) return false;
    return date.isAfter(now) && date.isBefore(sevenDaysLater);
  }

  void runstartUpLogic() async {
    await fetchTasks();
  }
}
