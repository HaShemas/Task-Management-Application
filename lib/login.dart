import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:task_manager_app/register.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  TextEditingController usernamecontroller = TextEditingController();
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
  void _showDialog(String title, String message) {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: Text(title),
      content: Text(message),
      actions: <Widget>[
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(); // Close the dialog
          },
          child: Text('OK'),
        ),
      ],
    ),
  );
}

Widget build(BuildContext context) {
  return Scaffold(
    //backgroundColor: const Color.fromARGB(255, 182, 241, 252),
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
                'Good to see you back!',
              ),
              const SizedBox(height: 15),
              TextField(
                controller: usernamecontroller,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Enter Email',
                  prefixIcon: Icon(Icons.person),
                ),
              ),
              const SizedBox(height: 15),
              TextField(
                obscureText: true,
                controller: passwordcontroller,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Enter Password',
                  prefixIcon: Icon(Icons.lock),
                ),
              ),
              const SizedBox(height: 15),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 108, 183, 245),
                  minimumSize: const Size.fromHeight(50),
                ),
                onPressed: () async {
                  try {
                    await FirebaseAuth.instance.signInWithEmailAndPassword(
                      email: usernamecontroller.text,
                      password: passwordcontroller.text,
                    );
                    setState(() {
                      errormessage = "";
                    });
                    _showDialog('Login Successful', 'You have successfully logged in.');
                  } on FirebaseAuthException catch (e) {
                    print(e);
                    setState(() {
                      errormessage = e.message.toString();
                    });
                    _showDialog('Invalid Email or Password!', errormessage);
                  }
                },
                child: const Text(
                  'LOGIN',
                  style: TextStyle(color: Colors.black),
                ),
              ),
              const SizedBox(height: 15),
              const Text(
                'No account yet? Sign Up now!',
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
                      builder: (context) => const Register(),
                    ),
                  );
                },
                child: const Text(
                  'SIGN UP',
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

 Future checkLogin(username, password) async {
    showDialog(
      context: context, 
      useRootNavigator: false,
      barrierDismissible: false,
      builder: (context) => const Center(
        child: CircularProgressIndicator(),
        ),); 
    
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: username, 
        password: password,
        );
        setState(() {
          errormessage="";
        });
  } on FirebaseAuthException catch (e) {
    print(e);
    setState(() {
      errormessage = e.message.toString();
    });
}
  Navigator.pop(context);
  }

}
