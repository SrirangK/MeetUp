import 'dart:developer';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:MeetUp/apis/apis.dart';
import 'package:MeetUp/helper/my_date.dart';
import 'package:MeetUp/models/message.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gallery_saver/gallery_saver.dart';

import '../main.dart';
class MessegeCard extends StatefulWidget {
  const MessegeCard({Key? key, required this.message}) : super(key: key);

  final Message message;

  @override
  State<MessegeCard> createState() => _MessegeCardState();
}

class _MessegeCardState extends State<MessegeCard> {
  @override
  Widget build(BuildContext context) {
    bool isMe=APIS.user.uid==widget.message.fromId;
    return InkWell(
      onLongPress: (){
        _showBottomSheet(isMe);
      },
      child: isMe ? _greenmessage():_blueMessage() ,);

  }
//sender message
  Widget _blueMessage(){
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(
            child: Container(
              padding: const EdgeInsets.all(8),
              margin: EdgeInsets.symmetric(horizontal: mq.width*0.04,vertical: mq.height*0.01),
              decoration: BoxDecoration(color: Colors.blue.shade50,
                  borderRadius:
                  const BorderRadius.only(topLeft: Radius.circular(20),topRight: Radius.circular(20),bottomRight: Radius.circular(20))),

              child:
              widget.message.type==Type.text ?
                  Text(widget.message.msg,style: const TextStyle(fontSize: 25),
                  ):ClipRRect(
                    borderRadius: BorderRadius.circular(mq.height*0.03),
                    child: CachedNetworkImage(
                      // width: mq.height*0.06,
                      // height: mq.height*0.06,
                      // fit: BoxFit.cover,
                      imageUrl: widget.message.msg,
                      placeholder: (context,url)=>const CircularProgressIndicator(strokeWidth: 2,),
                      errorWidget: (context, url, error) => const Icon( Icons.image,size: 70,),),
                    ),
                  ),
            ),

          
          Padding(
            padding:  EdgeInsets.only(right: mq.width*0.04),
            child: Text(MyDateUtil.getFormattedTime(context: context, time: widget.message.sent),style:const TextStyle(color: Colors.black54),),
          )
        ] ,
      );

  }
//receiver
  Widget _greenmessage(){
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [


        Padding(
          padding:  EdgeInsets.only(left: mq.width*0.04),
          child: Text(MyDateUtil.getFormattedTime(context: context, time: widget.message.sent),
            style: const TextStyle(color: Colors.black54),),
        ),
        Flexible(
          child: Container(
            padding: const EdgeInsets.all(8),
            margin: EdgeInsets.symmetric(horizontal: mq.width*0.04,vertical: mq.height*0.01),
            decoration: BoxDecoration(color: Colors.green.shade100,
                borderRadius:
                const BorderRadius.only(topLeft: Radius.circular(20),topRight: Radius.circular(20),bottomLeft: Radius.circular(20))),


            child: widget.message.type==Type.text ?
                  Text(widget.message.msg,style:const  TextStyle(fontSize: 25),
                  ):ClipRRect(
                    borderRadius: BorderRadius.circular(mq.height*0.03),
                    child: CachedNetworkImage(
                      // fit: BoxFit.cover,
                      imageUrl: widget.message.msg,
                      placeholder: (context,url)=>const CircularProgressIndicator(strokeWidth: 2,),
                      errorWidget: (context, url, error) => const Icon( Icons.image,size: 70,),
                    ),
                  ),
          ),
        ),
      ],
    );
  }


  //BOTTOM SHEET FOR MESSAGE
  void _showBottomSheet(bool  isMe) {
    showModalBottomSheet(context: context,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20),topRight: Radius.circular(20))),
        builder: (_){
          return ListView(
            shrinkWrap: true,
            children: [
              Container(
                height: 4,
                margin: EdgeInsets.symmetric(vertical: mq.height*0.015,horizontal: mq.width*0.4),
                decoration:const BoxDecoration(color: Colors.grey),
              ),

              widget.message.type == Type.text ?
                  _OptionItem(icon: const Icon(Icons.copy,color: Colors.blue,size: 26,), name: 'Copy',
                      onTap: () async {
                          await Clipboard.setData(ClipboardData(text: widget.message.msg)).then((value){
                              Navigator.pop(context);
                          });
                  }):
                  _OptionItem(icon: const Icon(Icons.save,color: Colors.blue,size: 26,), name: 'Save image',
                      onTap: () async {
                        try{
                          await GallerySaver.saveImage(widget.message.msg,albumName: 'MeetUp').then((success) {
                            Navigator.pop(context);
                          });
                        }catch(e){
                          log('Error while saving:$e');
                        }
                  }
                  ),

              if(isMe)
              _OptionItem(icon: const Icon(Icons.delete_forever_rounded,color: Colors.red,size: 26,), name: 'Delete',
                  onTap: () async {await APIS.deleteMessage(widget.message).then((value){Navigator.pop(context);});})
            ],
          );
        });
  }
}
class _OptionItem extends StatelessWidget {
  final Icon icon;
  final String name;
  final VoidCallback onTap;
  const _OptionItem({required this.icon,required this.name,required this.onTap,});


    @override
    Widget build(BuildContext context){
    return InkWell(
      onTap: ()=>onTap(),
      child: Padding(
        padding:  EdgeInsets.only(left: mq.width*0.05,bottom: mq.height*0.025),
        child: Row(children: [icon,Flexible(child: Text('    $name',style:TextStyle(fontSize: 20),))
    ],),
      ),
    );
  }
}
