import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:manager/constants/Size_of_screen.dart';
import 'package:manager/constants/strings.dart';
import 'package:manager/databases/firebase_services.dart';
import 'package:manager/models/user.dart';
import 'package:manager/userProvider.dart';
import 'package:manager/widgets/MainButton.dart';
import 'package:manager/widgets/MainInput.dart';
import 'package:manager/widgets/snackbars.dart';
import 'package:provider/provider.dart';
class AddProducts extends StatefulWidget {

  const AddProducts({super.key});

  @override
  State<AddProducts> createState() => _AddProductsState();
}

class _AddProductsState extends State<AddProducts> {
  File? _image;
   String? imagePath;
  String URL="";
  CustomerProvider? customerProvider;
  ProductProvider? productProvider;
  TextEditingController productNameController = TextEditingController();
  TextEditingController productDescriptionController = TextEditingController();
  TextEditingController priceController = TextEditingController();
 bool isLoading=false;
 String value="supper";
 List<String> categories=[
   "breakfast",
  "snack",
   "drinks"
   "lunch",
   "supper",
   "dessert",
 ];
GlobalKey<FormState> addProductForm=GlobalKey<FormState>();
 @override
  void initState(){
   super.initState();
   customerProvider=context.read<CustomerProvider>();
 }
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      appBar: AppBar(
        title:const Text("Add Products")
      ),
      body: Container(
        color: const Color.fromRGBO(245, 245, 245, 0.6),
        padding: const EdgeInsets.all(10),
        child:Form(
          key:addProductForm,
    child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
    Expanded(
    child: ListView(children: [
    const SizedBox(height: 20),
    MainInput(
      validator: checkValidator,
    hintText: "Product Name",
    label: const Text("Add Product Name"),
    controller: productNameController,
    obscureText: false,
    ),
    const SizedBox(height: 20),
    MainInput(
      validator: checkValidator,
    hintText: "Enter description here",
    label: const Text("Description"),
    controller: productDescriptionController,
    //keyboardType: TextInputType.number,
    obscureText: false,
    ),
      const SizedBox(height: 20),
      MainInput(
        validator: checkValidator,
        hintText: "Enter price here",
        label: const Text("Price"),
        controller: priceController,
        keyboardType: TextInputType.number,
        obscureText: false,
      ),
      const SizedBox(height: 10),
      Container(
        height:50,width:double.infinity,
        decoration:BoxDecoration(
          borderRadius:BorderRadius.circular(10),
          border: Border.all(
            color:Theme.of(context).brightness==Brightness.dark?
            Colors.white:Colors.black,width:1,style:BorderStyle.solid
          )

        ),
        child: DropdownButton(
          value:value,
            icon: const Icon(Icons.keyboard_arrow_down),
            items: categories.map((String items) {
              return DropdownMenuItem(
                value: items,
                child: Text(items),
              );
            }).toList(),
            onChanged: (newValue){
              setState(() {
               value = newValue!;
              });
            }),
      ),
      const SizedBox(height: 10),
      const Text("Add Photo"),
    InkWell(
      onTap:(){
        uploadPic();
      },
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Align(
          alignment: Alignment.topLeft,
          child: SvgPicture.asset(
            "./assets/svgs/camera.svg",
            width: 70,height: 70,color: Colors.green,
          ),
        ),
      ),
    ),
      const SizedBox(height: 10),
    Container(
      margin: const EdgeInsets.only(left:50,right:50),
      width: 200,height: 150,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        image: DecorationImage(
           image: Image.file(File("$imagePath"),
             fit: BoxFit.fitWidth,).image,
          // onError: ("",StackTrace.current){
          //
          // }
          ),
        //color: Colors.white70
      ),
    )

    //const SizedBox(height: 7),
    ]),
    ),
    SizedBox(
      width: double.infinity,
    child: MainButton(
      backgroundColor: Colors.green,
    onPressed:
    isLoading
    ? null
        :
    () async {
      if(addProductForm.currentState?.validate()==true ) {
        if (imagePath == null) {
          return PrimarySnackBar(context).displaySnackBar(
              message: "Please select an image");
        }
        else {
          setState(() {
            isLoading = true;
          });
         await uploadFile();

        }
      }
    },
    color: Colors.green,
    child: Visibility(
    visible:!isLoading,
    replacement: const CircularProgressIndicator(),
    child: const Text("Submit")),
    ),
    ),
      const SizedBox(height: 10),
    ],
    ),
      ),
    ));
  }
  String? checkValidator(String? value) {
   if (value?.isEmpty == true) {
      return AppStrings.isRequired;
    }
    return null;
  }
  Future<String?> uploadFile() async{

    File file = File(imagePath!);
    final storageReference = FirebaseStorage.instance
        .ref(customerProvider?.appUser?.email)
        .child(imagePath!);
    final uploadTask = storageReference.putFile(file);
    String? returnURL;
    await   uploadTask.whenComplete(() {
      // print('File Uploaded');
      storageReference.getDownloadURL().then((fileURL)  async {
        returnURL = fileURL;
        setState(() {
          URL=fileURL;
        });
        var product = Product(
          productName:  productNameController.text,
          restaurantName: customerProvider?.appUser?.fullName,
          description:productDescriptionController.text,
          id:productProvider?.typeOf?.id,
          picture: fileURL,
          price: double.parse(priceController.text),
            category:value
        );
        await ProductServices().saveUser(product: product,
            id:customerProvider?.appUser?.id)
            ?.whenComplete(()
        async{
        await ProductServices().saveCategory(product:product,value:value);
          setState(() {
            isLoading = false;
            imagePath=null;
          });
          PrimarySnackBar(context).displaySnackBar(
              message: "Product uploaded");
          productNameController.clear();
          productDescriptionController.clear();
          priceController.clear();
        });
        // print( URL.toString());
        // print("This is $returnURL");

        //returnURL=widget.URL;
        // setState(() {
        //   //widget.URL=returnURL;
        //   saveLoading = false;
        // });
      });
      // setState(() {
      //   URL=returnURL!;
      // });
      return URL;
    } );
    return URL;
 }
  void uploadPic() {
    showModalBottomSheet<dynamic>(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20), topRight: Radius.circular(20)),
        ),
        isScrollControlled: true,
        context: context,
        builder: (BuildContext context) {
          return StatefulBuilder(builder: (context, setState) {
            return Container(
              width: SizeConfig.W,
              height: 200,
              decoration: const BoxDecoration(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20))),
              margin: const EdgeInsets.all(10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(
                      height: 20,
                    ),
                    SizedBox(
                      width:double.infinity,height: 50,
                      child: IconLabelButton(
                          color: Colors.yellow,
                          backgroundColor: Colors.green,
                          icon: const Icon(Icons.camera_alt),
                          label: 'Camera',
                 onPressed:(){
                   Navigator.pop(context);
                   getCameraImage();
                   },
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    SizedBox(
                      width:double.infinity,height: 50,
                      child: IconLabelButton(
                          onPressed:(){
                            Navigator.pop(context);
                            getFileImage();
                          },
                          color: Colors.yellow,
                        backgroundColor: Colors.yellow,
                        icon: const Icon(Icons.file_copy),
                        label: 'File Manager',),
                    ),
                  ]),
            );
          });
        });
  }

  Future getCameraImage() async {
    ImagePicker picker = ImagePicker();
    XFile? pickedFile;
    pickedFile = (await picker.pickImage(
      source: ImageSource.camera,
    ));
    setState(() {
      if (pickedFile != null) {
        // _images?.add(File(pickedFile.path));
        _image = File(pickedFile.path);
        setState(() {
          imagePath=pickedFile?.path;
        });
        // Use if you only need a single picture
        // Navigator.of(context).push(MaterialPageRoute(
        //   builder: (context) => DisplayPictureScreen(
        //     // Pass the automatically generated path to
        //     // the DisplayPictureScreen widget.
        //     imagePath: pickedFile!.path,
        //   ),
        // ));
      } else {
        PrimarySnackBar(context).displaySnackBar(
            message: "No image selected");
      }
    });
  }

  Future getFileImage() async {
    ImagePicker picker = ImagePicker();
    XFile? pickedFile;
    pickedFile = (await picker.pickImage(
      source: ImageSource.gallery,
    ));
    setState(() {
      if (pickedFile != null) {
        // _images?.add(File(pickedFile.path));
        _image = File(pickedFile.path); // Use if you only need a single picture
        setState(() {
          imagePath=pickedFile?.path;
        });
        // Navigator.of(context).push(MaterialPageRoute(
        //   builder: (context) => DisplayPictureScreen(
        //     // Pass the automatically generated path to
        //     // the DisplayPictureScreen widget.
        //     imagePath: pickedFile!.path,
        //   ),
        // ));
      }else{
        PrimarySnackBar(context).displaySnackBar(
            message: "No image selected");
      }
    });
  }
}
