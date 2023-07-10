## 0.2.1

- Update SDK constraint to <4.0.0.
- Update example deps to the latest.

## 0.2.0

- Update to null safety.

## 0.1.4

- Add support for `.template.json` files.

## 0.1.3

- Upgrade dependency for `build` to `^1.0.0`.

## 0.1.2

Clean up `.template.html` files by default in release mode. To disable you can
configure the builder in your build.yaml:

```yaml
targets:
  $default:
    builders:
      built_html|template_cleanup:
        release_options:
          enabled: false
```

## 0.1.1

Add support of `version` command.

## 0.1.0+1

Allow 2.0.0 of the sdk.

## 0.1.0

Initial release, supports {{digest <uri>}} tags in html.
