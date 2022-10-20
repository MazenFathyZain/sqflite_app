import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../shared/cubit/cubit.dart';

  Widget buildTaskItem(Map? model,context) {
    return Dismissible(
      key: Key(model!["id"].toString()),
      onDismissed: (direction){
        AppCubit.get(context).deleteData(id: model["id"]);
      },
      child: Padding(
      padding: const EdgeInsets.all(20.0),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
           CircleAvatar(
            radius: 40,
            child: Text(model["date"]),
          ),
          const SizedBox(
            width: 20,
          ),
          Expanded(

            child: Column(
              mainAxisSize: MainAxisSize.min,
              children:  [
                Text(
                  model["title"],
                  style: const TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  model["time"],
                  style: const TextStyle(
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(
            width: 20,
          ),
          IconButton(
              onPressed: (){
                AppCubit.get(context).updateData(status: "done", id: model["id"]);
              },
              icon: const Icon(Icons.check_box),
            color: Colors.green,
          ),
          const SizedBox(
            width: 20,
          ),
          IconButton(
            color: Colors.blueGrey,
            onPressed: (){AppCubit.get(context).updateData(status: "archive", id: model["id"]);},
            icon: const Icon(Icons.archive),
          ),
        ],
      ),
  ),
    );
  }
