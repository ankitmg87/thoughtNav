// Copyright © 2021, Aperio Insights. Version 1.0.0
// All rights reserved.

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:thoughtnav/constants/color_constants.dart';
import 'package:thoughtnav/constants/routes/routes.dart';
import 'package:thoughtnav/screens/researcher/models/participant.dart';
import 'package:thoughtnav/services/firebase_firestore_service.dart';
import 'package:thoughtnav/services/participant_firestore_service.dart';

class PostStudyRewardMethodsScreen extends StatefulWidget {
  @override
  _PostStudyRewardMethodsScreenState createState() =>
      _PostStudyRewardMethodsScreenState();
}

class _PostStudyRewardMethodsScreenState
    extends State<PostStudyRewardMethodsScreen> {
  final _firebaseFirestoreService = FirebaseFirestoreService();

  final _amazonPaymentModel = PaymentRadioModel('Amazon', false);
  final _paypalPaymentModel = PaymentRadioModel('Paypal', false);

  String _studyUID;
  String _participantUID;

  Participant _participant;

  Future<void> _futureParticipant;

  Future<void> _getParticipant(String studyUID, String participantUID) async {
    _participant = await _firebaseFirestoreService.getParticipant(
        studyUID, participantUID);
  }

  @override
  void initState() {
    var getStorage = GetStorage();

    _studyUID = getStorage.read('studyUID');
    _participantUID = getStorage.read('participantUID');

    _futureParticipant = _getParticipant(_studyUID, _participantUID);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    if (screenSize.width < screenSize.height) {
      return WillPopScope(
        onWillPop: () async {
          await Navigator.of(context).popAndPushNamed(PARTICIPANT_DASHBOARD_SCREEN);
          return true;
        },
        child: Scaffold(
          appBar: buildPhoneAppBar(context),
          body: buildPhoneBody(screenSize),
        ),
      );
    } else {
      return Scaffold(
        appBar: _buildDesktopAppBar(context),
        body: buildDesktopBody(screenSize),
      );
    }
  }

  Widget buildDesktopBody(Size screenSize) {
    return FutureBuilder(
      future: _futureParticipant,
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.none:
          case ConnectionState.waiting:
          case ConnectionState.active:
            return Center(
              child: Text('Loading...'),
            );
            break;
          case ConnectionState.done:
            if (_participant.paymentMode == 'amazon') {
              _amazonPaymentModel.isSelected = true;
              _paypalPaymentModel.isSelected = false;
            } else {
              _amazonPaymentModel.isSelected = false;
              _paypalPaymentModel.isSelected = true;
            }

            return Container(
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          'Set up a Reward Method',
                          style: TextStyle(
                            color: TEXT_COLOR,
                            fontSize: 24.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(
                          height: 20.0,
                        ),
                        Text(
                          'After you complete this study,\nyou\'ll be awarded a \$${_participant.rewardAmount} giftcard.',
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Container(
                      color: TEXT_COLOR.withOpacity(0.1),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'How would you like to get paid?',
                            style: TextStyle(
                              color: TEXT_COLOR,
                              fontSize: 18.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Align(
                            child: Container(
                              margin: EdgeInsets.all(10.0),
                              padding: EdgeInsets.all(12.0),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(16.0),
                              ),
                              constraints: BoxConstraints(maxWidth: 500.0),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: InkWell(
                                      onTap: () {
                                        setState(() {
                                          _amazonPaymentModel.isSelected = true;
                                          _paypalPaymentModel.isSelected =
                                              false;

                                          _participant != null
                                              ? _participant.paymentMode =
                                                  _amazonPaymentModel
                                                      .paymentMode
                                              : null;
                                        });
                                      },
                                      child: PaymentOptionRadioItem(
                                        paymentModeAssetURL:
                                            'images/amazon_logo.png',
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
                                          _amazonPaymentModel.isSelected =
                                              false;
                                          _paypalPaymentModel.isSelected = true;
                                          _participant != null
                                              ? _participant.paymentMode =
                                                  _paypalPaymentModel
                                                      .paymentMode
                                              : null;
                                        });
                                      },
                                      child: PaymentOptionRadioItem(
                                        paymentModeAssetURL:
                                            'images/paypal_logo.png',
                                        paymentRadioModel: _paypalPaymentModel,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 20.0,
                          ),
                          Align(
                            child: Container(
                              constraints: BoxConstraints(maxWidth: 500.0),
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
                                    initialValue: _participant != null
                                        ? _participant.secondaryEmail
                                        : null,
                                    decoration: InputDecoration(
                                      filled: true,
                                      fillColor: Colors.grey[200],
                                      border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(16.0),
                                        borderSide: BorderSide(
                                          width: 0,
                                          style: BorderStyle.none,
                                        ),
                                      ),
                                    ),
                                    onChanged: (secondaryEmail) {
                                      _participant.secondaryEmail =
                                          secondaryEmail;
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ),
                          FlatButton(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(6.0),
                            ),
                            color: PROJECT_GREEN,
                            onPressed: () async {
                              await _firebaseFirestoreService.updateParticipant(
                                  _studyUID, _participant);
                              await Navigator.of(context).popAndPushNamed(
                                  PARTICIPANT_DASHBOARD_SCREEN);
                            },
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: screenSize.width * 0.05,
                                  vertical: 10.0),
                              child: Text(
                                'Continue',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 13.0,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
            break;
          default:
            return Center(
              child: Text('Loading...'),
            );
        }
      },
    );
  }

  Widget buildPhoneBody(Size screenSize) {
    return FutureBuilder(
      future: _futureParticipant,
      builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.none:
          case ConnectionState.waiting:
          case ConnectionState.active:
            return Center(
              child: Text('Loading...'),
            );
            break;
          case ConnectionState.done:
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'Set up a Reward Method',
                      style: TextStyle(
                        color: TEXT_COLOR,
                        fontSize: 24.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(
                      height: 20.0,
                    ),
                    Text(
                      'After you complete this study,\nyou\'ll be awarded a \$${_participant.rewardAmount} giftcard.',
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
                SizedBox(
                  height: 40.0,
                ),
                Container(
                  color: TEXT_COLOR.withOpacity(0.1),
                  padding: EdgeInsets.all(30.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'How would you like to get paid?',
                        style: TextStyle(
                          color: TEXT_COLOR,
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Align(
                        child: Container(
                          margin: EdgeInsets.all(10.0),
                          padding: EdgeInsets.all(12.0),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16.0),
                          ),
                          constraints: BoxConstraints(maxWidth: 500.0),
                          child: Row(
                            children: [
                              Expanded(
                                child: InkWell(
                                  onTap: () {
                                    setState(() {
                                      _amazonPaymentModel.isSelected = true;
                                      _paypalPaymentModel.isSelected = false;

                                      _participant != null
                                          ? _participant.paymentMode =
                                              _amazonPaymentModel.paymentMode
                                          : null;
                                    });
                                  },
                                  child: PaymentOptionRadioItem(
                                    paymentModeAssetURL:
                                        'images/amazon_logo.png',
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
                                      _participant != null
                                          ? _participant.paymentMode =
                                              _paypalPaymentModel.paymentMode
                                          : null;
                                    });
                                  },
                                  child: PaymentOptionRadioItem(
                                    paymentModeAssetURL:
                                        'images/paypal_logo.png',
                                    paymentRadioModel: _paypalPaymentModel,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 20.0,
                      ),
                      Align(
                        child: Container(
                          constraints: BoxConstraints(maxWidth: 500.0),
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
                                initialValue: _participant != null
                                    ? _participant.secondaryEmail
                                    : null,
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
                                onChanged: (secondaryEmail) {
                                  _participant.secondaryEmail = secondaryEmail;
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 20.0,
                      ),
                      FlatButton(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(6.0),
                        ),
                        color: PROJECT_GREEN,
                        onPressed: () {
                          Navigator.of(context)
                              .popAndPushNamed(PARTICIPANT_DASHBOARD_SCREEN);
                        },
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: screenSize.width * 0.05,
                              vertical: 10.0),
                          child: Text(
                            'Continue',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 13.0,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            );
            break;
          default:
            return Center(
              child: Text('Loading...'),
            );
        }
      },
    );
  }

  AppBar buildPhoneAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      leading: IconButton(
        icon: Icon(
          Icons.arrow_back_ios,
          color: Color(0xFF333333),
        ),
        onPressed: () =>
            Navigator.of(context).popAndPushNamed(PARTICIPANT_DASHBOARD_SCREEN),
      ),
      title: Text(
        'Reward Methods',
        style: TextStyle(
          color: Color(0xFF333333),
          fontWeight: FontWeight.bold,
        ),
      ),
      centerTitle: true,
    );
  }

  AppBar _buildDesktopAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      leading: IconButton(
        icon: Icon(
          Icons.arrow_back_ios,
          color: Color(0xFF333333),
        ),
        onPressed: () => Navigator.of(context).popAndPushNamed(PARTICIPANT_DASHBOARD_SCREEN),
      ),
      title: Text(
        'Reward Methods',
        style: TextStyle(
          color: Color(0xFF333333),
          fontWeight: FontWeight.bold,
        ),
      ),
      centerTitle: true,
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
