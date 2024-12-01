import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:task_manager_app/alldata.dart';
import 'package:task_manager_app/alldatahistory.dart';
import 'package:task_manager_app/home.dart';
import 'package:task_manager_app/login.dart';

class sidebar extends StatelessWidget {
   sidebar({super.key});

final user = FirebaseAuth.instance.currentUser!;
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/images/finalbg.jpg'), 
          fit: BoxFit.cover),),
        child: ListView(
          children: [
            UserAccountsDrawerHeader(accountName:  const 
            Text("Welcome!"), 
            accountEmail: Text( user.email!,),
                currentAccountPicture: CircleAvatar(
                  child: ClipOval(
                    child: Image.network('https://bloximages.chicago2.vip.townnews.com/tucson.com/content/tncms/assets/v3/editorial/0/80/0802223e-21bb-11ee-8d0c-b3a2d439312e/64b0727559628.image.jpg?resize=1200%2C800',
                      width: 90,
                      height: 90,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                ),
            ListTile(
              leading: const Icon(Icons.home),
              title: const Text("HOME"),
              onTap: (){
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const Home(),
                  ));
              },
            ),
            ListTile(
              leading: const Icon(Icons.task_alt_outlined),
              title: const Text("TASK"),
              onTap: (){
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const AllData(),
                  ));
              },
            ),
            ListTile(
              leading: const Icon(Icons.history),
              title: const Text("HISTORY"),
              onTap: (){
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const alldatahistory(),
                  ));
              },
            ),   
            ListTile(
              leading: const Icon(Icons.logout_outlined),
              title: const Text("LOGOUT"),
              onTap: () async {
          showDialog<void>(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Logout Confirmation'),
          content: const Text('Do you really want to logout?'),
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
                Navigator.of(context).pop(); // Close the dialog
                await handleSignOut(context);
                await _showLogoutSuccessDialog(context);
                try {
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                      builder: (context) => Login(),
                    ),
                  );
                } catch (e) {
                  print('Error signing out: $e');
                }
              },
            ),
          ],
        );
          },
        );
              },
            ),
          ],
        ),
      ),
    );
  }
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
Future<void> _showLogoutConfirmationDialog(BuildContext context) async {
  showDialog<void>(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Logout Confirmation'),
        content: const Text('Do you really want to logout?'),
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
              Navigator.of(context).pop(); // Close the dialog
              await handleSignOut(context);
              await _showLogoutSuccessDialog(context);
              try {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (context) => Login(),
                  ),
                );
              } catch (e) {
                print('Error signing out: $e');
              }
            },
          ),
        ],
      );
    },
  );
}

  Future<void> _showLogoutSuccessDialog(BuildContext context) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Logout Successful'),
          content: const Text('You have been successfully logged out.'),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
            ),
          ],
        );
      },
    );
  }

