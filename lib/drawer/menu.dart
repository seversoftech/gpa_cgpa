import 'package:flutter/material.dart';
import '../../fontsColorsETC.dart';

class Menu extends StatefulWidget {
  const Menu({super.key});

  @override
  _MenuState createState() => _MenuState();
}

class _MenuState extends State<Menu> {
  Icon? helpUpDownIcon;
  Icon? developerInfoUpDownIcon;
  Icon? contactUpDownIcon;
  Icon down = Icon(
    Icons.arrow_drop_down_circle,
    color: Colors.purple[900],
  );
  Icon up = const Icon(Icons.arrow_upward);
  MenuState() {
    helpUpDownIcon = down;
    developerInfoUpDownIcon = down;
    contactUpDownIcon = down;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 50),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        _menuButton(
          lastIcon: const Icon(Icons.info_outline),
          lastIconSpace: 45,
          title: 'Design & Developer By',
          onPress: () {
            setState(
              () {
                if (developerInfoUpDownIcon == down) {
                  developerInfoUpDownIcon = up;
                } else {
                  developerInfoUpDownIcon = down;
                }
              },
            );
          },
        ),
        _developerInfoContent(),
        _menuButton(
          firstIcon: const Icon(
            Icons.contacts,
          ),
          lastIcon: const Icon(Icons.person_2_outlined),
          lastIconSpace: 110,
          title: 'Supervised By',
          onPress: () {
            setState(
              () {
                if (contactUpDownIcon == down) {
                  contactUpDownIcon = up;
                } else {
                  contactUpDownIcon = down;
                }
              },
            );
          },
        ),
        Container(
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.all(
              Radius.circular(20),
            ),
          ),
          child: (contactUpDownIcon == down)
              ? null
              : Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: (contactUpDownIcon == down)
                      ? []
                      : [
                          Container(
                            height: 10,
                          ),
                          Row(
                            children: [
                              Container(
                                margin: const EdgeInsets.only(left: 20),
                              ),
                              const Icon(
                                Icons.contact_phone,
                                size: 14,
                              ),
                              Container(
                                padding: const EdgeInsets.only(left: 10),
                              ),
                              _setText(
                                  text: 'Mal. Suleiman Muhammad Nasir',
                                  color: Colors.purple.shade900,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: numberFont,
                                  fontSize: 16),
                            ],
                          ),
                          // Row(
                          //   children: [
                          //     Container(
                          //       margin: const EdgeInsets.only(
                          //           left: 20, top: 25, bottom: 5),
                          //     ),
                          //     const Icon(
                          //       Icons.email,
                          //       size: 14,
                          //     ),
                          //     Container(
                          //       padding: const EdgeInsets.only(left: 10),
                          //     ),
                          //     _setText(
                          //         text: 'developersever@gmail.com',
                          //         color: Colors.purple.shade900,
                          //         fontWeight: FontWeight.normal,
                          //         fontFamily: numberFont,
                          //         fontSize: 13),
                          //   ],
                          // ),
                        ],
                ),
        ),
        _menuButton(
            lastIcon: const Icon(Icons.help),
            lastIconSpace: 190,
            title: 'Help',
            onPress: () {
              setState(() {
                if (helpUpDownIcon == down) {
                  helpUpDownIcon = up;
                } else {
                  helpUpDownIcon = down;
                }
              });
            }),
        Expanded(
          child: ListView(
            padding: const EdgeInsets.all(0),
            shrinkWrap: true,
            children: (helpUpDownIcon == down) ? [] : _helpContent(),
          ),
        ),
      ]),
    );
  }

  List<Widget> _helpContent() {
    return [
      Container(
        alignment: const Alignment(0, -1),
        child: Text(
          'How to calculate GPA ?',
          style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 15,
              color: Colors.brown[1000]),
        ),
      ),
      Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
          ),
          alignment: const Alignment(0, -1),
          margin: const EdgeInsets.all(2),
          padding: const EdgeInsets.all(4),
          child: Text(
            '1- Select number of subjects per smester.\n     i.e In each smester include the no of subject \n     and type in Course Codes 6 subjects \n     with respective scores',
            style: TextStyle(
                fontSize: 13,
                fontStyle: FontStyle.normal,
                color: Colors.brown[750]),
          )),
      Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
        ),
        alignment: const Alignment(0, -1),
        margin: const EdgeInsets.all(2),
        padding: const EdgeInsets.all(4),
        child: Text(
          '2- Fill all the fields correctly to enable Calculate\n     Button.\n     If any incorrect value entered Calculate \n     button will be disabled',
          style: TextStyle(
              fontSize: 13,
              fontStyle: FontStyle.normal,
              color: Colors.brown[750]),
        ),
      ),
      Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
        ),
        alignment: const Alignment(0, -1),
        margin: const EdgeInsets.all(2),
        padding: const EdgeInsets.all(4),
        child: Text(
          ' Note credit points and credit hours of your\n smester result it will be helpful to calculate\n CGPA',
          style: TextStyle(
              fontSize: 13,
              fontStyle: FontStyle.normal,
              color: Colors.brown[750]),
        ),
      ),
      Container(
        alignment: const Alignment(0, -1),
        child: Text(
          'How to calculate CGPA ?',
          style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 15,
              color: Colors.brown[1000]),
        ),
      ),
      Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
        ),
        margin: const EdgeInsets.all(2),
        padding: const EdgeInsets.all(4),
        child: Text(
          '       Select number of semster \n       Enter points and credit of each smester\n       calculated in GPA',
          style: TextStyle(
              fontSize: 13,
              fontStyle: FontStyle.normal,
              color: Colors.brown[1000]),
        ),
      ),
    ];
  }

  Widget _buttonChild(
    String name,
    Icon secondIcon,
    double leftIconSpace,
  ) {
    return ClipRRect(
      borderRadius: const BorderRadius.only(
        topRight: Radius.circular(0),
        bottomRight: Radius.circular(0),
      ),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.purple[100],
          border: Border(
            top: BorderSide(width: 2, color: Colors.purple.shade900),
            bottom: BorderSide(width: 2, color: Colors.purple.shade900),
          ),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.only(left: 20),
            ),
            Text(
              name,
              style: TextStyle(
                  color: Colors.purple[900],
                  fontWeight: FontWeight.bold,
                  fontSize: 18),
            ),
            Container(
              padding: EdgeInsets.only(left: leftIconSpace),
            ),
            secondIcon
          ],
        ),
      ),
    );
  }

  Widget _menuButton({
    required String title,
    Icon? firstIcon,
    Icon? lastIcon,
    required double lastIconSpace,
    required VoidCallback onPress,
  }) {
    return GestureDetector(
      onTap: onPress,
      child: _buttonChild(
        title,
        lastIcon!,
        lastIconSpace,
      ),
    );
  }

  Widget _developerInfoContent() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: (developerInfoUpDownIcon == down)
          ? []
          : [
              Container(
                padding: const EdgeInsets.all(5),
                width: 90,
                height: 90,
                child: ClipRRect(
                  borderRadius: const BorderRadius.all(Radius.circular(15)),
                  child: Image.asset('img/dev.png'),
                ),
              ),
              Row(
                children: [
                  Container(
                    margin: const EdgeInsets.only(left: 20),
                  ),
                  const Icon(
                    Icons.account_circle,
                    size: 18,
                  ),
                  Container(
                    padding: const EdgeInsets.only(left: 10),
                  ),
                  _setText(
                      text: 'David Daniel Benjamin',
                      color: Colors.brown.shade900,
                      fontWeight: FontWeight.bold,
                      fontFamily: headerFont,
                      fontSize: 15),
                ],
              ),
              Row(
                children: [
                  Container(
                    margin: const EdgeInsets.only(left: 20),
                  ),
                  const Icon(
                    Icons.star,
                    size: 18,
                  ),
                  Container(
                    padding: const EdgeInsets.only(left: 10),
                  ),
                  _setText(
                      text: 'FPN/S05/2022/2023/HCS/1711',
                      color: Colors.brown.shade900,
                      fontWeight: FontWeight.bold,
                      fontFamily: headerFont,
                      fontSize: 15),
                ],
              ),
              Row(
                children: [
                  Container(
                    margin: const EdgeInsets.only(left: 20),
                  ),
                  const Icon(Icons.computer, size: 18),
                  Container(
                    padding: const EdgeInsets.only(left: 10),
                  ),
                  _setText(
                      text: 'Computer Science Dept',
                      color: Colors.brown.shade800,
                      fontWeight: FontWeight.bold,
                      fontFamily: headerFont,
                      fontSize: 15),
                ],
              ),
              Row(
                children: [
                  Container(
                    margin: const EdgeInsets.only(left: 20),
                  ),
                  const Icon(
                    Icons.school,
                    size: 18,
                  ),
                  Container(
                    padding: const EdgeInsets.only(left: 10),
                  ),
                  _setText(
                      text: 'School of Science',
                      color: Colors.brown.shade800,
                      fontWeight: FontWeight.bold,
                      fontFamily: headerFont,
                      fontSize: 15),
                ],
              ),
            ],
    );
  }

  Widget _setText(
      {required String text,
      required Color color,
      required FontWeight fontWeight,
      required double fontSize,
      required String fontFamily}) {
    return Container(
      padding: const EdgeInsets.all(2),
      child: Text(
        text,
        style: TextStyle(
          color: color,
          fontSize: fontSize,
          //  fontFamily: fontFamily,
          fontWeight: fontWeight,
          fontStyle: FontStyle.normal,
        ),
      ),
    );
  }
}
