# Codex
A personalized read-it-later service.

## Todo
- Search implementation
- Server-side APIs
- Reading queue UI
- Article adding UI
- Scribe integration
- See [Dart Neats](https://github.com/google/dart-neats) for other useful packages
- Add CI via github actions (see [here](https://github.com/dart-lang/markdown/blob/master/.github/workflows/test-package.yml))

## Development

Run tests:

```sh
dart test --chain-stack-traces
```

Build frontend (with hot reload):

```sh
webdev serve
```

Build frontend and run server:

```sh
webdev build --release --output web:build; and dart run bin/server.dart
```
