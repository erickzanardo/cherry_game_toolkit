# 🍒 Game Toolkit

[![shorebird ci](https://api.shorebird.dev/api/v1/github/erickzanardo/cherry_game_toolkit/badge.svg)](https://console.shorebird.dev/ci)

This repository contains a collection of tools, packages and other resources which are generic a
reusable across different game projects.

All the resources that live here came to life while I was working on my own game projects and
they are opionated given my own experience and preferences. However, I believe they can be useful to
other developers as well.

Hopefully you can find something useful here! And if you do, consider supporting my work!

Check out my games: https://g4me.info/@cherrybit

## 🖼️ Templates

Templates are base projects to kickstart new projects, the way to use them is simply by copying and
pasting them directly from this repository.

 - [Base Game](templates/base_game): A minimal Flutter Flame game template with
   basic structure and examples of common features like game loop, input handling, and asset
   management.

## 📦 Packages

 - [Level Progress](packages/level_progress): Reusable game progress based on sequencial levels logic.

Reusable packages that are generic and full contained. They can be imported into any project and
used as is using the pubspec git dependency.

Example:

```yaml
dependencies:
  level_progress:
    git:
      url: https://github.com/erickzanardo/cherry_game_toolkit.git
      path: packages/level_progress
      ref: main # optional, but recommended to avoid breaking changes
```
