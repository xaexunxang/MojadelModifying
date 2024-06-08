import 'package:flutter/material.dart';

// TABS에 label값을 주기 위한 TabInfo
class TabInfo {
  // final IconData icon;
  final String label;

  const TabInfo({
    // required this.icon,
    required this.label,
  });
}

// TABS = 카테고리 배열
const TABS = [
  TabInfo(label: '거래내역'),
  TabInfo(label: '요모조모'),
  TabInfo(label: '체크리스트'),
  TabInfo(label: '관심'),
  TabInfo(label: '가계부'),
];
