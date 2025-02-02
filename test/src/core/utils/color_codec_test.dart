import 'dart:ui' show Color;

import 'package:flutter_test/flutter_test.dart';
import 'package:learning_platfrom/src/core/utils/color_codec.dart';

void main() {
  group(
    'ColorCodec',
    () {
      test(
        'should match the color when encoding and decoding',
        () {
          const color = Color(0xFF000000);
          final encodedColor = colorCodec.encode(color);
          final decodedColor = colorCodec.decode(encodedColor);
          expect(decodedColor, color);
        },
      );

      test(
        'should match the color when encoding and decoding with alpha, red, green and blue',
        () {
          const color = Color.fromARGB(0, 107, 107, 174);
          final encodedColor = colorCodec.encode(color);
          final decodedColor = colorCodec.decode(encodedColor);
          expect(decodedColor, color);
        },
      );
    },
  );
}
