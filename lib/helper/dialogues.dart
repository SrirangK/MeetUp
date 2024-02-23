import 'package:cached_network_image/cached_network_image.dart';
import 'package:MeetUp/models/chat_user.dart';
import 'package:flutter/material.dart';

import '../main.dart';

class Dialogue{
  static void showsSnackbar(BuildContext context,String msg){
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content:Text(msg),
    backgroundColor: Colors.grey));
  }

  static void showProgressbar (BuildContext context){
    showDialog(context: context, builder: (_) =>const Center(child: CircularProgressIndicator()));
  }
  
}
class ProfileDialog extends StatelessWidget {
  const ProfileDialog({Key? key, required this.user}) : super(key: key);
  final ChatUser user;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(backgroundColor: Colors.white.withOpacity(0.9),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
    content: SizedBox(width: mq.width*0.6,height: mq.height*0.35,
    child: Stack(
      children: [
          Positioned(
            width: mq.width*0.55,
              child: Text(user.name,style: TextStyle(fontSize: 20,fontWeight: FontWeight.w500),)),
          Align(
            alignment: Alignment.center,
            child: ClipRRect(
            borderRadius: BorderRadius.circular(mq.height*0.25),
            child: CachedNetworkImage(
              width: mq.height*0.27,
              height: mq.height*0.27,
              fit: BoxFit.cover,
              imageUrl: user.image,
              errorWidget: (context, url, error) => const CircleAvatar(child: Icon( Icons.person),),
            ),
    ),
          ),],),),);
  }
}
