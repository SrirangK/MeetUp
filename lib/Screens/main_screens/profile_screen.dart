import 'package:cached_network_image/cached_network_image.dart';
import '../main_screens/home_screen.dart';
import 'package:MeetUp/apis/apis.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:image_picker/image_picker.dart';
import '../../helper/dialogues.dart';
import '../auth/login_screen.dart';
import '../../main.dart';
import '../../models/chat_user.dart';
import 'dart:io';

class ProfileScreen extends StatefulWidget {
  final ChatUser user;
  const ProfileScreen({Key? key, required this.user}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

_signOut () async{
  await APIS.auth.signOut();
  await GoogleSignIn().signOut();

}

class _ProfileScreenState extends State<ProfileScreen> {

  final _formKey=GlobalKey<FormState>();
  String? _image;
  var items= <String>['Sports', 'Dance', 'Anime', 'E-games','Art'];
  // String dropdownValue ='Dog' ;
  final TextEditingController _controller = new TextEditingController();

  @override
  Widget build(BuildContext context) {

    return GestureDetector(
      //for hiding keyboard
      onTap: ()=>FocusScope.of(context).unfocus(),
      
      child: WillPopScope(                     //Going back to home screen
        onWillPop: (){
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (_) =>const Homescreen()));
          return Future.value(false);
        },
        child: Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            title: const Text('Profile',style: TextStyle(color: Colors.black),),
            backgroundColor: Colors.white,
            leading: IconButton(
                        color: Colors.black,
                        icon: const Icon(Icons.arrow_back),
                        onPressed: (){
                            Navigator.pushReplacement(context,
                                MaterialPageRoute(builder: (_) =>const Homescreen()));
                            },
                            ),
              actions:[
                IconButton(onPressed: () {
                  _signOut();
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (_) => const Loginscreen()));
                }, icon: const Icon(Icons.logout,color: Colors.black,)
                )
          ]),

        body: Form(                       //To make fields necessary to fill
          key: _formKey,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: mq.width*0.05 ),
            child: SingleChildScrollView(
              child: Column(children:[
                  SizedBox(width: mq.width,height: mq.height*0.03),
                  Stack(
                    children: [
                      //profile picture
                      _image!=null ?
                      //local image
                      ClipRRect(
                        borderRadius: BorderRadius.circular(mq.height),
                        child: Image.file(
                          File(_image!),
                          width: mq.height*0.2,
                          height: mq.height*0.2,
                          fit: BoxFit.cover,
                        ),)
                          :
                          //image from server
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
                      Positioned(
                        bottom: -10,
                        right: 0,
                        child: MaterialButton(
                          elevation: 5,
                          onPressed: (){
                            _showBottomSheet();
                          },
                          color:Colors.white,
                          shape: const CircleBorder(),
                          child:const Icon(Icons.edit,color: Colors.blue,),),
                      )
                    ],
                  ),

                //for adding some space
                SizedBox(height: mq.height*0.03),
                Text(widget.user.email,style: const TextStyle(color:Colors.black38,fontSize: 16),),
                //for adding some space
                SizedBox(height: mq.height*0.05),

                TextFormField(
                  onSaved: (val)=>APIS.me.name=val ??'',
                  validator: (val)=> val != null && val.isNotEmpty ?null :'Name Required',
                  initialValue: widget.user.name,
                  decoration: InputDecoration(
                    prefixIcon:const Icon(Icons.person,color: Colors.blue,),
                    border:  OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
                    label: const Text('Name')
                )
                ),
                SizedBox(height: mq.height*0.02),

                TextFormField(
                    initialValue: widget.user.status,
                    onSaved: (val)=>APIS.me.status=val ??'',
                    decoration: InputDecoration(
                      prefixIcon:const Icon(Icons.info_outline,color: Colors.blue,),
                      border:  OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
                      label: const Text('Status')
                    )
                ),

                SizedBox(height: mq.height*0.03),

                TextFormField(
                    initialValue: widget.user.interest,
                    onSaved: (val)=>APIS.me.interest=val ??'',
                    validator: (val)=> val != null && val.isNotEmpty ?null :'Please provide your interests',
                    decoration: InputDecoration(
                        prefixIcon:const Icon(Icons.interests,color: Colors.blue,),
                        border:  OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
                        label: const Text('interest')
                    )
                ),

                ElevatedButton.icon(
                  onPressed: (){
                    if (_formKey.currentState!.validate()){
                      _formKey.currentState!.save();
                      APIS.updateUserInfo();
                      // Navigator.pop(context);
                      Dialogue.showsSnackbar(context, 'Updated');
                    }
                  },
                  icon:const Icon(Icons.edit),
                  label: const Text('Update'),)


              ]),
            ),
          ),
        )
        ),
      ),
    );

    }

//Change profile picture
void _showBottomSheet() {
    showModalBottomSheet(context: context,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(40),topRight: Radius.circular(40))),
        builder: (_){
          return ListView(
            shrinkWrap: true,
            padding: EdgeInsets.only(top: mq.height*0.03,bottom: mq.height*0.05),
            children: [
              const Text('Profile Picture',
                style: TextStyle(fontSize: 20),
                textAlign: TextAlign.center,),
              SizedBox(height: mq.height*0.02),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                   ElevatedButton(
                    onPressed: () async {
                      final ImagePicker picker = ImagePicker();
                      // Pick an image.
                      final XFile? image = await picker.pickImage(source: ImageSource.gallery,imageQuality: 80);
                      if (image!=null){
                        setState(() {
                          _image=image.path;
                        });
                        APIS.updateProfilePicture(File(_image!));
                        Navigator.pop(context);
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      fixedSize: Size(mq.width*0.2, mq.height*0.1),
                      shape:const CircleBorder()
                    ),
                    child: Image.asset('images/gallery .png')),

                ElevatedButton(
                    onPressed: () async {
                        final ImagePicker picker = ImagePicker();
                        // Pick an image.
                        final XFile? image = await picker.pickImage(source: ImageSource.camera,imageQuality: 80);
                        if (image!=null){
                            setState(() {
                              _image=image.path;
                            });
                            APIS.updateProfilePicture(File(_image!));
                            Navigator.pop(context);
                            }
                          },
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        fixedSize: Size(mq.width*0.2, mq.height*0.1),
                        shape:const CircleBorder()
                    ),
                    child: Image.asset('images/camera.png')),


              ],
              )
            ],
          );
        });
  }
}
