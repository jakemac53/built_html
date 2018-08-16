import 'package:built_html/builder.dart';

import 'package:build_test/build_test.dart';
import 'package:test/test.dart';

main() {
  test('Digest command works', () async {
    await testBuilder(HtmlTemplateBuilder(), {
      'a|index.template.html': '''
<p>{{digest index.template.html}}</p>
''',
    }, outputs: {
      'a|index.html': '''
<p>8a549f330bf0391893944744bac4d33a</p>
''',
    });
  });
}
