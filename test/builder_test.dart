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
<p>9e43ec54624795b34b4dd9ee60ffe652</p>
''',
    });
  });
}
