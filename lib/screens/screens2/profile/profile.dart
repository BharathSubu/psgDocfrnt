import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_tags/flutter_tags.dart';
import 'package:kf_drawer/kf_drawer.dart';

// ignore: must_be_immutable
class Profile extends KFDrawerContent {
  Profile({Key? key});

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  // ignore: deprecated_member_use

  final List _items = [];
  double _fontSize = 14;
  final GlobalKey<TagsState> _tagStateKey = GlobalKey<TagsState>();

  // NetworkHandler networkHandler = NetworkHandler();
  Widget page = CircularProgressIndicator();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    checkProfile();
  }

  void checkProfile() async {
    // var response = await networkHandler.get("profile/checkProfile");
    // if (response["status"]) {
    //   setState(() {
    //     page = MainProfile();
    //   });
    // } else {
    //   setState(() {
    //     page = button();
    //   });
    // }
    page = button();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: double.infinity,
      width: double.infinity,
      color: Color.fromRGBO(203, 224, 245, 0.5),
      child: Stack(fit: StackFit.expand, children: [
        Column(
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
            Expanded(child: button()),
          ],
        ),
      ]),
    );
  }

  Widget showProfile() {
    return Center(child: Text("Profile Data is Avalable"));
  }

  Widget button() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 70),
      child: Column(
        children: <Widget>[
          const SizedBox(height: 24),
          buildName(),
          const SizedBox(height: 12),
          Center(child: buildUpgradeButton()),
          const SizedBox(height: 12),
          buildAbout(),
          // Text(
          //   "Complete Your Profile",
          //   textAlign: TextAlign.center,
          //   style: TextStyle(
          //     color: Colors.deepOrange,
          //     fontSize: 18,
          //   ),
          // ),
          // SizedBox(
          //   height: 30,
          // ),
          // SizedBox(
          //   width: double.infinity,
          //   child: ElevatedButton(
          //     onPressed: () {
          // if (_formKey.currentState!.validate()) {
          //   // Sign up form is done
          //   // It saved our inputs
          //   _formKey.currentState!.save();
          //   //  Sign in also done
          // }
          // Navigator.push(
          //     context,
          //     MaterialPageRoute(
          //       builder: (context) => CreateProfile(),
          //     ));
          //     },
          //     child: Text("Sign In"),
          //   ),
          // ),
        ],
      ),
    );
  }

  Widget buildName() => Column(
        children: [
          Stack(children: [
            CircleAvatar(
              radius: 50,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(45),
                child: Image.asset("assets/images/defaultprofile.jpg"),
              ),
            ),
            Positioned(
                bottom: 10.0,
                right: 5.0,
                child: InkWell(
                  onTap: () {},
                  child: CircleAvatar(
                      radius: 20,
                      backgroundColor: Colors.teal,
                      child: Icon(
                        Icons.camera_enhance,
                        color: Colors.white,
                      )),
                )),
          ]),
          SizedBox(
            height: 10,
          ),
          Text(
            "Bharath Subramanya",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
          ),
          const SizedBox(height: 4),
          Text(
            "bharathsubu2002@gmail.com",
            style: TextStyle(color: Colors.grey),
          )
        ],
      );

  Widget buildUpgradeButton() => ElevatedButton(
        style: ElevatedButton.styleFrom(
          shape: StadiumBorder(),
          onPrimary: Colors.white,
          padding: EdgeInsets.symmetric(horizontal: 32, vertical: 12),
        ),
        child: Text("Supreme Doctor"),
        onPressed: () {},
      );

  Widget buildAbout() => Container(
        padding: EdgeInsets.symmetric(horizontal: 48),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'About',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                IconButton(onPressed: () {}, icon: Icon(Icons.edit))
              ],
            ),
            const SizedBox(height: 16),
            Text(
              "----",
              style: TextStyle(fontSize: 16, height: 1.4),
            ),
            Container(
              height: 100,
              child: Tags(
                key: _tagStateKey,
                textField: TagsTextField(
                  textStyle: TextStyle(fontSize: _fontSize),

                  //width: double.infinity, padding: EdgeInsets.symmetric(horizontal: 10),
                  onSubmitted: (str) {
                    // Add item to the data source.
                    setState(() {
                      // required
                      _items.add(Item(title: str));
                    });
                  },
                ),
                itemCount: _items.length, // required
                itemBuilder: (index) {
                  final Item currentitem = _items[index];
                  return ItemTags(
                    key: Key(index.toString()),
                    index: index,
                    title: currentitem.title,
                    active: currentitem.active,
                    customData: currentitem.customData,
                    textStyle: TextStyle(
                      fontSize: _fontSize,
                    ),
                    combine: ItemTagsCombine.withTextBefore,
                    removeButton: ItemTagsRemoveButton(
                      onRemoved: () {
                        // Remove the item from the data source.
                        setState(() {
                          // required
                          _items.removeAt(index);
                        });
                        //required
                        return true;
                      },
                    ), // OR null,
                    onPressed: (item) => print(item),
                    onLongPressed: (item) => print(item),
                  );
                },
              ),
            ),
          ],
        ),
      );
}
