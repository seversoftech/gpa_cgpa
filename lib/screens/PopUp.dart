import 'package:flutter/Material.dart';
import 'package:flutter/services.dart';

class PopUpLayout extends ModalRoute {
  Key? key;
  double top = 10;
  double bottom = 20;
  double left = 20;
  double right = 20;
  final Widget child;
  Color? bgColor;

  PopUpLayout({
    this.key,
    required this.child,
    required this.top,
    required this.bottom,
    required this.left,
    required this.right,
    this.bgColor,
  });

  @override
  Duration get transitionDuration => const Duration(milliseconds: 300);
  @override
  bool get opaque => false;
  @override
  bool get barrierDismissible => false;
  @override
  Color? get barrierColor => bgColor ?? Colors.black.withOpacity(0.5);
  @override
  String? get barrierLabel => null;
  @override
  bool get maintainState => false;

  @override
  Widget buildPage(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
  ) {
    return GestureDetector(
      onTap: () {
        SystemChannels.textInput.invokeMethod('TextInput.hide');
      },
      child: Material(
        type: MaterialType.transparency,
        child: SafeArea(
          bottom: true,
          child: _buildOverlayContent(context),
        ),
      ),
    );
  }

  Widget _buildOverlayContent(BuildContext context) {
    return Container(
      margin:
          EdgeInsets.only(bottom: bottom, left: left, top: top, right: right),
      child: child,
    );
  }

  @override
  Widget buildTransitions(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation, Widget child) {
    return FadeTransition(
      opacity: animation,
      child: ScaleTransition(
        scale: animation,
        child: child,
      ),
    );
  }
}

class PopUpContent extends StatefulWidget {
  @override
  _PopUpContentState createState() => _PopUpContentState();
  final Widget content;
  const PopUpContent({
    super.key,
    required this.content,
  });
}

class _PopUpContentState extends State<PopUpContent> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: widget.content,
    );
  }
}

showPopUp(
  BuildContext context,
  Widget widget,
  String title, {
  BuildContext? popUpContext,
}) {
  Navigator.push(
    context,
    PopUpLayout(
      top: 30,
      bottom: 50,
      left: 30,
      right: 30,
      child: PopUpContent(
        content: Scaffold(
          appBar: AppBar(
            centerTitle: true,
            title: Text(
              title,
            ),
            leading: Builder(
              builder: (context) {
                return IconButton(
                  icon: const Icon(Icons.arrow_back_ios_new_outlined),
                  onPressed: () {
                    try {
                      Navigator.pop(context);
                    } catch (e) {
                      // exception caught
                    }
                  },
                );
              },
            ),
          ),
          body: widget,
        ),
      ),
    ),
  );
}
