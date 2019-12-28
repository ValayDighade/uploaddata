import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';


class FresherPost extends StatefulWidget {
  @override
  _FresherPostState createState() => _FresherPostState();
}

class _FresherPostState extends State<FresherPost> {
  TextEditingController companyName=new TextEditingController();
  TextEditingController experience=new TextEditingController();
  TextEditingController location=new TextEditingController();
  TextEditingController position=new TextEditingController();
  TextEditingController salary=new TextEditingController();
  TextEditingController description=new TextEditingController();
  TextEditingController batch=new TextEditingController();
  TextEditingController applyLink=new TextEditingController();
  final _formKey = GlobalKey<FormState>();
  List<String> someImages=List<String>();
  String category;



  ////
  String fileName = "";
  File sampleImage;

  String url,blankURL;
  StorageReference storageRef;
  StorageUploadTask uploadTask;
  StorageTaskSnapshot downloadUrl;
  var formatter_date;
  String formatted;
  DateTime myDateTime;
  final db = Firestore.instance;
  var compressImg;

  File tempImage;
  bool _saving = false;
  List<String> _locations = ['Walk_In','Fresher', 'Experience', 'Internship', 'Goverment']; // Option 2
  String _selectedLocation; // Opti
  DateTime firstdate;
  var firstConvertedDate;

  /*Future _selectStartDate() async {
    DateTime picked = await showDatePicker(
        context: context,
        initialDate: new DateTime.now(),
        firstDate: new DateTime(2019),
        lastDate: new DateTime(2022));
    if (picked != null) {
      setState(() {
        *//*_value = picked.toString();
           var formattedDate = "${_value.day}-${date.month}-${date.year}";*//*
        firstdate = picked;
        firstConvertedDate = "${firstdate.day}-${firstdate.month}-${firstdate.year}";
      });
    }

    print(firstConvertedDate);
  }*/


