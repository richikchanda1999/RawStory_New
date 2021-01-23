import 'package:flutter/material.dart';

class ContributionPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Container(
      child: Column(
        children: <Widget>[
          Expanded(
              flex: 1,
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Text(
                  "Contribute to Raw Story",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
              )),
          Expanded(
              flex: 9,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  "Like you, we here at Raw Story believe in the"
                  "power of progressive journalism -- and we're"
                  "investing in the investigative reporting as other"
                  "publications give it the ax. Raw Story readers"
                  "power David Cay Johnston's DCReport, which"
                  "we've expanded to keep watch in Washington."
                  "We've launched a weekly podcast, \"We've Got"
                  "Issues\", focused on issues, not tweets. And"
                  "other news outlets, we've decided to make"
                  "our original content free. But we need your"
                  "support to do what we do.\n\n"
                  "We need your support to keep producing quality"
                  "journalism and deepen our investigative"
                  "reporting. Three silicon valley giants now"
                  "consume 70 percent of all online advertising"
                  "dollars. Every reader contribution, whatever the"
                  "amount, makes a tremendous difference. Invest"
                  "with us in the future.\n\n"
                  "Thank You",
                  style: TextStyle(fontSize: 15),
                ),
              )),
          Expanded(
              flex: 1,
              child: GestureDetector(
                  child: Container(
                alignment: Alignment.center,
                width: width * (2 / 3),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(width: 2, color: Colors.red)),
                child: Text(
                  "Contribute to Raw Story",
                  style:
                      TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
                ),
              ))),
          Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.only(
                    top: 20, bottom: 20, left: 8, right: 8),
                child: Row(
                  children: <Widget>[
                    Expanded(
                        child: Padding(
                      padding: const EdgeInsets.only(right: 4),
                      child: Container(
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(6),
                            border: Border.all(width: 2, color: Colors.black)),
                        child: Image.asset("assets/Images/applepay.png"),
                      ),
                    )),
                    Expanded(
                        child: Padding(
                      padding: const EdgeInsets.only(left: 2, right: 2),
                      child: Container(
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(6),
                            border: Border.all(width: 2, color: Colors.black)),
                        child: Image.asset("assets/Images/PP.png"),
                      ),
                    )),
                    Expanded(
                        child: Padding(
                      padding: const EdgeInsets.only(left: 4),
                      child: Container(
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(6),
                            border: Border.all(width: 2, color: Colors.black)),
                        child: Image.asset("assets/Images/gpay.png"),
                      ),
                    ))
                  ],
                ),
              )),
          Expanded(
              child: Text(
            "Click here to contribute by check",
            style: TextStyle(color: Colors.red),
          )),
        ],
      ),
    );
  }
}
