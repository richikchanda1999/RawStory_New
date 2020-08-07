import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:raw_story_new/BLoC/BookmarkedStories.dart';
import 'package:raw_story_new/BLoC/Screens.dart';
import 'package:raw_story_new/Styles/BookmarkedStories.dart';
import 'package:raw_story_new/UI/Settings.dart';

class BookmarkedStories extends StatelessWidget {
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
      bottomNavigationBar: SizedBox(
        height: 60,
      ),
      body: DismissibleList(),
    );
  }
}

class DismissibleList extends StatefulWidget {
  @override
  _DismissibleListState createState() => _DismissibleListState();
}

class _DismissibleListState extends State<DismissibleList>
    with BookmarkedStoriesStyle {
  @override
  Widget build(BuildContext context) {
    return ListView.separated(
        itemBuilder: (_, index) {
          return Dismissible(
              key: UniqueKey(),
              secondaryBackground: Container(
                color: Colors.red,
                padding: EdgeInsets.symmetric(horizontal: 40.ssp),
                child: Align(
                    alignment: Alignment.centerRight,
                    child: Icon(
                      Icons.delete,
                      color: Colors.white,
                      size: 100.ssp,
                    )),
              ),
              background: Container(),
              direction: DismissDirection.horizontal,
              onDismissed: (d) {
                setState(() {
                  BookmarkedStoriesBLoC().headings.removeAt(d.index);
                  BookmarkedStoriesBLoC().dates.removeAt(d.index);
                });
              },
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 20.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      BookmarkedStoriesBLoC().headings[index],
                      style: headingStyle,
                      textAlign: TextAlign.justify,
                    ),
                    gap(5.h),
                    Text(
                      'Published ${BookmarkedStoriesBLoC().dates[index]}',
                      style: dateStyle,
                    )
                  ],
                ),
              ));
        },
        separatorBuilder: (_, index) {
          return Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: Divider(
              thickness: 3.ssp,
              height: 10.h,
              color: Colors.grey,
            ),
          );
        },
        itemCount: BookmarkedStoriesBLoC().headings.length);
  }
}
