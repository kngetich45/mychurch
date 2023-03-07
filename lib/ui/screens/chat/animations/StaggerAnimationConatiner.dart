import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart' show timeDilation;

 

class StaggerAnimationConatiner extends StatelessWidget {
  final Animation<double> buttonController;
  final Animation buttonZoomOutAnimation;
  final Animation<Alignment> buttonBottomtoCenterAnimation;

  StaggerAnimationConatiner({Key? key, required this.buttonController})
      : buttonZoomOutAnimation = new Tween(
          begin: 60.0,
          end: 500.0,
        )
            .animate(
          new CurvedAnimation(parent: buttonController, curve: Curves.easeOut),
        ),
        buttonBottomtoCenterAnimation = new AlignmentTween(
          begin: Alignment.bottomRight,
          end: Alignment.center,
        )
            .animate(
          new CurvedAnimation(
            parent: buttonController,
            curve: new Interval(
              0.0,
              0.200,
              curve: Curves.easeOut,
            ),
          ),
        ),
        super(key: key);



  Widget _buildAnimation(BuildContext context, Widget? child) {
    timeDilation = 0.4;

    return (new Padding(
        padding: buttonZoomOutAnimation.value < 1000
            ? new EdgeInsets.all(0.0)
            : new EdgeInsets.all(0.0),
           child: new Container( 
            width: MediaQuery.of(context).size.width/2,
           height: MediaQuery.of(context).size.height/2,
           alignment: buttonBottomtoCenterAnimation.value,
                decoration: new BoxDecoration(
                    color: const Color.fromRGBO(247, 64, 106, 1.0),
                    shape: MediaQuery.of(context).size.width < 1000
                        ? BoxShape.rectangle
                        : BoxShape.rectangle),


           
            )));
  }

  @override
  Widget build(BuildContext context) {
    buttonController.addListener(() {
      // if (controller.isCompleted) Navigator.pushNamed(context, "/login");    //options
      // if (controller.isCompleted) Navigator.of(context).pop();       //options
      if (buttonController.isCompleted) {
       // Navigator.pushReplacementNamed(context, "/login");
       //Navigator.of(context).pushNamed(Routes.chatHome);
      }
    });
    return new AnimatedBuilder(
      builder: _buildAnimation,
      animation: buttonController,
    );
  }
}
