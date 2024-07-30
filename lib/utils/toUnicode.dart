String convertToUnicodeEscapes(String input) {
  String encodeString = '';

  // 遍历输入字符串中的每个字符
  for (int i = 0; i < input.length; i++) {
    // 获取当前字符的 Unicode 码点
    int codePoint = input.codeUnitAt(i);

    // 对于 UTF-16 编码的 Dart 字符串，可能需要处理代理对（surrogate pairs）
    // 但对于大多数中文字符，它们通常是单个的 UTF-16 码元
    // 这里我们简化处理，只处理单个码元的情况
    // 注意：如果字符串中包含需要代理对的字符（如某些表情符号），则此方法将不适用

    // 将 Unicode 码点转换为 `\uXXXX` 形式的字符串
    // 使用 String.format 或更简单的字符串插值来构建转义序列
    String escape = '\\u${codePoint.toRadixString(16).padLeft(4, '0')}';

    // 将转义序列添加到结果字符串中
    encodeString += escape;
  }

  // 返回构建好的结果字符串
  return encodeString;
}
