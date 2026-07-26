import 'package:early_ed/widgets/circular_profile.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../../helpers/common_methods.dart';

class SchoolInfo extends StatelessWidget {
  const SchoolInfo({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 100,
        title: Column(
          children: [
            Image.asset(
              "assets/images/EARLYED.png",
              width: 150,
              height: 100,
              fit: BoxFit.fill,
            ),
          ],
        ),
        centerTitle: true,
        backgroundColor: Colors.lightBlue,
      ),
      body: Container(
        color: Colors.lightBlue,
        child: Column(
          // mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 10),
              alignment: Alignment.center,
              child: const Text(
                "SCHOOL INFO",
                style: TextStyle(color: Colors.white, fontSize: 36),
              ),
            ),
            Container(
                margin: const EdgeInsets.all(10),
                width: 200,
                height: 200,
                decoration:
                    BoxDecoration(borderRadius: BorderRadius.circular(100)),
                child: const CircularProfile(
                  image: AssetImage("assets/images/school.jpg"),
                )),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 10),
              alignment: Alignment.center,
              child: const Text(
                "EARLYED",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 36,
                    fontWeight: FontWeight.bold),
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 10),
              alignment: Alignment.center,
              child: const Text(
                "Since 2012",
                style: TextStyle(color: Colors.white, fontSize: 33),
              ),
            ),
            Container(
                width: MediaQuery.of(context).size.width,
                height: 80,
                padding:
                    const EdgeInsets.symmetric(horizontal: 0, vertical: 10),
                alignment: Alignment.center,
                child: const Row(
                  children: [
                    Icon(
                      Icons.location_on_sharp,
                      size: 50,
                      color: Colors.deepOrange,
                    ),
                    Expanded(
                      child: Text(
                          "Al-Zaytoun Al-Qibliya, "
                          "Cairo Governorate",
                          style: TextStyle(fontSize: 16)),
                    ),
                  ],
                )
                //Text(
                //     "SIX GRADE",
                //     style: TextStyle(color: Colors.white, fontSize: 30),
                //   ),
                ),
            Container(
              // margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 50),
              // height:100 ,
              alignment: Alignment.topCenter,
              child: FilledButton(
                child: const Text(
                  "LOG OUT",
                  style: TextStyle(fontSize: 30),
                ),
                onPressed: () {
                  logOut(context);
                  // FirebaseAuth.instance.signOut();
                  // Navigator.push(
                  //     context,
                  //     MaterialPageRoute(
                  //       builder: (context) => AuthScreen(),
                  //     ));
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
