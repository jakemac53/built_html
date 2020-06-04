// Copyright (c) 2018, Google Inc. Please see the AUTHORS file for details.
// All rights reserved. Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file.

import 'dart:async';

import 'package:build/build.dart';
import 'package:yaml/yaml.dart';

HtmlTemplateBuilder htmlBuilder(BuilderOptions options) =>
    HtmlTemplateBuilder();

PostProcessBuilder templateCleanupBuilder(BuilderOptions options) =>
    FileDeletingBuilder(['.template.html', '.template.json'],
        isEnabled: options.config['enabled'] as bool ?? false);

class HtmlTemplateBuilder extends Builder {
  @override
  final buildExtensions = {
    '.template.html': ['.html'],
    '.template.json': ['.json']
  };

  @override
  Future build(BuildStep buildStep) async {
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
        case 'version':
          var pubspecAssetId =
              AssetId(buildStep.inputId.package, 'pubspec.yaml');

          // Check if we can load the pubspec file.
          if (!await buildStep.canRead(pubspecAssetId)) {
            log.severe(
                'Cannot read pubspec.yaml! Make sure it is included as a source in your target.');
            return;
          }

          var pubspec = await buildStep.readAsString(pubspecAssetId);
          var pubspecYaml = loadYaml(pubspec);

          // Check if the yaml file have been parsed well.
          if (pubspecYaml == null) {
            log.severe(
                'Cannot read pubspec.yaml! Make sure it is included as a source in your target.');
            return;
          }

          // Check if the version is set.
          if (pubspecYaml['version'] == null) {
            log.severe('Cannot read version from pubspec.yaml!');
            return;
          }

          output.write(pubspecYaml['version']);
          break;

        case 'digest':
          if (value?.isEmpty ?? true) {
            log.severe('''
Invalid template tag ${match.group(0)}.
Expected a command followed by a value, like {{command value}}.
''');
            return;
          }

          var id = AssetId.resolve(value, from: buildStep.inputId);
          output.write(await buildStep.digest(id));
          break;
        default:
          log.severe('Unrecognized template command: $command');
      }

      lastEnd = match.end;
    }

    output.write(content.substring(lastEnd, content.length));

    await buildStep.writeAsString(
      buildStep.inputId.changeExtension('').changeExtension(buildStep.inputId.extension),
      output.toString(),
    );
  }
}

final _regex = RegExp('{{([^{}]+)}}', multiLine: true);
