import 'package:flutter/material.dart';
import 'package:raw_story_new/BLoC/Screens.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:raw_story_new/Styles/Settings.dart';

class Settings extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        leading: IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: Colors.white,
            ),
            onPressed: () {
              ScreenBLoC().toScreen(Screens.HOME);
            }),
        title: Image.asset(
          'assets/Images/raw-story-logo.jpg',
          height: 130.h,
          width: 360.w,
        ),
        centerTitle: true,
      ),
      resizeToAvoidBottomPadding: true,
      bottomNavigationBar: SizedBox(height: 60,),
      body: ListView(
        padding: EdgeInsets.symmetric(vertical: 20.h, horizontal: 20.w),
        children: <Widget>[
          ProfilePage(),
          mediumGap(),
          Notifications(),
          mediumGap(),
          ApplicationSettings(),
          Newsletters(),
        ],
      ),
    );
  }
}

Widget gap(double h) => SizedBox(
      height: h,
    );

Widget smallGap() => gap(8.h);
Widget mediumGap() => gap(16.h);
Widget bigGap() => gap(32.h);

class ProfilePage extends StatelessWidget with SettingsStyle {
  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      title: Text(
        'User Profile',
        style: headingStyle,
      ),
      subtitle: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            mediumGap(),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      'Display Name (appears with comments)',
                      style: subheadingStyle,
                    ),
                    Container(
                      width: 500.w,
                      child: TextField(
                        style: textStyle,
                        decoration: InputDecoration(isDense: true),
                      ),
                    ),
                    mediumGap(),
                    Text(
                      'Email address',
                      style: subheadingStyle,
                    ),
                    smallGap(),
                    Text(
                      'steve@mac.com',
                      style: textStyle,
                    ),
                  ],
                ),
                Spacer(),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    CircleAvatar(
                      backgroundImage: AssetImage('assets/Images/face.png'),
                      radius: 60.ssp,
                    ),
                    smallGap(),
                    Text(
                      'CHANGE',
                      style: alterStyle,
                    )
                  ],
                )
              ],
            ),
            mediumGap(),
            Row(
              children: <Widget>[
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      'Subscription Type',
                      style: subheadingStyle,
                    ),
                    smallGap(),
                    Text(
                      'Monthly',
                      style: textStyle,
                    ),
                  ],
                ),
                Spacer(),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      'Subscription Enquiry',
                      style: subheadingStyle,
                    ),
                    smallGap(),
                    Text(
                      'September 13, 2019',
                      style: textStyle,
                    ),
                  ],
                ),
              ],
            ),
            mediumGap(),
            Text(
              'Payment Method',
              style: subheadingStyle,
            ),
            smallGap(),
            Text(
              'Credit Card - **** **** **** 1234',
              style: textStyle,
            ),
            smallGap(),
            Text(
              'UPDATE OR CHANGE SUBSCRIPTION OR PAYMENT METHOD',
              style: alterStyle,
            ),
          ],
        ),
      ),
    );
  }
}

class Notifications extends StatelessWidget with SettingsStyle {
  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      title: Text(
        'Notifications',
        style: headingStyle,
      ),
      subtitle: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            MySwitch('Enable Notifications', true),
            Text('What would you like to be notified about?'),
            CheckBoxTile('Breaking News'),
            CheckBoxTile('News Alerts'),
            CheckBoxTile('Updates To Bookmarked Stories')
          ],
        ),
      ),
    );
  }
}

class CheckBoxTile extends StatefulWidget {
  final String text;
  CheckBoxTile(this.text);

  @override
  _CheckBoxTileState createState() => _CheckBoxTileState();
}

class _CheckBoxTileState extends State<CheckBoxTile> with SettingsStyle {
  bool selected = true;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 20.w),
      child: Row(
        children: <Widget>[
          Checkbox(
            value: selected,
            onChanged: (v) {
              setState(() {
                selected = !selected;
              });
            },
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            visualDensity: VisualDensity.compact,
            checkColor: Colors.white,
            activeColor: Colors.blue,
          ),
          Text(
            widget.text,
            style: subheadingStyle,
          )
        ],
      ),
    );
  }
}

class ApplicationSettings extends StatelessWidget with SettingsStyle {
  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      title: Text(
        'Application Settings',
        style: headingStyle,
      ),
      subtitle: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            MySwitch('Enable Dark Mode', false),
            Text('Text Size'),
            MySlider()
          ],
        ),
      ),
    );
  }
}

class MySlider extends StatefulWidget {
  @override
  _MySliderState createState() => _MySliderState();
}

class _MySliderState extends State<MySlider> {
  double value = 0.35;
  double min = 0.0;
  double max = 1.0;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            'Aa',
            style: TextStyle(fontSize: 20.ssp),
          ),
          Expanded(
            child: Slider(
                value: value,
                min: min,
                max: max,
                onChanged: (v) {
                  setState(() {
                    value = v;
                  });
                }),
          ),
          Text(
            'Aa',
            style: TextStyle(fontSize: 40.ssp),
          ),
        ],
      ),
    );
  }
}

class Newsletters extends StatelessWidget with SettingsStyle {
  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      title: Text(
        'Newsletters',
        style: headingStyle,
      ),
      subtitle: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Text('You are currently subscribed to receive:'),
            CheckBoxTile('Raw Story Politics'),
            CheckBoxTile('Raw Story Finance'),
            CheckBoxTile('Raw Story Sports')
          ],
        ),
      ),
    );
  }
}

class MySwitch extends StatefulWidget {
  final String text;
  bool value;
  MySwitch(this.text, this.value);

  @override
  _MySwitchState createState() => _MySwitchState();
}

class _MySwitchState extends State<MySwitch> with SettingsStyle{
  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Text(
          widget.text,
          style: subheadingStyle,
        ),
        Spacer(),
        Switch(
          value: widget.value,
          onChanged: (v) {
            setState(() {
              widget.value = v;
            });
          },
          activeColor: Colors.blueAccent,
          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        )
      ],
    );
  }
}
