# Codex
A personalized read-it-later service.

## Development

Install dependencies:

```sh
dart pub get
```

Run tests (and format + lint code):

```sh
dart format . && dart analyze && dart test --chain-stack-traces
```

Build frontend (with hot reload):

```sh
webdev serve
```

Build frontend and run server:

```sh
webdev build --release --output web:build; and dart run bin/server.dart
```

## Reference
- See [Dart Neats](https://github.com/google/dart-neats) for other useful packages
