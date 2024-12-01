import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:task_manager_app/add_data.dart';
import 'package:task_manager_app/login.dart';
import 'package:task_manager_app/sidebar.dart';
import 'package:task_manager_app/task.dart';
import 'package:task_manager_app/update_data.dart';
class AllData extends StatefulWidget {
  const AllData({super.key});

  @override
  State<AllData> createState() => _AllDataState();
}

Stream<List<Task>> readTasks(){
  return FirebaseFirestore.instance
  .collection('Task')
  .snapshots()
  .map((snapshot) => snapshot.docs.map((doc) => Task.fromJson(doc.data(),
  ),
  )
  .toList(),
  );
}

Future deleteTask(String id) async {
  final docTask = FirebaseFirestore.instance.collection('Task').doc(id);
  docTask.delete();
}

Future<void> deleteAllTasks() async {
  try {
    // Fetch all tasks from the collection
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection('Task').get();

    // Iterate through each task and delete it
    for (QueryDocumentSnapshot documentSnapshot in querySnapshot.docs) {
      await FirebaseFirestore.instance.collection('Task').doc(documentSnapshot.id).delete();
    }

    print('All tasks deleted successfully.');
  } catch (e) {
    print('Error deleting tasks: $e');
  }
}

Future updateTaskStatus(String id, bool newStatus) async {
  final docTask = FirebaseFirestore.instance.collection('Task').doc(id);
  await docTask.update({'status': newStatus}); // Update the "status" field
}
Future<void> _showdeleteConfirmationDialog(BuildContext context, String id) async {
  showDialog<void>(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Delete Confirmation'),
        content: const Text('Delete file?'),
        actions: <Widget>[
          TextButton(
            child: const Text('No'),
            onPressed: () {
              Navigator.of(context).pop(); // Close the dialog
            },
          ),
          TextButton(
            child: const Text('Yes'),
            onPressed: () async {
              Navigator.of(context).pop(); 
              await deleteTask(id);  // Call deleteTask to delete the task
            },
          ),
        ],
      );
    },
  );
}

Future<void> _showDeleteAllConfirmationDialog(BuildContext context) async {
  showDialog<void>(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Delete All Tasks Confirmation'),
        content: const Text('Are you sure you want to delete all tasks?'),
        actions: <Widget>[
          TextButton(
            child: const Text('Cancel'),
            onPressed: () {
              Navigator.of(context).pop(); // Close the dialog
            },
          ),
          TextButton(
            child: const Text('Delete All'),
            onPressed: () async {
              await deleteAllTasks();  // Call deleteAllTasks to delete all tasks
              Navigator.of(context).pop(); // Close the dialog
            },
          ),
        ],
      );
    },
  );
}




Future<void> _showTaskDetailsDialog(BuildContext context, Task task) async {
  return showDialog<void>(
    context: context,
    barrierDismissible: false, // User must tap a button to close the dialog
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(task.title),
        content: SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              Text('Description:\n${task.description}'),
              // Add more details here as needed
            ],
          ),
        ),
        actions: <Widget>[
          TextButton(
            child: Text('Close'),
            onPressed: () {
              Navigator.of(context).pop(); // Close the dialog
            },
          ),
        ],
      );
    },
  );
}
Future<void> handleSignOut(BuildContext context) async {
  try {
    await FirebaseAuth.instance.signOut(); // Sign the user out
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const Login()), // Navigate back to the Login screen
    );
  } catch (e) {
    print('Error signing out: $e');
  }
}


class _AllDataState extends State<AllData> {
 int completedTasksCount = 0;
  int incompleteTasksCount = 0;
  int totalTasksCount = 0;

  Map<String, double> dataMap = {
    'Complete Tasks': 0,
    'Incomplete Tasks': 0,
    'Total Tasks': 0,
  };

