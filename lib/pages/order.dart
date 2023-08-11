import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_osm_interface/src/types/geo_point.dart' as geo;
import 'package:flutter/material.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';
import 'package:manager/userProvider.dart';
import 'package:manager/widgets/MainButton.dart';
import 'package:manager/widgets/bottomNavigation.dart';
import 'package:manager/widgets/drawer.dart';
import 'package:manager/models/user.dart';
import 'package:manager/constants/Size_of_screen.dart';
import 'package:manager/widgets/snackbars.dart';
import "package:provider/provider.dart";
import 'package:sticky_headers/sticky_headers.dart';
class Order extends StatefulWidget {
  const Order({super.key});
  @override
  State<Order> createState() => _OrderState();
}
class _OrderState extends State<Order> {
  CustomerProvider? customerProvider;
  bool driverRefresh=true;

  final mapController = MapController.withUserPosition(
    trackUserLocation: const UserTrackingOption(
      enableTracking: false,
      unFollowUser: true,
    ),
    //areaLimit: BoundingBox.
  );


  int dateSubtract=0;
  Stream<QuerySnapshot<Map<String, dynamic>>> allOrders(){
    var stringList =  DateTime.now().toIso8601String().split(RegExp(r"[T\.]"));

    var formatedDate = stringList[0];
    // print("2023-08-01");
    // print("gg");
    var date=formatedDate.replaceAll("-", "");
    if(date.endsWith("01")==true){
      var li= DateTime.now().subtract(const Duration(days:1))
          .toIso8601String().split(RegExp(r"[T\.]"));
      var formatedDate=li[0];
      var date=formatedDate.replaceAll("-", "");
      int dateGet=int.parse(date)-dateSubtract;
      dateGet=int.parse("${dateGet}000000");
      //int dateInt=int.parse("${date}000000");
      // print("fee");
      // print(dateGet);
      final products= FirebaseFirestore.instance
          .collection("Orders")
          .where("date",isGreaterThanOrEqualTo:dateGet )
          .where("title",isEqualTo: customerProvider?.appUser?.fullName)
          .snapshots();
      return products;
    }

    else{
      int dateGet=int.parse(date)-dateSubtract;
      dateGet=int.parse("${dateGet}000000");
      // print("hee");
      // print(date);
      // print(dateGet);

      final products= FirebaseFirestore.instance
          .collection("Orders")
          .where("date",isGreaterThanOrEqualTo:dateGet )
          .where("title",isEqualTo: customerProvider?.appUser?.fullName)
          .snapshots();
      return products;

    }
  }

  Stream<QuerySnapshot<Map<String,dynamic>>> changeFoodStatus(){

    final products= FirebaseFirestore.instance
        .collection("Orders")
        .where("date",isGreaterThanOrEqualTo:"dateGet" )
        .where("title",isEqualTo: customerProvider?.appUser?.fullName)
        .snapshots();
    return products;
  }





