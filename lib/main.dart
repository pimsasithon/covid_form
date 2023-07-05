import 'package:flutter/material.dart';
import 'package:quickalert/quickalert.dart';
import 'package:github/github.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Project',
      theme: ThemeData(
        primarySwatch: Colors.pink,
      ),
      home: const MyHomePage(title: 'Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  // void showAlert() {
  //   QuickAlert.show(
  //       title: "ผลการประเมินอาการ",
  //       text: "ยินดีด้วย คุณไม่มีอาการเสี่ยงติดโควิด",
  //       context: context,
  //       type: QuickAlertType.success);
  // }

  int score = 0;

  List<Question> questions = [
    Question('1. มีไข้ / วัดอุณหภูมิได้ 37.5 C ขึ้นไป'),
    Question('2. ไอ มีน้ำมูก เจ็บคอ'),
    Question('3. ถ่ายเหลว'),
    Question('4. จมูกไม่ได้กลิ่น ลิ้นไม่รับรส'),
    Question('5. ตาแดง มีผื่น'),
    Question('6. ไม่มีโรคประจำตัวร่วม'),
    Question(
        '7. แน่นหน้าอก / หายใจไม่ค่อยสะดวก / หายใจเร็ว / หายใจลำบาก ไอแล้วรู้สึกเหนื่อย'),
    Question('8. ถ่ายเหลวมากกว่า 3 ครั้ง/วัน'),
    Question('9. อ่อนเพลีย เวียนศีรษะ / หน้ามืด วิงเวียน'),
    Question(
        '10. หอบเหนื่อย พูดไม่เป็นประโยค / แน่นหน้าอกตลอดเวลา หายใจแล้วเจ็บหน้าอก'),
    Question('11. ซึม เรียกไม่รู้สึกตัว ตอบสนองช้า'),
  ];

  @override
  Widget build(BuildContext context) {
    // final successAlert = buildButton(
    //   onTap: () {
    //     QuickAlert.show(
    //       context: context,
    //       type: QuickAlertType.success,
    //       text: 'Form Submitted Successfully!',
    //     );
    //   },
    //   title: 'Success',
    //   text: 'Transaction Completed Successfully!',
    //   leadingIcon: Icon(
    //     Icons.check_circle,
    //     color: Colors.green,
    //   ),
    // );
    return Scaffold(
        appBar: AppBar(
          title: Text('แบบประเมินอาการโควิด'),
        ),
        body: ListView.builder(
          itemCount: questions.length,
          itemBuilder: (BuildContext context, int index) {
            return Padding(
              padding: EdgeInsets.all(25.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    questions[index].question,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Radio(
                        value: true,
                        groupValue: questions[index].answer,
                        onChanged: (value) {
                          setState(() {
                            questions[index].answer = value!;
                            updateScore();
                          });
                        },
                      ),
                      Text('มี'),
                      Radio(
                        value: false,
                        groupValue: questions[index].answer,
                        onChanged: (value) {
                          setState(() {
                            questions[index].answer = value!;
                            updateScore();
                          });
                        },
                      ),
                      Text('ไม่มี'),
                    ],
                  ),
                ],
              ),
            );
          },
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text('ผลการประเมินอาการ'),
                  content: Text(getAssessmentResult()),
                  actions: [
                    // Padding(
                    //     padding: EdgeInsets.all(30),
                    //     child: Align(
                    //         alignment: Alignment.bottomCenter,
                    //         child: Text(
                    //           "คุณต้องการบันทึกอาการโควิดเลยหรือไม่ ? ",
                    //           style:
                    //               TextStyle(fontSize: 16, color: Colors.black),
                    //         ))),
                    // TextButton(
                    //     onPressed: () {
                    //       Navigator.pop(context, 'ใช่');
                    //     },
                    //     child: Align(
                    //       alignment: Alignment(-0.4, 0),
                    //       child: const Text('ใช่'),
                    //     )),
                    // TextButton(
                    //     onPressed: () {
                    //       Navigator.pop(context, 'ไม่');
                    //     },
                    //     child: Align(
                    //       alignment: Alignment(0.4, 0),
                    //       child: const Text('ไม่'),
                    //     )),
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text('ใช่'),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text('ไม่'),
                    ),
                  ],
                );
              },
            );
          },

          child: Icon(Icons.check),

          // child: Column(
          //   mainAxisAlignment: MainAxisAlignment.center,
          //   children: [
          //     ElevatedButton(
          //         onPressed: () {
          //           showAlert();
          //         },
          //         child: Text("เช็คอาการ")),
          //   ],
          // )),
        ));
  }

  // คำนวณคะแนนและสร้างข้อความผลการประเมิน
  String getAssessmentResult() {
    int totalScore = 0;
    for (var question in questions) {
      if (question.answer) {
        totalScore++;
      }
    }

    if (totalScore > 2) {
      return 'คุณมีอาการเสี่ยงติดโควิด';
    } else {
      return 'ยินดีด้วย คุณไม่มีอาการเสี่ยงของผู้ติดเชื้อ';
    }
  }

  // อัปเดตคะแนนที่ได้จากคำตอบ
  void updateScore() {
    int newScore = 0;
    for (var question in questions) {
      if (question.answer) {
        newScore++;
      }
    }
    setState(() {
      score = newScore;
    });
  }

  buildButton(
      {required Null Function() onTap,
      required String title,
      required String text,
      required Icon leadingIcon}) {}
}

class Question {
  String question;
  bool answer;

  Question(this.question, {this.answer = false});
}
