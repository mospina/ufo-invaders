# Ufo Invaders

A Space Invader like game developed in Elm.

## Elm

### Start project

elm init

### Set up testing

npm install -g elm-test
elm-test init

To learn more about testing in elm: https://elmprogramming.com/easy-to-test.html

### Development environment

elm reactor

### Installing 3th party libs

elm install timjs/elm-collage

### Serving the app

elm make src/Main.elm --output=main.js

```html
<!DOCTYPE HTML>
<html>
<head>
  <meta charset="UTF-8">
  <title>Main</title>
  <link rel="stylesheet" href="whatever-you-want.css">
  <script src="main.js"></script>
</head>
<body>
  <script>var app = Elm.Main.init();</script>
</body>
</html>
```

## Images and assets

Images from https://opengameart.org/

- starfighter: https://opengameart.org/content/starfighter-x-3
- alien-spaceship: https://opengameart.org/content/alien-spaceship
- missile: https://opengameart.org/content/missile-32x32

## Notes and things

[Elm game base](https://github.com/ohanhi/elm-game-base)
[What key was pressed?](https://github.com/elm/browser/blob/1.0.0/notes/keyboard.md)
