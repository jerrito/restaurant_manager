import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:manager/databases/firebase_services.dart';
import 'package:manager/widgets/bottomNavigation.dart';
import 'package:manager/widgets/drawer.dart';
import 'package:manager/userProvider.dart';
import 'package:manager/widgets/snackbars.dart';
import 'package:provider/provider.dart';
import 'package:manager/editProduct.dart';
class Products extends StatefulWidget {
  const Products({super.key});

  @override
  State<Products> createState() => _ProductsState();
}

class _ProductsState extends State<Products> {
  CustomerProvider? customerProvider;
  ProductProvider? productProvider;

  @override
  void initState(){
    super.initState();
    customerProvider=context.read<CustomerProvider>();
    productProvider=context.read<ProductProvider>();
    print(customerProvider?.appUser?.image);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const Drawers(),
        bottomNavigationBar: BottomNavBar(idx:1),
      appBar: AppBar(
        title: const Text("Your Products"),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.add_circle_outline),
            //tooltip: 'Search for a specific food',
            onPressed: () {
              if(customerProvider?.appUser?.image==""){
                PrimarySnackBar(context).displaySnackBar(
                    message: "Update all profile details");
              }
             else {
                Navigator.pushNamed(context, "addProducts");
              }},
          ),

        ],
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
              icon: const Icon(Icons.menu),
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
              tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
            );
          },
        ),
      ),
      body:Container(
          color: const Color.fromRGBO(245, 245, 245, 0.6),
        child:Column(
         // mainAxisAlignment: MainAxisAlignment.center,
          children:[
            StreamBuilder<QuerySnapshot<Map<String,dynamic>>>(
              stream: allProducts(),
              builder: (context, snapshot) {
                if(!snapshot.hasData){
                  return const Center(child: Text("No products added yet"));
                }
                else if(snapshot.connectionState==ConnectionState.waiting){
                  //FlutterSpinkit
                 return const Center(child: CircularProgressIndicator());
                }
                return Flexible(
                    child:
                    ListView.builder(
                      itemCount: snapshot.data?.docs.length,
                        itemBuilder: (BuildContext context,index){
                        print(snapshot.data?.size);
                        var productDetails=snapshot.data?.docs[index];
                          return
                            ListTile(
                              onTap: () async {
                               // productProvider=context.read<ProductProvider>();
                               await productProvider?.getProduct(productName: productDetails["productName"],
                                   id:customerProvider!.appUser!.id! );
                               if(!context.mounted)return;
                                Navigator.push(context,
                                MaterialPageRoute(
                                    builder: (BuildContext context){
                                return EditProduct(
                                    productName: productDetails["productName"],
                                    description:productDetails["description"],
                                    category:productDetails["category"],
                                    picture:productDetails["picture"],
                                    price:productDetails["price"]);}));
                              },
                              isThreeLine: true,
                              title: Text(productDetails?["productName"]),
                              subtitle:  Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children:
                                [
                                  Text(productDetails?["description"]),
                                  Text(productDetails!["price"].toString()),]
                              ),
                              trailing: CircleAvatar(
                                radius: 30,
                                backgroundImage: Image.network(productDetails?["picture"]).image,
                              ),

                          );
                        }));
              }
            )
          ]
        )
      )
    );
  }
  Stream<QuerySnapshot<Map<String, dynamic>>> allProducts(){
   final products= FirebaseFirestore.instance.
    collection('pashewRestaurantManagerAccount')
       .doc(customerProvider?.appUser?.id)
       .collection("Products")
       .snapshots();
    return products;
  }

}
