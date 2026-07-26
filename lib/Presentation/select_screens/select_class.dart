import 'package:early_ed/Presentation/select_screens/select_student.dart';
import 'package:flutter/material.dart';

class SelectClass extends StatelessWidget {
  const SelectClass({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 100,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              bottomRight: Radius.circular(25),
              bottomLeft: Radius.circular(25)),
        ),
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
        actions: const [
          Icon(Icons.more_vert_rounded, size: 33, color: Colors.black)
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 0),
              alignment: Alignment.center,
              child: const Text(
                "Select Class",
                style: TextStyle(
                  fontSize: 40,
                  color: Colors.black,
                ),
              ),
            ),
            InkWell(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const SelectStudent(),
                    ));
              },
              child: Container(
                margin: const EdgeInsets.all(20),
                width: 280,
                height: 80,
                padding: const EdgeInsets.all(15),
                alignment: Alignment.topCenter,
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(Radius.circular(100)),
                  border: Border.all(color: Colors.blueAccent),
                ),
                child: const Text(
                  "1. First Class",
                  style: TextStyle(
                    fontSize: 35,
                    color: Colors.black,
                  ),
                ),
              ),
            ),
            InkWell(
              child: Container(
                margin: const EdgeInsets.all(20),
                width: 280,
                height: 80,
                padding: const EdgeInsets.all(15),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(Radius.circular(100)),
                  border: Border.all(color: Colors.blueAccent),
                ),
                child: const Text(
                  "2.Second Class",
                  style: TextStyle(
                    fontSize: 35,
                    color: Colors.black,
                  ),
                ),
              ),
            ),
            InkWell(
              child: Container(
                margin: const EdgeInsets.all(20),
                width: 280,
                height: 80,
                padding: const EdgeInsets.all(15),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(Radius.circular(100)),
                  border: Border.all(color: Colors.blueAccent),
                ),
                child: const Text(
                  "3. third Class",
                  style: TextStyle(
                    fontSize: 35,
                    color: Colors.black,
                  ),
                ),
              ),
            ),
            InkWell(
              child: Container(
                margin: const EdgeInsets.all(20),
                width: 280,
                height: 80,
                padding: const EdgeInsets.all(15),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(Radius.circular(100)),
                  border: Border.all(color: Colors.blueAccent),
                ),
                child: const Text(
                  "4. Fourth Class",
                  style: TextStyle(
                    fontSize: 35,
                    color: Colors.black,
                  ),
                ),
              ),
            ),
            InkWell(
              child: Container(
                margin: const EdgeInsets.all(20),
                width: 280,
                height: 80,
                padding: const EdgeInsets.all(15),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(Radius.circular(100)),
                  border: Border.all(color: Colors.blueAccent),
                ),
                child: const Text(
                  "5. Fifth Class",
                  style: TextStyle(
                    fontSize: 35,
                    color: Colors.black,
                  ),
                ),
              ),
            ),
            InkWell(
              child: Container(
                margin: const EdgeInsets.all(20),
                width: 280,
                height: 80,
                padding: const EdgeInsets.all(15),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(Radius.circular(100)),
                  border: Border.all(color: Colors.blueAccent),
                ),
                child: const Text(
                  "6. Six Class",
                  style: TextStyle(
                    fontSize: 35,
                    color: Colors.black,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
