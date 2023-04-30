enum EnumTab {
  first(ko: "첫번째", height: 300),
  second(ko: "두번째", height: 150),
  third(ko: "세번째", height: 200),
  fourth(ko: "네번째", height: 200),
  fifth(ko: "다섯번째", height: 300);

  final String ko;
  final double height;

  const EnumTab({
    required this.ko,
    required this.height,
  });
}

extension EnumTabExtension on EnumTab {
  double sumHeightUtilIndex({required int index, bool isLastHalf = false}) {
    double sumHeight = 0.0;

    for (int i = 0; i <= index; i++) {
      if (i == index && isLastHalf) {
        sumHeight += EnumTab.values[index].height / 2;
      } else {
        sumHeight += EnumTab.values[index].height;
      }
    }
    return sumHeight;
  }
}
