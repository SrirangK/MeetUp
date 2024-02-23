import 'package:MeetUp/apis/apis.dart';
import 'package:MeetUp/widgets/chat_user_card.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../main_screens/home_screen.dart';
import '../../main.dart';
import '../../models/chat_user.dart';


class All_users extends StatefulWidget {
  const All_users({Key? key}) : super(key: key);

  @override
  State<All_users> createState() => _All_usersState();
}


class _All_usersState extends State<All_users> {

  List<ChatUser> _list = [];
  final List<ChatUser> _searchList=[];
  bool _isSearching=false;
  var supplystream=APIS.getALLUsers();

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
            leading: IconButton(
              color: Colors.white,
              icon: const Icon(Icons.arrow_back),
              onPressed: (){
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (_) =>const Homescreen()));
              },
            ),

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
                  if(i.name.toLowerCase().contains(val.toLowerCase()) ||
                      i.email.toLowerCase().contains(val.toLowerCase()) ||
                        i.interest.toLowerCase().contains(val.toLowerCase())
                  ){
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


            ],

            ),

          body:StreamBuilder(
            stream:APIS.getALLUsers(),
            builder: (context, snapshot) {

              switch (snapshot.connectionState) {

              //if data is loading
                case ConnectionState.waiting:
                case ConnectionState.none:
                  return const Center(child: CircularProgressIndicator());
              //if some or all data is loaded
                case ConnectionState.active:
                case ConnectionState.done:
                  final data = snapshot.data?.docs;
                  _list=data?.map((e) => ChatUser.fromJson(e.data())).toList() ??[];

                  if(_list.isNotEmpty){
                    return ListView.builder(
                        itemCount: _isSearching ? _searchList.length : _list.length,
                        padding: EdgeInsets.only(top: mq.height * 0.015),
                        itemBuilder: (context, index) {
                          return ChatUserCard(user:_isSearching ? _searchList[index] : _list[index]);
                        }
                    );
                  }
                  else{
                    return const Center(child: Text('No connections found!',style: TextStyle(fontSize: 30,color: Colors.white),));}
              }
            },
          ),
        ),
      ),
    );
  }

  }

