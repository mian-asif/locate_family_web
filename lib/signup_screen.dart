import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:motion_toast/motion_toast.dart';
import 'package:motion_toast/resources/arrays.dart';

import 'admin_home.dart';
import 'custom_widgets.dart';
class SignInScreen extends StatefulWidget {
  const SignInScreen({Key? key}) : super(key: key);

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  TextEditingController passwordController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  final _auth = FirebaseAuth.instance;
  final FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  final user = FirebaseAuth.instance.currentUser;
   late String email;
   bool loading =false;

  Future<void> validateUser() async {
    try {
      final UserCredential userCredential = await _auth
          .signInWithEmailAndPassword(email: emailController.text.trim(),
          password: passwordController.text.trim());
    } on FirebaseAuthException catch  (e) {
      if (kDebugMode) {
        print('Failed with error code: ${e.code}');
      }
      if (kDebugMode) {
        print(e.message);
      }
      MotionToast.error(
          position:MotionToastPosition.bottom,
          title:  const Text("Error"),
          description:  Text(e.message.toString())
      ).show(context);
    }
    getUsersData();
    if(email==emailController.text.trim()){
      Get.off( AdminDashboard());
    }else{
      MotionToast.error(
          position:MotionToastPosition.bottom,
          // title:  Text("Error"),
          description:  const Text('Admin Not Found')
      ).show(context);
    }
  }
  getUsersData()  {
    FirebaseFirestore.instance
        .collection('admin')
        // .where("email", isEqualTo: auth.currentUser?.uid)
        .get()
        .then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        // // print(doc['full_name']);
        setState(() {
          // myEmail = doc['email'];
          email = doc['email'];
          loading=false;
          // loading=false;
        });
        // getLength();
      });
    });
  }
  @override
  void initState() {

    super.initState();

  }
  @override
  Widget build(BuildContext context) {
    var cHeight = MediaQuery.of(context).size.height;
    var cWidth= MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.white,

      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding:  EdgeInsets.only(top: cHeight*0.05,left: cWidth*0.03),
            child: Column(
              children: [
                Image.asset('assets/images/logoweb.png',width: cWidth*0.08,height: cHeight*0.2),
                Padding(
                  padding: EdgeInsets.only(top: cHeight*0.02
                  ),
                  child: Text('Locate Family',style: TextStyle(
                      fontWeight: FontWeight.bold,fontSize: 30,color: Colors.teal
                  )),
                ),
              ],
            )
          ),
          Padding(
            padding:  EdgeInsets.only(left: cWidth*0.3,right: cWidth*0.3,top: cHeight*0.09),
            child:  loginTextField(controller: emailController,hintText: 'Email',obscureText: false),
          ),
          Padding(
            padding:  EdgeInsets.only(left: cWidth*0.3,right: cWidth*0.3,top: cHeight*0.05),
            child: loginTextField(controller: passwordController,hintText: 'Password',obscureText: true),
          ),
          Padding(
            padding:  EdgeInsets.only(top: cHeight*0.1),
            child: Center(
                child: SizedBox(
                    height:cHeight*0.08, //height of button
                    width:cWidth*0.12, //width of button
                    child:
                loading? CircularProgressIndicator(): signInButton(
                      onPressed: (){
                        validateUser();
                        loading=true;


                      }
                    )
                )
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: cHeight*0.08),
            child: const Text('Powerd By TSoftek',style: TextStyle(
              fontWeight: FontWeight.bold,fontSize: 16,color: Colors.teal
            )),
          ),
        ],
      ),


    );
  }
}
