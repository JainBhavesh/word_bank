// import 'package:flutter/material.dart';

// class TaskCircle extends StatelessWidget {
//   final int daysLeft;
//   final bool isFinish;

//   const TaskCircle({super.key, required this.daysLeft, this.isFinish = false});

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       height: 70,
//       width: 70,
//       decoration: BoxDecoration(
//         shape: BoxShape.circle,
//         color: isFinish ? Colors.yellow : Colors.red,
//       ),
//       child: Center(
//         child: isFinish
//             ? const Text(
//                 'Finish',
//                 style:
//                     TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
//               )
//             : Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   Text(
//                     '$daysLeft',
//                     style: const TextStyle(
//                         color: Colors.white,
//                         fontSize: 20,
//                         fontWeight: FontWeight.bold),
//                   ),
//                   const Text(
//                     'Days left',
//                     style: TextStyle(color: Colors.white, fontSize: 12),
//                   ),
//                 ],
//               ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';

class TaskList extends StatelessWidget {
  final List<Map<String, dynamic>> dateList;

  const TaskList({Key? key, required this.dateList}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: dateList.length,
      itemBuilder: (context, index) {
        var task = dateList[index];

        // Handling possible null values safely
        int daysLeft = task['remaining_day'] ?? 0;
        bool isFinish = daysLeft == 0; // Finish if no days left

        return ListTile(
          title: Text('Task ID: ${task['id']}'),
          subtitle: Text('Target Date: ${task['target_date']}'),
          trailing: TaskCircle(
            daysLeft: daysLeft,
            isFinish: isFinish,
          ),
        );
      },
    );
  }
}

class TaskCircle extends StatelessWidget {
  final int daysLeft;
  final bool isFinish;

  const TaskCircle({super.key, required this.daysLeft, this.isFinish = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 70,
      width: 70,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: isFinish ? Colors.yellow : Colors.red,
      ),
      child: Center(
        child: isFinish
            ? const Text(
                'Finish',
                style:
                    TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
              )
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '$daysLeft',
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold),
                  ),
                  const Text(
                    'Days left',
                    style: TextStyle(color: Colors.white, fontSize: 12),
                  ),
                ],
              ),
      ),
    );
  }
}
