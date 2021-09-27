A basic Builder for injecting content into html and json templates.

## Usage

First, add a dependency on this package:

```bash
$ pub add --dev built_html
```

The next step is to rename your `*.html` or `*.json` files to a `*.template.html` or `*.template.json` files. Those files will be modified and copied to the original location.

Also, take a look at [example project](example/) for a working solution.

## Commands

### `digest <url>`

This command adds a content hash of an asset. Takes one parameter, the path to the file.

```html
<script src="main.dart.js?q={{digest main.dart.js}}"></script>
```

### `version`

This command simply adds the version from your `package.yaml`. Takes no parameters.

```html
<script src="main.dart.js?q={{version}}"></script>
```
