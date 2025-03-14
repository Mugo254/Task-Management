import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:task_synced/ui/common/app_colors.dart';

import 'update_task_viewmodel.dart';

class UpdateTaskView extends StackedView<UpdateTaskViewModel> {
  final int taskId;
  const UpdateTaskView({
    Key? key,
    required this.taskId,
  }) : super(key: key);

  @override
  Widget builder(
    BuildContext context,
    UpdateTaskViewModel viewModel,
    Widget? child,
  ) {
    return Scaffold(
      backgroundColor: kPureWhite,
      appBar: AppBar(
        title: const Text("Update Task"),
        backgroundColor: kPureWhite,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 30.0),
        child: Form(
          key: viewModel.formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextFormField(
                      controller: viewModel.titleController,
                      style: Theme.of(context)
                          .textTheme
                          .titleMedium!
                          .copyWith(color: kPureBlack, fontSize: 17),
                      decoration: InputDecoration(
                        labelText: "Title",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      validator: (value) =>
                          value!.isEmpty ? "Title is required" : null,
                    ),
                    const SizedBox(height: 16),
                    DropdownButtonFormField<String>(
                      value: viewModel.selectedPriority,
                      decoration: InputDecoration(
                        labelText: "Priority",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      items: viewModel.priorities.map((priority) {
                        return DropdownMenuItem(
                          value: priority,
                          child: Text(
                            priority,
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium!
                                .copyWith(color: kPureBlack, fontSize: 17),
                          ),
                        );
                      }).toList(),
                      onChanged: (value) => viewModel.setPriority(value),
                      validator: (value) =>
                          value == null ? "Priority is required" : null,
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          width: MediaQuery.of(context).size.width * 0.45,
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.grey,
                            ),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: ListTile(
                            title: Text(
                              viewModel.dueDate != null
                                  ? viewModel.dueDate!
                                      .toLocal()
                                      .toString()
                                      .split(' ')[0]
                                  : 'Not Set',
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium!
                                  .copyWith(color: kPureBlack, fontSize: 17),
                            ),
                            trailing: const Icon(Icons.calendar_today),
                            onTap: () async {
                              DateTime? pickedDate = await showDatePicker(
                                context: context,
                                initialDate: DateTime.now(),
                                firstDate: DateTime.now(),
                                lastDate: DateTime(2100),
                              );
                              viewModel.setDueDate(pickedDate);
                            },
                          ),
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width * 0.45,
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.grey,
                            ),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: ListTile(
                            title: Text(
                              viewModel.dueTime != null
                                  ? "${viewModel.dueTime!.hour.toString().padLeft(2, '0')}:${viewModel.dueTime!.minute.toString().padLeft(2, '0')}"
                                  : 'Not Set',
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium!
                                  .copyWith(color: kPureBlack, fontSize: 17),
                            ),
                            trailing: const Icon(Icons.lock_clock),
                            onTap: () async {
                              TimeOfDay? pickedTime = await showTimePicker(
                                context: context,
                                initialTime: TimeOfDay.now(),
                              );
                              viewModel.setTimeDue(pickedTime);
                            },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 4,
                    ),
                    Row(
                      children: [
                        Checkbox(
                          value: viewModel.isCompleted,
                          onChanged: (value) =>
                              viewModel.setCompletedStatus(value!),
                        ),
                        Text(
                          "Is Completed",
                          style: Theme.of(context)
                              .textTheme
                              .titleMedium!
                              .copyWith(color: kPureBlack),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              GestureDetector(
                onTap: () {
                  viewModel.submitForm(taskId.toString());
                },
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: kHeavyBlueColor),
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Center(
                      child: Text(
                        "Update Task",
                        style: Theme.of(context)
                            .textTheme
                            .titleMedium!
                            .copyWith(color: kPureWhite),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void onViewModelReady(UpdateTaskViewModel viewModel) {
    viewModel.runstartUpLogic(taskId);

    super.onViewModelReady(viewModel);
  }

  @override
  UpdateTaskViewModel viewModelBuilder(
    BuildContext context,
  ) =>
      UpdateTaskViewModel();
}
