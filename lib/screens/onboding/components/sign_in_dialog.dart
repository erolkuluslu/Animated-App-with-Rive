// Import necessary libraries
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'sign_in_form.dart';

// Function to show a custom dialog
void showCustomDialog(BuildContext context,
    {required ValueChanged<dynamic> onValue}) {
  // Function to handle dialog closing and passing result
  showGeneralDialog(
    context: context, // Context of the calling widget
    barrierLabel:
        "Barrier", // Label for the barrier (invisible layer behind the dialog)
    barrierDismissible: true, // Whether tapping outside the dialog dismisses it
    barrierColor: Colors.black
        .withOpacity(0.5), // Color of the barrier (with transparency)
    transitionDuration:
        const Duration(milliseconds: 400), // Duration of the dialog animation
    pageBuilder: (_, __, ___) {
      // Content of the dialog
      return Center(
        child: Container(
          height: 620, // Height of the dialog container
          margin: const EdgeInsets.symmetric(
              horizontal: 16), // Margin around the container
          padding: const EdgeInsets.symmetric(
              vertical: 32, horizontal: 24), // Padding inside the container
          decoration: BoxDecoration(
            color: Colors.white
                .withOpacity(0.95), // Background color with transparency
            borderRadius:
                BorderRadius.circular(40), // Border radius of the container
            boxShadow: [
              // Shadows for depth effect
              BoxShadow(
                color: Colors.black
                    .withOpacity(0.3), // Shadow color with transparency
                offset: const Offset(0, 30), // Offset of the shadow
                blurRadius: 60, // Blur radius of the shadow
              ),
              const BoxShadow(
                color: Colors.black45, // Shadow color without transparency
                offset: Offset(0, 30), // Offset of the shadow
                blurRadius: 60, // Blur radius of the shadow
              ),
            ],
          ),
          child: Scaffold(
            resizeToAvoidBottomInset:
                false, // Prevent content from being pushed up by keyboard
            backgroundColor:
                Colors.transparent, // Background color of the scaffold
            body: Stack(
              clipBehavior:
                  Clip.none, // Allow children to overflow the container
              children: [
                // Main content of the dialog
                Column(
                  children: [
                    const Text(
                      "Sign in", // Title of the dialog
                      style: TextStyle(
                        fontSize: 34, // Font size of the title
                        fontFamily: "Poppins", // Font family of the title
                        fontWeight: FontWeight.w600, // Font weight of the title
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(
                          vertical: 16), // Padding below the title
                      child: Text(
                        "To access various feature please sign in", // Subheading of the dialog
                        textAlign: TextAlign.center, // Text alignment
                      ),
                    ),
                    const SignInForm(), // Sign in form widget
                    Row(
                      children: const [
                        // Horizontal divider
                        Expanded(
                          child: Divider(),
                        ),
                        // OR text separating social login options
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16),
                          child: Text(
                            "OR",
                            style: TextStyle(
                              color: Colors.black26, // Text color
                              fontWeight: FontWeight.w500, // Font weight
                            ),
                          ),
                        ),
                        // Horizontal divider
                        Expanded(child: Divider()),
                      ],
                    ),
                    // Subheading for social login options
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 24),
                      child: Text(
                        "Sign up with Email, Apple or Google",
                        style: TextStyle(color: Colors.black54), // Text color
                      ),
                    ),
                    // Row of social login buttons
                    Row(
                      mainAxisAlignment: MainAxisAlignment
                          .spaceEvenly, // Spacing between buttons
                      children: [
                        IconButton(
                          onPressed: () {}, // Handle email login button click
                          icon: SvgPicture.asset(
                            // Email icon using SVG
                            "assets/icons/email_box.svg",
                            height: 64, // Icon height
                            width: 64, // Icon width
                          ),
                        ),
                        IconButton(
                          onPressed: () {}, // Handle Apple login button click
                          icon: SvgPicture.asset(
                            "assets/icons/apple_box.svg",
                            height: 64,
                            width: 64,
                          ),
                        ),
                        IconButton(
                          onPressed: () {},
                          padding: EdgeInsets.zero,
                          icon: SvgPicture.asset(
                            "assets/icons/google_box.svg",
                            height: 64,
                            width: 64,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                // Close button positioned at the bottom
                const Positioned(
                  left: 0,
                  right: 0,
                  bottom: -48,
                  child: CircleAvatar(
                    radius: 16,
                    backgroundColor: Colors.white,
                    child: Icon(
                      Icons.close,
                      size: 20,
                      color: Colors.black,
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      );
    },
    // Transition animation for the dialog

    transitionBuilder: (_, anim, __, child) {
      Tween<Offset> tween;
      tween = Tween(begin: const Offset(0, -1), end: Offset.zero);
      // Slide transition animation
      return SlideTransition(
        // Animated position based on the tween
      position: tween.animate(
          CurvedAnimation(parent: anim, curve: Curves.easeInOut),
        ),
        child: child,
      );
    },
  ).then(onValue); // Pass the result to the onValue callback when the dialog closes
}
