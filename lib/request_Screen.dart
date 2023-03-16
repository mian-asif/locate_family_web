import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:empty_widget/empty_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:locate_web/request_details_screen.dart';

import 'custom_widgets.dart';
class RequestScreen extends StatefulWidget {
  const RequestScreen({Key? key}) : super(key: key);

  @override
  State<RequestScreen> createState() => _RequestScreenState();
}

class _RequestScreenState extends State<RequestScreen> {
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
      body:  StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('foodRequest').snapshots(),
        builder: (context, snapshot) {
          var snapm = snapshot.data?.docs.isNotEmpty;
          var snapt = snapshot.data?.docs.isEmpty;
          if (snapt == true ) {
            return Padding(
              padding:  EdgeInsets.all(cWidth*0.15),
              child: EmptyWidget(

                image: null,
                packageImage: PackageImage.Image_1,
                title: 'No Requests',
                // subTitle: 'You Have No Requests \n  yet',
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
      ),
    );
  }
}
