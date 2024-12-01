import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:task_manager_app/sidebar.dart';
import 'package:task_manager_app/task.dart';
import 'package:pie_chart/pie_chart.dart';
class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _AllDataState();
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

class _AllDataState extends State<Home> {
 int completedTasksCount = 0;
  int incompleteTasksCount = 0;
  int totalTasksCount = 0;

  Map<String, double> dataMap = {
    'Complete Tasks': 0,
    'Incomplete Tasks': 0,
    'Total Tasks': 0,
    'No Tasks': 0,
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
          'No Tasks' : 0,
        };
      });
    });
  }
 
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 182, 241, 252),
      drawer: sidebar(),
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        centerTitle: true,
        title: const Text(
          'HOME',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color.fromARGB(255, 11, 79, 134),
        
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
            Container(
              width: 1000, // Set the width as per your requirements
              height: 600,
              child: PieChart(
                dataMap: dataMap, 
              colorList: const [Color.fromRGBO(76, 175, 80, 1), Colors.red, Colors.blue,Colors.grey],
              chartRadius: MediaQuery.of(context).size.width / 1.0,
              ),
              ) ,
            
            const SizedBox(height: 20,),
           
          ],
        ),
      ),
    );
  }


}