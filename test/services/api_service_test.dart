import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:task_synced/app/app.locator.dart';
import 'package:task_synced/models/task.dart';
import '../helpers/test_helpers.dart';

void main() {
  group('ApiServiceTest -', () {
    setUp(() => registerServices());
    tearDown(() => locator.reset());
  });

  group('API Calls -', () {
    test('Fetch By Task ID', () async {
      final apiService = getAndRegisterApiService();

      // Mock the API call
      when(apiService.getTaskById("1")).thenAnswer(
        (_) async => Task(
          id: 1,
          title: "Finish report",
          priority: "High",
          completed: false,
        ),
      );

      // Call the method
      await apiService.getTaskById("1");

      // Verify if the API method was called
      verify(apiService.getTaskById("1")).called(1);
    });

    test('Fetch All Tasks', () async {
      final apiService = getAndRegisterApiService();

      // Mock the API call
      when(apiService.getTasks()).thenAnswer((_) async => [
            Task(
              id: 1,
              title: "Finish report",
              priority: "High",
              completed: false,
            ),
            Task(
              id: 2,
              title: "Tesing tests",
              priority: "Low",
              completed: false,
            ),
          ]);

      // Call the method
      await apiService.getTasks();

      // Verify if the API method was called
      verify(apiService.getTasks()).called(1);
    });
  });
}