  @override
  Widget build(BuildContext context) {


    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text("SEND JOBS")),
      ),
      body: ModalProgressHUD(
          inAsyncCall: _saving,
          opacity: 0.5,
          progressIndicator: SpinKitFadingCircle(
            color: Colors.green,
            size: 100,
          ),
          dismissible: false,


          child:SingleChildScrollView(
          child: Stack(
            children: <Widget>[
              Form(
                key: _formKey,
                child: Column(
                  //mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    /*Padding(
                      padding:  EdgeInsets.only(top:h/22,left: w/30),
                      child: Row(
                        children: <Widget>[
                          Padding(
                            padding:  EdgeInsets.only(left:w/30,),
                            child: InkWell(
                              onTap: ()
                              {
                                _selectStartDate();
                              },
                              child: Container(
                                height: 30,
                                width: 140,
                                decoration: BoxDecoration(
                                    border: Border.all(width: 1)
                                ),
                                child: Row(
                                  children: <Widget>[
                                    Icon(Icons.date_range,color: Colors.blueAccent,
                                      size:25,),
                                    new Center(
                                      child: new Text('POST DATE'),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding:  EdgeInsets.only(left:w/40),
                            child: Container(
                                height: h/18,
                                width: w/2.2,
                                decoration: BoxDecoration(
                                  border: Border(
                                    bottom: BorderSide(
                                      //                   <--- left side
                                      color: Colors.black,
                                      width: 1,
                                    ),
                                  ),
                                ),
                                child: Center(
                                    child: firstConvertedDate != null
                                        ? new Text(firstConvertedDate,
                                      style:TextStyle(fontSize: h/50) ,
                                    )
                                        : Text(""))),
                          ),

                        ],
                      ),
                    ),*/

                    Padding(
                      padding: EdgeInsets.only(
                        top: h / 40,
                        right: 20,left: 20
                      ),
                      child: Container(
                        height: h / 18,
                        width: w / 1.1,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5) ,
                          border: Border.all(width:0.5)
                        ),
                        child: DropdownButtonHideUnderline(
                          child: ButtonTheme(
                            alignedDropdown: true,
                            child:  DropdownButton(
                              hint: Text('Choose Job Category'), // Not necessary for Option 1
                              value: _selectedLocation,
                              onChanged: (newValue) {
                                setState(() {
                                  _selectedLocation = newValue;
                                });
                              },
                              items: _locations.map((location) {
                                return DropdownMenuItem(
                                  child: new Text(location),
                                  value: location,
                                );
                              }).toList(),
                            ),

                          ),
                        ),
                      ),
                    ),


                    Padding(
                      padding: EdgeInsets.only(left: 20,right: 20,top: 10),
                      child: TextFormField(

                        controller: companyName,
                        decoration: InputDecoration(
                          contentPadding: new EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
                          labelText: "Enter Company Name",
                          border: new OutlineInputBorder(
                            borderSide: new BorderSide(color: Colors.teal),

                          ),
                        ),
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Please enter some text';
                          }
                          return null;
                        },
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 20,right: 20,top:10),
                      child: TextFormField(
                        controller: experience,
                        decoration: InputDecoration(
                          labelText: "Enter Experience",
                          contentPadding: new EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
                          border: new OutlineInputBorder(
                              borderSide: new BorderSide(color: Colors.teal)
                          ),
                        ),
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Please enter Experience';
                          }
                          return null;
                        },
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 20,right: 20,top: 10),
                      child: TextFormField(
                        controller: batch,
                        keyboardType: TextInputType.number,

                        decoration: InputDecoration(
                          contentPadding: new EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
                          labelText: "Enter Batch",
                          border: new OutlineInputBorder(
                              borderSide: new BorderSide(color: Colors.teal)
                          ),
                        ),
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Please enter Batch';
                          }
                          return null;
                        },
                      ),
                    ),

                    Padding(
                      padding: EdgeInsets.only(left: 20,right: 20,top: 10),
                      child: TextFormField(
                        controller: position,
                        decoration: InputDecoration(
                          contentPadding: new EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
                          labelText: "Enter Position",
                          border: new OutlineInputBorder(
                              borderSide: new BorderSide(color: Colors.teal)
                          ),
                        ),
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Please enter some text';
                          }
                          return null;
                        },
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 20,right: 20,top: 10),
                      child: TextFormField(
                        controller: location,
                        decoration: InputDecoration(
                          contentPadding: new EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
                          labelText: "Enter Location",
                          border: new OutlineInputBorder(
                              borderSide: new BorderSide(color: Colors.teal)
                          ),
                        ),
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Please enter Location';
                          }
                          return null;
                        },
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 20,right: 20,top: 10),
                      child: TextFormField(
                        controller: salary,
                        keyboardType:TextInputType.numberWithOptions(),
                        decoration: InputDecoration(
                          contentPadding: new EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
                          labelText: "Enter Salary",
                          border: new OutlineInputBorder(
                              borderSide: new BorderSide(color: Colors.teal)
                          ),
                        ),
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Please enter some text';
                          }
                          return null;
                        },
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 20,right: 20,top: 10),
                      child: TextFormField(

                        controller: applyLink,
                        maxLines: 2,
                        decoration: InputDecoration(
                          contentPadding: new EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
                          labelText: "Add Apply Link",
                          border: new OutlineInputBorder(
                            borderSide: new BorderSide(color: Colors.teal),

                          ),
                        ),
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Please enter some text';
                          }
                          return null;
                        },
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 20,right: 20,top: 10),
                      child: TextFormField(
                        maxLines: 3,
                        controller: description,
                        maxLength:700,
                        decoration: InputDecoration(
                          contentPadding: new EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
                          labelText: "Enter description",
                          border: new OutlineInputBorder(
                              borderSide: new BorderSide(color: Colors.teal)
                          ),
                        ),
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Please enter some text';
                          }
                          return null;
                        },
                      ),
                    ),
                    Row(
                      children: <Widget>[
                        Expanded(
                          child: Padding(
                            padding: EdgeInsets.only(top: h / 50,),
                            child: GestureDetector(
                              onTap: () {
                                getImage();
                              },
                              child: Container(
                                  height: h/13,
                                  width: w/13,
                                  child: Image.asset(
                                      "images/folder.png")),
                            ),
                          ),
                          flex: 1,
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(
                                top: 15, left: 10, right: 10),
                            child: Container(
                              height: h / 8,
                              width: w/2,
                              child: tempImage == null
                                  ? Text("No Image Selected")
                                  : new Image.file(tempImage),
                            ),
                          ),
                          flex: 5,
                        ),
                      ],
                    ),

                    Padding(
                      padding: EdgeInsets.only(left: 20,right: 20,top:10,bottom: 20),
                      child: SizedBox(
                        height:40,
                        width: 400,
                        child: Material(
                          elevation: 2,

                          child: RaisedButton(
                            color: Colors.green,
                            onPressed: (){
                              _submit();
                            },
                            child: Text("Submit",style: TextStyle(color: Colors.white),),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              )


            ],
          ),
        )

      ),
    );
  }

  void _submit() {

    /*setState(() {
      _saving = true;
      _Validator();
      print("trueeeeeee");
    });*/

    //Simulate a service call
    print('submitting to backend...');
    new Future.delayed(new Duration(microseconds: 100), () {

      setState(() {
        print("falseeeee");
        _saving=true;
        _Validator();
        // _sendToServer();
      });
    });
  }



  _Validator()
  {
    if (_formKey.currentState.validate()) {

      if(tempImage==null)
        {
          Fluttertoast.showToast(
              msg: "Select Image",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.CENTER,
              timeInSecForIos: 1,
              backgroundColor: Colors.red,
              textColor: Colors.white,
              fontSize: 16.0
          );
          _saving=false;
        }
      else if(_selectedLocation==null)
        {
          Fluttertoast.showToast(
              msg: "Select Type",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.CENTER,
              timeInSecForIos: 1,
              backgroundColor: Colors.red,
              textColor: Colors.white,
              fontSize: 16.0
          );
          _saving=false;
        }
     /* else if(firstConvertedDate==null)
        {
          Fluttertoast.showToast(
              msg: "Select Date",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.CENTER,
              timeInSecForIos: 1,
              backgroundColor: Colors.red,
              textColor: Colors.white,
              fontSize: 16.0
          );
          _saving=false;
        }*/
      else{
        _saving=true;

        upload();

    }
    }
    else{
      _saving=false;
      print("add all");
      //_addData();
    }
  }

  _addData()
  {
    var now = new DateTime.now();
    formatter_date = new DateFormat('dd-MM-yyyy');
    String activityCreatedDate = formatter_date.format(now);
    print(activityCreatedDate + "dateprint");
    if(url!=null)
      {
        _saving = true;

        Firestore.instance
            .collection('JobPortal')
            .add({
          "Date": activityCreatedDate,
          "CompanyName": companyName.text,
          "Experience": experience.text,
          "Location": location.text,
          "Batch": batch.text,
          "Position": position.text,
          "Salary": salary.text,
          "Description": description.text,
          "ImageURL":url,
          "ApplyLink":applyLink.text,
          "Type":_selectedLocation
        }).then((_){

          getfcm();

          companyName.text="";
          experience.text="";
          location.text="";
          position.text="";
          salary.text="";
          description.text="";
          batch.text="";
          applyLink.text="";
          tempImage=null;


          // Navigator.of(context).pop();

          _showDialog();
        });
      }
    else{
      Fluttertoast.showToast(
          msg: "URL is Empty",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIos: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0
      );
    }




  }

  Future getImage() async {
    tempImage = await ImagePicker.pickImage(source: ImageSource.gallery)
        .whenComplete(() {
      setState(() {});
    });

    fileName = (tempImage.path);

    print("///abcd////");
    print(fileName);

    /* final tempDir = await getTemporaryDirectory();
    final path = tempDir.path;

    //compress image code
    Img.Image image = Img.decodeImage(tempImage.readAsBytesSync());
    Img.Image smallerImg = Img.copyResize(image, width: 500);

    compressImg = new File(fileName)
      ..writeAsBytesSync(Img.encodeJpg(smallerImg, quality: 85));

    setState(() {
      sampleImage = compressImg;
    });

    print("///////////////////////////////////");
    print(sampleImage);*/


  }

  ///////uplod to db

  upload() {
    print(fileName + ":    gotfilename");

    if (fileName.isEmpty) {
      _Validator();
    } else {
      _saving = true;
      print("come in else block");
      StorageReference storageReference =
      FirebaseStorage.instance.ref().child(fileName);
      uploadTask = storageReference.putFile(tempImage);
      return getURL();
    }
  }

  //////getURl

  getURL() {
    _saving = true;
    uploadTask.onComplete.then((s) async {
      var dowurl = await (await uploadTask.onComplete).ref.getDownloadURL();
      url = dowurl;

      print(url);

      if (url.isNotEmpty) {
        return _addData();
      }
    });
  }

  void _showDialog() {
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: Center(child: new Text("SUCCESS")),
          content: new Text("Data Added"),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            Center(
              child: new FlatButton(
                child: new Text("Ok"),
                onPressed: () {

                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => FresherPost()),
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }




  Future<void>getfcm() async{

    final postUrl = 'https://fcm.googleapis.com/fcm/send';

       final data = {
      "notification": {"body": "hiii", "title": 'homework'},

      "priority": "high",
      "data": {
        "click_action": "FLUTTER_NOTIFICATION_CLICK",
        "id": "1",
        "status": "done",
        "sound": 'default',
      },
      "to": "/topics/jobs"
    };

    final headers = {
      'content-type': 'application/json',
      'Authorization': 'AAAAj3OSd0w:APA91bGge3sadAg6ipPZEZyqPElHjMDtXDoeyh2uB8TEarcGs7vAsrvDWULg_3i9L4FkZsBJyuEAMRslA44Dtsgb09u0AhyMModGnPAS8ksGgtbyj5NtXCucnFxlcEWOyWgwJInEcxZm'
    };

    final response = await http.post(postUrl,
        body: json.encode(data),
        encoding: Encoding.getByName('utf-8'),
        headers: headers);

    if (response.statusCode == 200) {
      print(response);
      // on success do sth

      print("true"+'hogya');
    } else {
      // on failure do sth
      print("false"+'nahi hoa');

    }

  }


}
