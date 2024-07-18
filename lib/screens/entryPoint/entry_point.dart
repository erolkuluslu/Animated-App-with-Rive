import 'dart:math';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:rive/rive.dart';
import 'package:rive_animation/constants.dart';
import 'package:rive_animation/screens/home/home_screen.dart';
import 'package:rive_animation/utils/rive_utils.dart';
import '../../model/menu.dart';
import 'components/btm_nav_item.dart';
import 'components/menu_btn.dart';
import 'components/side_bar.dart';

class EntryPoint extends StatefulWidget {
    EntryPoint({super.key});

  @override
  State<EntryPoint> createState() => _EntryPointState();
}

class _EntryPointState extends State<EntryPoint>
    with SingleTickerProviderStateMixin {
  // Track if the sidebar is open
  bool isSideBarOpen = false;

  // Maintain selected menu items for both bottom & sidebar
  Menu selectedBottonNav = bottomNavItems.first;
  Menu selectedSideMenu = sidebarMenus.first;

  // Trigger input for Rive animation (menu open state)
  late SMIBool isMenuOpenInput;

  // Update selected bottom navigation menu item
  void updateSelectedBtmNav(Menu menu) {
    // Update state only if different menu is selected
    if (selectedBottonNav != menu) {
      setState(() {
        selectedBottonNav = menu;
      });
    }
  }

  // Animation controller and animations for side menu opening
  late AnimationController _animationController;
  late Animation<double> scalAnimation;
  late Animation<double> animation;

  @override
  void initState() {
    // Initialize animation controller with duration
    _animationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 200));

    // Add listener to update UI based on animation state
    _animationController.addListener(() {
      setState(() {});
    });

    // Define animations for scaling and rotation
    scalAnimation = Tween<double>(begin: 1, end: 0.8).animate(CurvedAnimation(
        parent: _animationController, curve: Curves.fastOutSlowIn));
    animation = Tween<double>(begin: 0, end: 1).animate(CurvedAnimation(
        parent: _animationController, curve: Curves.fastOutSlowIn));

    super.initState();
  }

  @override
  void dispose() {
    // Dispose animation controller to avoid memory leaks
    _animationController.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Extend body behind the bottom navigation bar
      extendBody: true,
      // Prevent bottom overflow when keyboard is shown
      resizeToAvoidBottomInset: false,
      backgroundColor: backgroundColor2,
      body: GestureDetector(
        onTap: () {
          if (isSideBarOpen) {
            isMenuOpenInput.value = false;
            _animationController.reverse();
            setState(() {
              isSideBarOpen = false;
            });
          }
        },
        child: Stack(
          children: [
            // Animated positioning of the sidebar based on open state
        IgnorePointer(
              child: AnimatedPositioned(
                width: 288,
                height: MediaQuery.of(context).size.height,
                duration: const Duration(milliseconds: 200),
                curve: Curves.fastOutSlowIn,
                left: isSideBarOpen ? 0 : -288,
                top: 0,
                child: const SideBar(),
              ),
            ),
            // Transform home page with animation
            Transform(
              alignment: Alignment.center,
              // Apply matrix transformation with rotation and depth
              transform: Matrix4.identity()
                ..setEntry(3, 2, 0.001)
                ..rotateY(
                    1 * animation.value - 30 * (animation.value) * pi / 180),
              // Translate home page based on animation value
              child: Transform.translate(
                offset: Offset(animation.value * 265, 0),
                child: Transform.scale(
                  // Scale home page based on animation value
                  scale: scalAnimation.value,
                  child:  ClipRRect(
                    borderRadius: BorderRadius.all(
                      Radius.circular(24),
                    ),
                    child: HomePage(),
                  ),
                ),
              ),
            ),
            // Animated position of the menu button based on isSideBarOpen state
            AnimatedPositioned(
              // Animation duration
              duration: const Duration(milliseconds: 200),
              // Animation curve
              curve: Curves.fastOutSlowIn,
              // Position based on open state
              left: isSideBarOpen ? 220 : 0,
              top: 16,
              child: MenuBtn(
                press: () {
                  // Toggle menu open state in Rive animation
                  isMenuOpenInput.value = !isMenuOpenInput.value;

                  // Animate sidebar open/close based on current animation state
                  if (_animationController.value == 0) {
                    _animationController.forward();
                  } else {
                    _animationController.reverse();
                  }

                  // Update UI state for sidebar open/close
                  setState(() {
                    isSideBarOpen = !isSideBarOpen;
                  });
                },
                riveOnInit: (artboard) {
                  // Get the state machine controller from the artboard
                  final controller = StateMachineController.fromArtboard(
                      artboard, "State Machine");

                  // Add the controller to the artboard
                  artboard.addController(controller!);

                  // Find the trigger input for menu open state
                  isMenuOpenInput =
                      controller.findInput<bool>("isOpen") as SMIBool;

                  // Set initial state of menu open trigger
                  isMenuOpenInput.value = true;
                },
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Transform.translate(
        offset: Offset(0, 100 * animation.value),
        child: SafeArea(
          child: Container(
            padding:
                const EdgeInsets.only(left: 12, top: 12, right: 12, bottom: 12),
            decoration: BoxDecoration(
              color: backgroundColor2.withOpacity(0.8),
              boxShadow: [
                BoxShadow(
                  color: backgroundColor2.withOpacity(0.3),
                  offset: const Offset(0, 20),
                  blurRadius: 20,
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ...List.generate(
                  bottomNavItems.length,
                  (index) {
                    Menu navBar = bottomNavItems[index];
                    return BtmNavItem(
                      navBar: navBar,
                      press: () {
                        RiveUtils.chnageSMIBoolState(navBar.rive.status!);
                        updateSelectedBtmNav(navBar);
                      },
                      riveOnInit: (artboard) {
                        navBar.rive.status = RiveUtils.getRiveInput(artboard,
                            stateMachineName: navBar.rive.stateMachineName);
                      },
                      selectedNav: selectedBottonNav,
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
