import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_basic/flutter_bluetooth_basic.dart';
import 'dart:typed_data';
import 'dart:async';
import 'package:flutter_bluetooth_basic/flutter_bluetooth_basic.dart';

class MyBluetoothPage extends StatefulWidget {
  @override
  _MyBluetoothPageState createState() => _MyBluetoothPageState();
}

class _MyBluetoothPageState extends State<MyBluetoothPage> {
  BluetoothManager _bluetoothManager = BluetoothManager.instance;
  BluetoothDevice? _device;
  bool _isConnected = false;
  late BluetoothConnection _bluetoothConnection;
  String bildirim = "Komut bekleniyor.";
  Key animatedTextKey = UniqueKey();
  bool isTapped = false;
  bool isTapped2 = false;
  bool isTapped3 = false;
  bool isTapped4 = false;
  bool isTapped5 = false;
  bool isTapped6 = false;
  bool isTapped7 = false;

  @override
  void initState() {
    super.initState();
    _bluetoothManager.state.listen((state) {
      if (state == BluetoothManagerState.STATE_ON) {
        _connectToDevice();
      }
    });
  }

  Future<void> _connectToDevice() async {
    List<BluetoothDevice> devices = await _bluetoothManager.getBondedDevices();
    if (devices.isNotEmpty) {
      _device = devices[0]; // İlk bağlı cihazı seçiyoruz
      try {
        _bluetoothConnection = await _device!.createConnection();
        setState(() {
          _isConnected = true;
        });
      } catch (e) {
        print("Bluetooth bağlantı hatası: $e");
      }
    } else {
      print("Bağlı cihaz bulunamadı.");
    }
  }

