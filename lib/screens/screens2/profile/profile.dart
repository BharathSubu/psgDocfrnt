import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_tags/flutter_tags.dart';
import 'package:image_picker/image_picker.dart';
import 'package:kf_drawer/kf_drawer.dart';

import '../../../network/networkapi.dart';

// ignore: must_be_immutable
class Profile extends KFDrawerContent {
  Profile({Key? key});

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  // ignore: deprecated_member_use
  final ImagePicker _picker = ImagePicker();
  //late PickedFile _imageFile;
  File? _imageFile;
  late List _items = [];
  double _fontSize = 14;
  final GlobalKey<TagsState> _tagStateKey = GlobalKey<TagsState>();
  late String name;
  late String role;
  late String about;
  String? email = "";

  late String img;
  final storage = FlutterSecureStorage();
  NetworkHandler networkHandler = NetworkHandler();
  // NetworkHandler networkHandler = NetworkHandler();
  Widget page = CircularProgressIndicator();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUserData();
  }

  void getUserData() async {
    email = await storage.read(key: "email");
    var response = await networkHandler.get("duser/getdata/${email}");
    print(response);
    if (response["status"] == true) {
      setState(() {
        name = response["name"];
        img = response["img"];
        role = response["role"];
        email = response["email"];
        final length = response["attribute"].length;
        for (int i = 0; i < length; i++) {
          _items.add(Item(title: response["attribute"][i]));
        }
      });
    }
    page = button();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
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
      ),
    );
  }

  Widget showProfile() {
    return Center(child: Text("Profile Data is Avalable"));
  }

  Widget button() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        imageProfile(img),
        buildName(),
        const SizedBox(height: 12),
        Center(child: buildUpgradeButton()),
        const SizedBox(height: 12),
        buildAbout(),
      ],
    );
  }

  Widget buildName() => Column(
        children: [
          SizedBox(
            height: 10,
          ),
          Text(
            name,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
          ),
          const SizedBox(height: 4),
          Text(
            email!,
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
        child: Text(role),
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
            TextField(
              decoration: InputDecoration(labelText: "Add patient attributes"),
              style: TextStyle(fontSize: 14),
              //width: double.infinity, padding: EdgeInsets.symmetric(horizontal: 10),
              onSubmitted: (string) {
                // Add item to the data source.
                setState(() {
                  // required
                  _items.add(Item(title: string));
                  networkHandler.get("duser/setattribute/${email}/${string}");
                });
              },
            ),
            Container(
              height: 300,
              child: ListView(children: [
                Padding(
                  padding: EdgeInsets.all(5),
                  child: Tags(
                    key: _tagStateKey,
                    itemCount: _items.length, // required
                    itemBuilder: (index) {
                      final Item currentitem = _items[index];
                      return ItemTags(
                        key: Key(index.toString()),
                        index: index,
                        title: currentitem.title,
                        customData: currentitem.customData,
                        textStyle: TextStyle(
                          fontSize: _fontSize,
                        ),
                        combine: ItemTagsCombine.withTextBefore,
                        removeButton: ItemTagsRemoveButton(
                          onRemoved: () {
                            // Remove the item from the data source.
                            setState(() {
                              _items.removeAt(index);
                              networkHandler.get(
                                  "duser/delattribute/${email}/${currentitem.title}");
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
              ]),
            ),
          ],
        ),
      );
  Widget imageProfile(String webimagepath) {
    return Center(
      child: Stack(children: <Widget>[
        _imageFile != null
            ? CircleAvatar(
                radius: 60.0,
                backgroundImage: Image.file(
                  _imageFile!,
                  fit: BoxFit.cover,
                ).image)
            : webimagepath == "null"
                ? CircleAvatar(
                    radius: 60.0,
                    backgroundImage:
                        AssetImage("assets/images/defaultprofile.jpg"))
                : CircleAvatar(
                    radius: 60.0,
                    backgroundImage:
                        NetworkImage(NetworkHandler().getImage(email!))),
        Positioned(
            bottom: 13.0,
            right: 15.0,
            child: InkWell(
              onTap: () {
                showModalBottomSheet(
                  context: context,
                  builder: ((builder) => bottomSheet()),
                );
              },
              child: CircleAvatar(
                  radius: 15,
                  backgroundColor: Colors.grey,
                  child: Icon(
                    Icons.edit,
                    color: Colors.white,
                  )),
            )),
        // if (webimagepath != "")
        //   Positioned(
        //       bottom: 20.0,
        //       left: 20.0,
        //       child: InkWell(
        //         onTap: () async {
        // var response =
        // await networkHandler.delete('user/deletephoto');
        // if (response.statusCode == 200) {}
        //         },
        //         child: CircleAvatar(
        //             radius: 20,
        //             backgroundColor: Colors.teal,
        //             child: Icon(
        //               Icons.delete,
        //               color: Colors.white,
        //             )),
        //       ))
      ]),
    );
  }

  Widget bottomSheet() {
    return Container(
      height: 100.0,
      width: MediaQuery.of(context).size.width,
      margin: EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 20,
      ),
      child: Column(
        children: <Widget>[
          Text(
            "Choose Profile photo",
            style: TextStyle(
              fontSize: 20.0,
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
            FlatButton.icon(
              icon: Icon(Icons.camera),
              onPressed: () {
                takePhoto(ImageSource.camera);
              },
              label: Text("Camera"),
            ),
            FlatButton.icon(
              icon: Icon(Icons.image),
              onPressed: () {
                takePhoto(ImageSource.gallery);
              },
              label: Text("Gallery"),
            ),
          ])
        ],
      ),
    );
  }

  void takePhoto(ImageSource source) async {
    final pickedImage = await _picker.pickImage(source: source);
    if (pickedImage == null) return;
    final imageTemporary = File(pickedImage.path);
    setState(() => {upload(imageTemporary)});
  }

  void upload(var imageTemporary) async {
    _imageFile = imageTemporary;
    var imageResponse = await networkHandler.patchImage(
        "duser/add/image/${email}", _imageFile!.path);
  }
}
