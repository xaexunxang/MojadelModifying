import 'package:flutter/material.dart';

import '../../sample/things_sample.dart';


// 중고거래 and 거래 중 화면
class UsedTrading extends StatelessWidget {
  const UsedTrading({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          width: 430.0,
          height: 348.0,
          child: ListView.separated(
            itemCount: items.length,
            itemBuilder: (context, index) {
              return Container(
                height: 140.0,
                child: Row(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: SizedBox(
                        width: 150,
                        height: 300,
                        child: Image.asset(
                          items[index]['imagePath']!,
                          fit: BoxFit.fill,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 6.0),
                      child: RichText(
                        text: TextSpan(children: [
                          TextSpan(
                            text: '${items[index]['name']}\n',
                            style: TextStyle(
                              fontSize: 17,
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          TextSpan(
                            text:
                            '${items[index]['location']} ${items[index]['time']}\n',
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.grey,
                            ),
                          ),
                          TextSpan(
                            text: '${items[index]['price']}',
                            style: const TextStyle(
                              fontSize: 16,
                              color: Colors.green,
                              // AppColors.mintgreen 대신 Colors.green을 사용했습니다. 필요에 따라 적절한 색상 코드로 수정하세요.
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ]),
                      ),
                    ),
                  ],
                ),
              );
            },
            separatorBuilder: (context, index) => Divider(),
          ),
        ),
      ],
    );
  }
}

// 공동구매 and 거래 중 화면
class GroupBuying extends StatelessWidget {
  const GroupBuying({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 100.0,
          height: 100.0,
          color: Colors.deepOrangeAccent,
          child: const Text(
            '공동구매 거래 중!',
            style: TextStyle(color: Colors.black),
          ),
        ),
        Container(
          width: 100.0,
          height: 100.0,
          color: Colors.lightGreenAccent,
          child: const Text(
            '공동구매 거래 중!',
            style: TextStyle(color: Colors.black),
          ),
        ),
      ],
    );
  }
}

// 중고거래 and 거래 완료 화면
class UsedTraded extends StatelessWidget {
  const UsedTraded({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          width: 100.0,
          height: 100.0,
          color: Colors.red,
          child: const Text(
            '중고거래 거래완료!',
            style: TextStyle(color: Colors.black),
          ),
        ),
        Container(
          width: 100.0,
          height: 100.0,
          color: Colors.blue,
          child: const Text(
            '중고거래 거래완료!',
            style: TextStyle(color: Colors.black),
          ),
        ),
      ],
    );
  }
}

// 공동구매 and 거래 완료 화면
class GroupBought extends StatelessWidget {
  const GroupBought({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 100.0,
          height: 100.0,
          color: Colors.yellow,
          child: const Text(
            '공동구매 거래완료!',
            style: TextStyle(color: Colors.black),
          ),
        ),
        Container(
          width: 100.0,
          height: 100.0,
          color: Colors.green,
          child: const Text(
            '공동구매 거래완료!',
            style: TextStyle(color: Colors.black),
          ),
        ),
      ],
    );
  }
}
