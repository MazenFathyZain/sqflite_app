import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_project/shared/cubit/cubit.dart';
import 'package:sqflite_project/shared/cubit/states.dart';

import 'custom_widgets/custom_text_form_field.dart';


class HomeView extends StatelessWidget {
  var scaffoldKey = GlobalKey<ScaffoldState>();
  var formKey = GlobalKey<FormState>();

  var titleController = TextEditingController();
  var timeController = TextEditingController();
  var dateController = TextEditingController();




  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => AppCubit()..createDatabase(),
      child: BlocConsumer<AppCubit, AppStates>(
        listener: (context, state) {
          if(state is AppInsertDatabaseState){
            Navigator.pop(context);
          }
        },
        builder: (context, state) {
          AppCubit cubit =  AppCubit.get(context);
          return Scaffold(
            key: scaffoldKey,
            floatingActionButton: FloatingActionButton(
              onPressed: () {
                if (cubit.isBottomSheetShow) {
                  if (formKey.currentState!.validate()) {
                    cubit.insertToDatabase(
                      title: titleController.text,
                      time: timeController.text,
                      date: dateController.text,
                    );
                  }
                } else {
                  scaffoldKey.currentState
                      ?.showBottomSheet(
                          (context) => Container(
                                color: Colors.white,
                                padding: EdgeInsets.all(20.0),
                                child: Form(
                                  key: formKey,
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      // Title TextField
                                      CustomTextFormField(
                                        controller: titleController,
                                        prefixIcon: const Icon(Icons.title),
                                        keyboardType: TextInputType.text,
                                        label: "Task Title",
                                        onTap: () {
                                          print("title tapped");
                                        },
                                        validator: (value) {
                                          if (value.isEmpty) {
                                            return "Title must be not empty";
                                          }
                                          return null;
                                        },
                                      ),
                                      const SizedBox(height: 15),
                                      // Time TextField
                                      CustomTextFormField(
                                        controller: timeController,
                                        onTap: () {
                                          showTimePicker(
                                                  context: context,
                                                  initialTime: TimeOfDay.now())
                                              .then((value) {
                                            timeController.text = value!
                                                .format(context)
                                                .toString();
                                            // print(value?.format(context));
                                          });
                                        },
                                        prefixIcon: const Icon(
                                            Icons.watch_later_outlined),
                                        keyboardType: TextInputType.none,
                                        label: "Task Time",
                                        validator: (value) {
                                          if (value.isEmpty) {
                                            return "Time must be not empty";
                                          }
                                          return null;
                                        },
                                      ),
                                      const SizedBox(height: 15),
                                      // date TextField
                                      CustomTextFormField(
                                        controller: dateController,
                                        onTap: () {
                                          showDatePicker(
                                            context: context,
                                            initialDate: DateTime.now(),
                                            firstDate: DateTime.now(),
                                            lastDate:
                                                DateTime.parse('2023-01-01'),
                                          ).then((value) {
                                            dateController.text =
                                                DateFormat.yMMMd()
                                                    .format(value!);
                                          });
                                        },
                                        prefixIcon:
                                            const Icon(Icons.calendar_today),
                                        keyboardType: TextInputType.none,
                                        label: "Task Date",
                                        validator: (value) {
                                          if (value.isEmpty) {
                                            return "Date must be not empty";
                                          }
                                          return null;
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                          elevation: 20.0)
                      .closed
                      .then((value) {
                    cubit.changeBottomSheetState(isShow:  false, icon: Icons.edit);
                  });
                  cubit.changeBottomSheetState(isShow:  true, icon: Icons.add);
                }
              },
              child: Icon(cubit.fabIcon),
            ),
            bottomNavigationBar: BottomNavigationBar(
              currentIndex:  cubit.currentIndex,
              onTap: (index) {
                AppCubit.get(context).changeIndex(index);
              },
              items: const [
                BottomNavigationBarItem(icon: Icon(Icons.menu), label: "Tasks"),
                BottomNavigationBarItem(
                    icon: Icon(Icons.check_circle_outline), label: "Done"),
                BottomNavigationBarItem(
                    icon: Icon(Icons.archive), label: "Archived"),
              ],
            ),
            appBar: AppBar(
              title: Text(cubit.titles[cubit.currentIndex]),
            ),
            body: cubit.screens[cubit.currentIndex],
          );
        },
      ),
    );
  }


}
