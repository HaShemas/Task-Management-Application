import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:task_manager_app/task.dart';

class UpdateData extends StatefulWidget {
  const UpdateData({
    super.key,
    required this.task,});

    final Task task;

  @override
  State<UpdateData> createState() => _UpdateDataState();
}


class _UpdateDataState extends State<UpdateData> {
  TextEditingController titlecontroller = TextEditingController();
  TextEditingController descriptioncontroller = TextEditingController();
  late String errormessage;
  late bool isError;

  @override
  void initState() {
    errormessage = "This is an error";
    isError = false;
    titlecontroller.text = widget.task.title;
    descriptioncontroller.text = widget.task.description;
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future updateTask(String id) async{
  final docTask = FirebaseFirestore.instance.collection('Task').doc(id);
  docTask.update({
    'description': descriptioncontroller.text,
    'title': titlecontroller.text,
  });

    Navigator.pop(context);
}
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
                  'UPDATE TASK',
                  style: txtstyle,
                ),
                const SizedBox(height: 15),
                TextField(
                  controller: titlecontroller,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Enter title',
                    prefixIcon: Icon(Icons.person),
                  ),
                ),
                const SizedBox(height: 15),
                TextField(
                  controller: descriptioncontroller,
                   maxLines: null,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Enter description',
                    prefixIcon: Icon(Icons.email),
                  ),
                ),
                const SizedBox(height: 15),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 108, 183, 245),
                    minimumSize: const Size.fromHeight(50),
                  ),
                  onPressed: () {
                    updateTask(widget.task.id);
                  },
                  child: const Text('UPDATE',
                  style: TextStyle(color: Colors.black),),
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
