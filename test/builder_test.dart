import 'package:built_html/builder.dart';

import 'package:build_test/build_test.dart';
import 'package:test/test.dart';

main() {
  test('Digest command works', () async {
    await testBuilder(HtmlTemplateBuilder(), {
      'a|index.template.html': '<p>{{digest index.template.html}}</p>',
      'a|script.js': 'useful js script',
      'a|styles.css': 'useful css styles',
      'a|assets.template.json':
          '{ "script.js": "{{digest script.js}}", "styles.css": "{{digest styles.css}}" }',
    }, outputs: {
      'a|index.html': '<p>ddfbfb428acba99177a5d34f795f24d9</p>',
      'a|assets.json':
          '{ "script.js": "5140897c4b2dd3628459f33e0df969e2", "styles.css": "d5e95fc0e4382d6f22d3b4103594da79" }'
    });
  });
}
