import 'package:flutter/material.dart';

/*----------------------------------------------------------------------------*/
// 중고거래와 공동구매 선택 DropdownButton(이 함수 내 item에서 사용됨)
const List<String> transactionTypes = ['중고거래', '공동구매'];

class TransactionDropdownButton extends StatefulWidget {
  // tabbar_using_controller.dart에서 initalValue값과 onChanged값 받아옴
  final String initialValue;
  final ValueChanged<String>? onChanged;

  const TransactionDropdownButton(
      {required this.initialValue, this.onChanged, super.key});

  @override
  State<TransactionDropdownButton> createState() =>
      _TransactionDropdownButtonState();
}

class _TransactionDropdownButtonState extends State<TransactionDropdownButton> {
  // dropDownValue값 정의
  late String dropDownValue;

  @override
  void initState() {
    super.initState();
    // 받아온 initialValue값 저장
    dropDownValue = widget.initialValue;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 20.0),
      child: Column(
        children: [
          DropdownButton(
              //DropdownButton 스타일
              borderRadius: BorderRadius.circular(7.0),
              value: dropDownValue,
              elevation: 8,
              style: const TextStyle(
                color: Colors.black,
              ),
              // 중고거래와 공동구매 배열을 리스트형태로 맵핑하여
              // DropdownMenuItem에 String형태의 value를 넣어주고
              // 그 value값을 Text로 출력
              items: transactionTypes
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem(value: value, child: Text(value));
              }).toList(),
              onChanged: (String? value) {
                setState(() {
                  // dropDownValue는 null값이 아니다
                  dropDownValue = value!;
                  // 아무것도 누르지 않았을 때 dropDownValue = transactionTypes.first값 호출
                  widget.onChanged?.call(dropDownValue);
                });
              }),
        ],
      ),
    );
  }
}

/*----------------------------------------------------------------------------*/
// 상단과 기능 동일
const List<String> checkTransaction = ['거래 중', '거래 완료'];

class TransactionCheckDropdownButton extends StatefulWidget {
  final String initialValue;
  final ValueChanged<String>? onChanged;

  const TransactionCheckDropdownButton(
      {required this.initialValue, required this.onChanged, super.key});

  @override
  State<TransactionCheckDropdownButton> createState() =>
      _TransactionCheckDropdownButtonState();
}

class _TransactionCheckDropdownButtonState
    extends State<TransactionCheckDropdownButton> {
  late String checkDropDownValue;

  @override
  void initState() {
    super.initState();
    checkDropDownValue = widget.initialValue;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          DropdownButton(
              borderRadius: BorderRadius.circular(7.0),
              value: checkDropDownValue,
              elevation: 8,
              style: const TextStyle(
                color: Colors.black,
              ),
              items: checkTransaction
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem(value: value, child: Text(value));
              }).toList(),
              onChanged: (String? value) {
                setState(() {
                  checkDropDownValue = value!;
                  widget.onChanged?.call(checkDropDownValue);
                });
              }),
        ],
      ),
    );
  }
}