  @override
  void initState() {
    super.initState();
    // Fetch tasks and calculate counts
    readTasks().listen((tasks) {
      setState(() {
        completedTasksCount = tasks.where((task) => task.status).length;
        incompleteTasksCount = tasks.where((task) => !task.status).length;
        totalTasksCount = tasks.length;

        // Update dataMap after counts have been updated
        dataMap = {
          'Complete Tasks': completedTasksCount.toDouble(),
          'Incomplete Tasks': incompleteTasksCount.toDouble(),
          'Total Tasks': totalTasksCount.toDouble(),
        };
      });
    });
  }
  Widget buildList(Task task) => Visibility(
  visible: !task.status, // Hide the ListTile when task.status is true
  child: Container(
    decoration: const BoxDecoration(border: Border(
    bottom: BorderSide(width: 2.0, color: Colors.black))),
    child: ListTile(
      contentPadding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
      leading: const Icon(Icons.task),
      title: Text(
        task.title,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
      ),
      subtitle: Text(
        task.description,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      dense: true,
      onTap: () {
        _showTaskDetailsDialog(context, task);
      },
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Checkbox(
            value: task.status,
            onChanged: (newValue) {
              if (newValue != null) {
                updateTaskStatus(task.id, newValue);
                setState(() {
                  task.status = newValue;
                });
              }
            },
          ),
          IconButton(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => UpdateData(task: task),
                ),
              );
            },
            icon: const Icon(Icons.edit_outlined),
          ),
          IconButton(
            onPressed: () {
              _showdeleteConfirmationDialog(context, task.id);
            },
            icon: const Icon(Icons.delete_outlined),
          ),
        ],
      ),
    ),
  ),
);



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 182, 241, 252),
      drawer: sidebar(),
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        centerTitle: true,
        title: const Text(
          'All Tasks',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color.fromARGB(255, 11, 79, 134),
        actions: <Widget>[
          IconButton(
            onPressed: () {
              _showDeleteAllConfirmationDialog(context);
            },
            icon: const Icon(Icons.delete),
          ),
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/finalbg.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            const SizedBox(height: 10,),
             Row(
               mainAxisAlignment: MainAxisAlignment.spaceEvenly,
               crossAxisAlignment: CrossAxisAlignment.center,
               children: [
                 RichText(
                 text: TextSpan(
                   style: const TextStyle(
                     color: Colors.black, // Set the desired text color
                     fontWeight: FontWeight.bold,
                   ),
                   children: <TextSpan>[
                     const TextSpan(
                       text: 'Complete Tasks',
                       style: TextStyle(fontWeight: FontWeight.bold),
                     ),
                     TextSpan(
                       text: '\n             $completedTasksCount',
                       style: const TextStyle(fontWeight: FontWeight.bold,),
                     ),
                   ],
                 ),
               ),

                 RichText(
                 text: TextSpan(
                   style: const TextStyle(
                     color: Colors.black, // Set the desired text color
                     fontWeight: FontWeight.bold,
                   ),
                   children: <TextSpan>[
                     const TextSpan(
                       text: 'Incomplete Tasks',
                       style: TextStyle(fontWeight: FontWeight.bold),
                     ),
                     TextSpan(
                       text: '\n             $incompleteTasksCount',
                       style: const TextStyle(fontWeight: FontWeight.bold),
                     ),
                   ],
                 ),
               ),
                 RichText(
                 text: TextSpan(
                   style: const TextStyle(
                     color: Colors.black, // Set the desired text color
                     fontWeight: FontWeight.bold,
                   ),
                   children: <TextSpan>[
                     const TextSpan(
                       text: 'Total Tasks',
                       style: TextStyle(fontWeight: FontWeight.bold),
                     ),
                     TextSpan(
                       text: '\n        $totalTasksCount',
                       style: const TextStyle(fontWeight: FontWeight.bold),
                     ),
                   ],
                 ),
               ),
               ],
             ),
             const SizedBox(height: 10,),
             const Divider(height: .5, color: Color.fromARGB(255, 94, 140, 238)),
            Expanded(
  child: StreamBuilder<List<Task>>(
  stream: readTasks(),
  builder: (context, snapshot) {
    if (snapshot.hasError) {
      return Text('Something went wrong! ${snapshot.error}');
    } else if (snapshot.hasData) {
      final tasks = snapshot.data!;

      return ListView(
        children: tasks.map(buildList).toList(),
      );
    } else {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }
  },
)
),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => const AddData(),
            ),
          );
        },
        backgroundColor: const Color.fromARGB(255, 11, 79, 134),
        foregroundColor: Colors.white,
        child: const Icon(Icons.add),
      ),
    );
  }


}