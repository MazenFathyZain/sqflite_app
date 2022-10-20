import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../custom_widgets/task_item.dart';
import '../shared/cubit/cubit.dart';
import '../shared/cubit/states.dart';



class NewTasks extends StatelessWidget {
  const NewTasks({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit,AppStates>(
      listener: (context, state){},
      builder: (context, state){
        var tasks = AppCubit.get(context).newTasks;
        return ListView.separated(
          itemBuilder: (context,index) => buildTaskItem(tasks![index],context),
          separatorBuilder: (context,index) =>Container(
            height: 1.0,
            width: double.infinity,
            color: Colors.grey[300],
          ),
          itemCount: tasks!.length,
        );
      },

    );
  }
}
