import 'package:flutter/material.dart';
import 'package:law_education_app/conts.dart';
import 'package:law_education_app/screens/auth/signup_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'onboarding_1.dart';
import 'onboarding_2.dart';
import 'onboarding_3.dart';


class OnBooardingScreen extends StatefulWidget {
  const OnBooardingScreen({super.key});

  @override
  State<OnBooardingScreen> createState() => _OnBooardingScreenState();
}

class _OnBooardingScreenState extends State<OnBooardingScreen> {

  PageController controllerDef =  PageController();
  int currentPage=0;

  Future<void> CompletedOnBoardingScreen()async
  {
    SharedPreferences sp = await SharedPreferences.getInstance();
    await sp.setBool("seenOnBoadingScreen",true);
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => SignUpScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          PageView(
            controller: controllerDef,
            onPageChanged: (int page)
            {
              setState(() {
                currentPage=page;
              });
            },
            children: [
              OnBoardingScreen1(),
              OnBoardingScreen2(),
              OnBoardingScreen3(),
            ],
          ),
          Align(
            alignment: Alignment.topRight,
            child: Padding(
              padding: const EdgeInsets.only(right: 15,top: 70),
              child: InkWell(
                onTap: ()
                {
                  controllerDef.jumpToPage(2);
                },
                child: Container(
                  child: Text("Skip",style: TextStyle(
                      fontSize: 15,
                      color: Colors.grey,
                      fontWeight: FontWeight.bold
                  ),),
                ),
              ),
            ),
          ),
          Container(
            child:
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 55),
                child: SmoothPageIndicator(
                  controller: controllerDef,
                  count: 3,
                  effect: WormEffect(
                    activeDotColor: primaryColor,
                  ),
                ),
              ),
            ),
          ),
          Visibility(
            visible: currentPage>0,
            child: Align(
              alignment: Alignment.bottomLeft,
              child: Padding(
                padding: const EdgeInsets.only(left: 20,bottom: 50),
                child: InkWell(
                  onTap: ()
                  {
                    controllerDef.previousPage(duration: Duration(milliseconds: 500),
                        curve: Curves.easeIn);
                  },
                  child: Container(
                    child: Text("Previous",style: TextStyle(
                        fontSize: 15,
                        color: Colors.grey,
                        fontWeight: FontWeight.bold
                    ),),
                  ),
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomRight,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 50),
              child: currentPage==2?doneButton():nextButton(),
            ),
          )
        ],
      ),
    );
  }

  doneButton() {
    return ClipRRect(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(20.0), // Rounded top-left corner
        bottomLeft: Radius.circular(20.0), // Rounded bottom-left corner
        topRight: Radius.circular(0.0), // Straight top-right corner
        bottomRight: Radius.circular(0.0), // Straight bottom-right corner
      ),
      child: InkWell(
        onTap: ()
        {
          CompletedOnBoardingScreen();
        },
        child: Container(
          alignment: Alignment.bottomRight,
          height: 30,
          width: 100,
          color: primaryColor,
          child: Center(
            child: Text("Get Started",style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 15,
              color: Colors.white,
            ),),
          ),
        ),
      ),
    );
  }
  nextButton() {
    return InkWell(
      onTap: ()
      {
        controllerDef.nextPage(duration: Duration(milliseconds: 500),
          curve: Curves.easeIn,);
      },
      child: Container(
        padding: const EdgeInsets.only(right: 20,),
        child: Text("Next",style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 15,
          color: primaryColor,
        ),),
      ),
    );
  }

}


