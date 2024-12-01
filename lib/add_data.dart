import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:task_manager_app/task.dart';

class AddData extends StatefulWidget {
  const AddData({super.key});

  @override
  State<AddData> createState() => _AddDataState();
}


class _AddDataState extends State<AddData> {
  TextEditingController titlecontroller = TextEditingController();
  TextEditingController descriptioncontroller = TextEditingController();
  late String errormessage;
  late bool isError;

  @override
  void initState() {
    errormessage = "This is an error";
    isError = false;
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

Future createTask() async{
  final docTask = FirebaseFirestore.instance.collection('Task').doc();
  final newTask = Task(
    id: docTask.id,
    title: titlecontroller.text,
    description: descriptioncontroller.text,
    status: false
  );
  final json = newTask.toJson();
  await docTask.set(json);

  setState((){
    titlecontroller.text="";
    descriptioncontroller.text="";
    Navigator.pop(context);
  });}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 182, 241, 252),
      appBar: AppBar(
       backgroundColor: const Color.fromARGB(255, 11, 79, 134),
        title: const Text('',
        style: TextStyle(color: Colors.white),),
        leading: IconButton(
          color: Colors.white,
          onPressed: (){
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back),
          ),
      ),
      body: Container(
        decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/images/finalbg.jpg'), 
          fit: BoxFit.cover),),
        child: Center(
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 25),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'ADD TASK',
                  style: txtstyle,
                ),
                const SizedBox(height: 15),
                TextField(
                  controller: titlecontroller,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Enter task title',
                    prefixIcon: Icon(Icons.add_task_sharp),
                  ),
                ),
                const SizedBox(height: 15),
                                TextField(
                    controller: descriptioncontroller,
                    maxLines: null, 
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Enter task description',
                      prefixIcon: Icon(Icons.description),
                    ),
                  ),
                const SizedBox(height: 15),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 108, 183, 245),
                    minimumSize: const Size.fromHeight(50),
                  ),
                  onPressed: () {
                    createTask();
                  },
                  child: const Text('SAVE',
                  style: TextStyle(
                    color: Colors.black),),
                ),
                const SizedBox(height: 15),
                (isError)
                    ? Text(
                        errormessage,
                        style: errortxtstyle,
                      )
                    : Container(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  var errortxtstyle = const TextStyle(
    fontWeight: FontWeight.bold,
    color: Colors.red,
    letterSpacing: 1,
    fontSize: 18,
  );
  var txtstyle = const TextStyle(
    fontWeight: FontWeight.bold,
    letterSpacing: 2,
    fontSize: 38,
  );

}
