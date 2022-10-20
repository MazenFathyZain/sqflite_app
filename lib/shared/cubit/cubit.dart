import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_project/shared/cubit/states.dart';

import '../../tasks/archived_tasks.dart';
import '../../tasks/done_tasks.dart';
import '../../tasks/new_tasks.dart';

class AppCubit extends Cubit<AppStates> {
  AppCubit() : super(AppInitialState());

  static AppCubit get(context) => BlocProvider.of(context);
  int currentIndex = 0;
  List<Widget> screens = [
    const NewTasks(),
    const DoneTasks(),
    ArchivedTasks(),
  ];
  List titles = [
    "NewTasks",
    "DoneTasks",
    "ArchivedTasks",
  ];

  void changeIndex(int index) {
    currentIndex = index;
    emit(AppChangeBottomNavbarState());
  }

  late Database database;
  List<Map>? newTasks = [];
  List<Map>? doneTasks = [];
  List<Map>? archivedTasks = [];

  void createDatabase() {
    openDatabase('todo4.db', version: 1, onCreate: (database, version) {
      print("database created");
      database
          .execute(
              'CREATE TABLE tasks (id INTEGER PRIMARY KEY, title TEXT, date TEXT, time TEXT, status TEXT)')
          .then((value) {
        print("table created");
      }).catchError((onError) {
        print("error when created table ${onError.toString()}");
      });
    }, onOpen: (database) {
      getDataFromDatabase(database);
      print("database opened");
    }).then((value) {
      database = value;
      emit(AppCreateDatabaseState());
    });
  }

  insertToDatabase(
      {@required String? title,
      @required String? time,
      @required String? date}) async {
    await database.transaction((txn) => txn
            .rawInsert(
                'INSERT INTO tasks (title, date, time, status) VALUES("$title", "$time", "$date", "NEW")')
            .then((value) {
          print("$value inserted successfully");
          emit(AppInsertDatabaseState());
          getDataFromDatabase(database);
        }).catchError((Error) {
          print("Error when inserting new record ${Error.toString()}");
        }));
  }

  void getDataFromDatabase(database) {
    newTasks = [];
    doneTasks = [];
    archivedTasks = [];
    emit(AppGetDatabaseLoadingState());
    database.rawQuery("SELECT * FROM tasks").then((value) {
      value.forEach((element) {
        if (element["status"] == "NEW") {
          newTasks?.add(element);
        } else if (element["status"] == "done") {
          doneTasks?.add(element);
        } else {
          archivedTasks?.add(element);
        }
      });

      emit(AppGetDatabaseState());
    });
  }

  void updateData({@required String? status, @required int? id}) async {
    database.rawUpdate(
      'UPDATE tasks SET status = ? WHERE id = ?',
      ['$status', id],
    ).then((value) {
      getDataFromDatabase(database);
      emit(AppUpdateDatabaseState());
    });
  }

  void deleteData({@required int? id}) async {
    database.rawDelete(
      'DELETE FROM tasks WHERE id = ?',[id ]
    ).then((value) {
      getDataFromDatabase(database);
      emit(AppDeleteDatabaseState());
    });
  }

  bool isBottomSheetShow = false;
  IconData fabIcon = Icons.edit;

  void changeBottomSheetState(
      {@required bool? isShow, @required IconData? icon}) {
    isBottomSheetShow = isShow!;
    fabIcon = icon!;
    emit(AppChangeBottomSheetState());
  }
}
