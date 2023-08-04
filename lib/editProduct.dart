import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:manager/constants/strings.dart';
import 'package:manager/databases/firebase_services.dart';
import 'package:manager/userProvider.dart';
import 'package:manager/widgets/MainButton.dart';
import 'package:manager/widgets/MainInput.dart';
import 'package:manager/widgets/snackbars.dart';
import 'package:provider/provider.dart';

import 'models/user.dart';

class EditProduct extends StatefulWidget {
  final String productName;
  final String description;
  final String category;
  final String picture;
  final double price;
  const EditProduct({super.key, required this.productName, required this.description, required this.picture, required this.price, required this.category});

  @override
  State<EditProduct> createState() => _EditProductState();
}

class _EditProductState extends State<EditProduct> {
  CustomerProvider? customerProvider;
  ProductProvider? productProvider;
  TextEditingController nameController = TextEditingController();
  TextEditingController amountController = TextEditingController();
  bool isLoading=false;
  File? _image;
 late String value=widget.category;
  List<String> categories=[
    "breakfast",
    "snack/drinks",
    "lunch",
    "supper",
    "dessert",
  ];
  String productName="";
  String description="";
  double price=0;
  String URL="";
  String imagePath="";
  String imageLocalPath="";
  bool network_or_file=true;
  @override
  void initState(){
    super.initState();
    productName=widget.productName;
    imagePath =widget.picture;
    price =widget.price;
    description =widget.description;
    value=widget.category;
    customerProvider=context.read<CustomerProvider>();
    productProvider=context.read<ProductProvider>();
    // print(productProvider?.typeOf?.productName);
    // print(customerProvider?.appUser?.fullName);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title:const Text("Edit Product")
        ),
        body: Container(
          color: const Color.fromRGBO(245, 245, 245, 0.6),
          padding: const EdgeInsets.all(10),
          child:Form(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: ListView(children: [
                    const SizedBox(height: 70),
                  MainInput(
                    enabled: false,
                    validator: checkValidator,
                      initialValue: widget.productName,
                      //hintText: "Product Name",
                      label: const Text("Edit Product Name"),
                      //controller: nameController,
                      obscureText: false,
                    onChanged: (value){
                      productName=value;
                    },
                    ),
                    const SizedBox(height: 40),
                     MainInput(
                       validator: checkValidator,
                      initialValue: widget.description,
                      hintText: "Edit description here",
                      label: const Text("Description"),
                     // controller: amountController,
                      //keyboardType: TextInputType.number,
                      obscureText: false,
                       onChanged: (value){
                         description=value;
                       },
                    ),
                    const SizedBox(height: 40),
                    MainInput(
                      validator: checkValidator,
                      initialValue: widget.price.toString(),
                      hintText: "Edit price here",
                      label: const Text("Price"),
                      keyboardType: TextInputType.number,
                      obscureText: false,
                      onChanged: (value){
                        price=double.parse(value);
                      },
                    ),
                    const SizedBox(height: 20),
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
                    Visibility(
                      visible:network_or_file,
                      replacement: Container(
                        margin: const EdgeInsets.only(left:50,right:50),
                        width: 200,height: 150,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          image: DecorationImage(
                            image: Image.file(File(imagePath),
                              fit: BoxFit.fitWidth,).image,
                          ),
                          //color: Colors.white70
                        ),
                      ),
                      child: Container(
                        margin: const EdgeInsets.only(left:50,right:50),
                        width: 200,height: 150,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          image: DecorationImage(
                            image: Image.network(widget.picture,
                              fit: BoxFit.fitWidth,).image,
                          ),
                          //color: Colors.white70
                        ),
                      ),
                    ),
                    const SizedBox(height: 40),

                    const SizedBox(height: 7),


                  ]),
                ),
                SizedBox(
                  width:double.infinity,
                  child: MainButton(
                    onPressed:
                    isLoading
                        ? null
                        :
                        () async {
                      setState(() {
                        isLoading = true;
                      });
                      uploadFile(product: productProvider?.typeOf);

                    },
                    backgroundColor: Colors.green,
                    color: Colors.green,
                    child: Visibility(
                        visible: !isLoading,
                        replacement: const CircularProgressIndicator(),
                        child: const Text("Update")),
                  ),
                ),
              ],
            ),
          ),
        ));
  }
  Future<String?> uploadFile({required Product? product}) async{
    String? pName=product?.productName;
    String? describe=product?.description;
    double? pricing=product?.price;
    String? pic=product?.picture;
    String? categories=product?.category;
if(network_or_file==true){
  setState(() {
    pName=productName;
    describe=description;
    pricing=price;
    categories=value;
  });
  var prods=product;
  prods?.productName=pName;
  prods?.description=describe;
  prods?.price=pricing;
  prods?.category=categories;
  prods?.restaurantName= customerProvider?.appUser?.fullName;
  //await ProductServices().updateCategory(product: prods!, value: value);
  await updateUser(product: prods!);
}
else{
    File file = File(imagePath);
    final storageReference = FirebaseStorage.instance
        .ref(customerProvider?.appUser?.email)
        .child(imagePath);
    final uploadTask = storageReference.putFile(file);
    String? returnURL;
    await   uploadTask.whenComplete(() {
      print('File Uploaded');

      storageReference.getDownloadURL().then((fileURL)  async {
        returnURL = fileURL;
        setState(() {
          URL=fileURL;
          pName=productName;
        describe=description;
        pricing=price;
        pic=imagePath;
        });
        var prods=product;
        prods?.productName=pName;
        prods?.description=describe;
        prods?.picture=fileURL;
        prods?.price=pricing;
        prods?.category=categories;
        prods?.restaurantName= customerProvider?.appUser?.fullName;
       // await ProductServices().updateCategory(product: prods!, value: value);
        await updateUser(product: prods!);

      });
      return URL;
    } );}
    return URL;

  }
  updateUser({required Product product}) async {
    var result=await productProvider?.updateProduct(
        product: product, id: customerProvider?.appUser?.id);
print("1");
    // await productProvider?.updateCategory(product: product, value: value);
    if (result?.status == QueryStatuses.successful) {
      print("2");
     await  productProvider?.getCategoryProduct(
          productName: productProvider!.typeOf!.productName!,
          restuarantName: productProvider!.typeOf!.restaurantName!,
          value: widget.category)?.
       whenComplete(() async{
         if (!context.mounted) return;
      productProvider = context.read<ProductProvider>();
      print(productProvider?.typeOf?.id);
      var result_2 = await productProvider?.updateCategory(
          product: product, value: value,
          prodId:productProvider!.typeOf!.id!);
      if (result_2?.status == QueryStatuses.successful) {

      //await productProvider?.updateCategory(product: product, value: value);

      setState(() {
        isLoading = false;
      });
      if (!context.mounted) return;
      PrimarySnackBar(context).displaySnackBar(
        message: "Product updated successfully",
        backgroundColor: Colors.green,
      );
      Navigator.pop(context);

      return;

      }});
    }
    if (result?.status == QueryStatuses.failed) {
      setState(() {
        isLoading = false;
      });
      PrimarySnackBar(context).displaySnackBar(
        message: "Error saving profile details",
        backgroundColor: Colors.red,
      );
    }
  }

  String? checkValidator(String? value) {
    if (value?.isEmpty == true) {
      return AppStrings.isRequired;
    }
    return null;
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
              width: double.infinity,
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
          imagePath=pickedFile!.path;
          network_or_file=false;
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
          imagePath=pickedFile!.path;
          network_or_file=false;
        });
        // Navigator.of(context).push(MaterialPageRoute(
        //   builder: (context) => DisplayPictureScreen(
        //     // Pass the automatically generated path to
        //     // the DisplayPictureScreen widget.
        //     imagePath: pickedFile!.path,
        //   ),
        // ));
      }
    });
  }
}
