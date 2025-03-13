import 'package:flutter_test/flutter_test.dart';
import 'package:task_synced/app/app.locator.dart';
import 'package:task_synced/ui/views/home/home_viewmodel.dart';

import '../helpers/test_helpers.dart';

void main() {
  HomeViewModel getModel() => HomeViewModel();

  group('HomeViewmodelTest -', () {
    setUp(() => registerServices());
    tearDown(() => locator.reset());

    test('Fetch All Tasks In HomePage', () async {
      final model = getModel();

      await model.fetchTasks();

      expect(model.tasks, isNotNull);
      expect(model.tasks, []);
    });
  });
}
