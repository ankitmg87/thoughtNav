import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:thoughtnav/constants/color_constants.dart';
import 'package:thoughtnav/constants/routes/routes.dart';
import 'package:thoughtnav/screens/participant/pre_study/first_time_setup/full_screen_new/full_screen_new_widgets/custom_flat_button.dart';
import 'package:thoughtnav/screens/participant/pre_study/first_time_setup/full_screen_new/full_screen_new_widgets/custom_information_container.dart';

class RewardMethodScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            color: Color(0xFF333333),
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          'Step 3 of 3',
          style: TextStyle(
            color: Color(0xFF333333),
            fontSize: 20.0,
          ),
        ),
        centerTitle: true,
      ),
      body: Center(
        child: Container(
          constraints: BoxConstraints(
            maxWidth: 600.0
          ),
          child: ListView(
            children: [
              CustomInformationContainer(
                title: 'Setup a Reward Method',
                subtitle1:
                    'After you complete this study, you\'ll be awarded a \$150 giftcard.',
              ),
              SizedBox(
                height: 20.0,
              ),
              Container(
                margin: EdgeInsets.all(10.0),
                padding: EdgeInsets.all(12.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16.0),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'How would you like to get paid?',
                      style: TextStyle(
                        color: Color(0xFF3F3F3F),
                        fontWeight: FontWeight.bold,
                        fontSize: 16.0,
                      ),
                    ),
                    SizedBox(
                      height: 10.0,
                    ),
                    Row(
                      children: [
                        _PaymentModeSelectionWidget(
                          screenHeight: screenHeight,
                          logoPath: 'images/paypal_logo.png',
                        ),
                        _PaymentModeSelectionWidget(
                          screenHeight: screenHeight,
                          logoPath: 'images/amazon_logo.png',
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 80.0,
                    ),
                    Text(
                      'Enter the email address for your account',
                      style: TextStyle(
                        fontSize: 16.0,
                      ),
                    ),
                    SizedBox(
                      height: 20.0,
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 10.0),
                      child: Text(
                        'Email',
                        style: TextStyle(
                          color: Colors.grey[400],
                          fontWeight: FontWeight.bold,
                          fontSize: 16.0,
                        ),
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10.0),
                        border: Border.all(color: Colors.grey[300]),
                      ),
                      child: TextFormField(
                        decoration: InputDecoration(
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 10.0,
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 10.0),
                      child: Text(
                        'Password',
                        style: TextStyle(
                          color: Colors.grey[400],
                          fontWeight: FontWeight.bold,
                          fontSize: 16.0,
                        ),
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10.0),
                        border: Border.all(
                          color: Colors.grey[300],
                        ),
                      ),
                      child: TextFormField(
                        decoration: InputDecoration(
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 10.0,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        GestureDetector(
                          onTap: () => Navigator.of(context)
                              .pushNamed(SETUP_COMPLETE_SCREEN),
                          child: Text(
                            'Setup Later',
                            style: TextStyle(
                              color: PROJECT_GREEN,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 40.0,
              ),
              CustomFlatButton(
                label: 'Complete',
                routeName: SETUP_COMPLETE_SCREEN,
              ),
              SizedBox(
                height: 40.0,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _PaymentModeSelectionWidget extends StatefulWidget {
  final String logoPath;

  const _PaymentModeSelectionWidget({
    Key key,
    @required this.screenHeight,
    this.logoPath,
  }) : super(key: key);

  final double screenHeight;

  @override
  __PaymentModeSelectionWidgetState createState() =>
      __PaymentModeSelectionWidgetState();
}

class __PaymentModeSelectionWidgetState
    extends State<_PaymentModeSelectionWidget> {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 8.0),
        height: widget.screenHeight * 0.3,
        // child: DottedBorder(
        //   color: Colors.grey[300],
        //   radius: Radius.circular(20.0),
        //   borderType: BorderType.RRect,
        //   padding: EdgeInsets.all(20.0),
        //   child: Container(
        //     decoration: BoxDecoration(
        //       borderRadius: BorderRadius.circular(20.0),
        //     ),
        //     child: Column(
        //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
        //       children: [
        //         Image(
        //           image: AssetImage(
        //             widget.logoPath,
        //           ),
        //         ),
        //         SizedBox(
        //           height: 20.0,
        //         ),
        //         Container(
        //           padding: EdgeInsets.all(4.0),
        //           decoration: BoxDecoration(
        //             shape: BoxShape.circle,
        //             border: Border.all(
        //               color: Colors.grey[300],
        //             ),
        //           ),
        //           child: Icon(
        //             CupertinoIcons.add,
        //             color: Colors.grey[300],
        //           ),
        //         ),
        //       ],
        //     ),
        //   ),
        // ),
      ),
    );
  }
}
