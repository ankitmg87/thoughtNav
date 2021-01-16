import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:thoughtnav/screens/researcher/models/insight.dart';

class InsightWidget extends StatelessWidget {
  final Insight insight;

  const InsightWidget({
    Key key,
    this.insight,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(8.0),
      color: Colors.grey[100],
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              insight.moderatorAvatarURL != null
                  ? CachedNetworkImage(
                imageUrl: insight.moderatorAvatarURL,
                imageBuilder: (context, imageProvider) {
                  return Container(
                    decoration: BoxDecoration(
                        shape: BoxShape.circle, color: Colors.white),
                    padding: EdgeInsets.all(5.0),
                    width: 30.0,
                    height: 30.0,
                    child: Image(
                      image: imageProvider,
                    ),
                  );
                },
              )
                  : Container(
                decoration: BoxDecoration(
                    shape: BoxShape.circle, color: Colors.white),
                padding: EdgeInsets.all(5.0),
                width: 30.0,
                height: 30.0,
                child: Image(
                  image: AssetImage(
                    'images/researcher_images/researcher_dashboard/participant_icon.png',
                  ),
                ),
              ),
              SizedBox(
                width: 20.0,
              ),
              RichText(
                text: TextSpan(
                  text: insight.moderatorName ?? 'Mike Courtney',
                  style: TextStyle(
                    color: Colors.grey[700],
                    fontWeight: FontWeight.bold,
                    fontSize: 12.0,
                  ),
                  children: [
                    TextSpan(
                      text: ' says:',
                      style: TextStyle(
                        fontSize: 12.0,
                        color: Colors.grey[700],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(
            height: 10.0,
          ),
          Row(
            children: [
              SizedBox(
                width: 50.0,
              ),
              Expanded(
                child: Text(
                  insight.insightStatement,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 12.0,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}