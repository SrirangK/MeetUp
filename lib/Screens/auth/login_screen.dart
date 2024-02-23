import 'dart:developer';
import 'dart:io';
import 'package:MeetUp/apis/apis.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../main.dart';
import '../main_screens/home_screen.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../../helper/dialogues.dart';



class Loginscreen extends StatefulWidget {
  const Loginscreen({Key? key}) : super(key: key);

  @override
  State<Loginscreen> createState() => _LoginscreenState();
}

class _LoginscreenState extends State<Loginscreen> {
  bool _isAnimate=false;
  @override
  void initState(){
    super.initState();
    Future.delayed(const Duration(milliseconds: 500),(){
      setState(() {
        _isAnimate=true;
      });
    });
  }

  _handleGoogleBtnClick(){
    Dialogue.showProgressbar(context); //for showing progress bar
    _signInWithGoogle().then((user) async{
      Navigator.pop(context); //for hiding progress bar
      if(user!=null){
        log('\nUser:${user.user}');
        log('\nUserAdditionalInfo:${user.additionalUserInfo}');

        if((await APIS.userExist())){
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (_) => const Homescreen()));
        }else{
         await APIS.createUser().then((value) {
           Navigator.pushReplacement(
               context, MaterialPageRoute(builder: (_) => const Homescreen()));
         });
        }

      }
      }
    );

  }

  Future<UserCredential?> _signInWithGoogle() async {
    // Trigger the authentication flow
    try{
      await InternetAddress.lookup('google.com');
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      // Obtain the auth details from the request
      final GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;

      // Create a new credential
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );

      // Once signed in, return the UserCredential
      return await APIS.auth.signInWithCredential(credential);
    }catch(e){
      log('\n_signInWithGoogle: $e');
      Dialogue.showsSnackbar(context, 'Something went wrong(Check Internet)');
      return null;
    }
  }

  // _signOut () async{
  //   await APIS.auth.signOut();
  //   await GoogleSignIn().signOut();
  // }

  @override
  Widget build(BuildContext context) {
    mq=MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Welcome to MeetUp',style: TextStyle(fontSize: 25),),
        ),
      body: Stack(children: [
        AnimatedPositioned(
            top: _isAnimate ? mq.height*0.15 :-mq.height*0.5,
            left:mq.width*0.25,
            width: mq.width*0.5,
            height: mq.height*0.3,
            duration:const Duration(milliseconds: 1500),
            child: Image.asset('images/laugh.png')),
        Positioned(
            bottom: mq.height*0.18,
            left:mq.width*0.15,
            width: mq.width*0.7,
            height: mq.height*0.05,
            child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.lime,shape: const StadiumBorder()),

                onPressed: (){
                  _handleGoogleBtnClick();
                },
                icon: Image.asset('images/google.png',height: mq.height*0.036,),
                label:const Text('Sign In with Google',style: TextStyle(fontSize: 20),)),),

      ],
      ),
    );
  }
}
