import 'dart:convert';
import 'package:email_client/Data/MailData.dart';
import 'package:email_client/Models/MailModel.dart';
import 'package:enough_mail/enough_mail.dart';

void printMessage(MimeMessage message) {
  print('from: ${message.from} with subject "${message.decodeSubject()}" sender: "${message.to}" ');
  if (!message.isTextPlainMessage()) {
    print(' content-type: ${message.mediaType}');
  } else {
    final plainText = message.decodeTextPlainPart();
    if (plainText != null) {
      final lines = plainText.split('\r\n');
      for (final line in lines) {
        if (line.startsWith('>')) {
          // break when quoted text starts
          break;
        }
        print(line);
      }
    }
  }
}



void setMessages(MimeMessage message) async {
  mailData.add(MailModel(
      title: ' ', //message.decodeSubject().toString(),
      content: message.decodeTextPlainPart(),
      personalName: message.from!.first.personalName,
      avatar: '',
      date: message.decodeDate().toString()));
}


Future<bool> connect(String email,String password) async {

  //Автоматическое обнаружение конфигурации
  final config = await Discover.discover(email, isLogEnabled: false);


  try {
    var account =  MailAccount.fromDiscoveredSettings('my account', email, password, config!);
    MailModel.mailClient = MailClient(account, isLogEnabled: false);
    await MailModel.mailClient.connect();
    print('connected');
    return  true;


    final mailboxes =  await MailModel.mailClient.listMailboxesAsTree(createIntermediate: false);
    print(mailboxes);
    await MailModel.mailClient.selectInbox();
    final messages = await MailModel.mailClient.fetchMessages();
    messages.forEach(printMessage);
    messages.forEach(setMessages);


   /* List<MailAddress> mailadress = [
      MailAddress('Dias', 'lolkacolka@yandex.ru'),
    ];
    var mailadressFrom = MailAddress('Dias', 'lolkacolka2@yandex.ru');


    MimeMessage messageBuilder = MessageBuilder.buildSimpleTextMessage(
        mailadressFrom,
        mailadress,
        'Hei',
        subject: 'ПРОВЕРКА Yandex',

    );
    await mailClient.sendMessage(messageBuilder);*/




  /*  mailClient.eventBus.on<MailLoadEvent>().listen((event) {
      print('New message at ${DateTime.now()}:');
      printMessage(event.message);
    });*/

    await MailModel.mailClient.startPolling();
  } on MailException catch (e) {
    print('High level API failed with $e');
    return false;
  } on MailAccount catch(e){
    print('Неверный логин или пароль');
    return false;
  }

}

Future<List<MailModel>> getMails(String nameBox) async{
  final mailboxes =  MailModel.mailClient.mailboxes;
  var  _mailboxes = await MailModel.mailClient.listMailboxes();
  var inbox;
  if(nameBox == 'inbox'){
    inbox = _mailboxes.firstWhere((box) => box.isInbox);
  }
  else if (nameBox == 'sendbox'){
    inbox = _mailboxes.firstWhere((box) => box.isSent);
  }
  else if(nameBox == 'trashbox'){
    inbox = _mailboxes.firstWhere((box) => box.isTrash);
  }
  else if(nameBox == 'spam'){
    inbox = _mailboxes.firstWhere((box) => box.isJunk);
  }
  else{
    print('Ошибка');
  }
  print( 'name BOX ----> ${inbox.name}');
  await MailModel.mailClient.selectMailbox(inbox);
   MailModel.messages = await MailModel.mailClient.fetchMessages();

  List<MailModel> mails = [];
  MailModel.messages.forEach((message) {
    String title = message.decodeSubject().toString();
    String? personalName = message.from!.first.personalName;
    String? date = '${message.decodeDate()!.day}/${message.decodeDate()!.month}/${message.decodeDate()!.year}';
    String? content = message.decodeTextPlainPart();
    content ??= message.decodeContentText();
    mails.add(
      MailModel(
          title: title,
          content: content,
          personalName: personalName,
          avatar: personalName![0],
          date: date,
      ));
  });
  return mails;
}

Future<bool> send(String emailTo, String emailFrom, String text, String subject) async{

  try {
    List<MailAddress>  emails = [];
    emails.add(
      MailAddress(emailTo,text),
    );
    MimeMessage mimeMessage = MessageBuilder.buildSimpleTextMessage(
        MailAddress(emailFrom,emailFrom),
        emails,
        text,
        subject: subject,
    );
    await MailModel.mailClient.sendMessage(mimeMessage);
    return true;
  } on Exception catch (e) {
    return false;
  }


}

/*Codec<String, String> stringToBase64 = utf8.fuse(base64Url);
  ImapClient client = ImapClient();
  await client.connect('imap.yandex.ru', 993, true);

  await client.login('lolkacolka2', 'Dias_123');
  ImapFolder inbox = await client.getFolder('inbox');


  Map response = await inbox.fetch(["BODY.PEEK[HEADER.FIELDS (Subject)]"], messageIds: [3]);
  String preSubject = response[3]["BODY[HEADER.FIELDS (SUBJECT)]"].toString();
  print(preSubject);
  */ /*String string = preSubject.replaceAll('Subject: =?UTF-8?B?', '');
  String string2 = string.replaceAll('Subject: =?UTF-8?b?', '');
  String string3 =  string2.replaceAll('=?','');
  RegExp re = RegExp(r'^\D+$');
  String string4 =  string3.substring(0,string2.length-4);
  print(string4.length);
  List<int> bytes = base64.decode(string4);
  print(utf8.decode(bytes));

  print(bytes);
  //print(stringToBase64.decoder(await inbox.fetch(["BODY.PEEK[HEADER.FIELDS (Subject)]"], messageIds: [3])));
  print(await inbox.fetch(["BODY.PEEK[HEADER.FIELDS (Date)]"], messageIds: [3]));
  print(await inbox.fetch(["BODY.PEEK[HEADER.FIELDS (From)]"], messageIds: [3]));
  print(await inbox.fetch(["BODY.PEEK[HEADER.FIELDS (To)]"], messageIds: [3]));*/ /*
  //print(await inbox.fetch(["BODYSTRUCTURE"], messageIds: [1]));*/
