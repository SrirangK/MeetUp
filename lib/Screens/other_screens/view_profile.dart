import 'package:cached_network_image/cached_network_image.dart';
import '../main_screens/chatscreen.dart';
import 'package:MeetUp/apis/apis.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../../main.dart';
import '../../models/chat_user.dart';


class ViewProfileScreen extends StatefulWidget {
  final ChatUser user;
  const ViewProfileScreen({Key? key, required this.user}) : super(key: key);

  @override
  State<ViewProfileScreen> createState() => _ViewProfileScreenState();
}

_signOut () async{
  await APIS.auth.signOut();
  await GoogleSignIn().signOut();

}

class _ViewProfileScreenState extends State<ViewProfileScreen> {


  @override
  Widget build(BuildContext context) {

    return GestureDetector(
      //for hiding keyboard
      onTap: ()=>FocusScope.of(context).unfocus(),
      
      child: WillPopScope(                     //Going back to home screen
        onWillPop: (){
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (_) =>ChatScreen(user: widget.user,)));
          return Future.value(false);
        },
        child: Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            title:  Text(widget.user.name,style: TextStyle(color: Colors.black,fontSize: 30),),
            backgroundColor: Colors.blue,
            leading: IconButton(
                        color: Colors.black,
                        icon: const Icon(Icons.arrow_back),
                        onPressed: (){
                            Navigator.pushReplacement(context,
                                MaterialPageRoute(builder: (_) =>ChatScreen(user: widget.user,)));
                            },
                            ),),

        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: mq.width*0.05 ),
          child: SingleChildScrollView(
            child: Column(children:[
                SizedBox(width: mq.width,height: mq.height*0.03),
                ClipRRect(
                  borderRadius: BorderRadius.circular(mq.height),
                  child: CachedNetworkImage(
                    width: mq.height*0.2,
                    height: mq.height*0.2,
                    fit: BoxFit.cover,
                    imageUrl: widget.user.image,
                    errorWidget: (context, url, error) => const CircleAvatar(child: Icon( Icons.person),),
                    ),
                ),

              //for adding some space
              SizedBox(height: mq.height*0.03),
              Text(widget.user.email,style: const TextStyle(color:Colors.black87,fontSize: 18),),
              //for adding some space
              SizedBox(height: mq.height*0.05),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Status: ',style: TextStyle(color: Colors.black87,fontWeight: FontWeight.w300,fontSize: 20),),
                  Text(widget.user.status,style: const TextStyle(color:Colors.black87,fontSize: 18),),
                ],
              ),
              SizedBox(height: mq.height*0.05),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Interests: ',style: TextStyle(color: Colors.black87,fontWeight: FontWeight.w300,fontSize: 20),),
                  Text(widget.user.interest,style: const TextStyle(color:Colors.black87,fontSize: 18),),
                ],
              ),
            ]),
          ),
        )
        ),
      ),
    );

    }



}
