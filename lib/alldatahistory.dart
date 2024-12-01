import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:task_manager_app/alldata.dart';
import 'package:task_manager_app/login.dart';
import 'package:task_manager_app/sidebar.dart';
import 'package:task_manager_app/task.dart';

class alldatahistory extends StatefulWidget {
  const alldatahistory({super.key});

  @override
  State<alldatahistory> createState() => _alldatahistoryState();
}
Future<void> _showTaskDetailsDialog(BuildContext context, Task task) async {
  return showDialog<void>(
    context: context,
    barrierDismissible: false, 
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(task.title),
        content: SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              Text('Description:\n${task.description}'),
            ],
          ),
        ),
        actions: <Widget>[
          TextButton(
            child: Text('Close'),
            onPressed: () {
              Navigator.of(context).pop(); 
            },
          ),
        ],
      );
    },
  );
}
Future<void> handleSignOut(BuildContext context) async {
  try {
    await FirebaseAuth.instance.signOut(); 
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const Login()), 
    );
  } catch (e) {
    print('Error signing out: $e');
  }
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

Future<void> _showDeleteAllConfirmationDialog(BuildContext context) async {
  showDialog<void>(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Delete All Task History Confirmation'),
        content: const Text('Are you sure you want to delete all tasks history?'),
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

class _alldatahistoryState extends State<alldatahistory> {
  @override
  Widget buildList(Task task) => GestureDetector (
    child: Container(
      decoration: const BoxDecoration(border: Border(bottom: BorderSide())),
      child: ListTile(
        contentPadding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
          leading: const Icon(Icons.task),
          title: Text(
          task.title,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold),),
          subtitle: Text(task.description,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,),
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
                    print("Checkbox onChanged: newValue=$newValue");
                    if (newValue != null) {
                      updateTaskStatus(task.id, newValue);
                      setState(() {
                        task.status = !newValue;
                      });
                    }
                  }
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
        title: const Text('All Tasks History',
        style: TextStyle(color: Colors.white),),
        backgroundColor: const Color.fromARGB(255, 11, 79, 134),
        actions: <Widget> [
            IconButton(
              onPressed: (){
                _showDeleteAllConfirmationDialog(context);
              },
              icon: const Icon(Icons.delete),),
          ],
       
      ),
      body: Container(
        decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/images/finalbg.jpg'), 
          fit: BoxFit.cover),),
        child: StreamBuilder<List<Task>>(
          stream: readTasks(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Text('Something went wrong! ${snapshot.error}');
            } else if (snapshot.hasData) {
              final tasks = snapshot.data!;
              final completedTasks = tasks.where((task) => task.status).toList();
      
              return ListView(
                children: completedTasks.map(buildList).toList(),
              );
            } else {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
          },
        ),
      ),
      );
  }
}