 late List<PopupMenuItem<dynamic>> items=[
  PopupMenuItem<int>(
    onTap:(){

  },value:1,

    child:TextButton(
      child:const Text("Yesterday included"),
      onPressed:(){
        setState((){
          dateSubtract=1;
        });
        Navigator.pop(context);
      },),

    ),
    PopupMenuItem<int>(
        onTap:(){

        },value:2,
        child:TextButton(
          child:const Text("All the Month Orders"),
          onPressed:(){
            setState((){
              dateSubtract=100;
            });
            Navigator.pop(context);
            // print(DateTime.now().day+DateTime.now().month);
            // print(DateTime.now().subtract(Duration(days:1)));
          },)

    ),
  ];
  @override
  void initState() {
    super.initState();
    customerProvider = context.read<CustomerProvider>();


  }
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return SafeArea(
      child: Scaffold(
        drawer: const Drawers(),
          bottomNavigationBar: BottomNavBar(idx:0),
          appBar: AppBar(
            title: const Text("Orders"),
            centerTitle: true,
            actions:[
              IconButton(
                icon:const Icon(Icons.more_vert),
                onPressed:(){
                  showMenu(context: context,
                      position: const RelativeRect.fromLTRB(50,80,30,0),
                      items: items);
                }
              )

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
        body:  SingleChildScrollView(
          //physics: ScrollPhysics(),
          child: Container(
            color: const Color.fromRGBO(245, 245, 245, 0.6),
            padding: const EdgeInsets.all(10),
            child: Column(
                mainAxisSize:MainAxisSize.min,
                children:[
            StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
              stream: allOrders(),
              builder: (context, snapshot) {
                if(!snapshot.hasData){
                  return const Center(child: Text("No orders yet"));
                }
                else if(snapshot.connectionState==ConnectionState.waiting){
                  //FlutterSpinkit
                  return const Center(child: CircularProgressIndicator());
                }
                return ListView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                  itemCount: snapshot.data?.docs.length,
                  itemBuilder: (context, index) {
    //print(snapshot.data?.docs.length);
    var orders=snapshot.data?.docs[index];
   var id= snapshot.data?.docs[index].id;
    return Container(
      margin:const EdgeInsets.only(bottom:10),
      decoration: BoxDecoration(
        color:Colors.white,
        borderRadius:BorderRadius.circular(10),
        border:Border.all(
            width:1,color:Colors.white,style:BorderStyle.solid
        )
      ),
      child: StickyHeader(
            header:Center(
        child: Text("Deliver to ${orders?["customerName"]}"
        "\n${orders?["customerLocation"].toString().substring(0,45)}...\n"
        "${orders?["customerNumber"]}",textAlign:TextAlign.center),
      ),
      content:Column(
        children: [
            ListTile(
            leading:Text(orders!["quantity"].toString()),
            title: Text(orders["name"]),
            trailing: Text(orders["totalAmount"].toString()),
            ),
            Row(
      mainAxisAlignment: MainAxisAlignment.start,
                children:[
                  Text("Total: GHc ${orders["totalAmount"].toString()}",
                      style:const TextStyle(
                                    fontSize:15,fontWeight: FontWeight.bold
                                )),
                                Visibility(
                                  visible:orders["statusCheck"],
                                  replacement:Row(
                                    mainAxisAlignment:MainAxisAlignment.start,
                                    children:[
                                      //SizedBox(width:15),
                                      SizedBox(
                                        width:115,
                                        child: MainButton(onPressed: (){
                                          Map<String,dynamic> gg={
                                            "status":"accepted",
                                            "statusCheck":true,
                                          };
                                              FirebaseFirestore.instance
                                                  .collection("Orders")
                                                  .doc(id).update(gg);
                                            }, color: Colors.white, child: const Text("Accept")),
                                      ),
                                     // SizedBox(width:5),
                                      SizedBox(width:110,
                                        child: MainButton(onPressed:(){
                                          Map<String,dynamic> gg={
                                            "status":"rejected",
                                            "statusCheck":true,
                                          };
                                              FirebaseFirestore.instance
                                                  .collection("Orders")
                                                  .doc(id).update(gg);
                                            }, color:Colors.white, child: const Text("Reject")),
                                      )
                                    ]
                                  ),
                                  child: Row(
                                    children: [
                                      MainButton(
                                        onPressed:orders["driverName"]!=null? null:() {
                                          showDialog(context: context,
                                              builder:
                                          (BuildContext context){
                                            return StatefulBuilder(
                                              builder: (context,setState) {
                                                return Dialog(

                                                  child: SizedBox(
                                                    height: MediaQuery.of(context).size.height*0.8,
                                                    child:StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                                                      stream: getDrivers(),
                                                     builder:  (BuildContext context ,snapshot){
                                                        if(!snapshot.hasData){
                                                          return const Center(child: Text("No drivers yet"));
                                                        }
                                                        else if(snapshot.connectionState==ConnectionState.waiting){
                                                          return const Center(child: CircularProgressIndicator());
                                                        }

                                                      return Column(
                                                        children: [
                                                          const Text("Select driver",style:TextStyle(
                                                            fontSize:18,fontWeight:FontWeight.bold
                                                          )),
                                                          const SizedBox(height:10),
                                                          Flexible(
                                                            child: ListView.builder(
                                                                itemCount:snapshot.data?.docs.length,
                                                                itemBuilder: (BuildContext context,index){
                                                              var drivers=snapshot.data?.docs[index];
                                                              return ListTile(
                                                                onTap: () async {
                                                                 // print(drivers?["fullName"]);
                                                                  Map<String,dynamic> driverDetails={
                                                                   "driverLocation":drivers?["location"],
                                                                   "driverName":drivers?["fullName"],
                                                                  "driverStatus":"Pending",
                                                                   "driverLongitude":drivers?["longitude"],
                                                                   "driverLatitude":drivers?["latitude"],
                                                                   "driverNumber":drivers?["number"],
                                                                  };
                                                                  FirebaseFirestore.instance
                                                                      .collection("Orders")
                                                                      .doc(id).update(driverDetails).
                                                                  whenComplete(()async{
                                                                    // await FirebaseFirestore.instance
                                                                    //     .collection("pashewFoodAccount")
                                                                    //     .doc(customerProvider?.appUser?.id)
                                                                    //     .collection("Orders")
                                                                    //     .add(orders)
                                                                         Navigator.pop(context);
                                                                        PrimarySnackBar(context).displaySnackBar(
                                                                            message: "Driver ${drivers?["fullName"]} assigned");
                                                                  });
                                                                  //print(orders["customerName"]);
                                                                },
                                                                title: Text(drivers?["fullName"]),
                                                                trailing:  CircleAvatar(
                                                                  backgroundImage:NetworkImage(
                                                                    drivers?["image"]
                                                                  ) ,
                                                                ),

                                                              );
                                                            }),
                                                          ),
                                                          MainButton(
                                                              onPressed:()async{
                                                                await  showDialog(
                                                                    context: context,
                                                                      builder: (BuildContext context){
                                                                        return StatefulBuilder(
                                                                            builder: (context,setState) {
                                                                              return Container(
                                                                                height:MediaQuery.of(context).size.height*0.8,
                                                                                width:double.infinity,
                                                                                decoration:BoxDecoration(
                                                                                    borderRadius:BorderRadius.circular(10)),
                                                                                child: Stack(
                                                                                  children: [
                                                                                    OSMFlutter(
                                                                                       // mapIsLoading:Center(child: const
                                                                                       // CircularProgressIndicator(
                                                                                       //   value:100
                                                                                       // )),
                                                                                      controller:mapController,
                                                                                      userTrackingOption: const UserTrackingOption(
                                                                                        enableTracking: false,
                                                                                        unFollowUser: true,
                                                                                      ),
                                                                                      //isPicker: true,
                                                                                      initZoom: 16,
                                                                                      minZoomLevel: 4,
                                                                                      maxZoomLevel: 18,
                                                                                      stepZoom: 1.0,
                                                                                      userLocationMarker: UserLocationMaker(
                                                                                        personMarker: const MarkerIcon(
                                                                                          icon: Icon(
                                                                                            Icons.location_history_rounded,
                                                                                            color: Colors.red,
                                                                                            size: 48,
                                                                                          ),
                                                                                        ),
                                                                                        directionArrowMarker: const MarkerIcon(
                                                                                          icon: Icon(
                                                                                            Icons.double_arrow,
                                                                                            size: 48,
                                                                                          ),
                                                                                        ),
                                                                                      ),
                                                                                      roadConfiguration: const RoadOption(
                                                                                        roadColor: Colors.yellowAccent,
                                                                                      ),
                                                                                      markerOption: MarkerOption(
                                                                                          defaultMarker: const MarkerIcon(
                                                                                            icon: Icon(
                                                                                              Icons.person_pin_circle,
                                                                                              color: Colors.blue,
                                                                                              size: 56,
                                                                                            ),
                                                                                          )
                                                                                      ),
                                                                                    ),
                                                                                    Align(
                                                                                      alignment: Alignment.topRight,
                                                                                      child:IconButton(
                                                                                        onPressed:(){

                                                                                          mapController.dispose();
                                                                                          Navigator.pop(context);},
                                                                                          icon:
                                                                                          const Icon(Icons.cancel))
                                                                                    ),
                                                                                    Visibility(
                                                                                      visible:driverRefresh,
                                                                                      replacement:Align(
                                                                                          alignment: Alignment.bottomRight,
                                                                                         child: IconButton(
                                                                                          onPressed:(){
                                                                                            getDrivers();
                                                                                            },
                                                                                          icon:const Icon(Icons.refresh,
                                                                                          size:30,color:Colors.green)
                                                                                        )
                                                                                      ),
                                                                                      child: Align(
                                                                                          alignment: Alignment.bottomCenter,
                                                                                          child:IconLabelButton(
                                                                                              onPressed:(){

                                                                                                setState((){
                                                                                                  driverRefresh=false;
                                                                                                  mapController.addMarker(
                                                                                                       geo.GeoPoint(
                                                                                                         latitude:customerProvider!.appUser!.latitude!,
                                                                                                         longitude:customerProvider!.appUser!.longitude!),
                                                                                                     markerIcon:const MarkerIcon(
                                                                                                       icon:Icon(Icons.restaurant,
                                                                                                       color:Colors.green,size: 50,)),
                                                                                                   );
                                                                                                  for(int i=0;i<snapshot.data!.docs.length;i++){
                                                                                                    var drivers=snapshot.data?.docs[i];
                                                                                                    //print(drivers?["latitude"]);
                                                                                                    mapController.drawRoad(
                                                                                                        geo.GeoPoint(
                                                                                                            latitude: drivers?["latitude"],
                                                                                                            longitude: drivers?["longitude"]),
                                                                                                        geo.GeoPoint(
                                                                                                            latitude: customerProvider!.appUser!.latitude!,
                                                                                                            longitude: customerProvider!.appUser!.longitude!),
                                                                                                        roadOption:const RoadOption(
                                                                                                          roadColor: Colors.black,
                                                                                                          roadWidth: 5,
                                                                                                        ));
                                                                                                    mapController.addMarker(
                                                                                                      geo.GeoPoint(
                                                                                                          latitude:drivers?["latitude"],
                                                                                                          longitude:drivers?["longitude"]),
                                                                                                      markerIcon:const MarkerIcon(
                                                                                                          icon:Icon(Icons.motorcycle,
                                                                                                            color:Colors.green,size: 50,)),
                                                                                                    );
                                                                                                  }
                                                                                                  // mapController.myLocation();

                                                                                                });
                                                                                                },
                                                                                              icon:
                                                                                              const Icon(Icons.location_on),
                                                                                            backgroundColor: Colors.green,
                                                                                              color: Colors.green,
                                                                                              label: 'Show Drivers',
                                                                                             )
                                                                                      ),
                                                                                    )
                                                                                  ],
                                                                                ),
                                                                              );
                                                                            }
                                                                        );
                                                                      });

                                                              },
                                                              backgroundColor: Colors.green,
                                                              color: Colors.green,
                                                              child: const Text("Use map instead",
                                                              )),
                                                          const SizedBox(height:10)
                                                        ],
                                                      );

                                                     }) ),
                                                );
                                              }
                                            );
                                          });
                                          },
                                        color: Colors.white,
                                        child: Text(orders["driverStatus"]=='accepted'?"Driver Accepted":"Driver Pending"),
                                      ),

                                    ],
                                  ),
                                )
                              ]
                          )


                  ])

                  ),
    );

              });
              }
            )
              ]),
          ),
        ),
        ),

    );
  }
  Stream<QuerySnapshot<Map<String, dynamic>>> getDrivers(){
    return FirebaseFirestore.instance
        .collection("pashewDriverAccount")
        .snapshots();

  }
}
