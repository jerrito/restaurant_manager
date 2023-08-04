import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:manager/widgets/MainButton.dart';
import 'package:manager/main.dart';

class BottomNavBar extends StatefulWidget {
  int idx;
  BottomNavBar({Key? key, required this.idx}) : super(key: key);

  @override
  State<BottomNavBar> createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      selectedItemColor: Colors.pink,
      unselectedItemColor: Colors.black,
      showSelectedLabels: false,
      showUnselectedLabels: true,
      // color: Color.fromRGBO(0, 110, 255, 1),
      onTap: (index) {
        if (index == 0) {
          setState(() {
            Navigator.pushReplacementNamed(context, "order");
            widget.idx = index;
          });
        } else if (index == 1) {
          setState(() {
            Navigator.pushReplacementNamed(context, "products");
            widget.idx = index;
          });
        } else if (index == 2) {
          setState(() {
            Navigator.pushReplacementNamed(context, "profile");
            widget.idx = index;
          });
        }
      },
      currentIndex: widget.idx,
      items: [
        BottomNavigationBarItem(
          activeIcon: IconLabelButton(
              label: "Order",
              icon: SvgPicture.asset('./assets/svgs/shopping-bag.svg',
                color:Theme.of(context).brightness==Brightness.dark?
                Colors.white:Colors.black,),
              onPressed: () {},
              backgroundColor: Colors.green,
              color: Colors.green),
          label: "Orders",
          icon: SvgPicture.asset('./assets/svgs/shopping-bag.svg',
              color:Theme.of(context).brightness==Brightness.dark?
              Colors.white: Colors.black, width: 18, height: 18),
        ),
        BottomNavigationBarItem(
          label: "Meals",
          icon: SvgPicture.asset('./assets/svgs/coffee.svg',
              color:Theme.of(context).brightness==Brightness.dark?
              Colors.white: Colors.black, width: 18, height: 18),
          activeIcon: IconLabelButton(
              label: "Meals",
              icon: SvgPicture.asset('./assets/svgs/coffee.svg',
                  color: Colors.white),
              onPressed: () {},
              backgroundColor: Colors.green,
              color:Theme.of(context).brightness==Brightness.dark?
              Colors.white:Colors.green),
        ),

        BottomNavigationBarItem(
          label: "Profile",
          icon: SvgPicture.asset('./assets/svgs/user.svg',
              color:Theme.of(context).brightness==Brightness.dark?
              Colors.white: Colors.black, width: 18, height: 18),
          activeIcon: IconLabelButton(
              label: "Profile",
              icon: SvgPicture.asset('./assets/svgs/user.svg',
                  color:Theme.of(context).brightness==Brightness.dark?
                  Colors.white: Colors.black),
              onPressed: () {},
              backgroundColor:Colors.green,
              color:Theme.of(context).brightness==Brightness.dark?
              Colors.white: Colors.green),
        ),
      ],
    );
  }
}
