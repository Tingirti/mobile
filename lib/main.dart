import 'dart:async';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_basic/flutter_bluetooth_basic.dart';

class BluetoothControlPage extends StatefulWidget {
  @override
  _BluetoothControlPageState createState() => _BluetoothControlPageState();
}

class _BluetoothControlPageState extends State<BluetoothControlPage> {
  BluetoothManager _bluetoothManager;
  BluetoothDevice _device;
  BluetoothConnection _bluetoothConnection;
  bool _isConnected = false;
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
    _bluetoothManager = BluetoothManager.instance;
    _bluetoothManager.onStateChanged().listen((state) {
      if (state == BluetoothState.CONNECTED) {
        setState(() {
          _isConnected = true;
        });
      } else {
        setState(() {
          _isConnected = false;
        });
      }
    });
  }

  void connectToDevice(BluetoothDevice device) async {
    try {
      _bluetoothConnection =
          await BluetoothConnection.toAddress(device.address);
      setState(() {
        _isConnected = true;
      });
      _bluetoothConnection.input.listen((Uint8List data) {
        // Handle incoming data if needed
      });
    } catch (error) {
      print("Bağlantı hatası: $error");
      setState(() {
        _isConnected = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Bluetooth Control'),
      ),
      body: Column(
        children: [
          // Your UI elements like buttons and notifications
          SizedBox(height: 20),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton.icon(
                onPressed: () async {
                  if (_isConnected) {
                    try {
                      String komut = "7";
                      List<int> bytes = komut.codeUnits;
                      _bluetoothConnection.output
                          .add(Uint8List.fromList(bytes));
                      await _bluetoothConnection.output.allSent;
                    } catch (error) {
                      print("Komut gönderme hatası: $error");
                    }
                  } else {
                    print("Bağlı bir cihaz bulunamadı.");
                  }
                  setState(() {
                    bildirim = "Aracınızın farları açıldı.";
                    animatedTextKey = UniqueKey(); // Key değiştirildi
                  });
                  Timer(Duration(seconds: 4), () {
                    setState(() {
                      bildirim = "Komut bekleniyor.";
                      animatedTextKey = UniqueKey(); // Key tekrar değiştirildi
                    });
                  });
                },
                icon: Icon(
                  Icons.sunny, // Anahtar ikonu
                  color: Colors.black87,
                ),
                label: Text(
                  'HEADLİGHT',
                  style: TextStyle(
                    fontFamily: 'Montserrat',
                    fontWeight: FontWeight.normal,
                    color: Colors.black87,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  primary: Color(0xFFE5E4E2), // Buton rengi
                  padding: EdgeInsets.all(10), // Buton iç boşluğu
                  shape: RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(10), // Köşeleri yuvarlama
                    side: BorderSide(
                      color: Color(0xFF8757A1), // Buton kenarlık rengi
                      width: 2, // Buton kenarlık kalınlığı
                    ),
                  ),
                  tapTargetSize: MaterialTapTargetSize
                      .shrinkWrap, // Butonun boyutunu içeriğe göre ayarlar
                  elevation:
                      5, // Butonun z-eksenindeki yüksekliği (gölgelenme miktarı)
                  shadowColor: Color(0xFF8757A1), // Buton gölge rengi
                ),
              ),
              InkWell(
                onTapDown: (_) async {
                  if (_isConnected) {
                    try {
                      String komut = "9";
                      List<int> bytes = komut.codeUnits;
                      _bluetoothConnection.output
                          .add(Uint8List.fromList(bytes));
                      await _bluetoothConnection.output.allSent;
                    } catch (error) {
                      print("Komut gönderme hatası: $error");
                    }
                  } else {
                    print("Bağlı bir cihaz bulunamadı.");
                  }
                  setState(() {
                    bildirim = "DDÜÜÜÜTTT!?!?!!!";
                    animatedTextKey = UniqueKey(); // Key değiştirildi
                    isTapped2 =
                        true; // Butona basıldığında isTapped değerini true yap
                  });
                },
                onTapUp: (_) async {
                  if (_isConnected) {
                    try {
                      String komut = "10";
                      List<int> bytes = komut.codeUnits;
                      _bluetoothConnection.output
                          .add(Uint8List.fromList(bytes));
                      await _bluetoothConnection.output.allSent;
                    } catch (error) {
                      print("Komut gönderme hatası: $error");
                    }
                  } else {
                    print("Bağlı bir cihaz bulunamadı.");
                  }
                  setState(() {
                    bildirim = "Komut bekleniyor...";
                    animatedTextKey = UniqueKey(); // Key değiştirildi
                    isTapped2 =
                        false; // Butondan el çekildiğinde isTapped değerini false yap
                  });
                },
                onTapCancel: () {
                  setState(() {
                    isTapped2 =
                        false; // Butondan el çekilip dokunma iptal edildiğinde isTapped değerini false yap
                  });
                },
                child: Container(
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Color(0xFFE5E4E2), // Butonun arka plan rengi
                    borderRadius: BorderRadius.circular(
                        10), // Butonun köşe yuvarlama derecesi
                    border: Border.all(
                      color: Color(0xFF8757A1), // Buton kenarlık rengi
                      width: 2, // Buton kenarlık kalınlığı
                    ),
                    boxShadow: isTapped2
                        ? [
                            // Butona dokunulduğunda gölgelenme efekti
                            BoxShadow(
                              color: Color(0xFF8757A1).withOpacity(
                                  0.9), // Gölge rengi ve opaklık değeri
                              blurRadius: 15, // Gölgenin yayılma miktarı
                              offset: Offset(0, 3), // Gölgenin konumu (x, y)
                            ),
                          ]
                        : [], // Butona dokunulmadığında gölgelenme efekti olmasın
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.multitrack_audio,
                          color: Colors.black87), // Buton ikonu
                      SizedBox(width: 8), // İkon ile metin arasındaki boşluk
                      Text(
                        'HORN',
                        style: TextStyle(
                          fontFamily: 'Montserrat',
                          fontWeight: FontWeight.normal,
                          color: Colors.black87, // Metin rengi
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              ElevatedButton.icon(
                onPressed: () async {
                  if (_isConnected) {
                    try {
                      String komut = "8";
                      List<int> bytes = komut.codeUnits;
                      _bluetoothConnection.output
                          .add(Uint8List.fromList(bytes));
                      await _bluetoothConnection.output.allSent;
                    } catch (error) {
                      print("Komut gönderme hatası: $error");
                    }
                  } else {
                    print("Bağlı bir cihaz bulunamadı.");
                  }
                  setState(() {
                    bildirim = "Aracınızın farları kapatıldı.";
                    animatedTextKey = UniqueKey(); // Key değiştirildi
                  });
                  Timer(Duration(seconds: 4), () {
                    setState(() {
                      bildirim = "Komut bekleniyor.";
                      animatedTextKey = UniqueKey(); // Key tekrar değiştirildi
                    });
                  });
                },
                icon: Icon(
                  Icons.dark_mode, // Anahtar ikonu
                  color: Colors.black87,
                ),
                label: Text(
                  'HEADLİGHT',
                  style: TextStyle(
                    fontFamily: 'Montserrat',
                    fontWeight: FontWeight.normal,
                    color: Colors.black87,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  primary: Color(0xFFE5E4E2), // Buton rengi
                  padding: EdgeInsets.all(10), // Buton iç boşluğu
                  shape: RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(10), // Köşeleri yuvarlama
                    side: BorderSide(
                      color: Color(0xFF8757A1), // Buton kenarlık rengi
                      width: 2, // Buton kenarlık kalınlığı
                    ),
                  ),
                  tapTargetSize: MaterialTapTargetSize
                      .shrinkWrap, // Butonun boyutunu içeriğe göre ayarlar
                  elevation:
                      5, // Butonun z-eksenindeki yüksekliği (gölgelenme miktarı)
                  shadowColor: Color(0xFF8757A1), // Buton gölge rengi
                ),
              ),
              // Diğer butonlar için benzer şekilde devam edin
            ],
          ),
          SizedBox(height: 20),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              InkWell(
                onTapDown: (_) async {
                  if (_isConnected) {
                    try {
                      String komut = "15";
                      List<int> bytes = komut.codeUnits;
                      _bluetoothConnection.output
                          .add(Uint8List.fromList(bytes));
                      await _bluetoothConnection.output.allSent;
                    } catch (error) {
                      print("Komut gönderme hatası: $error");
                    }
                  } else {
                    print("Bağlı bir cihaz bulunamadı.");
                  }
                  setState(() {
                    bildirim = "Sol cam iniyor";
                    animatedTextKey = UniqueKey(); // Key değiştirildi
                    isTapped5 = true;
                  });
                },
                onTapUp: (_) async {
                  if (_isConnected) {
                    try {
                      String komut = "16";
                      List<int> bytes = komut.codeUnits;
                      _bluetoothConnection.output
                          .add(Uint8List.fromList(bytes));
                      await _bluetoothConnection.output.allSent;
                    } catch (error) {
                      print("Komut gönderme hatası: $error");
                    }
                  } else {
                    print("Bağlı bir cihaz bulunamadı.");
                  }
                  setState(() {
                    bildirim = "Komut bekleniyor.";
                    animatedTextKey = UniqueKey(); // Key değiştirildi
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
                              color: Color(0xFF8757A1).withOpacity(0.9),
                              blurRadius: 15,
                              offset: Offset(0, 3),
                            ),
                          ]
                        : [],
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.arrow_circle_down, color: Colors.black87),
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
                  if (_isConnected) {
                    try {
                      String komut = "17";
                      List<int> bytes = komut.codeUnits;
                      _bluetoothConnection.output
                          .add(Uint8List.fromList(bytes));
                      await _bluetoothConnection.output.allSent;
                    } catch (error) {
                      print("Komut gönderme hatası: $error");
                    }
                  } else {
                    print("Bağlı bir cihaz bulunamadı.");
                  }
                  setState(() {
                    bildirim = "Sol cam kalkıyor.";
                    animatedTextKey = UniqueKey(); // Key değiştirildi
                    isTapped6 = true;
                  });
                },
                onTapUp: (_) async {
                  if (_isConnected) {
                    try {
                      String komut = "18";
                      List<int> bytes = komut.codeUnits;
                      _bluetoothConnection.output
                          .add(Uint8List.fromList(bytes));
                      await _bluetoothConnection.output.allSent;
                    } catch (error) {
                      print("Komut gönderme hatası: $error");
                    }
                  } else {
                    print("Bağlı bir cihaz bulunamadı.");
                  }
                  setState(() {
                    bildirim = "Komut bekleniyor.";
                    animatedTextKey = UniqueKey(); // Key değiştirildi
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
                              color: Color(0xFF8757A1).withOpacity(0.9),
                              blurRadius: 15,
                              offset: Offset(0, 3),
                            ),
                          ]
                        : [],
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.arrow_circle_up, color: Colors.black87),
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
                  if (_isConnected) {
                    try {
                      String komut = "19";
                      List<int> bytes = komut.codeUnits;
                      _bluetoothConnection.output
                          .add(Uint8List.fromList(bytes));
                      await _bluetoothConnection.output.allSent;
                    } catch (error) {
                      print("Komut gönderme hatası: $error");
                    }
                  } else {
                    print("Bağlı bir cihaz bulunamadı.");
                  }
                  setState(() {
                    bildirim = "Sağ cam iniyor.";
                    animatedTextKey = UniqueKey(); // Key değiştirildi
                    isTapped7 = true;
                  });
                },
                onTapUp: (_) async {
                  if (_isConnected) {
                    try {
                      String komut = "20";
                      List<int> bytes = komut.codeUnits;
                      _bluetoothConnection.output
                          .add(Uint8List.fromList(bytes));
                      await _bluetoothConnection.output.allSent;
                    } catch (error) {
                      print("Komut gönderme hatası: $error");
                    }
                  } else {
                    print("Bağlı bir cihaz bulunamadı.");
                  }
                  setState(() {
                    bildirim = "Komut bekleniyor.";
                    animatedTextKey = UniqueKey(); // Key değiştirildi
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
                              color: Color(0xFF8757A1).withOpacity(0.9),
                              blurRadius: 15,
                              offset: Offset(0, 3),
                            ),
                          ]
                        : [],
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.arrow_circle_down, color: Colors.black87),
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
                  if (_isConnected) {
                    try {
                      String komut = "21";
                      List<int> bytes = komut.codeUnits;
                      _bluetoothConnection.output
                          .add(Uint8List.fromList(bytes));
                      await _bluetoothConnection.output.allSent;
                    } catch (error) {
                      print("Komut gönderme hatası: $error");
                    }
                  } else {
                    print("Bağlı bir cihaz bulunamadı.");
                  }
                  setState(() {
                    bildirim = "Sağ cam kalkıyor.";
                    animatedTextKey = UniqueKey(); // Key değiştirildi
                    isTapped = true;
                  });
                },
                onTapUp: (_) async {
                  if (_isConnected) {
                    try {
                      String komut = "22";
                      List<int> bytes = komut.codeUnits;
                      _bluetoothConnection.output
                          .add(Uint8List.fromList(bytes));
                      await _bluetoothConnection.output.allSent;
                    } catch (error) {
                      print("Komut gönderme hatası: $error");
                    }
                  } else {
                    print("Bağlı bir cihaz bulunamadı.");
                  }
                  setState(() {
                    bildirim = "Komut bekleniyor.";
                    animatedTextKey = UniqueKey(); // Key değiştirildi
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
                              color: Color(0xFF8757A1).withOpacity(0.9),
                              blurRadius: 15,
                              offset: Offset(0, 3),
                            ),
                          ]
                        : [],
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.arrow_circle_up, color: Colors.black87),
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
          SizedBox(height: 20),
          Text(
            bildirim,
            key: animatedTextKey,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _bluetoothConnection?.dispose();
    super.dispose();
  }
}
