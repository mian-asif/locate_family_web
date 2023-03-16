import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:empty_widget/empty_widget.dart';
import 'package:flutter/material.dart';

import 'custom_widgets.dart';
class CategoryScreen extends StatefulWidget {
  const CategoryScreen({Key? key}) : super(key: key);

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
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
                  Navigator.pop(context);
                },
              ),
              FlatButton(
                color: Colors.green,
                textColor: Colors.white,
                child: const Text('OK'),
                onPressed: () {
                  Navigator.pop(context);
                  FirebaseFirestore.instance.collection('category').doc(id).
                  update({'name': textFieldController.text});
                  textFieldController.clear();
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
                  Navigator.pop(context);
                },
              ),
              FlatButton(
                color: Colors.green,
                textColor: Colors.white,
                child: const Text('OK'),
                onPressed: () {
                  Navigator.pop(context);
                  FirebaseFirestore.instance.collection('category').doc(id).delete();
                },
              ),

            ],
          );
        });
  }
  bool loading = true;
  loagingChange(){
    setState(() {
      loading=false;
    });

  }
  @override

  void initState() {
    Future.delayed(Duration(seconds: 1), (){
      print("Wait for 10 seconds");
      loagingChange();
    });
    // TODO: implement initState
    super.initState();
  }

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
    return Scaffold(
      body: loading?Center(child: CircularProgressIndicator()):  StreamBuilder<QuerySnapshot>(
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
      ),
    );
  }
}
