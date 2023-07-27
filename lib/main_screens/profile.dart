// ignore_for_file: unused_import, unnecessary_import

// import 'dart:html';

import 'package:cbs/customer_screens/address_book.dart';
import 'package:cbs/customer_screens/customer_orders.dart';
import 'package:cbs/customer_screens/wishlist.dart';
import 'package:cbs/main_screens/cart.dart';
import 'package:cbs/main_screens/profile.dart';
import 'package:cbs/providers/id_provider.dart';
import 'package:cbs/widgets/alert_dialog.dart';
import 'package:cbs/widgets/appbar_widgets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../customer_screens/add_address.dart';
import '../minor_screens/update_password.dart';
import '../providers/auth_repo.dart';
import '../widgets/yellow_button.dart';

class ProfileScreen extends StatefulWidget {
  // final String documentId;
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  late Future<String> documentId;
  late String docId;
  CollectionReference users =
      FirebaseFirestore.instance.collection('customers');
  // CollectionReference anonymous =
  //     FirebaseFirestore.instance.collection('anonymous');
  clearUserId(){
    context.read<IdProvider>().clearCustomerId();
  }
  @override
  void initState() {

    documentId = context.read<IdProvider>().getDocumentId();
    docId=context.read<IdProvider>().getData;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String>(
        future: documentId,
        builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
            case ConnectionState.waiting:
              return const Material(
                  child: Center(child: CircularProgressIndicator()));
            case ConnectionState.done:
              return docId != '' ? userScaffold() : noUserScaffold();
            case ConnectionState.active:
            case ConnectionState.done:
              if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              }
          }
          return const Material(
              child: Center(child: CircularProgressIndicator()));
        });
  }

  String userAddress(dynamic data) {
    if (
    // FirebaseAuth.instance.currentUser!.isAnonymous == true
    docId==''
    ) {
      return 'example: Delhi - India';
    } else if (
    // FirebaseAuth.instance.currentUser!.isAnonymous == false
    docId!=''
        &&
        data['address'] == '') {
      return 'Set your Address';
    }
    return data['address'];
  }

  Widget userScaffold() {
    return FutureBuilder<DocumentSnapshot>(
        future:
        // FirebaseAuth.instance.currentUser!.isAnonymous
        //     ? anonymous.doc(docId).get()
        //     :
        users.doc(docId).get(),
        builder:
            (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (snapshot.hasError) {
            return const Text("Something went wrong");
          }

          if (snapshot.hasData && !snapshot.data!.exists) {
            return const Text("Document does not exist");
          }

          if (snapshot.connectionState == ConnectionState.done) {
            Map<String, dynamic> data =
                snapshot.data!.data() as Map<String, dynamic>;
            return Scaffold(
              backgroundColor: Colors.grey.shade300,
              body: Stack(
                children: [
                  Container(
                    height: 230,
                    decoration: const BoxDecoration(
                      gradient:
                          LinearGradient(colors: [Colors.yellow, Colors.brown]),
                    ),
                  ),
                  CustomScrollView(
                    slivers: [
                      SliverAppBar(
                        pinned: true,
                        // centerTitle: true,
                        elevation: 0,
                        backgroundColor: Colors.white,
                        expandedHeight: 140,
                        flexibleSpace: LayoutBuilder(
                          builder: (context, constraints) {
                            return FlexibleSpaceBar(
                              title: AnimatedOpacity(
                                duration: const Duration(milliseconds: 200),
                                opacity:
                                    constraints.biggest.height <= 120 ? 1 : 0,
                                child: const Align(
                                  alignment: Alignment.center,
                                  child: Text(
                                    'Account',
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ),
                              background: Container(
                                decoration: const BoxDecoration(
                                  gradient: LinearGradient(
                                      colors: [Colors.yellow, Colors.brown]),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      top: 25.0, left: 30),
                                  child: Row(
                                    children: [
                                      data['profileimage'] == ''
                                          ? const CircleAvatar(
                                              radius: 50,
                                              backgroundImage: AssetImage(
                                                  'images/inapp/guest.jpg'),
                                            )
                                          : CircleAvatar(
                                              radius: 50,
                                              backgroundImage: NetworkImage(
                                                  data['profileimage']),
                                            ),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(left: 25),
                                        child: Text(
                                          data['name'] == ''
                                              ? 'guest'.toUpperCase()
                                              : data['name'].toUpperCase(),
                                          style: const TextStyle(
                                              fontSize: 24,
                                              fontWeight: FontWeight.w600),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      SliverToBoxAdapter(
                        child: Column(
                          children: [
                            Container(
                              height: 80,
                              width: MediaQuery.of(context).size.width * 0.9,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(50),
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  Container(
                                    decoration: const BoxDecoration(
                                        color: Colors.black54,
                                        borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(30),
                                          bottomLeft: Radius.circular(30),
                                        )),
                                    child: TextButton(
                                      child: SizedBox(
                                        height: 40,
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.2,
                                        child: const Center(
                                          child: Text(
                                            'Cart',
                                            style: TextStyle(
                                                color: Colors.yellow,
                                                fontSize: 20),
                                          ),
                                        ),
                                      ),
                                      onPressed: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    const CartScreen(
                                                        back:
                                                            AppBarBackButton())));
                                      },
                                    ),
                                  ),
                                  Container(
                                    color: Colors.yellow,
                                    child: TextButton(
                                      child: SizedBox(
                                        height: 40,
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.2,
                                        child: const Center(
                                          child: Text(
                                            'Orders',
                                            style: TextStyle(
                                                color: Colors.black54,
                                                fontSize: 20),
                                          ),
                                        ),
                                      ),
                                      onPressed: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    const CustomerOrders()));
                                      },
                                    ),
                                  ),
                                  Container(
                                    decoration: const BoxDecoration(
                                        color: Colors.black54,
                                        borderRadius: BorderRadius.only(
                                          topRight: Radius.circular(30),
                                          bottomRight: Radius.circular(30),
                                        )),
                                    child: TextButton(
                                      child: SizedBox(
                                        height: 40,
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.2,
                                        child: const Center(
                                          child: Text(
                                            'Wishlist',
                                            style: TextStyle(
                                                color: Colors.yellow,
                                                fontSize: 20),
                                          ),
                                        ),
                                      ),
                                      onPressed: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    const WishlistScreen()));
                                      },
                                    ),
                                  )
                                ],
                              ),
                            ),
                            Container(
                              color: Colors.grey.shade300,
                              child: Column(
                                children: [
                                  const SizedBox(
                                    height: 150,
                                    child: Image(
                                        image: AssetImage(
                                            'images/inapp/logo.jpg')),
                                  ),
                                  const ProfileHeaderlabel(
                                    headerLabel: '  Account Info.  ',
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: Container(
                                      height: 260,
                                      decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(16)),
                                      child: Column(
                                        children: [
                                          RepeatedListTile(
                                              icon: Icons.email,
                                              subTitle: data['email'] == ''
                                                  ? 'guest'
                                                  : data['email'],
                                              title: 'Email Address'),
                                          const YellowDivider(),
                                          RepeatedListTile(
                                            icon: Icons.phone,
                                            title: 'Phone No.',
                                            subTitle: data['phone'] == ''
                                                ? 'example-9999xxxxx'
                                                : data['phone'],
                                          ),
                                          const YellowDivider(),
                                          RepeatedListTile(
                                            onPressed: FirebaseAuth.instance
                                                    .currentUser!.isAnonymous
                                                ? null
                                                : () {
                                                    Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                            builder: (context) =>
                                                                const AddressBook()));
                                                  },
                                            icon: Icons.location_pin,
                                            title: 'Address',
                                            subTitle: userAddress(data),
                                            // data['address'] == ''
                                            //     ? 'example:India'
                                            //     : data['address'],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  const ProfileHeaderlabel(
                                      headerLabel: '  Account Settings  '),
                                  Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: Container(
                                      height: 260,
                                      decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(16)),
                                      child: Column(
                                        children: [
                                          RepeatedListTile(
                                            title: 'Edit Profile',
                                            icon: Icons.edit,
                                            onPressed: () {},
                                          ),
                                          const YellowDivider(),
                                          RepeatedListTile(
                                            icon: Icons.lock,
                                            title: 'Change Password',
                                            onPressed: () {
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          const UpdatePassword()));
                                            },
                                          ),
                                          const YellowDivider(),
                                          RepeatedListTile(
                                            icon: Icons.logout,
                                            title: 'Log Out',
                                            onPressed: () async {
                                              MyAlertDilaog.showMyDialog(
                                                context: context,
                                                title: 'Log Out',
                                                content:
                                                    'Are you sure to log out ?',
                                                tabNo: () {
                                                  Navigator.pop(context);
                                                },
                                                tabYes: () async {
                                                  await FirebaseAuth.instance
                                                      .signOut();
                                                  clearUserId();


                                                  // final SharedPreferences pref =
                                                  //     await _prefs;
                                                  // pref.setString(
                                                  //     'customerid', '');
                                                  await Future.delayed(
                                                          const Duration(
                                                              microseconds:
                                                                  100))
                                                      .whenComplete(() {
                                                    Navigator.pop(context);
                                                    Navigator
                                                        .pushReplacementNamed(
                                                            context,
                                                            '/onboarding_screen');
                                                  });
                                                },
                                              );
                                            },
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ],
              ),
            );
          }

          return const Center(
            child: CircularProgressIndicator(
              color: Colors.purple,
            ),
          );
        });
  }

  Widget noUserScaffold() {
    return Scaffold(
      backgroundColor: Colors.grey.shade300,
      body: Stack(
        children: [
          Container(
            height: 230,
            decoration: const BoxDecoration(
                gradient:
                    LinearGradient(colors: [Colors.yellow, Colors.brown])),
          ),
          CustomScrollView(
            slivers: [
              SliverAppBar(
                centerTitle: true,
                pinned: true,
                elevation: 0,
                backgroundColor: Colors.white,
                expandedHeight: 140,
                flexibleSpace: LayoutBuilder(
                  builder: (context, constraints) {
                    return FlexibleSpaceBar(
                      title: AnimatedOpacity(
                        duration: const Duration(milliseconds: 200),
                        opacity: constraints.biggest.height <= 120 ? 1 : 0,
                        child: const Text(
                          'Account',
                          style: TextStyle(color: Colors.black),
                        ),
                      ),
                      background: Container(
                        decoration: const BoxDecoration(
                            gradient: LinearGradient(
                                colors: [Colors.yellow, Colors.brown])),
                        child: Padding(
                          padding: const EdgeInsets.only(top: 25, left: 30),
                          child: Row(
                            children: [
                              const CircleAvatar(
                                radius: 50,
                                backgroundImage:
                                    AssetImage('images/inapp/guest.jpg'),
                              ),
                              Row(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 25),
                                    child: Text(
                                      'guest'.toUpperCase(),
                                      style: const TextStyle(
                                          fontSize: 24,
                                          fontWeight: FontWeight.w600),
                                    ),
                                  ),
                                  YellowButton(
                                      label: 'login',
                                      onPressed: () {
                                        Navigator.pushReplacementNamed(
                                            context, '/customer_login');
                                      },
                                      width: 0.25)
                                ],
                              )
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              SliverToBoxAdapter(
                child: Column(
                  children: [
                    Container(
                      height: 80,
                      width: MediaQuery.of(context).size.width * 0.9,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(50)),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Container(
                            decoration: const BoxDecoration(
                                color: Colors.black54,
                                borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(30),
                                    bottomLeft: Radius.circular(30))),
                            child: TextButton(
                              child: SizedBox(
                                height: 40,
                                width: MediaQuery.of(context).size.width * 0.2,
                                child: const Center(
                                  child: Text(
                                    'Cart',
                                    style: TextStyle(
                                        color: Colors.yellow, fontSize: 20),
                                  ),
                                ),
                              ),
                              onPressed: () {
                                logInDialog();
                              },
                            ),
                          ),
                          Container(
                            color: Colors.yellow,
                            child: TextButton(
                              child: SizedBox(
                                height: 40,
                                width: MediaQuery.of(context).size.width * 0.2,
                                child: const Center(
                                  child: Text(
                                    'Orders',
                                    style: TextStyle(
                                        color: Colors.black54, fontSize: 20),
                                  ),
                                ),
                              ),
                              onPressed: () {
                                logInDialog();
                              },
                            ),
                          ),
                          Container(
                            decoration: const BoxDecoration(
                                color: Colors.black54,
                                borderRadius: BorderRadius.only(
                                    topRight: Radius.circular(30),
                                    bottomRight: Radius.circular(30))),
                            child: TextButton(
                              child: SizedBox(
                                height: 40,
                                width: MediaQuery.of(context).size.width * 0.2,
                                child: const Center(
                                  child: Text(
                                    'Wishlist',
                                    style: TextStyle(
                                        color: Colors.yellow, fontSize: 20),
                                  ),
                                ),
                              ),
                              onPressed: () {
                                logInDialog();
                              },
                            ),
                          )
                        ],
                      ),
                    ),
                    Container(
                      color: Colors.grey.shade300,
                      child: Column(
                        children: [
                          const SizedBox(
                            height: 150,
                            child: Image(
                                image: AssetImage('images/inapp/logo.jpg')),
                          ),
                          const ProfileHeaderlabel(
                            headerLabel: '  Account Info.  ',
                          ),
                          Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Container(
                              height: 260,
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(16)),
                              child: Column(
                                children: [
                                  const RepeatedListTile(
                                      icon: Icons.email,
                                      subTitle: 'example@email.com',
                                      title: 'Email Address'),
                                  const YellowDivider(),
                                  const RepeatedListTile(
                                      icon: Icons.phone,
                                      subTitle: 'example: +11111',
                                      title: 'Phone No.'),
                                  const YellowDivider(),
                                  RepeatedListTile(
                                    onPressed: () {
                                      logInDialog();
                                    },
                                    title: 'Address',
                                    icon: Icons.location_pin,
                                    subTitle: 'example : New Jersey - USA',
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const ProfileHeaderlabel(
                              headerLabel: '  Account Settings  '),
                          Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Container(
                              height: 260,
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(16)),
                              child: Column(
                                children: [
                                  RepeatedListTile(
                                    title: 'Edit Profile',
                                    subTitle: '',
                                    icon: Icons.edit,
                                    onPressed: () {},
                                  ),
                                  const YellowDivider(),
                                  RepeatedListTile(
                                    title: 'Change Password',
                                    icon: Icons.lock,
                                    onPressed: () {
                                      logInDialog();
                                    },
                                  ),
                                  const YellowDivider(),
                                  RepeatedListTile(
                                    title: 'Log Out',
                                    icon: Icons.logout,
                                    onPressed: () async {
                                      MyAlertDilaog.showMyDialog(
                                          context: context,
                                          title: 'Log Out',
                                          content: 'Are you sure to log out ?',
                                          tabNo: () {
                                            Navigator.pop(context);
                                          },
                                          tabYes: () async {
                                            await AuthRepo.logOut();

                                            await Future.delayed(const Duration(
                                                    microseconds: 100))
                                                .whenComplete(() {
                                              Navigator.pop(context);
                                              Navigator.pushReplacementNamed(
                                                  context,
                                                  '/onboarding_screen');
                                            });
                                          });
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ],
      ),
    );
  }

  void logInDialog() {
    showCupertinoDialog<void>(
      context: context,
      builder: (BuildContext context) => CupertinoAlertDialog(
        title: const Text('please log in'),
        content: const Text('you should be logged in to take an action'),
        actions: <CupertinoDialogAction>[
          CupertinoDialogAction(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('Cancel'),
          ),
          CupertinoDialogAction(
            isDestructiveAction: true,
            onPressed: () {
              Navigator.pop(context);
              Navigator.pushReplacementNamed(context, '/customer_login');
            },
            child: const Text('Log in'),
          )
        ],
      ),
    );
  }
}

class YellowDivider extends StatelessWidget {
  const YellowDivider({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 40),
      child: Divider(
        color: Colors.yellow,
        thickness: 1,
      ),
    );
  }
}

class RepeatedListTile extends StatelessWidget {
  final String title;
  final String subTitle;
  final IconData icon;
  final Function()? onPressed;
  const RepeatedListTile({
    Key? key,
    required this.icon,
    this.onPressed,
    this.subTitle = '',
    required this.title,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: ListTile(
        title: Text(title),
        subtitle: Text(subTitle),
        leading: Icon(icon),
      ),
    );
  }
}

class ProfileHeaderlabel extends StatelessWidget {
  final String headerLabel;

  const ProfileHeaderlabel({
    Key? key,
    required this.headerLabel,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(
            height: 40,
            width: 50,
            child: Divider(
              color: Colors.grey,
              thickness: 1,
            ),
          ),
          Text(headerLabel,
              style: const TextStyle(
                  color: Colors.grey,
                  fontSize: 24,
                  fontWeight: FontWeight.w600)),
          const SizedBox(
            height: 40,
            width: 50,
            child: Divider(
              color: Colors.grey,
              thickness: 1,
            ),
          ),
        ],
      ),
    );
  }
}
