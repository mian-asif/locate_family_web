import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';


// Login Text Field Widget
Widget loginTextField({controller, hintText,obscureText,}) {
  return TextField(
    obscureText: obscureText,
    controller: controller,
    decoration: InputDecoration(
        hintText: hintText,
        contentPadding: const EdgeInsets.all(15),
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10))),
    onChanged: (value) {
      // do something
    },
  );
}
Widget signInButton({onPressed,}) {
  return ElevatedButton(
      style: ElevatedButton.styleFrom(
          primary: const Color(0XFF378C5C), //background color of button
          // side: BorderSide(width:3, color:Color(0XFF116530)), //border width and color
          elevation: 3, //elevation of button
          shape: RoundedRectangleBorder( //to set border radius to button
              borderRadius: BorderRadius.circular(10)
          ),
          padding: const EdgeInsets.all(20) //content padding inside button
      ),
      onPressed:onPressed,
      child: const Text("Sign In",style: TextStyle(
        fontSize: 20,fontWeight: FontWeight.w500
      ),)
  );
}
Widget updateDeleteButton({onPressed,text,color,backColor}) {
  return      ElevatedButton(onPressed: onPressed, child: Text(text),
      style: ButtonStyle(
          backgroundColor:MaterialStateProperty.all(backColor) ,
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(

                  borderRadius: BorderRadius.circular(5),
                  side: BorderSide(color: color)
              )
          )
      )
  );
}
Widget updateDeleteButtonRequest({onPressed,text,color,backColor}) {
  return      ElevatedButton(onPressed: onPressed, child: Text(text),
      style: ButtonStyle(
          backgroundColor:MaterialStateProperty.all(backColor) ,
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(

                  borderRadius: BorderRadius.circular(5),
                  side: BorderSide(color: color)
              )
          )
      )
  );
}

Widget foodRequestCard(context, {seekerName, requestDate, viewPersons, photoURL, onPress}) {
  var cWidth = MediaQuery.of(context).size.width;
  var cHeight = MediaQuery.of(context).size.height;
  return Container(
    height: cHeight * 0.13,
    width: cWidth,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(10),
      color: const Color(0XFF378C5C),
    ),
    child: Row(
      children: [

      ],
    ),
  );
}
Widget detailsTextField(context, {tittle,controller,readOnly}) {
  var cWidth = MediaQuery.of(context).size.width;
  var cHeight = MediaQuery.of(context).size.height;
  return  Column(
mainAxisAlignment: MainAxisAlignment.start,
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      // Padding(
      //   padding:  EdgeInsets.only(left: cWidth*0.005,bottom: cHeight*0.004),
      //   child: Text(tittle,style: TextStyle(
      //     fontSize: 16,fontWeight: FontWeight.bold
      //   ),),
      // ),
      TextField(
        readOnly: readOnly,
        controller:controller ,
        decoration: InputDecoration(
          labelText: tittle,
          border: OutlineInputBorder(),
        ),
      ),
    ],
  );
}
Widget foodRequestAdmin(context, {tittle, description, onPress}) {
  var cWidth = MediaQuery.of(context).size.width;
  var cHeight = MediaQuery.of(context).size.height;
  return InkWell(
    onTap: onPress,
    child: Container(
      height: cHeight * 0.1,
      width: cWidth,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        // color: const Color(0XFF378C5C),
        color:  Colors.white,
      ),
      child: Row(

        children:  [
          Padding(
            padding: EdgeInsets.only(left: cWidth*0.04),
            child: const Text('Tittle:',style: TextStyle(
                fontWeight: FontWeight.bold,fontSize: 14
            )),
          ),
          Padding(
            padding: EdgeInsets.only(left: cWidth*0.04),
            child:  Container(
              width: cWidth*0.07,
              // color: Colors.green,
              child: Text(tittle,style: TextStyle(
                  fontWeight: FontWeight.w500,fontSize: 14
              )
              ,overflow: TextOverflow.ellipsis),
            ),
          ),
          Spacer(),
          Padding(
            padding: EdgeInsets.only(left: cWidth*0.04),
            child: const Text('Description:',style: TextStyle(
                fontWeight: FontWeight.bold,fontSize: 14
            )),
          ),
          Padding(
            padding: EdgeInsets.only(left: cWidth*0.04),
            child: SizedBox(
              height: cHeight,
              width: cWidth*0.3,
              child:  Center(
                child: Text(description,style: TextStyle(
                    fontWeight: FontWeight.w500,fontSize: 14
                ),overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
          ),

        ],
      ),

    ),
  );
}
