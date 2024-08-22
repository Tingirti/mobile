import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'dart:typed_data';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'dart:async';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: VideoScreen(),
    );
  }
}

class VideoScreen extends StatefulWidget {
  @override
  _VideoScreenState createState() => _VideoScreenState();
}

class _VideoScreenState extends State<VideoScreen> {
  late VideoPlayerController _controller;
  bool _showControls = false;
  bool _videoStarted = false;
  Color _buttonColor = Color(0xFFE5E4E2);
  Color _borderColor = Color(0xFF8757A1);
  Color _lightColor = Colors.transparent;
  String bildirim = "Komut bekleniyor...";
  Key animatedTextKey = UniqueKey();
  late AnimationController scaleController; // Animasyon kontrolcüsü
  late Animation<double> scaleAnimation; // Ölçek animasyonu

  late BluetoothConnection _bluetoothConnection;
  bool _isConnected = false;

  var isTapped =
      false; // Butona dokunulup dokunulmadığını izlemek için bir değişken

  bool isTapped2 =
      false; // Butona dokunulup dokunulmadığını izlemek için bir değişken

  bool isTapped3 =
      false; // Butona dokunulup dokunulmadığını izlemek için bir değişken

  bool isTapped4 =
      false; // Butona dokunulup dokunulmadığını izlemek için bir değişken

  bool isTapped5 =
      false; // Butona dokunulup dokunulmadığını izlemek için bir değişken

  bool isTapped6 =
      false; // Butona dokunulup dokunulmadığını izlemek için bir değişken