  Future<void> _sendCommand(String command) async {
    if (_isConnected && _device != null) {
      try {
        List<int> bytes = command.codeUnits;
        await _device!.write(Uint8List.fromList(bytes));
      } catch (error) {
        print("Komut gönderme hatası: $error");
      }
    } else {
      print("Bağlı bir cihaz bulunamadı.");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Bluetooth Kontrolleri"),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    SizedBox(height: 20),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ElevatedButton.icon(
                          onPressed: () async {
                            await _sendCommand("7");
                            setState(() {
                              bildirim = "Aracınızın farları açıldı.";
                              animatedTextKey = UniqueKey();
                            });
                            Timer(Duration(seconds: 4), () {
                              setState(() {
                                bildirim = "Komut bekleniyor.";
                                animatedTextKey = UniqueKey();
                              });
                            });
                          },
                          icon: Icon(
                            Icons.sunny,
                            color: Colors.black87,
                          ),
                          label: Text(
                            'HEADLIGHT',
                            style: TextStyle(
                              fontFamily: 'Montserrat',
                              fontWeight: FontWeight.normal,
                              color: Colors.black87,
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            primary: Color(0xFFE5E4E2),
                            padding: EdgeInsets.all(10),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                              side: BorderSide(
                                color: Color(0xFF8757A1),
                                width: 2,
                              ),
                            ),
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            elevation: 5,
                            shadowColor: Color(0xFF8757A1),
                          ),
                        ),
                        InkWell(
                          onTapDown: (_) async {
                            await _sendCommand("9");
                            setState(() {
                              bildirim = "DDÜÜÜÜTTT!?!?!!!";
                              animatedTextKey = UniqueKey();
                              isTapped2 = true;
                            });
                          },
                          onTapUp: (_) async {
                            await _sendCommand("10");
                            setState(() {
                              bildirim = "Komut bekleniyor...";
                              animatedTextKey = UniqueKey();
                              isTapped2 = false;
                            });
                          },
                          onTapCancel: () {
                            setState(() {
                              isTapped2 = false;
                            });
                          },
                          child: Container(
                            padding: EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: Color(0xFFE5E4E2),
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                color: Color(0xFF8757A1),
                                width: 2,
                              ),
                              boxShadow: isTapped2
                                  ? [
                                      BoxShadow(
                                        color:
                                            Color(0xFF8757A1).withOpacity(0.9),
                                        blurRadius: 15,
                                        offset: Offset(0, 3),
                                      ),
                                    ]
                                  : [],
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.multitrack_audio,
                                    color: Colors.black87),
                                SizedBox(width: 8),
                                Text(
                                  'HORN',
                                  style: TextStyle(
                                    fontFamily: 'Montserrat',
                                    fontWeight: FontWeight.normal,
                                    color: Colors.black87,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        ElevatedButton.icon(
                          onPressed: () async {
                            await _sendCommand("8");
                            setState(() {
                              bildirim = "Aracınızın farları kapatıldı.";
                              animatedTextKey = UniqueKey();
                            });
                            Timer(Duration(seconds: 4), () {
                              setState(() {
                                bildirim = "Komut bekleniyor.";
                                animatedTextKey = UniqueKey();
                              });
                            });
                          },
                          icon: Icon(
                            Icons.dark_mode,
                            color: Colors.black87,
                          ),
                          label: Text(
                            'HEADLIGHT',
                            style: TextStyle(
                              fontFamily: 'Montserrat',
                              fontWeight: FontWeight.normal,
                              color: Colors.black87,
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            primary: Color(0xFFE5E4E2),
                            padding: EdgeInsets.all(10),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                              side: BorderSide(
                                color: Color(0xFF8757A1),
                                width: 2,
                              ),
                            ),
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            elevation: 5,
                            shadowColor: Color(0xFF8757A1),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 20),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        InkWell(
                          onTapDown: (_) async {
                            await _sendCommand("11");
                            setState(() {
                              bildirim = "Camlar iniyor...";
                              animatedTextKey = UniqueKey();
                              isTapped3 = true;
                            });
                          },
                          onTapUp: (_) async {
                            await _sendCommand("12");
                            setState(() {
                              bildirim = "Komut bekleniyor.";
                              animatedTextKey = UniqueKey();
                              isTapped3 = false;
                            });
                          },
                          onTapCancel: () {
                            setState(() {
                              isTapped3 = false;
                            });
                          },
                          child: Container(
                            padding: EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: Color(0xFFE5E4E2),
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                color: Color(0xFF8757A1),
                                width: 2,
                              ),
                              boxShadow: isTapped3
                                  ? [
                                      BoxShadow(
                                        color:
                                            Color(0xFF8757A1).withOpacity(0.9),
                                        blurRadius: 15,
                                        offset: Offset(0, 3),
                                      ),
                                    ]
                                  : [],
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.arrow_circle_down,
                                    color: Colors.black87),
                                SizedBox(width: 8),
                                Text(
                                  'WINDOW',
                                  style: TextStyle(
                                    fontFamily: 'Montserrat',
                                    fontWeight: FontWeight.normal,
                                    color: Colors.black87,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        InkWell(
                          onTapDown: (_) async {
                            await _sendCommand("13");
                            setState(() {
                              bildirim = "Camlar kalkıyor...";
                              animatedTextKey = UniqueKey();
                              isTapped4 = true;
                            });
                          },
                          onTapUp: (_) async {
                            await _sendCommand("14");
                            setState(() {
                              bildirim = "Komut bekleniyor.";
                              animatedTextKey = UniqueKey();
                              isTapped4 = false;
                            });
                          },
                          onTapCancel: () {
                            setState(() {
                              isTapped4 = false;
                            });
                          },
                          child: Container(
                            padding: EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: Color(0xFFE5E4E2),
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                color: Color(0xFF8757A1),
                                width: 2,
                              ),
                              boxShadow: isTapped4
                                  ? [
                                      BoxShadow(
                                        color:
                                            Color(0xFF8757A1).withOpacity(0.9),
                                        blurRadius: 15,
                                        offset: Offset(0, 3),
                                      ),
                                    ]
                                  : [],
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.arrow_circle_up,
                                    color: Colors.black87),
                                SizedBox(width: 8),
                                Text(
                                  'WINDOW',
                                  style: TextStyle(
                                    fontFamily: 'Montserrat',
                                    fontWeight: FontWeight.normal,
                                    color: Colors.black87,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 20),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        InkWell(
                          onTapDown: (_) async {
                            await _sendCommand("15");
                            setState(() {
                              bildirim = "Sol cam iniyor";
                              animatedTextKey = UniqueKey();
                              isTapped5 = true;
                            });
                          },
                          onTapUp: (_) async {
                            await _sendCommand("16");
                            setState(() {
                              bildirim = "Komut bekleniyor.";
                              animatedTextKey = UniqueKey();
                              isTapped5 = false;
                            });
                          },
                          onTapCancel: () {
                            setState(() {
                              isTapped5 = false;
                            });
                          },
                          child: Container(
                            padding: EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: Color(0xFFE5E4E2),
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                color: Color(0xFF8757A1),
                                width: 2,
                              ),
                              boxShadow: isTapped5
                                  ? [
                                      BoxShadow(
                                        color:
                                            Color(0xFF8757A1).withOpacity(0.9),
                                        blurRadius: 15,
                                        offset: Offset(0, 3),
                                      ),
                                    ]
                                  : [],
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.arrow_circle_down,
                                    color: Colors.black87),
                                SizedBox(width: 8),
                                Text(
                                  'LW',
                                  style: TextStyle(
                                    fontFamily: 'Montserrat',
                                    fontWeight: FontWeight.normal,
                                    color: Colors.black87,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        InkWell(
                          onTapDown: (_) async {
                            await _sendCommand("17");
                            setState(() {
                              bildirim = "Sol cam kalkıyor.";
                              animatedTextKey = UniqueKey();
                              isTapped6 = true;
                            });
                          },
                          onTapUp: (_) async {
                            await _sendCommand("18");
                            setState(() {
                              bildirim = "Komut bekleniyor.";
                              animatedTextKey = UniqueKey();
                              isTapped6 = false;
                            });
                          },
                          onTapCancel: () {
                            setState(() {
                              isTapped6 = false;
                            });
                          },
                          child: Container(
                            padding: EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: Color(0xFFE5E4E2),
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                color: Color(0xFF8757A1),
                                width: 2,
                              ),
                              boxShadow: isTapped6
                                  ? [
                                      BoxShadow(
                                        color:
                                            Color(0xFF8757A1).withOpacity(0.9),
                                        blurRadius: 15,
                                        offset: Offset(0, 3),
                                      ),
                                    ]
                                  : [],
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.arrow_circle_up,
                                    color: Colors.black87),
                                SizedBox(width: 8),
                                Text(
                                  'LW',
                                  style: TextStyle(
                                    fontFamily: 'Montserrat',
                                    fontWeight: FontWeight.normal,
                                    color: Colors.black87,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 20),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        InkWell(
                          onTapDown: (_) async {
                            await _sendCommand("19");
                            setState(() {
                              bildirim = "Sağ cam iniyor.";
                              animatedTextKey = UniqueKey();
                              isTapped7 = true;
                            });
                          },
                          onTapUp: (_) async {
                            await _sendCommand("20");
                            setState(() {
                              bildirim = "Komut bekleniyor.";
                              animatedTextKey = UniqueKey();
                              isTapped7 = false;
                            });
                          },
                          onTapCancel: () {
                            setState(() {
                              isTapped7 = false;
                            });
                          },
                          child: Container(
                            padding: EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: Color(0xFFE5E4E2),
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                color: Color(0xFF8757A1),
                                width: 2,
                              ),
                              boxShadow: isTapped7
                                  ? [
                                      BoxShadow(
                                        color:
                                            Color(0xFF8757A1).withOpacity(0.9),
                                        blurRadius: 15,
                                        offset: Offset(0, 3),
                                      ),
                                    ]
                                  : [],
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.arrow_circle_down,
                                    color: Colors.black87),
                                SizedBox(width: 8),
                                Text(
                                  'RW',
                                  style: TextStyle(
                                    fontFamily: 'Montserrat',
                                    fontWeight: FontWeight.normal,
                                    color: Colors.black87,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        InkWell(
                          onTapDown: (_) async {
                            await _sendCommand("21");
                            setState(() {
                              bildirim = "Sağ cam kalkıyor.";
                              animatedTextKey = UniqueKey();
                              isTapped = true;
                            });
                          },
                          onTapUp: (_) async {
                            await _sendCommand("22");
                            setState(() {
                              bildirim = "Komut bekleniyor.";
                              animatedTextKey = UniqueKey();
                              isTapped = false;
                            });
                          },
                          onTapCancel: () {
                            setState(() {
                              isTapped = false;
                            });
                          },
                          child: Container(
                            padding: EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: Color(0xFFE5E4E2),
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                color: Color(0xFF8757A1),
                                width: 2,
                              ),
                              boxShadow: isTapped
                                  ? [
                                      BoxShadow(
                                        color:
                                            Color(0xFF8757A1).withOpacity(0.9),
                                        blurRadius: 15,
                                        offset: Offset(0, 3),
                                      ),
                                    ]
                                  : [],
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.arrow_circle_up,
                                    color: Colors.black87),
                                SizedBox(width: 8),
                                Text(
                                  'RW',
                                  style: TextStyle(
                                    fontFamily: 'Montserrat',
                                    fontWeight: FontWeight.normal,
                                    color: Colors.black87,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
