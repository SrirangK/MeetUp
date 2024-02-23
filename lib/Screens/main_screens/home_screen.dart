
import '../other_screens/all_users.dart';
import '../main_screens/profile_screen.dart';
import 'package:MeetUp/apis/apis.dart';
import 'package:MeetUp/widgets/chat_user_card.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../helper/dialogues.dart';
import '../../main.dart';
import '../../models/chat_user.dart';


class Homescreen extends StatefulWidget {
  const Homescreen({Key? key}) : super(key: key);

  @override
  State<Homescreen> createState() => _HomescreenState();
}


class _HomescreenState extends State<Homescreen> {

  List<ChatUser> _list = [];
  final List<ChatUser> _searchList=[];
  bool _isSearching=false;
  // static FirebaseFirestore firestore =FirebaseFirestore.instance;



  @override
  void initState(){
    super.initState();
    APIS.getSelfInfo();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: ()=>FocusScope.of(context).unfocus(),     //For hiding keyboard
      child: WillPopScope(
        //Making Back button work
        onWillPop: (){
          if(_isSearching){
            setState(() {
              _isSearching=!_isSearching;
            });
            return Future.value(false);
          }else{
            return Future.value(true);
          }
        },
        child: Scaffold(
          appBar: AppBar(
            leading: IconButton(onPressed: (){
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (_) => ProfileScreen(user:APIS.me)));
            }, icon: const Icon(Icons.account_circle_rounded),),

            title: _isSearching ?  TextField(
              decoration: const InputDecoration(
                  border: InputBorder.none,
                  hintText: 'Name,email..',
                  ),
              autofocus: true,
              style: const TextStyle(color: Colors.white,fontSize: 19),

              //To update search list
              onChanged:(val){
                _searchList.clear();
                for (var i in _list){
                  if(i.name.toLowerCase().contains(val.toLowerCase()) || i.email.toLowerCase().contains(val.toLowerCase())){
                    _searchList.add(i);
                  }
                  setState(() {
                    _searchList;
                  });
                }
              } ,
            )
            :const Text('MEETUP',style: TextStyle(fontFamily: 'Caveat'),),


            actions: [
              IconButton(onPressed: () {
                setState(() {
                  _isSearching= !_isSearching;
                });
              }, icon: Icon(_isSearching ? CupertinoIcons.clear_circled_solid:Icons.search)),

              IconButton(onPressed: () {
                _addChatUser();
              }
                  , icon: const Icon(Icons.person_add_outlined))
            ],),


          floatingActionButton: FloatingActionButton(
            onPressed: () {
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (_) =>const All_users()));
            },
            child: const Icon(Icons.people),
          ),

          body: StreamBuilder(
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
                      _list=data?.map((e) => ChatUser.fromJson(e.data())).toList() ??[];
                      // var hasuser=_list.length;
                      if (_list.isNotEmpty) {
                        return ListView.builder(
                            itemCount: _isSearching ? _searchList.length : _list.length,
                            padding: EdgeInsets.only(top: mq.height * 0.015),
                            itemBuilder: (context, index) {
                              return ChatUserCard(user:_isSearching ? _searchList[index] : _list[index]);
                            }
                        );
                      } else {
                        return const Center(child: Text('No connections found!',style: TextStyle(fontSize: 30,color: Colors.black),));
                      }
                  }
              );
            }
          })
        ),
      ),
    );
  }

  void _addChatUser(){
    String name='';
    showDialog(context: context,
        builder: (_)=>AlertDialog(
          contentPadding:  const EdgeInsets.only(left: 24,right: 24,top: 20,bottom: 10),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: const Row(
            children: [
              Icon(Icons.person_add,color: Colors.blue,size: 28,),
              Text(' Add user'),
            ],
          ),

          content: TextFormField(
            maxLines: null,
            onChanged: (value)=>name=value,
            decoration: InputDecoration(
              hintText: 'Name',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15)
              )
            ),
          ),
          actions: [
            MaterialButton(onPressed: (){
              Navigator.pop(context);
            },
            child: const Text('Cancel',style: TextStyle(color: Colors.red,fontSize: 16),),),
            MaterialButton(onPressed: () async {
              Navigator.pop(context);
              if(name.isNotEmpty){
                await APIS.addChatUser(name).then((value){
                  if(!value){
                    Dialogue.showsSnackbar(context, 'User does not Exists!');
                  }
                });
              }
            },
            child: const Text('ADD',style: TextStyle(color: Colors.blue,fontSize: 16),),)
          ],
        ));
  }
}
