import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:empty_widget/empty_widget.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:locate_web/request_details_screen.dart';
import 'package:sidebarx/sidebarx.dart';

import 'add_category_screen.dart';
import 'custom_widgets.dart';

// void main() {
//   runApp(SidebarXExampleApp());
// }

class AdminDashboard extends StatelessWidget {
  AdminDashboard({Key? key}) : super(key: key);

  final _controller = SidebarXController(selectedIndex: 0, extended: true);
  final _key = GlobalKey<ScaffoldState>();


  @override
  Widget build(BuildContext context) {
    var cHeight= MediaQuery.of(context).size.height;
    var cWidth= MediaQuery.of(context).size.width;
    return MaterialApp(
      title: 'Locate Family',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: primaryColor,
        canvasColor: canvasColor,
        scaffoldBackgroundColor: scaffoldBackgroundColor,
        textTheme: const TextTheme(
          headlineSmall: TextStyle(
            color: Colors.white,
            fontSize: 46,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
      home: Builder(
        builder: (context) {
          final isSmallScreen = MediaQuery.of(context).size.width < 600;
          return Scaffold(
            key: _key,
            appBar: isSmallScreen
                ? AppBar(
              backgroundColor: canvasColor,
                    title: Text(_getTitleByIndex(_controller.selectedIndex)),
                 leading: IconButton(
                onPressed: () {
                  // if (!Platform.isAndroid && !Platform.isIOS) {
                  //   _controller.setExtended(true);
                  // }
                  _key.currentState?.openDrawer();
                },
                icon: const Icon(Icons.menu),
              ),
            )
                : null,
            drawer: ExampleSidebarX(controller: _controller),
            body: Row(
              children: [
                if (!isSmallScreen) ExampleSidebarX(controller: _controller),
                Expanded(
                  child: Center(
                    child: _ScreensExample(
                      controller: _controller,
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class ExampleSidebarX extends StatelessWidget {
  const ExampleSidebarX({
    Key? key,
    required SidebarXController controller,
  })  : _controller = controller,
        super(key: key);

  final SidebarXController _controller;

  @override
  Widget build(BuildContext context) {
    return SidebarX(
      controller: _controller,
      theme: SidebarXTheme(
        margin: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: canvasColor,
          borderRadius: BorderRadius.circular(20),
        ),
        hoverColor: scaffoldBackgroundColor,
        textStyle: TextStyle(color: Colors.black.withOpacity(0.7)),
        selectedTextStyle: const TextStyle(color: Colors.white),
        itemTextPadding: const EdgeInsets.only(left: 30),
        selectedItemTextPadding: const EdgeInsets.only(left: 30),
        itemDecoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: canvasColor),
        ),
        selectedItemDecoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: actionColor.withOpacity(0.37),
          ),
          gradient: const LinearGradient(
            colors: [accentCanvasColor, canvasColor],
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.28),
              blurRadius: 30,
            )
          ],
        ),
        iconTheme: IconThemeData(
          color: Colors.white.withOpacity(0.7),
          size: 20,
        ),
        selectedIconTheme: const IconThemeData(
          color: Colors.white,
          size: 20,
        ),
      ),
      extendedTheme: const SidebarXTheme(
        width: 200,
        decoration: BoxDecoration(
          color: Colors.white,
        ),
      ),
      footerDivider: divider,
      headerBuilder: (context, extended) {
        return SizedBox(
          height: 100,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Image.asset('assets/images/logoweb.png'),
          ),
        );
      },
      items: [
        SidebarXItem(
          icon: Icons.category,
          label: 'Category',
          onTap: () {
            debugPrint('Home');
          },
        ),

         const SidebarXItem(
          iconWidget: Icon(Icons.add,color: Colors.white),
          label: 'Add Category',
        ),
        const SidebarXItem(
          iconWidget: Icon(Icons.request_page,color: Colors.white),
          label: 'Requests',
        ),
      ],
    );
  }
}

class _ScreensExample extends StatefulWidget {
  const _ScreensExample({
    Key? key,
    required this.controller,
  }) : super(key: key);

  final SidebarXController controller;

  @override
  State<_ScreensExample> createState() => _ScreensExampleState();
}

class _ScreensExampleState extends State<_ScreensExample> {
  TextEditingController textFieldController =TextEditingController();
  TextEditingController textNewFieldController =TextEditingController();
  final categoryReference = FirebaseFirestore.instance.collection('category');
  Future<void> displayTextInputDialog(BuildContext context, id) async {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Update Category',style: TextStyle(fontSize: 20,
                fontWeight: FontWeight.bold)),
            content: TextField(
              controller: textFieldController,
              decoration: const InputDecoration(hintText: "Enter Category Name"),
            ),
            actions: <Widget>[
              FlatButton(
                color: Colors.red,
                textColor: Colors.white,
                child: const Text('CANCEL'),
                onPressed: () {
                  setState(() {
                    Navigator.pop(context);
                  });
                },
              ),
              FlatButton(
                color: Colors.green,
                textColor: Colors.white,
                child: const Text('OK'),
                onPressed: () {
                  setState(() {
                    Navigator.pop(context);
                    FirebaseFirestore.instance.collection('category').doc(id).
                    update({'name': textFieldController.text});
                    textFieldController.clear();
                  });
                },
              ),

            ],
          );
        });
  }
  Future<void> deleteTextInputDialog(BuildContext context, id) async {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Delete Category',style: TextStyle(fontSize: 20,
                fontWeight: FontWeight.bold)),
            actions: <Widget>[
              FlatButton(
                color: Colors.red,
                textColor: Colors.white,
                child: const Text('CANCEL'),
                onPressed: () {
                  setState(() {
                    Navigator.pop(context);
                  });
                },
              ),
              FlatButton(
                color: Colors.green,
                textColor: Colors.white,
                child: const Text('OK'),
                onPressed: () {
                  setState(() {
                    Navigator.pop(context);
                    FirebaseFirestore.instance.collection('category').doc(id).delete();
                  });
                },
              ),

            ],
          );
        });
  }
  Future<void> addCategory(String text) {
    // Call the user's CollectionReference to add a new user
    return categoryReference
        .add({
      'name':text ,
      'date':DateTime.now() ,
    })
        .then((value) => print("User Category"))
        .catchError((error) => print("Failed to add Category: $error"));
  }
  Future<void> displayTextInputDialogCategory(BuildContext context, text,) async {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Are you sure? \nYou want to save new category',style: TextStyle(fontSize: 15,
                fontWeight: FontWeight.w400)),
            // content: TextField(
            //   controller: textFieldController,
            //   decoration: const InputDecoration(hintText: "Enter Name"),
            // ),
            actions: <Widget>[
              FlatButton(
                color: Colors.red,
                textColor: Colors.white,
                child: const Text('CANCEL'),
                onPressed: () {
                  setState(() {
                    Navigator.pop(context);
                  });
                },
              ),
              FlatButton(
                color: Colors.green,
                textColor: Colors.white,
                child: const Text('OK'),
                onPressed: () {
                  setState(() {
                    Navigator.pop(context);
                    addCategory(text);
                    textNewFieldController.clear();
                  });
                },
              ),

            ],
          );
        });
  }
  bool loading =true;
  @override
  Widget build(BuildContext context) {
    var cHeight= MediaQuery.of(context).size.height;
    var cWidth= MediaQuery.of(context).size.width;
    final theme = Theme.of(context);
    bool isMobile(BuildContext context) =>
        MediaQuery.of(context).size.width < 600;
    bool isTab(BuildContext context) =>
        MediaQuery.of(context).size.width < 1100 &&
            MediaQuery.of(context).size.width >= 600;
    bool isDesktop(BuildContext context) =>
        MediaQuery.of(context).size.width >= 1100;
    return AnimatedBuilder(
      animation: widget.controller,
      builder: (context, child) {
        final pageTitle = _getTitleByIndex(widget.controller.selectedIndex);
        switch (widget.controller.selectedIndex) {
          case 0:
            return StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance.collection('category').snapshots(),
              builder: (context, snapshot) {
                var snapm = snapshot.data?.docs.isNotEmpty;
                var snapt = snapshot.data?.docs.isEmpty;
                if (snapt == true ) {
                  return Padding(
                    padding: const EdgeInsets.all(40.0),
                    child: EmptyWidget(

                      image: null,
                      packageImage: PackageImage.Image_1,
                      title: 'No Request',
                      subTitle: 'You Have No Requests \n  yet',
                      titleTextStyle: const TextStyle(
                        fontSize: 22,
                        color: Color(0xff9da9c7),
                        fontWeight: FontWeight.w500,
                      ),
                      subtitleTextStyle: const TextStyle(
                        fontSize: 14,
                        color: Color(0xffabb8d6),
                      ),
                    ),
                  ) ;
                }
                else if(snapm == true ) {
                  return SingleChildScrollView(
                    child: SizedBox(
                      height: cHeight,
                      width: cWidth,
                      child:  ListView.builder(
                        // scrollDirection: Axis.horizontal,
                        //   physics: NeverScrollableScrollPhysics(),
                          itemCount: snapshot.data!.docs.length,
                          itemBuilder: (context, index) {
                            DocumentSnapshot doc = snapshot.data!.docs[index];
                            var  name = (doc['name']);
                            // var  Time = (doc['date']);
                            var  id = (doc.id);

                            return Padding(
                              padding:  EdgeInsets.only(left: MediaQuery.of(context).
                              size.width*0.08,right: MediaQuery.of(context).size.width*0.08
                                  ,bottom:MediaQuery.of(context).size.height*0.0,
                                  top:MediaQuery.of(context).size.height*0.03  ),
                              child: Container(
                                  height: cHeight * 0.13,
                                  width: cWidth,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    // color: const Color(0XFF378C5C),
                                    color:  Colors.white,
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                    isMobile(context)? Container():isTab(context)?Padding(
                                      padding: EdgeInsets.only(left: cWidth*0.03,top: cHeight*0.01),
                                      child: const Text('Name:',style: TextStyle(fontWeight: FontWeight.w600,color: Colors.indigo),),
                                    ):Padding(
                                        padding: EdgeInsets.only(left: cWidth*0.03,top: cHeight*0.01),
                                        child: const Text('Category Name:',style: TextStyle(fontWeight: FontWeight.w600,color: Colors.indigo),),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(left: cWidth*0.03,top: cHeight*0.01),
                                        child: Container(
                                          // color: Colors.green,
                                          width: cWidth*0.13,
                                          child: Text(name,style: TextStyle(fontWeight:
                                          FontWeight.bold,color: Colors.black,
                                              fontStyle: FontStyle.italic

                                          ),overflow: TextOverflow.ellipsis,),
                                        ),
                                      ),
                                      Row(
                                        children: [
                                          Padding(
                                            padding:  EdgeInsets.only(right: cWidth*0.01),
                                            child: updateDeleteButton(onPressed: (){
                                              displayTextInputDialog(context,id);
                                              // return
                                              //
                                            }
                                                ,text: 'Update',color: Colors.blue,backColor: Colors.blue),
                                          ),
                                          Padding(
                                            padding:  EdgeInsets.only(right: cWidth*0.01),
                                            child: updateDeleteButton(onPressed: (){
                                              deleteTextInputDialog(context,id);
                                            },
                                                text: 'Delete',color: Colors.red,backColor: Colors.red),
                                          ),
                                        ],
                                      )
                                    ],
                                  )
                              ),
                            );
                          }),
                    ),
                  );
                }
                else {

                  return const Center(
                    child:
                      Text('Loading...')
                  ) ;
                }
              },
            );
          case 1:
            return Container(
              decoration: const BoxDecoration(
                backgroundBlendMode: BlendMode.dstATop,
                // image: DecorationImage(image: AssetImage('assets/images/admin.png'),fit: BoxFit.cover,repeat: ImageRepeat.repeat),
                color: Colors.indigo
              ),
              width: cWidth,
              height: cHeight,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding:  EdgeInsets.only(left: cWidth*0.25,right: cWidth*0.25),
                    child: SizedBox(
                      height: cHeight*0.07,
                      child: TextField(
                        textAlignVertical: TextAlignVertical.center,
                        controller: textNewFieldController,
                        decoration: InputDecoration(

                            border: OutlineInputBorder(

                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            filled: true,
                            hintStyle: TextStyle(color: Colors.grey[800],fontSize: 13),
                            hintText: "Add Name",
                            fillColor: Colors.white),
                      ),
                    ),
                  ),
                  Padding(
                    padding:  EdgeInsets.only(top: cHeight*0.12),
                    child: SizedBox(
                        height:cHeight*0.07, //height of button
                        width:cWidth*0.15, //width of button
                        child:ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                primary: Colors.white, //background color of button//border width and color
                                elevation: 7, //elevation of button
                                shape: RoundedRectangleBorder( //to set border radius to button
                                    borderRadius: BorderRadius.circular(10)
                                ),
                                // padding: EdgeInsets.all(20) //content padding inside button
                            ),
                            onPressed: (){
                              displayTextInputDialogCategory(context,textNewFieldController.text);
                            },
                            child: const Text("Save",style: TextStyle(color: Colors.green,fontWeight: FontWeight.bold),)
                        )
                    ),
                  )
                ],
              ),
            );
          case 2:
            return StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance.collection('foodRequest').snapshots(),
              builder: (context, snapshot) {
                var snapm = snapshot.data?.docs.isNotEmpty;
                var snapt = snapshot.data?.docs.isEmpty;
                if (snapt == true ) {
                  return Padding(
                    padding: const EdgeInsets.all(40.0),
                    child: EmptyWidget(

                      image: null,
                      packageImage: PackageImage.Image_1,
                      title: 'No Request',
                      subTitle: 'You Have No Requests \n  yet',
                      titleTextStyle: const TextStyle(
                        fontSize: 22,
                        color: Color(0xff9da9c7),
                        fontWeight: FontWeight.w500,
                      ),
                      subtitleTextStyle: const TextStyle(
                        fontSize: 14,
                        color: Color(0xffabb8d6),
                      ),
                    ),
                  ) ;
                }
                else if(snapm == true ) {
                  return SingleChildScrollView(
                    child: SizedBox(
                      height: cHeight,
                      width: cWidth,
                      child:  ListView.builder(
                        // scrollDirection: Axis.horizontal,
                        //   physics: NeverScrollableScrollPhysics(),
                          itemCount: snapshot.data!.docs.length,
                          itemBuilder: (context, index) {
                            DocumentSnapshot doc = snapshot.data!.docs[index];
                            var  tittle = (doc['tittle']);
                            var  description = (doc['description']);
                            // var  donationType = (doc['donationType']);
                            var  date = (doc['Date']);
                            var  personView = (doc['personView']);
                            var  seekerAddress = (doc['seekerAddress']);
                            var  seekerName = (doc['seekerName']);
                            var  seekerEmail = (doc['seekerEmail']);
                            var  category = (doc['category']);
                            var  id = (doc.id);

                            return Padding(
                              padding:  EdgeInsets.only(left: MediaQuery.of(context).
                              size.width*0.08,right: MediaQuery.of(context).size.width*0.08
                                  ,bottom:MediaQuery.of(context).size.height*0.0,
                                  top:MediaQuery.of(context).size.height*0.03  ),
                              child: foodRequestAdmin(context,
                                description: description,onPress: (){
                                Get.to(const RequestDetailsScreen(),arguments: [tittle,description,category,seekerAddress,id,seekerName,seekerEmail]);
                                  },tittle: tittle
                              ),
                            );
                          }),
                    ),
                  );
                }
                else {

                  return const Center(
                      child:
                      Text('Loading...')
                  ) ;
                }
              },
            );
          default:
            return Text(
              pageTitle,
              style: theme.textTheme.headlineSmall,
            );
        }
      },
    );
  }
}

String _getTitleByIndex(int index) {
  switch (index) {
    case 0:
      return 'Home';
    case 1:
      return 'Add Category';
    case 2:
      return 'Notification';
    case 3:
      return 'Add Category';
    case 4:
      return 'Custom iconWidget';
    case 5:
      return 'Profile';
    case 6:
      return 'Settings';
    default:
      return 'Not found page';
  }
}

const primaryColor = Color(0xFF685BFF);
const canvasColor = Color(0XFF378C5C);
const scaffoldBackgroundColor = Color(0XFF378C5C);
const accentCanvasColor = Color(0XFF378C5C);
const white = Colors.white;
final actionColor = const Color(0xFF5F5FA7).withOpacity(0.6);
final divider = Divider(color: white.withOpacity(0.3), height: 1);