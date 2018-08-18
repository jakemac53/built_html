// Copyright (c) 2018, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:async';

import 'package:build/build.dart';

HtmlTemplateBuilder createBuilder(BuilderOptions options) =>
    HtmlTemplateBuilder();

class HtmlTemplateBuilder extends Builder {
  @override
  final buildExtensions = {
    '.template.html': ['.html']
  };

  @override
  Future build(BuildStep buildStep) async {
    // Print anything in between the last and the current match.
    var content = await buildStep.readAsString(buildStep.inputId);

    var matches = _regex.allMatches(content);
    var output = StringBuffer();
    var lastEnd = 0;

    for (var match in matches) {
      output.write(content.substring(lastEnd, match.start));
      var group = match.group(0);

      // Remove the braces.
      group = group.substring(2, group.length - 2).trim();

      // Get the command and value.
      var parts = group.split(' ');
      var command = parts.first;
      var value = parts.last;

      switch (command) {
        case 'timestamp':
          output.write(DateTime.now().millisecondsSinceEpoch);
          break;

        case 'digest':
          if (value?.isEmpty ?? true) {
            log.severe('''
Invalid template tag ${match.group(0)}.
Expected a command followed by a value, like {{command value}}.
''');
            return null;
          }

          var id = AssetId.resolve(value, from: buildStep.inputId);
          output.write(await buildStep.digest(id));
          break;
        default:
          log.severe('Unrecognized template command: $command');
      }

      lastEnd = match.end;
    }

    // Print the rest of the file.
    output.write(content.substring(lastEnd, content.length));

    // Create new (built) file.
    await buildStep.writeAsString(
      buildStep.inputId.changeExtension('').changeExtension('.html'),
      output.toString(),
    );
  }
}

final _regex = RegExp('{{([^{}]+)}}', multiLine: true);