  bool isTapped7 =
      false; // Butona dokunulup dokunulmadığını izlemek için bir değişken

////////////////////
  @override
  void initState() {
    super.initState();
    _initBluetoothConnection(); // Bluetooth cihazına bağlan
    _controller = VideoPlayerController.asset('assets/ceydostartscreen.mp4')
      ..initialize().then((_) {
        _controller.play();
        setState(() {
          _videoStarted = true;
        });
      })
      ..setLooping(false)
      ..addListener(() {
        if (_controller.value.isPlaying) {
          if (!_showControls) {
            setState(() {
              _showControls = false;
            });
          }
        } else {
          if (_showControls) {
            setState(() {
              _showControls = true;
            });
          }
        }
      })
      ..addListener(() {
        if (_controller.value.position >=
            _controller.value.duration - Duration(seconds: 1)) {
          _controller.setVolume(0.0);
          _controller.setPlaybackSpeed(2.0);
          Future.delayed(Duration(seconds: 1), () {
            _controller.pause();
            setState(() {
              _showControls = true;
            });
          });
        }
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    _bluetoothConnection.dispose(); // Uygulama kapanırken bağlantıyı kapat
    super.dispose();
  }

  Future<void> _initBluetoothConnection() async {
    try {
      List<BluetoothDevice> devices =
          await FlutterBluetoothSerial.instance.getBondedDevices();
      if (devices.isNotEmpty) {
        // İlk eşleşmiş cihaza bağlan
        _bluetoothConnection =
            await BluetoothConnection.toAddress(devices.first.address);
        setState(() {
          _isConnected = true;
        });
      }
    } catch (error) {
      print("Bağlantı hatası: $error");
    }
  }

  @override
  Widget build(BuildContext context) {
    double en = MediaQuery.of(context).size.width;
    double boy = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Stack(
        children: [
          Center(
            child: _controller.value.isInitialized
                ? AspectRatio(
                    aspectRatio: _controller.value.aspectRatio,
                    child: VideoPlayer(_controller),
                  )
                : CircularProgressIndicator(),
          ),
          if (_videoStarted)
            AnimatedOpacity(
              opacity: _showControls ? 1.0 : 0.0,
              duration: Duration(seconds: 2),
              child: Container(
                width: en,
                height: boy,
                color: Colors.white,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(padding: EdgeInsets.all(20)),
                    Container(
                      alignment: Alignment.center,
                      width: en,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(100),
                          bottomRight: Radius.circular(100),
                        ), // Köşeleri yuvarlama
                        gradient: LinearGradient(
                          begin: Alignment.bottomCenter,
                          end: Alignment.topCenter,
                          colors: [Color(0xFF8757A1), Colors.white],
                        ),
                      ),
                      child: Text(
                        'CEYDO',
                        style: TextStyle(
                          color: Color(0xFFE5E4E2),
                          fontFamily: 'Montserrat',
                          fontSize: en / 6,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 10,
                          shadows: [
                            Shadow(
                              color: Color(0xFF8757A1),
                              offset: Offset(
                                  0, 0), // X ve Y eksenindeki gölge uzaklığı
                              blurRadius: 7, // Gölge bulanıklığı
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 100),
                    Container(
                      alignment: Alignment.center,
                      width: en / 1.2,
                      height: 100,
                      decoration: BoxDecoration(
                        color: Color(0xff8757a1).withOpacity(0.1),
                        border: Border.all(
                          color: Color(0xff8757A1), // Çerçeve rengi
                          width: 4, // Çerçeve kalınlığı
                        ),
                        borderRadius:
                            BorderRadius.circular(20), // Köşeleri yuvarlama
                      ),
                      child: AnimatedTextKit(
                        key: animatedTextKey,
                        animatedTexts: [
                          TypewriterAnimatedText(bildirim),
                        ],
                        onTap: () {
                          print("Tap Event");
                        },
                      ),
                    ),
                    SizedBox(height: 20),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        ElevatedButton.icon(
                          onPressed: () async {
                            if (_isConnected) {
                              try {
                                // Arduino'ya komut göndermek için gerekli işlemleri yapın
                                String komut = "1";
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
                              bildirim = "Araç pasif edildi.";
                              animatedTextKey = UniqueKey(); // Key değiştirildi
                            });
                            Timer(Duration(seconds: 3), () {
                              setState(() {
                                bildirim = "Komut bekleniyor.";
                                animatedTextKey =
                                    UniqueKey(); // Key tekrar değiştirildi
                              });
                            });
                            print("object");
                          },
                          icon: Icon(
                            Icons.lock, // Anahtar ikonu
                            color: Colors.black87,
                          ),
                          label: Text(
                            'PASSIVE',
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
                              borderRadius: BorderRadius.circular(
                                  10), // Köşeleri yuvarlama
                              side: BorderSide(
                                color:
                                    Color(0xFF8757A1), // Buton kenarlık rengi
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
                        ElevatedButton.icon(
                          onPressed: () async {
                            if (_isConnected) {
                              try {
                                // Arduino'ya komut göndermek için gerekli işlemleri yapın
                                String komut = "2";
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
                              bildirim = "Araç aktif edildi.";
                              animatedTextKey = UniqueKey(); // Key değiştirildi
                            });
                            Timer(Duration(seconds: 3), () {
                              setState(() {
                                bildirim = "Komut bekleniyor.";
                                animatedTextKey =
                                    UniqueKey(); // Key tekrar değiştirildi
                              });
                            });
                          },
                          icon: Icon(
                            Icons.key, // Anahtar ikonu
                            color: Colors.black87,
                          ),
                          label: Text(
                            'ACTİVE',
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
                              borderRadius: BorderRadius.circular(
                                  10), // Köşeleri yuvarlama
                              side: BorderSide(
                                color:
                                    Color(0xFF8757A1), // Buton kenarlık rengi
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
                      ],
                    ),
                    SizedBox(height: 20),
                    InkWell(
                      onTapDown: (_) async {
                        if (_isConnected) {
                          try {
                            // Arduino'ya komut göndermek için gerekli işlemleri yapın
                            String komut = "3";
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
                          _buttonColor = Color(0xFF8757A1);
                          _borderColor = Colors.transparent;
                          _lightColor = Color(0xFF8757A1).withOpacity(0.3);
                          bildirim = "Marş veriliyor...";
                          animatedTextKey = UniqueKey(); // Key değiştirildi
                        });
                      },
                      onTapUp: (_) async {
                        if (_isConnected) {
                          try {
                            // Arduino'ya komut göndermek için gerekli işlemleri yapın
                            String komut = "4";
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
                          _buttonColor = Color(0xFFE5E4E2);
                          _borderColor = Color(0xFF8757A1);
                          _lightColor = Colors.transparent;
                          bildirim = "Komut bekleniyor.";
                          animatedTextKey = UniqueKey(); // Key değiştirildi
                        });
                      },
                      onTapCancel: () {
                        setState(() {
                          _buttonColor = Color(0xFFE5E4E2);
                          _borderColor = Color(0xFF8757A1);
                          _lightColor = Colors.transparent;
                        });
                      },
                      child: Container(
                        width: 150,
                        height: 150,
                        decoration: BoxDecoration(
                          color: _buttonColor,
                          shape: BoxShape.circle,
                          border: Border.all(color: _borderColor, width: 6),
                          boxShadow: [
                            BoxShadow(
                              color: _lightColor,
                              blurRadius: 13,
                              spreadRadius: 20,
                            ),
                          ],
                        ),
                        child: Center(
                          child: Text(
                            'Start',
                            style: TextStyle(
                              fontSize: en / 12,
                              fontFamily: 'Montserrat',
                              fontWeight: FontWeight.normal,
                              color: Colors.black87,
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ElevatedButton.icon(
                          onPressed: () async {
                            if (_isConnected) {
                              try {
                                // Arduino'ya komut göndermek için gerekli işlemleri yapın
                                String komut = "5";
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
                              bildirim = "Aracınızın kapıları kitlendi.";
                              animatedTextKey = UniqueKey(); // Key değiştirildi
                            });
                            Timer(Duration(seconds: 4), () {
                              setState(() {
                                bildirim = "Komut bekleniyor.";
                                animatedTextKey =
                                    UniqueKey(); // Key tekrar değiştirildi
                              });
                            });
                          },
                          icon: Icon(
                            Icons.lock, // Anahtar ikonu
                            color: Colors.black87,
                          ),
                          label: Text(
                            'DOOR',
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
                              borderRadius: BorderRadius.circular(
                                  10), // Köşeleri yuvarlama
                              side: BorderSide(
                                color:
                                    Color(0xFF8757A1), // Buton kenarlık rengi
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
                        ElevatedButton.icon(
                          onPressed: () async {
                            if (_isConnected) {
                              try {
                                // Arduino'ya komut göndermek için gerekli işlemleri yapın
                                String komut = "6";
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
                              bildirim = "Aracınızın kapıları açıldı.";
                              animatedTextKey = UniqueKey(); // Key değiştirildi
                            });
                            Timer(Duration(seconds: 4), () {
                              setState(() {
                                bildirim = "Komut bekleniyor.";
                                animatedTextKey =
                                    UniqueKey(); // Key tekrar değiştirildi
                              });
                            });
                          },
                          icon: Icon(
                            Icons.lock_open, // Anahtar ikonu
                            color: Colors.black87,
                          ),
                          label: Text(
                            'DOOR',
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
                              borderRadius: BorderRadius.circular(
                                  10), // Köşeleri yuvarlama
                              side: BorderSide(
                                color:
                                    Color(0xFF8757A1), // Buton kenarlık rengi
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
                      ],
                    ),
                    SizedBox(height: 20),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ElevatedButton.icon(
                          onPressed: () async {
                            if (_isConnected) {
                              try {
                                // Arduino'ya komut göndermek için gerekli işlemleri yapın
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
                                animatedTextKey =
                                    UniqueKey(); // Key tekrar değiştirildi
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
                              borderRadius: BorderRadius.circular(
                                  10), // Köşeleri yuvarlama
                              side: BorderSide(
                                color:
                                    Color(0xFF8757A1), // Buton kenarlık rengi
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
                                // Arduino'ya komut göndermek için gerekli işlemleri yapın
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
                                // Arduino'ya komut göndermek için gerekli işlemleri yapın
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
                              color:
                                  Color(0xFFE5E4E2), // Butonun arka plan rengi
                              borderRadius: BorderRadius.circular(
                                  10), // Butonun köşe yuvarlama derecesi
                              border: Border.all(
                                color:
                                    Color(0xFF8757A1), // Buton kenarlık rengi
                                width: 2, // Buton kenarlık kalınlığı
                              ),
                              boxShadow: isTapped2
                                  ? [
                                      // Butona dokunulduğunda gölgelenme efekti
                                      BoxShadow(
                                        color: Color(0xFF8757A1).withOpacity(
                                            0.9), // Gölge rengi ve opaklık değeri
                                        blurRadius:
                                            15, // Gölgenin yayılma miktarı
                                        offset: Offset(
                                            0, 3), // Gölgenin konumu (x, y)
                                      ),
                                    ]
                                  : [], // Butona dokunulmadığında gölgelenme efekti olmasın
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.multitrack_audio,
                                    color: Colors.black87), // Buton ikonu
                                SizedBox(
                                    width:
                                        8), // İkon ile metin arasındaki boşluk
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
                                // Arduino'ya komut göndermek için gerekli işlemleri yapın
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
                                animatedTextKey =
                                    UniqueKey(); // Key tekrar değiştirildi
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
                              borderRadius: BorderRadius.circular(
                                  10), // Köşeleri yuvarlama
                              side: BorderSide(
                                color:
                                    Color(0xFF8757A1), // Buton kenarlık rengi
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
                      ],
                    ),
                    SizedBox(height: 20),
                    Column(
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            InkWell(
                              onTapDown: (_) async {
                                if (_isConnected) {
                                  try {
                                    String komut = "11";
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
                                  bildirim = "Camlar iniyor...";
                                  animatedTextKey =
                                      UniqueKey(); // Key değiştirildi
                                  isTapped3 = true;
                                });
                              },
                              onTapUp: (_) async {
                                if (_isConnected) {
                                  try {
                                    String komut = "12";
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
                                  animatedTextKey =
                                      UniqueKey(); // Key değiştirildi
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
                                            color: Color(0xFF8757A1)
                                                .withOpacity(0.9),
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
                                if (_isConnected) {
                                  try {
                                    String komut = "13";
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
                                  bildirim = "Camlar kaldırılıyor.";
                                  animatedTextKey =
                                      UniqueKey(); // Key değiştirildi
                                  isTapped4 = true;
                                });
                              },
                              onTapUp: (_) async {
                                if (_isConnected) {
                                  try {
                                    String komut = "14";
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
                                  animatedTextKey =
                                      UniqueKey(); // Key değiştirildi
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
                                            color: Color(0xFF8757A1)
                                                .withOpacity(0.9),
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
                                  animatedTextKey =
                                      UniqueKey(); // Key değiştirildi
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
                                  animatedTextKey =
                                      UniqueKey(); // Key değiştirildi
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
                                            color: Color(0xFF8757A1)
                                                .withOpacity(0.9),
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
                                  animatedTextKey =
                                      UniqueKey(); // Key değiştirildi
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
                                  animatedTextKey =
                                      UniqueKey(); // Key değiştirildi
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
                                            color: Color(0xFF8757A1)
                                                .withOpacity(0.9),
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
                                  animatedTextKey =
                                      UniqueKey(); // Key değiştirildi
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
                                  animatedTextKey =
                                      UniqueKey(); // Key değiştirildi
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
                                            color: Color(0xFF8757A1)
                                                .withOpacity(0.9),
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
                                  animatedTextKey =
                                      UniqueKey(); // Key değiştirildi
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
                                  animatedTextKey =
                                      UniqueKey(); // Key değiştirildi
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
                                            color: Color(0xFF8757A1)
                                                .withOpacity(0.9),
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
                    )
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}
