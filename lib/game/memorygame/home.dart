import 'package:flutter/material.dart';
import 'package:meditation/pages/mindGame.dart';
import 'card.dart';
import 'memory_card.dart';


class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);
  static String id='home';

  @override
  State<Home> createState() => _HomeState();
}

class Details {
  String name;
  Color primarycolor;
  Color secomdarycolor;
  Widget goto;

  Details(
      {required this.name,
        required this.primarycolor,
        required this.secomdarycolor,
        required this.goto});
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 70,
        centerTitle: true,
        automaticallyImplyLeading: false,
        actions:<Widget> [
          IconButton(
              onPressed: (){
                Navigator.pushNamed(context, mindGame.id);
              }, icon:Icon(Icons.close)),
        ],
        backgroundColor: Color(0xFF8E97FD),
        title: Text('Choose the Level',
          style: TextStyle(
            fontSize: 25,
            fontWeight: FontWeight.bold,
            fontFamily: 'Alegreya',
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView.builder(
          itemCount: _list.length,
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (BuildContext context) => _list[index].goto,
                    ));
              },
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Stack(
                  children: [
                    Container(
                      height: 100,
                      width: double.infinity,
                      decoration: BoxDecoration(
                          color: _list[index].secomdarycolor,
                          boxShadow: const [
                            BoxShadow(
                              blurRadius: 4,
                              color: Colors.black45,
                              spreadRadius: 0.5,
                              //offset: Offset(3, 4)
                            )
                          ]),
                    ),
                    Container(
                      height: 90,
                      width: double.infinity,
                      decoration:
                      BoxDecoration(color: _list[index].primarycolor,
                          // borderRadius: BorderRadius.circular(30),
                          boxShadow: const [
                            BoxShadow(
                              blurRadius: 4,
                              color: Colors.black12,
                              spreadRadius: 0.3,
                              //offset: Offset(
                              // 5,3,)
                            )
                          ]),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Center(
                              child: Text(
                                _list[index].name,
                                style: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 30,
                                    fontWeight: FontWeight.bold,
                                    ),
                              )),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  List<Details> _list = [
    Details(
        name: "EASY",
        primarycolor: Color(0xFFCBCFFF),
        secomdarycolor: Colors.white,
        goto: FlipCardGane(Level.Easy)),
    Details(
        name: "HARD",
        primarycolor: Color(0xFFCBCFFF),
        secomdarycolor: Colors.white,
        goto: FlipCardGane(Level.Hard)),
  ];
}