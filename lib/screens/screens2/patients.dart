import 'package:flutter/material.dart';
import 'package:kf_drawer/kf_drawer.dart';

class CalendarPage extends KFDrawerContent {
  @override
  _CalendarPageState createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  bool requestPage = true;
  bool patientPage = false;
  @override
  Widget build(BuildContext context) {
    return Container(
      height: double.infinity,
      width: double.infinity,
      color: Color.fromRGBO(203, 224, 245, 0.5),
      child: Column(
        children: <Widget>[
          SizedBox(
            height: MediaQuery.of(context).padding.top,
          ),
          Row(
            children: <Widget>[
              ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(32.0)),
                child: Material(
                  shadowColor: Colors.transparent,
                  color: Colors.transparent,
                  child: IconButton(
                    icon: Icon(
                      Icons.sort,
                      color: Colors.black,
                    ),
                    onPressed: widget.onMenuPressed,
                  ),
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                height: MediaQuery.of(context).size.height * 0.07,
                width: MediaQuery.of(context).size.width * 0.40,
                child: ElevatedButton(
                  onPressed: () {
                    setState(() {
                      patientPage = false;
                      requestPage = true;
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    shape: new RoundedRectangleBorder(
                      borderRadius: new BorderRadius.circular(30.0),
                    ),
                    elevation: requestPage ? 50 : 0,
                    primary: requestPage ? Colors.white : Colors.black,
                    onPrimary: Colors.white,
                    side: BorderSide(
                        color: requestPage ? Colors.black : Colors.white,
                        width: 1),
                  ),
                  child: Text(
                    "Patient Request",
                    style: TextStyle(
                        color: requestPage ? Colors.black : Colors.white),
                  ),
                ),
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.05,
              ),
              Container(
                height: MediaQuery.of(context).size.height * 0.07,
                width: MediaQuery.of(context).size.width * 0.40,
                child: ElevatedButton(
                  onPressed: () {
                    setState(() {
                      requestPage = false;
                      patientPage = true;
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    shape: new RoundedRectangleBorder(
                      borderRadius: new BorderRadius.circular(30.0),
                    ),
                    elevation: patientPage ? 50 : 0,
                    primary: patientPage ? Colors.white : Colors.black,
                    onPrimary: Colors.white,
                    side: BorderSide(
                        color: patientPage ? Colors.black : Colors.white,
                        width: 1),
                  ),
                  child: Text(
                    "Your Patients",
                    style: TextStyle(
                        color: patientPage ? Colors.black : Colors.white),
                  ),
                ),
              )
            ],
          ),
          buildpatientReport(
              index: "index",
              imgUrl:
                  "https://static.independent.co.uk/s3fs-public/thumbnails/image/2020/05/13/11/screenshot-2020-05-13-at-11.39.32-am.png?width=1200",
              name: "Bharath Subramanyaa",
              role: "Aug 20 5:30PM",
              tag: "tag",
              onClicked: () {},
              context: context),
        ],
      ),
    );
  }
}

Widget buildpatientReport({
  required String index,
  required String imgUrl,
  required String name,
  required String role,
  required String tag,
  required VoidCallback onClicked,
  required BuildContext context,
}) =>
    Stack(
      children: [
        Container(
          margin: EdgeInsets.all(10),
          height: MediaQuery.of(context).size.height * 0.20,
          width: MediaQuery.of(context).size.width,
          child: Card(
            color: Colors.white,
            clipBehavior: Clip.antiAlias,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(24),
            ),
          ),
        ),
        Container(
          margin: EdgeInsets.all(20),
          height: MediaQuery.of(context).size.height * 0.12,
          width: MediaQuery.of(context).size.width * 0.9,
          child: Card(
            color: Colors.grey.shade200.withOpacity(0.5),
            clipBehavior: Clip.antiAlias,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(24),
            ),
            child: Container(
              padding: EdgeInsets.all(10).copyWith(left: 0, right: 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  imgUrl != ""
                      ? Container(
                          height: 80,
                          width: 80,
                          clipBehavior: Clip.hardEdge,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                          ),
                          child: CircleAvatar(
                              radius: 40,
                              backgroundImage: NetworkImage(imgUrl)),
                        )
                      : CircleAvatar(
                          radius: 40,
                          backgroundImage:
                              AssetImage("assets/images/defaultprofile.jpg")),
                  Container(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          name,
                          style: TextStyle(fontSize: 20, color: Colors.black),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          role,
                          style: TextStyle(fontSize: 14, color: Colors.black),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        Positioned(
            right: 18,
            bottom: 5,
            child: Container(
              margin: EdgeInsets.all(10),
              child: RaisedButton(
                child: Text(
                  'Show Report',
                  style: TextStyle(color: Colors.black),
                ),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)),
                onPressed: () {},
              ),
            )),
      ],
    );

Widget buildRequestCard({
  required String index,
  required String imgUrl,
  required String name,
  required String role,
  required String tag,
  required VoidCallback onClicked,
  required BuildContext context,
}) =>
    Stack(
      children: [
        Container(
          margin: EdgeInsets.all(10),
          height: MediaQuery.of(context).size.height * 0.20,
          width: MediaQuery.of(context).size.width,
          child: Card(
            color: Colors.white,
            clipBehavior: Clip.antiAlias,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(24),
            ),
          ),
        ),
        Container(
          margin: EdgeInsets.all(20),
          height: MediaQuery.of(context).size.height * 0.12,
          width: MediaQuery.of(context).size.width * 0.9,
          child: Card(
            color: Colors.grey.shade200.withOpacity(0.5),
            clipBehavior: Clip.antiAlias,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(24),
            ),
            child: Container(
              padding: EdgeInsets.all(10).copyWith(left: 0, right: 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  imgUrl != ""
                      ? Container(
                          height: 80,
                          width: 80,
                          clipBehavior: Clip.hardEdge,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                          ),
                          child: CircleAvatar(
                              radius: 40,
                              backgroundImage: NetworkImage(imgUrl)),
                        )
                      : CircleAvatar(
                          radius: 40,
                          backgroundImage:
                              AssetImage("assets/images/defaultprofile.jpg")),
                  Container(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          name,
                          style: TextStyle(fontSize: 20, color: Colors.black),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          role,
                          style: TextStyle(fontSize: 14, color: Colors.black),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        Positioned(bottom: 20, child: outTour(context: context)),
      ],
    );

Widget outTour({
  required BuildContext context,
}) {
  return Container(
    width: MediaQuery.of(context).size.width * 0.9,
    child: Container(
      width: MediaQuery.of(context).size.width * 0.67,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          InkWell(
              onTap: () {},
              child: Row(
                children: [
                  Text("ACCEPT"),
                  Icon(Icons.close),
                ],
              )),
          SizedBox(
            width: 10,
          ),
          InkWell(
              onTap: () {},
              child: Row(
                children: [
                  Text("REJECT"),
                  Icon(Icons.close),
                ],
              )),
        ],
      ),
    ),
  );
}
