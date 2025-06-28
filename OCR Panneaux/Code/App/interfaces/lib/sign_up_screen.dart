import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'alert_screen.dart';
import 'login_screen.dart';

class SignUpScreen extends StatelessWidget {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final passwordController = TextEditingController();

  void register(BuildContext context) async {
    try {
      // Création du compte
      UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );

      // Récupération de l'UID
      String uid = userCredential.user!.uid;

      // Référence à la collection 'users' dans Firestore
      CollectionReference users = FirebaseFirestore.instance.collection('users');

      // Ajout des infos dans Firestore
      await users.doc(uid).set({
        'name': nameController.text.trim(),
        'email': emailController.text.trim(),
        'phone': phoneController.text.trim(),
        'uid': uid,
      });

      print("User ajouté avec succès !");
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => AlertScreen()));
    } catch (e) {
      print('Erreur d’inscription: $e');
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Erreur: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(20),
        child: ListView(
          children: [
            Text("Sign up", style: TextStyle(fontSize: 22)),
            TextField(controller: nameController, decoration: InputDecoration(labelText: "Full Name")),
            TextField(controller: emailController, decoration: InputDecoration(labelText: "Email")),
            TextField(controller: phoneController, decoration: InputDecoration(labelText: "Phone")),
            TextField(controller: passwordController, obscureText: true, decoration: InputDecoration(labelText: "Password")),
            ElevatedButton(onPressed: () => register(context), child: Text("Register")),
            TextButton(
              onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => LoginScreen())),
              child: Text("Already have an account? Login"),
            )
          ],
        ),
      ),
    );
  }
}
