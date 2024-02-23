import 'package:cached_network_image/cached_network_image.dart';
import 'package:MeetUp/apis/apis.dart';
import 'package:MeetUp/helper/dialogues.dart';
import 'package:MeetUp/helper/my_date.dart';
import 'package:MeetUp/models/message.dart';
import 'package:flutter/material.dart';
import '../Screens/main_screens/chatscreen.dart';
import '../main.dart';
import '../models/chat_user.dart';
class ChatUserCard extends StatefulWidget {

  final ChatUser user;
  const ChatUserCard({Key? key, required this.user}) : super(key: key);

  @override
  State<ChatUserCard> createState() => _ChatUserCardState();
}

class _ChatUserCardState extends State<ChatUserCard> {

//Last message info
  Message? _message;
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: mq.width*0.03,vertical:3),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      color:Colors.white,
      child:InkWell(
        onTap: (){
          Navigator.push(context, MaterialPageRoute(builder: (_)=>ChatScreen(user: widget.user,)));
        },
        child:StreamBuilder(
          stream: APIS.getlastmessage(widget.user),
            builder:(context,snapshot){
              final data = snapshot.data?.docs;
              final list=data?.map((e) => Message.fromJson(e.data())).toList() ??[];

              if(list.isNotEmpty){
                _message=list[0];
              }
              return ListTile(

                //user image
                  leading: InkWell(
                    onTap: (){
                      showDialog(context: context, builder: (_)=>ProfileDialog(user: widget.user));
                    },

                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(mq.height),
                      child: CachedNetworkImage(
                        width: mq.height*0.063,
                        height: mq.height*0.065,
                        fit: BoxFit.cover,
                        imageUrl: widget.user.image,
                        errorWidget: (context, url, error) => const CircleAvatar(child: Icon( Icons.person),),
                      ),
                    ),
                  ),

                  title: Text(widget.user.name),
                  subtitle: Text(_message !=null ?
                  _message!.type==Type.image? 'image' :_message!.msg :' likes:${widget.user.interest}',maxLines: 1,),
                  trailing:_message==null ? null :

                      _message!.read.isEmpty && _message!.fromId !=APIS.user.uid?
                      Container(
                      width: 15,
                      height: 15,
                      decoration:BoxDecoration(
                        color: Colors.lightGreenAccent,
                        borderRadius: BorderRadius.circular(mq.height),)
                    ):Text(MyDateUtil.getlastmessegetime(context: context, time:_message!.sent)),
                  );

      })
      ),
      );
  }
}
