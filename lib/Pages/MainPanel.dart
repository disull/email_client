import 'package:email_client/Models/MailModel.dart';
import 'package:email_client/Widgets/SendMessengeWidget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();


class MainPanel extends StatelessWidget {

  String nameBox = 'inbox';
  MainPanel({Key? key, required this.nameBox }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
     // key: _scaffoldKey,
      appBar: AppBar(
        /*leading: IconButton(onPressed: () {
          _scaffoldKey.currentState?.openDrawer();
        }, icon: Icon(Icons.menu),),*/
        title: const Text('Входящие'),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 10),
            child: CircleAvatar(
              backgroundColor: Colors.red,
              radius: 20,
            ),
          )
        ],
        centerTitle: true,
      ),
      body: SendMessengerList(box: nameBox),

      floatingActionButton: FloatingActionButton(

        backgroundColor: Colors.amber,
        child: const Icon(Icons.send_outlined),
        onPressed: (){

          Navigator.pushNamed(context, 'sendMessage');

        },
      ),

      drawer: Container(
        width: 250,
        child: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: <Widget> [
              const DrawerHeader(
                decoration: BoxDecoration(
                  color: Colors.blue,
                ),
                child: Text('MAILER'),
              ),
              ListTile(
                title: const Text('Входящие'),
                onTap: (){
                  Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) =>
                      MainPanel(nameBox: 'inbox')
                  ), (route) => false);
                },
              ),
              ListTile(
                title: const Text('Отправленные'),
                onTap: (){

                  Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) =>
                  MainPanel(nameBox: 'sendbox')
                  ), (route) => false);
                },
              ),
              ListTile(
                title: const Text('Выйти'),
                onTap: (){
                  Navigator.pushNamedAndRemoveUntil(context, 'loginPage', (route) => false);
                  MailModel.mailClient.disconnect();
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
