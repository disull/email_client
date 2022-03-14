import 'package:email_client/Pages/RecipientMessagePage.dart';
import 'package:email_client/functions/Connections.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../Data/MailData.dart';
import '../Models/MailModel.dart';

late Future <List<MailModel>> items;

class  SendMessengerList extends StatefulWidget {
  String box;
  SendMessengerList({Key? key, required this.box}) : super(key: key);

  @override
  State<SendMessengerList> createState() => _SendMessengerListState();
}

class _SendMessengerListState extends State<SendMessengerList> {


  @override
  void initState() {
    items = getMails(widget.box);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return  FutureBuilder(
        future: items,
        builder: (BuildContext context, snapshot) {
          if(snapshot.hasData){
            List<MailModel> items = snapshot.data as List<MailModel>;
            return ListView.separated(
              itemCount: items.length,
              itemBuilder: (BuildContext context, int index) {
                return ListTile(
                  contentPadding: const EdgeInsets.all(0),
                  minVerticalPadding: 0,
                  title: SizedBox(
                    height: 150,
                    width: double.infinity,
                    child: TextButton(
                      onPressed: () {
                        Navigator.pushNamed(context, 'detailPage', arguments: items[index]);
                      },
                      child: Row(
                        children: [
                          Expanded(
                            flex: 25,
                            child: Container(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                children: [
                                  const CircleAvatar(
                                    backgroundColor: Colors.red,
                                    radius: 20,
                                  ),
                                  PopupMenuButton(
                                      icon: Icon(Icons.menu),
                                      itemBuilder: (context) {
                                        return [
                                          PopupMenuItem(
                                              child: TextButton(
                                                onPressed: () {},
                                                child: const Text('Удалить'),
                                              )),
                                          PopupMenuItem(
                                              child: TextButton(
                                                onPressed: () {},
                                                child: const Text('В спам'),
                                              ))
                                        ];
                                      })
                                ],
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 50,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(width: double.infinity, height: 25,
                                    child: Text(items[index].personalName.toString(),
                                      overflow: TextOverflow.ellipsis,)),
                                Container(width: double.infinity, height: 30,
                                    child: Text(items[index].title,
                                        overflow: TextOverflow.ellipsis)),
                                Container(width: double.infinity, height: 70,
                                  child: Text(items[index].content,
                                    overflow: TextOverflow.fade,), ),
                              ],
                            ),
                          ),
                          Expanded(
                            flex: 25,
                            child: Column(
                              mainAxisAlignment:  MainAxisAlignment.spaceAround,
                              children: [
                                Text((TimeOfDay.hoursPerDay).toString()),
                                IconButton(onPressed: (){}, icon: Icon(Icons.star_border, size: 30,))
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                );
              },
              separatorBuilder: (BuildContext context, int index) {
                return const Divider(
                  height: 0,
                  thickness: 2,
                  indent: 0,
                  endIndent: 0,
                  color: Colors.black12,
                );
              },
            );
          }
          else if(snapshot.hasError){
            return Text(snapshot.error.toString());
          }
          else{
            return Center(child: CircularProgressIndicator());
          }
        }

    );
  }
}



