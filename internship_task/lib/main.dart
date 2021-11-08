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
  Color contColorl = Colors.white;
  String pubMes = '';

  @override
  Widget build(BuildContext context) {
    return Material(
      color: contColorl,
      child: Container(
        height: double.infinity,
        width: double.infinity,
        child: Row(
          children: [
            Expanded(
              child: FlatButton(
                onPressed: () async{
                  await connect().then((MqttServerClient client) async{
                    await client.connect('naveera','naveera1');
                    if(client.connectionStatus.state == MqttConnectionState.connected) {
                      var text2 = publish('ON', client, "topic/thingA");
                      client.subscribe("topic/thingA", MqttQos.atLeastOnce);
                      client.updates.listen((List<MqttReceivedMessage<MqttMessage>> c) {
                        final MqttPublishMessage message = c[0].payload;
                        return MqttPublishPayload.bytesToStringAsString(message.payload.message);
                      });
                      // var text2 = publish('ON', client, "topic/thingA");
                      print(client.connectionStatus.state);
                      if(text2 != 0){
                        setState(() {
                          contColorl = Colors.green;
                        });
                      }
                      print(text2);

                    }
                    else{
                      print(client.connectionStatus.state);
                    }

                  });

                },
                child: Container(
                  height: 80,
                  width: double.infinity,
                  color: Colors.lightBlueAccent,
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
            ),
            Expanded(
              child: FlatButton(
                onPressed: () async{
                  await connect().then((MqttServerClient client) async{
                    // client.disconnect();
                    await client.connect('naveera1','naveera12');
                    print(client.connectionStatus.state);
                    var text2 =publish('OFF', client, "topic/thingA");
                    client.subscribe("topic/thingA", MqttQos.atLeastOnce);
                    if(text2!= 0){
                      setState(() {
                        contColorl = Colors.red;
                      });
                    }
                    print(text2);
                    client.disconnect();
                    print(client.connectionStatus.state);
                  });
                },
                child: Container(
                  height: 80,
                  width: double.infinity,
                  color: Colors.lightBlueAccent,
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
            ),
          ],
        ),
      ),
    );
  }

  Future<MqttServerClient> connect() async {
    MqttServerClient client =
    MqttServerClient.withPort('broker.hivemq.com', 'flutter_client', 1883);
    client.logging(on: true);
    final connMessage = MqttConnectMessage()
        .withWillTopic('will topic')
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

    return client;
  }
  publish(String message,MqttServerClient client,String topic) {
    final MqttClientPayloadBuilder builder = MqttClientPayloadBuilder();
    builder.addString(message);
    return client.publishMessage(topic, MqttQos.atLeastOnce, builder.payload);
  }

}