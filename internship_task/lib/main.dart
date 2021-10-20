// @dart=2.9

import 'package:flutter/material.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';

void main() {
  runApp(MaterialApp(home: MyApp()));
}

class MyApp extends StatefulWidget {
  const MyApp({Key key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Color contColorl;
  String pubMes = '';

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
        height: double.infinity,
        width: double.infinity,

        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            FlatButton(
              onPressed: () async{
                await connect().then((MqttServerClient client) async{
                  await client.connect('naveera','naveera1');
                  if(client.connectionStatus.state == MqttConnectionState.connected) {
                    publish('ON', client, "topic/thingA");
                    client.subscribe("topic/thingA", MqttQos.atLeastOnce);
                    client.updates.listen((List<MqttReceivedMessage<MqttMessage>> c) {
                      final MqttPublishMessage message = c[0].payload;
                      final payload =
                      MqttPublishPayload.bytesToStringAsString(message.payload.message);
                    });
                    print(client.connectionStatus.state);
                    print('etxt of btnA ');

                  }
                  else{
                    print(client.connectionStatus.state);
                  }

                });

              },
              child: Container(
                height: 40,
                width: 70,
                color: Colors.green,
                alignment: Alignment.center,
                child: Text(
                  'ON',
                  style: TextStyle(
                      fontSize: 20,
                      color: Colors.black
                  ),
                ),
              ),
            ),
            FlatButton(
                onPressed: () async{
                  await connect().then((MqttServerClient client){
                    client.unsubscribe("topic/thingA");
                  });
                },
                child: Container(
                  height: 40,
                  width: 70,
                  color: Colors.red,
                  alignment: Alignment.center,
                  child: Text(
                    'OFF',
                    style: TextStyle(
                        fontSize: 20,
                        color: Colors.black
                    ),
                  ),
                )
            ),
            FlatButton(
              onPressed: () async{
                await connect().then((MqttServerClient client) async{
                  // client.disconnect();
                  await client.connect('naveera1','naveera12');
                  print(client.connectionStatus.state);
                  publish('OFF', client, "topic/thingA");
                  var text2 = client.subscribe("topic/thingA", MqttQos.atLeastOnce);

                  // const pubTopic = 'topic/thingB';
                  // final builder = MqttClientPayloadBuilder();
                  // builder.addString('OFF');
                  // client.publishMessage(
                  //     pubTopic, MqttQos.atLeastOnce, builder.payload);

                  print(text2);
                  client.disconnect();
                  print(client.connectionStatus.state);
                });
              },
              child: Container(
                height: 40,
                width: 70,
                color: Colors.red,
                alignment: Alignment.center,
                child: Text(
                  'OFF',
                  style: TextStyle(
                      fontSize: 20,
                      color: Colors.black
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: 40,right: 40),
              child: Container(
                height: 40,
                color: Colors.green,
              ),
            )
          ],
        ),
      ),
    );
  }

  Future<MqttServerClient> connect() async {
    MqttServerClient client =
    MqttServerClient.withPort('broker.hivemq.com', 'flutter_client', 1883);
    client.logging(on: true);
    // client.onConnected = onConnected;

    // client.onDisconnected = onDisconnected;
    // client.onUnsubscribed = onUnsubscribed;
    // client.onSubscribed = onSubscribed;
    // client.onSubscribeFail = onSubscribeFail ;

    final connMessage = MqttConnectMessage()
        .withWillTopic('willtopic')
        .withWillMessage('Will message')
        .startClean()
        .withWillQos(MqttQos.atLeastOnce);
    client.connectionMessage = connMessage;
    try {
      await client.connect();
    } catch (e) {
      print('Exception: $e');
      client.disconnect();
    }

    // client.updates.listen((List<MqttReceivedMessage<MqttMessage>> c) {
    //   final MqttPublishMessage message = c[0].payload;
    //   final payload =
    //   MqttPublishPayload.bytesToStringAsString(message.payload.message);
    //   // if(payload.)
    //   print(message);
    //   print('Received message:$payload from topic: ${c[0].topic}>');
    //   setState(() {
    //       pubMes = payload;
    //   });
    //   print('pubmes $pubMes');
    // });

    return client;
  }
  publish(String message,MqttServerClient client,String topic) {
    final MqttClientPayloadBuilder builder = MqttClientPayloadBuilder();
    builder.addString(message);
    // final MqttPublishMessage recMess = client[0].payload as MqttPublishMessage;
    return client.publishMessage(topic, MqttQos.atLeastOnce, builder.payload);
  }



// connection succeeded
//   void onConnected() {
//     print('Connecteds');
//   }
//
// // unconnected
//   void onDisconnected() {
//     print('Disconnected');
//   }
//
// // subscribe to topic succeeded
//   void onSubscribed(String topic) {
//     print('Subscribed topic: $topic');
//   }
//
// // subscribe to topic failed
//   void onSubscribeFail(String topic) {
//     print('Failed to subscribe $topic');
//   }
//
// // unsubscribe succeeded
//   void onUnsubscribed(String topic) {
//     print('Unsubscribed topic: $topic');
//   }
}