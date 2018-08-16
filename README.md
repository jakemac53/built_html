A basic Builder for injecting content hashes into html templates. In the future
other functionality may be added.

## Usage

First, add a dependency on this package (probably a dev dependency):

```yaml
dev_dependencies:
  built_html: ^0.1.0
```

The next step is to rename your `*.html` file to a `*.template.html` file. This
will be modified and copied to the original `*.html` location.

### Adding content digests

To add a content digest to your html, you can use the `{{digest <uri>}}` syntax.

For example, to create a cache busting uri for a javascript file, you can do the
following:

```html
<script src="main.dart.js?q={{digest main.dart.js}}"></script>
```
