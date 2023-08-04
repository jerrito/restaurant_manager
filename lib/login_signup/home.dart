import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:manager/constants/Size_of_screen.dart';
//import 'package:manager/feature/presentation/widgets/buy.dart';
import 'package:manager/widgets/drawer.dart';
import 'package:manager/userProvider.dart';
import 'package:path/path.dart'  as p;
import 'package:provider/provider.dart';
import 'package:sqflite/sqflite.dart';
//import 'manager/widgets/food_with_price.dart';
//import 'package:manager/sql_database.dart';
import 'package:provider/provider.dart';


class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final List<String> imgList = [
    "./assets/images.burger.jpg",
    "./assets/images.god_of war.png",
    "./assets/images.pizza.jpg"
  ];
  int _current = 0;
  int cartNumber=0;
  final CarouselController _controller = CarouselController();
  Future<int> cartLength() async {
    final database = openDatabase(
      p.join(await getDatabasesPath(), 'pashewCart.db'),
      version: 1,);
final db = await database;
    final List<Map<dynamic, dynamic>> maps =  await db.query('CARTDATA');
    setState(() {
      cartNumber=maps.length;
    });
    print(maps.length);
    return maps.length;
  }
  ProductProvider? customerProvider;

  @override
  void initState(){
    super.initState();
    customerProvider=context.read<ProductProvider>();
    //table();
    //cartLength();
  }
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      drawer: const Drawers(),
      appBar: AppBar(
        title: const Text("Home"),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            tooltip: 'Search for a specific food',
            onPressed: () {
              Navigator.pushNamed(context, "specificBuyItem");
            },
          ),
          Badge(
            backgroundColor: Colors.green,
            label:Text("$cartNumber"),
            child: IconButton(
              icon: const Icon(Icons.shopping_cart),
              tooltip: 'Open shopping cart',
              onPressed: () {
                Navigator.pushNamed(context, "cart");
              },
            ),

          ),
          Padding(padding: EdgeInsets.only(right:10))
          // IconButton(
          //   icon: const Icon(Icons.shopping_cart),
          //   tooltip: 'Open shopping cart',
          //   onPressed: () {
          //     Navigator.pushNamed(context, "cart");
          //   },
          // ),
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
      body: Container(
          color: const Color.fromRGBO(245, 245, 245, 0.6),
          // padding: const EdgeInsets.all(10),
          child:  Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const SizedBox(height: 10),
                const Text("Popular Categories",style:TextStyle(fontSize:18)),
                const SizedBox(height: 10),
                // Flexible(
                //   child: ListView(
                //     scrollDirection: Axis.horizontal,
                //     //reverse: true,
                //    // items: category.length,
                //     children:[
                //       category[0],
                //       category[1],
                //       category[2],
                //       category[3],
                //     ]
                //     ,
                //   ),
                // ),
                SizedBox(height: 30),
                // CarouselSlider(
                //   items: items,
                //   options: CarouselOptions(
                //     viewportFraction: 0.6,
                //     autoPlay: true,
                //     enlargeCenterPage: false,
                //     enlargeFactor: 0.3,
                //     aspectRatio: 16 / 9,
                //   ),
                // ),

                const SizedBox(height: 40),
                CarouselSlider.builder(
                  itemCount: 3,
                  options: CarouselOptions(
                    viewportFraction: 0.9,
                    autoPlay: true,
                    enlargeCenterPage: false,
                    enlargeFactor: 0.3,
                    aspectRatio: 16 / 9,
                    onPageChanged: (index, reason) {
                      setState(() {
                        _current = index;
                      });
                    },
                    // autoPlayAnimationDuration: Duration(seconds: 5),
                  ),
                  carouselController: _controller,
                  //scrollDirection: Axis.horizontal,
                  itemBuilder: (BuildContext context, int i, int index) {
                    return SizedBox(
                      height: 270,
                      width: 305,
                      child: Container(
                        height: 270,
                        width: 305,
                        margin: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.rectangle,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Stack(children: [
                          Image.asset(
                            "./assets/images/pizza.jpg",
                            height: 210,
                            width: double.infinity - 120,
                          ),
                          const Positioned(
                              left: 110,
                              top: 115,
                              child: Text("Pizza",
                                  style: TextStyle(
                                      color: Colors.black, fontSize: 25))),
                          Positioned(
                            left: 110,
                            top: 135,
                            child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: imgList.asMap().entries.map((entry) {
                                  return GestureDetector(
                                    onTap: () =>
                                        _controller.animateToPage(entry.key),
                                    child: Container(
                                      width: 12.0,
                                      height: 12.0,
                                      margin: const EdgeInsets.symmetric(
                                          vertical: 8.0, horizontal: 4.0),
                                      decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: (Theme.of(context)
                                                          .brightness ==
                                                      Brightness.dark
                                                  ? Colors.white
                                                  : Colors.black)
                                              .withOpacity(_current == entry.key
                                                  ? 0.9
                                                  : 0.4)),
                                    ),
                                  );
                                }).toList()),
                          )
                        ]),
                      ),
                    );
                  },
                ),
                // ]),
                const SizedBox(height: 40)
              ],
            ),
          ),

    );
  }

 //  List<Widget> category = [
 //    FoodCategory(onTap: () {},
 //        image: "burger.jpg",
 //        name: "Sandwich", amount: 20),
 //    FoodCategory(onTap: () {}, image: "friedrice.png",
 //        name: "Fried Rice",
 //        amount: 25),
 //    FoodCategory(onTap: () {}, image: "pizza.jpg", name: "Pizza",
 //        amount: 55),
 //    FoodCategory(onTap: () {}, image: "yam3.png", name: "Yam",
 //        amount: 20),
 //    FoodCategory(onTap: () {}, image: "awaakye.jpeg",
 //        name: "Awaakye",
 //        amount: 25),
 //  ];
 // late List<Widget> items = [
 //    FoodWithPrice(
 //        onTap:(){
 //          showBuying("friedrice.png","Fried Rice","Curry Fried rice",25);},
 //        image: "friedrice.png",
 //        name: "Fried Rice",
 //        title: "Curry Fried rice",
 //        amount: 25),
 //    FoodWithPrice(
 //        onTap: () {
 //          showBuying("friedrice.png","Fried Rice","Curry Fried rice",25);},
 //        image: "burger.jpg",
 //        name: "Sandwich",
 //        title: "Burger Sandwich",
 //        amount: 45),
 //    FoodWithPrice(
 //        onTap: () {
 //          showBuying("awaakye2.png","Awaakye","Awaakye/fish",25);},
 //        image: "awaakye2.png",
 //        name: "Awaakye",
 //        title: "Awaakye/fish",
 //        amount: 25),
 //    FoodWithPrice(
 //        onTap: () {showBuying("friedrice.png","Fried Rice","Curry Fried rice",30);},
 //        image: "friedrice.png",
 //        name: "Fried Rice",
 //        title: "Curry Fried rice",
 //        amount: 30),
 //    FoodWithPrice(
 //        onTap: () {showBuying("gobe2.png","Gari and Beans","Gobe",20);},
 //        image: "gobe2.png",
 //        name: "Gari and Beans",
 //        title: "Gobe",
 //        amount: 20),
 //    FoodWithPrice(
 //        onTap: () {showBuying("yam3.png","Plantain with Stew","Bodie Ampesie",25);},
 //        image: "yam3.png",
 //        name: "Plantain with Stew",
 //        title: "Bodie Ampesie",
 //        amount: 25),
 //    FoodWithPrice(
 //        onTap: () {showBuying("gobe2.png","Gari and Beans","Gobe",20);},
 //        image: "gobe2.png",
 //        name: "Gari and Beans",
 //        title: "Gobe",
 //        amount: 20),
 //  ];
 //
 //  void showBuying(String image,String name,String title,double amount){
 //    showModalBottomSheet<dynamic>(
 //      shape: const RoundedRectangleBorder(
 //          borderRadius: BorderRadius.only(
 //              topLeft: Radius.circular(20), topRight: Radius.circular(20))),
 //      isScrollControlled: true,
 //      isDismissible:true,
 //      context: context,
 //      builder: (BuildContext context) {
 //        return StatefulBuilder(builder: (context, setState) {
 //          return Buying(image: image, name: name,
 //              title: title,amount:amount);
 //        });
 //      },
 //    );
 //  }

  // Future<Database> table()async{
  //   final database = openDatabase(
  //
  //       p.join(await getDatabasesPath(), 'cart.db'),
  //           onCreate: (db, version) {
  //   return db.execute(
  //       'CREATE TABLE IF NOT EXISTS CARTDATA (name TEXT PRIMARY KEY , amount INTEGER, totalAmount INTEGER, title TEXT, quantity INTEGER)');
  //   },
  //   version: 1,
  //   );
  //   print("ss");
  //   return database;
  // }
}
