import 'package:uuid/uuid.dart';

const _undefined = 'UNDEF';

extension StringX on String {
  /// Trim UUID like `abcda-dbasdasd-asdasdasd` to `ABCDA`
  /// if uuid is invalid return the string as is
  /// [limit] - number of characters to trim
  /// example: `abcde-fghij-klmno` with limit = 3 returns `ABC`
  String splitUuid([final int limit = 4]) {
    var lim = limit;
    // safety check
    lim = limit > length ? length : limit;
    if (Uuid.isValidUUID(fromString: this) && contains('-')) {
      return substring(0, indexOf('-')).toUpperCase().substring(0, lim);
    } else {
      return this;
    }
  }

  /// If string length is less than [splitLength] return the string as is
  /// If string length is greater than [splitLength]
  /// return string truncated to [splitLength] and append `...`
  /// ```dart
  /// 'abcdefg'.splitTo(4); // 'abcd...'
  /// 'abc'.splitTo(4); // 'abc'
  /// ```
  String splitTo(int splitLength) {
    if (length > splitLength) {
      return '${substring(0, splitLength)}...';
    } else {
      return this;
    }
  }

  /// Extract the first two letters of the first word in any language where possible
  /// If there is only one letter return the letter and a dot
  /// If there are no matches return 'un.'
  /// If string is null return 'un.'
  /// [capitalize] - if true return in uppercase
  String extractFirstTwoLetter({bool capitalize = false}) {
    var result = _undefined; // undefined

    /// Matches any letter in any alphabet
    final regex = RegExp(r'\p{Letter}', unicode: true);
    final matches = regex.allMatches(this).map((match) => match.group(0)!).toList();

    if (matches.length >= 2) {
      result = matches[0] + matches[1];
    } else if (matches.length == 1) {
      result = '${matches[0]}.';
    }

    return capitalize ? result.toUpperCase() : result;
  }
}
