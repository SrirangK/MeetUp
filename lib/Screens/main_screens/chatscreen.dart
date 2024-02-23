  import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:MeetUp/models/chat_user.dart';
import 'package:MeetUp/widgets/messege_card.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../apis/apis.dart';
import '../../main.dart';
import '../../models/message.dart';
import '../../widgets/chat_user_card.dart';
import '../other_screens/view_profile.dart';
import 'home_screen.dart';

class ChatScreen extends StatefulWidget {

  final ChatUser user;
  const ChatScreen({Key? key, required this.user}) : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final List<ChatUser> _searchList=[];
  bool _isSearching=false;
//for storing messeges
  List<Message> _list=[];
  List<ChatUser> _list1 = [];
  final _textController=TextEditingController();
  bool _showEmogi=false;
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: (){
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (_) =>const Homescreen()));
        return Future.value(false);
      },
      child: GestureDetector(
        onTap: ()=>FocusScope.of(context).unfocus(),
        child: SafeArea(
          child: WillPopScope(
            onWillPop: (){
              if(_showEmogi){
                setState(() {
                  _showEmogi=!_showEmogi;
                });
                return Future.value(false);
              }else{
                return Future.value(true);
              }
            },
            child: Scaffold(
              appBar: AppBar(
                automaticallyImplyLeading: false,
                flexibleSpace: _appBar(),
              ),

              body: Column(children:[
                Expanded(
                  child: StreamBuilder(
                    stream:APIS.getALLMesseges(widget.user),
                    builder: (context, snapshot) {

                      switch (snapshot.connectionState) {

                      //if data is loading
                        case ConnectionState.waiting:
                        case ConnectionState.none:
                          return const SizedBox();
                      //if some or all data is loaded
                        case ConnectionState.active:
                        case ConnectionState.done:
                          final data = snapshot.data?.docs;
                          _list=data?.map((e) => Message.fromJson(e.data())).toList() ??[];

                          if(_list.isNotEmpty){
                            return ListView.builder(
                              reverse: true,
                                itemCount: _list.length,
                                padding: EdgeInsets.only(top: mq.height * 0.015),
                                itemBuilder: (context, index) {
                                  return MessegeCard(message: _list[index]);
                                }
                            );
                          }
                          else{
                            return const Center(child: Text('Say hi!!🤝',style: TextStyle(fontSize: 30,color: Colors.black),));
                          }
                      }
                    },
                  ),
                ),
                _chatinput(),
              if(_showEmogi)
                SizedBox(
                    height: mq.height*0.35,
                    child: EmojiPicker(
                    textEditingController: _textController,
                    config: Config(
                    columns: 7,
                    emojiSizeMax: 32 * (Platform.isIOS ? 1.30 : 1.0),

                    ),
                    ),
                )]
              ),
            ),
          ),
        ),
      ),
    );
  }
  Widget _appBar(){
    return InkWell(
      onTap: (){
        Navigator.push(context, MaterialPageRoute(builder: (_)=>ViewProfileScreen(user: widget.user)));
      },
      child: Row(children: [
        IconButton(
            onPressed: (){
              Navigator.push(context, MaterialPageRoute(builder: (_)=>Homescreen()));
            },
            icon:const Icon(Icons.arrow_back,color: Colors.white,)),

        ClipRRect(
          borderRadius: BorderRadius.circular(mq.height),
          child: CachedNetworkImage(
            width: mq.height*0.06,
            height: mq.height*0.06,
            fit: BoxFit.cover,
            imageUrl: widget.user.image,
            errorWidget: (context, url, error) => const CircleAvatar(child: Icon( Icons.person),),
          ),
        ),

        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
          Padding(
            padding: const EdgeInsets.only(left: 8.0,bottom: 1),
            child: Text(widget.user.name,style: const TextStyle(color: Colors.white,fontSize: 23),),
          ),


          ],)
      ],),
    );
  }

  Widget _chatinput(){
    return Padding(
      padding:  EdgeInsets.symmetric(vertical: mq.height*0.01),
      child: Row(
        children: [
          Expanded(
            child: Card(
              color: Colors.white70,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
              child: Row(
                children: [
                  //emogi buttton
                IconButton(
                  onPressed: (){
                    FocusScope.of(context).unfocus();
                    setState(() {
                      _showEmogi=!_showEmogi;
                    });
                  },
                  icon:const Icon(Icons.emoji_emotions,color: Colors.blueAccent,),),

                Expanded(child: TextField(
                  controller: _textController,
                  keyboardType: TextInputType.multiline,
                  maxLines: null,
                  onTap: (){
                    setState(() {
                      if(_showEmogi==true)
                      _showEmogi=!_showEmogi;
                    });
                  },
                  decoration: const InputDecoration(
                    hintText: 'Type...',
                    border: InputBorder.none,
                  ),
                  autofocus: true,
                )
                ),
                //pick image from gallery
                IconButton(
                    onPressed: () async {
                      final ImagePicker picker = ImagePicker();
                      // Pick an image.
                      final List<XFile> images = await picker.pickMultiImage(imageQuality: 70);
                      for(var i in images){
                        await APIS.sendChatImage(widget.user,File(i.path));
                      }
                    },
                    icon:const Icon(Icons.image,color: Colors.blueAccent,)),
                //image from camera
                IconButton(
                    onPressed: () async {
                      final ImagePicker picker = ImagePicker();
                      // Pick an image.
                      final XFile? image = await picker.pickImage(source: ImageSource.camera,imageQuality: 70);
                      if (image!=null){
                        await APIS.sendChatImage(widget.user,File(image.path));
                      }
                    },
                    icon:const Icon(Icons.camera_alt,color: Colors.blueAccent,)),
              ]
              ),
            ),
          ),

          MaterialButton(shape:CircleBorder(),
            minWidth: 0,
            padding: EdgeInsets.zero,
            onPressed: (){
            if(_textController.text.isNotEmpty){
              if(_list.isEmpty){
                APIS.sendFirstmessage(widget.user, _textController.text,Type.text);
                _textController.text='';
                APIS.addChatUser(widget.user.name);
                // APIS.getmyUserId();
                StreamBuilder(
                    stream:APIS.getmyUserId() ,
                    builder: (context,snapshot){
                      switch (snapshot.connectionState) {
                      //if data is loading
                        case ConnectionState.waiting:
                        case ConnectionState.none:
                        // return const Center(child: CircularProgressIndicator());
                        //if some or all data is loaded
                        case ConnectionState.active:
                        case ConnectionState.done:
                          return StreamBuilder(
                              stream:APIS.getUsersid(snapshot.data?.docs.map((e) => e.id).toList() ??[]),
                              builder: (context, snapshot) {
                                final data = snapshot.data?.docs;
                                _list1=data?.map((e) => ChatUser.fromJson(e.data())).toList()??[];
                                if(_list.isNotEmpty){
                                  return ListView.builder(
                                      itemCount: _isSearching ? _searchList.length : _list.length,
                                      padding: EdgeInsets.only(top: mq.height * 0.015),
                                      itemBuilder: (context, index) {
                                        return ChatUserCard(user:_isSearching ? _searchList[index] : _list1[index]);
                                      }
                                  );
                                }
                                else{
                                  return const Center(child: Text('No connections found!',style: TextStyle(fontSize: 30,color: Colors.white),));
                                }
                              }
                          );
                      }
                    });
                    }else{
              APIS.sendMessege(widget.user, _textController.text,Type.text);
              _textController.text='';
            }}
            },
            child: Icon(Icons.send,color: Colors.blueAccent,size: 30,),)
        ],
      ),
    );
    
  }
}
