/*
 * trim 相关方法
 * @Author: Jiyu Shao 
 * @Date: 2021-08-14 15:56:54 
 * @Last Modified by: Jiyu Shao
 * @Last Modified time: 2021-08-14 15:59:50
 */

class Trim {
  static String trimMultilineMargin(String s) {
    return s.splitMapJoin(
      RegExp(r'^', multiLine: true),
      onMatch: (_) => '\n',
      onNonMatch: (n) => n.trim(),
    );
  }
}
