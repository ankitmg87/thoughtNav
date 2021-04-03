import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:thoughtnav/constants/color_constants.dart';
import 'package:thoughtnav/screens/researcher/models/participant.dart';

import 'custom_information_container.dart';

class OnboardingPage3 extends StatefulWidget {
  final Participant participant;

  const OnboardingPage3({Key key, this.participant}) : super(key: key);

  @override
  _OnboardingPage3State createState() => _OnboardingPage3State();
}

class _OnboardingPage3State extends State<OnboardingPage3> {
  final _amazonPaymentModel = PaymentRadioModel('Amazon', false);
  final _paypalPaymentModel = PaymentRadioModel('Paypal', false);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: Container(
          constraints: BoxConstraints(maxWidth: 600.0),
          child: ListView(
            shrinkWrap: true,
            children: [
              CustomInformationContainer(
                title: 'Setup a Reward Method',
                subtitle1:
                    'After you complete this study, you\'ll be awarded a \$${widget.participant.rewardAmount} giftcard.',
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
                  mainAxisSize: MainAxisSize.min,
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
                        Expanded(
                          child: InkWell(
                            onTap: () {
                              setState(() {
                                _amazonPaymentModel.isSelected = true;
                                _paypalPaymentModel.isSelected = false;
                                widget.participant.paymentMode =
                                    _amazonPaymentModel.paymentMode;
                              });
                            },
                            child: PaymentOptionRadioItem(
                              paymentModeAssetURL: 'images/amazon_logo.png',
                              paymentRadioModel: _amazonPaymentModel,
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 10.0,
                        ),
                        Expanded(
                          child: InkWell(
                            onTap: () {
                              setState(() {
                                _amazonPaymentModel.isSelected = false;
                                _paypalPaymentModel.isSelected = true;
                                widget.participant.paymentMode =
                                    _paypalPaymentModel.paymentMode;
                              });
                            },
                            child: PaymentOptionRadioItem(
                              paymentModeAssetURL: 'images/paypal_logo.png',
                              paymentRadioModel: _paypalPaymentModel,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20.0,),
              Container(
                margin: EdgeInsets.all(10.0),
                padding: EdgeInsets.all(12.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16.0),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Enter a second email for receiving rewards (optional)',
                      style: TextStyle(
                        color: Color(0xFF3F3F3F),
                        fontWeight: FontWeight.bold,
                        fontSize: 16.0,
                      ),
                    ),
                    SizedBox(
                      height: 10.0,
                    ),
                    TextFormField(
                      initialValue: widget.participant.email,
                      onChanged: (secondaryEmail){
                        widget.participant.secondaryEmail = secondaryEmail;
                      },
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.grey[200],
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16.0),
                          borderSide: BorderSide(
                            width: 0,
                            style: BorderStyle.none,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class PaymentOptionRadioItem extends StatelessWidget {
  final String paymentModeAssetURL;
  final PaymentRadioModel paymentRadioModel;

  PaymentOptionRadioItem({
    this.paymentRadioModel,
    this.paymentModeAssetURL,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.0),
        border: Border.all(
          color:
              paymentRadioModel.isSelected ? PROJECT_GREEN : Colors.grey[400],
          width: paymentRadioModel.isSelected ? 5.0 : 1.0,
        ),
      ),
      child: Image(
        image: AssetImage(
          paymentModeAssetURL,
        ),
      ),
    );
  }
}

class PaymentRadioModel {
  bool isSelected;
  final String paymentMode;

  PaymentRadioModel(this.paymentMode, this.isSelected);
}
