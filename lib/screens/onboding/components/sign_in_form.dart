import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:rive/rive.dart';
import 'package:rive_animation/screens/entryPoint/entry_point.dart';

class SignInForm extends StatefulWidget {
  const SignInForm({
    Key? key,
  }) : super(key: key);

  @override
  State<SignInForm> createState() => _SignInFormState();
}

class _SignInFormState extends State<SignInForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>(); // Key for the form
  bool isShowLoading = false; // Flag to show or hide loading animation
  bool isShowConfetti = false; // Flag to show or hide confetti animation
  late SMITrigger error; // Trigger for error state in Rive animation
  late SMITrigger success; // Trigger for success state in Rive animation
  late SMITrigger reset; // Trigger for reset state in Rive animation
  late SMITrigger confetti; // Trigger for confetti animation

  void _onCheckRiveInit(Artboard artboard) { // Called when Rive animation is initialized
    // Get the state machine controller from the artboard
    StateMachineController? controller =
    StateMachineController.fromArtboard(artboard, 'State Machine 1');

    // Add the controller to the artboard
    artboard.addController(controller!);

    // Find the trigger inputs for different states
    error = controller.findInput<bool>('Error') as SMITrigger;
    success = controller.findInput<bool>('Check') as SMITrigger;
    reset = controller.findInput<bool>('Reset') as SMITrigger;
  }

  void _onConfettiRiveInit(Artboard artboard) { // Called when Rive animation is initialized
    // Get the state machine controller from the artboard
    StateMachineController? controller = StateMachineController.fromArtboard(artboard, "State Machine 1");

    // Add the controller to the artboard
    artboard.addController(controller!);

    // Find the trigger input for confetti animation
    confetti = controller.findInput<bool>("Trigger explosion") as SMITrigger;
  }

  // Handle the sign in button click
  void singIn(BuildContext context) {
    // Trigger the confetti animation
    // confetti.fire();

    // Update loading and confetti states
    setState(() {
      isShowConfetti = true;
      isShowLoading = true;
    });

    // Delay for simulating API call
    Future.delayed(
      const Duration(seconds: 1),
          () {
        // Validate the form
        if (_formKey.currentState!.validate()) {
          // Show success state in Rive animation
          success.fire();

          // Delay for simulating API call response
          Future.delayed(
            const Duration(seconds: 2),
                () {
              // Hide loading animation
              setState(() {
                isShowLoading = false;
              });

              // Trigger confetti animation
              confetti.fire();

              // Delay for showing confetti
              Future.delayed(const Duration(seconds: 1), () {
                // Navigate to another page and hide confetti
                // Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>  EntryPoint(),
                  ),
                );
              });
            },
          );
        } else {
          // Show error state in Rive animation
          error.fire();

          // Delay for showing error message
          Future.delayed(
            const Duration(seconds: 2),
                () {
              // Hide loading animation
              setState(() {
                isShowLoading = false;
              });

              // Reset the Rive animation
              reset.fire();
            },
          );
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Form for email and password input
        Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Email",
                style: TextStyle(
                  color: Colors.black54,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 8, bottom: 16),
                child: TextFormField(
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "";
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    prefixIcon: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: SvgPicture.asset("assets/icons/email.svg"),
                    ),
                  ),
                ),
              ),
              const Text(
                "Password",
                style: TextStyle(
                  color: Colors.black54,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 8, bottom: 16),
                child: TextFormField(
                  obscureText: true,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "";
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    prefixIcon: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: SvgPicture.asset("assets/icons/password.svg"),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 8, bottom: 24),
                child: ElevatedButton.icon(
                  onPressed: () {
                    singIn(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFF77D8E),
                    minimumSize: const Size(double.infinity, 56),
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(10),
                        topRight: Radius.circular(25),
                        bottomRight: Radius.circular(25),
                        bottomLeft: Radius.circular(25),
                      ),
                    ),
                  ),
                  icon: const Icon(
                    CupertinoIcons.arrow_right,
                    color: Color(0xFFFE0037),
                  ),
                  label: const Text("Sign In"),
                ),
              ),
            ],
          ),
        ),
        isShowLoading
            ? CustomPositioned(
                child: RiveAnimation.asset(
                  'assets/RiveAssets/check.riv',
                  fit: BoxFit.cover,
                  onInit: _onCheckRiveInit,
                ),
              )
            : const SizedBox(),
        isShowConfetti
            ? CustomPositioned(
                scale: 6,
                child: RiveAnimation.asset(
                  "assets/RiveAssets/confetti.riv",
                  onInit: _onConfettiRiveInit,
                  fit: BoxFit.cover,
                ),
              )
            : const SizedBox(),
      ],
    );
  }
}

class CustomPositioned extends StatelessWidget {
  const CustomPositioned({super.key, this.scale = 1, required this.child});

  final double scale;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: Column(
        children: [
          const Spacer(),
          SizedBox(
            height: 100,
            width: 100,
            child: Transform.scale(
              scale: scale,
              child: child,
            ),
          ),
          const Spacer(flex: 2),
        ],
      ),
    );
  }
}
