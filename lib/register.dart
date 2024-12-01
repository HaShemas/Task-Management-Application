import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:task_manager_app/authenticator.dart';
import 'package:task_manager_app/employee.dart';
import 'package:task_manager_app/login.dart';

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  TextEditingController namecontroller = TextEditingController();
  TextEditingController emailcontroller = TextEditingController();
  TextEditingController passwordcontroller = TextEditingController();
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 182, 241, 252),
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
                  'WELCOME!',
                  style: txtstyle,
                ),
                const Text(
                  'Register your account now!',
                ),
                const SizedBox(height: 15),
                TextField(
                  controller: namecontroller,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Enter name',
                    prefixIcon: Icon(Icons.person),
                  ),
                ),
                const SizedBox(height: 15),
                TextField(
                  controller: emailcontroller,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Enter Email Address',
                    prefixIcon: Icon(Icons.email),
                  ),
                ),
                const SizedBox(height: 15),
                TextField(
                  obscureText: true,
                  controller: passwordcontroller,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Enter password',
                    prefixIcon: Icon(Icons.lock),
                  ),
                ),
                const SizedBox(height: 15),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 108, 183, 245),
                    minimumSize: const Size.fromHeight(50),
                  ),
                  onPressed: () {
                    registerUser();
                  },
                  child: const Text('REGISTER',
                  style: TextStyle(
                    color: Colors.black,
                  ),),
                ),
                (isError)
                    ? Text(
                        errormessage,
                        style: errortxtstyle,
                      )
                    : Container(),
                  const SizedBox(height: 15),
              const Text(
                'Already have an account? Log in instead!',
                style: TextStyle(fontSize: 12),
              ),
              Container(
                height: 12,
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 108, 183, 245),
                  minimumSize: const Size.fromHeight(50),
                ),
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const Login(),
                    ),
                  );
                },
                child: const Text(
                  'LOGIN',
                  style: TextStyle(color: Colors.black),
                ),
              ),
              const SizedBox(height: 15),
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

  Future createUser() async {
    final user = FirebaseAuth.instance.currentUser!;
    final userid = user.uid;
    final docUser = FirebaseFirestore.instance.collection('Employee').doc(userid);

    final employee = Employee(
      id: userid,
      name: namecontroller.text,
      email: emailcontroller.text,
    );

    final json = employee.toJson();
    await docUser.set(json);

    goToAuthenticator();

  }

  Future registerUser() async {
    try {
  await FirebaseAuth.instance.createUserWithEmailAndPassword(
    email: emailcontroller.text.trim(),
    password: passwordcontroller.text.trim(),
    );
    createUser();
      setState((){
        errormessage = "";
      });
} on FirebaseAuthException catch (e) {
  print(e);
  setState(() {
    errormessage = e.message.toString();
  });
}
  }

  goToAuthenticator() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const Authenticator(),
      ),
    );
  }
}
