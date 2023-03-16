import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
class AddCategoryScreen extends StatefulWidget {
  const AddCategoryScreen({Key? key}) : super(key: key);

  @override
  State<AddCategoryScreen> createState() => _AddCategoryScreenState();
}

class _AddCategoryScreenState extends State<AddCategoryScreen> {
  TextEditingController textFieldController =TextEditingController();
  TextEditingController textNewFieldController =TextEditingController();
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
  final categoryReference = FirebaseFirestore.instance.collection('category');
  @override
  Widget build(BuildContext context) {
    var cHeight= MediaQuery.of(context).size.height;
    var cWidth= MediaQuery.of(context).size.width;
    return Scaffold(
      body: Container(
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
      ),
    );
  }
}
