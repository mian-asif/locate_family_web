import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import 'custom_widgets.dart';
class RequestDetailsScreen extends StatefulWidget {
  const RequestDetailsScreen({Key? key}) : super(key: key);

  @override
  State<RequestDetailsScreen> createState() => _RequestDetailsScreenState();
}

class _RequestDetailsScreenState extends State<RequestDetailsScreen> {

  var tittle = Get.arguments[0];
  var description = Get.arguments[1];
  var category = Get.arguments[2];
  var seekerAddress = Get.arguments[3];
  var docID = Get.arguments[4];
  var seekerName = Get.arguments[5];
  var seekerEmail = Get.arguments[6];
TextEditingController tittleController = TextEditingController();
TextEditingController descriptionController = TextEditingController();
TextEditingController seekerAddressController = TextEditingController();
TextEditingController categoryController = TextEditingController();
TextEditingController seekerNameController = TextEditingController();
  @override
  void initState() {
    setState(() {
      tittleController.text = Get.arguments[0];
      descriptionController.text = Get.arguments[1];
      seekerAddressController.text = Get.arguments[3];
      seekerNameController.text = Get.arguments[5];
      categoryController.text = Get.arguments[2];
    });

    // TODO: implement initState
    super.initState();
  }
  CollectionReference users = FirebaseFirestore.instance.collection('foodRequest');
  Future<void> updateUser() {
    return users
        .doc(docID)
        .update(
        {
          'tittle': tittleController.text,
          'description': descriptionController.text,

        }
        )
        .then((value) => print("User Updated"))
        .catchError((error) => print("Failed to update user: $error"));
  }
  Future<void> deleteUser() {
    return users
        .doc(docID).delete()
        .then((value) => print(" Deleted"))
        .catchError((error) => print("Failed to update user: $error"));
  }

  @override
  Widget build(BuildContext context) {
    var cHeight = MediaQuery.of(context).size.height;
    var cWidth = MediaQuery.of(context).size.width;
    return Scaffold(

      body: Container(
            color: Colors.white,
            width: cWidth,
            height: cHeight,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding:  EdgeInsets.only(top: cHeight*0.08),
                  child: Container(
                    color: Colors.white,
                    width: cWidth*0.8,
                    height: cHeight*0.75,
                    child: Column(
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                                child:
                                Padding(
                                  padding:  EdgeInsets.only(left: cWidth*0.05,right: cWidth*0.1,top: cHeight*0.03),
                                  child: detailsTextField(context,tittle: "Tittle",
                                      controller: tittleController,readOnly: false

                                  ),
                                )),
                            Expanded(
                                child:
                                Padding(
                                  padding:  EdgeInsets.only(left: cWidth*0.05,right: cWidth*0.1,top: cHeight*0.03),
                                  child: detailsTextField(context,tittle: "Seeker Name",
                                      controller: seekerNameController,readOnly: false
                                  ),
                                )),
                          ],
                        ),
                        //Seeker Address & Email
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                                child:
                                Padding(
                                  padding:  EdgeInsets.only(left: cWidth*0.05,right: cWidth*0.1,top: cHeight*0.03),
                                  child: detailsTextField(context,tittle: "Seeker Address",
                                      controller: seekerAddressController,readOnly: true
                                  ),
                                )),
                            Expanded(
                                child:
                                Padding(
                                  padding:  EdgeInsets.only(left: cWidth*0.05,right: cWidth*0.1,top: cHeight*0.03),
                                  child: detailsTextField(context,tittle: "Category",
                                    controller: categoryController,readOnly: true
                                  ),
                                )),
                          ],
                        ),
                        //Description
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                                child:
                                Padding(
                                  padding:  EdgeInsets.only(left: cWidth*0.05,right: cWidth*0.1,top: cHeight*0.06),
                                  child:  TextFormField(
                                    controller: descriptionController,
                                    minLines: 6,
                                    maxLines: 6,
                                    keyboardType: TextInputType.multiline,
                                    decoration: InputDecoration(
                                      hintText: 'description',
                                      labelText: 'description',
                                      hintStyle: TextStyle(
                                          color: Colors.grey
                                      ),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.all(Radius.circular(10.0)),
                                      ),
                                    ),
                                  ),
                                )),

                          ],
                        ),
                      ],
                    )
                  ),
                ),
                //Buttons
                Padding(
                  padding:  EdgeInsets.only(top: cHeight*0.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Padding(
                        padding:  EdgeInsets.only(right: cWidth*0.02),
                        child: updateDeleteButton(onPressed: (){
                          updateUser();
                          Get.back();
                          // displayTextInputDialog(context,id);
                          // return
                          //
                        }
                            ,text: 'Update',color: Colors.blue,backColor: Colors.blue),
                      ),
                      Padding(
                        padding:  EdgeInsets.only(right: cWidth*0.02),
                        child: updateDeleteButton(onPressed: (){
                          deleteUser();
                          Get.back();
                          // deleteTextInputDialog(context,id);
                        },
                            text: 'Delete',color: Colors.red,backColor: Colors.red),
                      ),
                    ],
                  ),
                ),
              ],
            )

        ),
    );
  }
}
