![Game2D](media/game2d.png)  
[![Chat on Discord](https://img.shields.io/discord/754884471324672040?style=for-the-badge)](https://discord.gg/tPWjMwK)
[![Follow on Bluesky](https://img.shields.io/badge/Bluesky-tinyBigGAMES-blue?style=for-the-badge&logo=bluesky)](https://bsky.app/profile/tinybiggames.com)

> 🚧 **This repository is currently under construction.**
>
> Game2D is actively being developed and rapidly evolving. Some features mentioned in this documentation may not yet be fully implemented, and both APIs and internal structure are subject to change as we continue to improve and expand the library.
>
> Your contributions, feedback, and issue reports are highly valued and will help shape Game2D into the ultimate 2D game framework for Delphi!

# 🎮 Game2D

A modern, pure Object Pascal 2D game library for Delphi.

Game2D is a fast, lightweight, and intuitive framework designed to make 2D game development in Delphi easy and enjoyable. With its clean API and modular architecture, Game2D provides all the essentials needed to build everything from classic arcade games to modern prototypes. Whether you're creating your first game or building a commercial product, Game2D helps you get up and running quickly, letting you focus on gameplay and creativity rather than low-level details.

## ✨ Features

- 🧩 **Easy-to-use, object-oriented API**  
  Game2D’s API is designed with Delphi developers in mind. Everything is fully object-oriented, consistent, and simple to use, so you can concentrate on your game logic instead of wrestling with framework quirks.

- 🎨 **Sprite Rendering & Animation**  
  Effortlessly display and animate sprites with robust support for sprite sheets, atlases, and smooth frame-based animations.

- 🗺️ **Scene Management**  
  Organize your game world using built-in support for entities, actors, stages, and worlds. Easily add, remove, or manage game objects and layers for complex 2D scenes.

- 🔊 **Audio Playback**  
  Play background music, sound effects, and more with a simple API for loading and managing audio assets.

- 🎬 **Video Playback**  
  Integrate MPEG video playback directly into your games for cutscenes, intros, or dynamic backgrounds.

- 🖥️ **Console Output Management**  
  Take full control of console output for debugging, development tools, or retro-inspired games.

- 🖱️ **Immediate Mode GUI (IMGUI) Support**  
  Quickly build user interfaces using an immediate mode GUI system—ideal for in-game menus, HUDs, editors, and debugging panels.

- 🌐 **Networking (UDP)**  
  Add real-time multiplayer or online features using easy UDP networking capabilities.

- 💾 **Database Integration**  
  Save and load game data locally using SQLite, or connect to remote MySQL databases via PHP for high scores, player profiles, and more.

- 🗂️ **Sprite Atlas Support**  
  Efficiently manage and render multiple sprites from a single image file, optimizing performance and memory usage.

- 📚 **Fully Documented & Extensible**  
  Comprehensive documentation and clean, modular codebase make it easy to extend, customize, and understand Game2D.

## 🚀 Why Game2D?

- 💡 **Purpose-Built for Delphi/Object Pascal Developers**  
  Game2D is written from the ground up in pure Object Pascal, making it a natural fit for Delphi projects with no external dependencies or bindings to other languages.

- ⚡ **Minimal Dependencies, Blazing Fast**  
  No bloat, no hassle—just the tools you need, optimized for speed and efficiency.

- 🕹️ **Perfect for Prototyping, Learning, and Production**  
  Game2D is suitable for everyone from beginners learning game programming to experienced developers shipping commercial titles. Rapid iteration and clear structure make prototyping a breeze.

- 🛠️ **Extensible by Design**  
  Add your own components, systems, and tools with ease—Game2D’s modular architecture invites customization.

## 🛠️ Getting Started

1. **Clone this repository:**
   ```sh
    git clone https://github.com/tinyBigGAMES/Game2D.git
   ````

2. **Add the `Game2D` units to your Delphi project:**

   ```delphi
   uses
     Game2D.Deps, Game2D.OpenGL, Game2D.Common, Game2D.Core, Game2D.Network, Game2D.Database;
   ```

3. **Explore the `examples/` folder**
   Dive into sample projects and demos that showcase the major features and typical usage patterns.

4. **Start Building!**
   Game2D lets you get straight to developing your game. Create sprites, build scenes, add audio, and more with just a few lines of code.

## 🛠️ Support and Resources

- 🐞 **Report Issues** via the [Issue Tracker](https://github.com/tinyBigGAMES/Game2D/issues)  
- 💬 **Join Discussions** on the [Forum](https://github.com/tinyBigGAMES/Game2D/discussions), [Discord](https://discord.gg/tPWjMwK), and [Facebook Group](https://www.facebook.com/groups/game2d/)  
- 📚 **Learn More** at [Learn Delphi](https://learndelphi.org)  
- 📖 **Read Documentation** in the [Wiki](https://github.com/tinyBigGAMES/Game2D/wiki)

## 🤝 Contributing  

Contributions to **Game2D** are highly encouraged! 🌟  

### How to Contribute
- 🐛 **Report Issues**: Submit issues if you encounter bugs or need help
- 💡 **Suggest Features**: Share your ideas to make Game2D even better
- 🔧 **Create Pull Requests**: Help expand the capabilities and robustness of the library
- 📝 **Improve Documentation**: Help make Game2D more accessible to developers
- 🎮 **Share Examples**: Contribute sample projects and tutorials

### Development Guidelines
- Follow Delphi coding conventions
- Include unit tests for new features
- Update documentation for API changes
- Test on multiple Windows versions

Your contributions make a difference! 🙌

#### Contributors 👥
<br/>

<a href="https://github.com/tinyBigGAMES/Game2D/graphs/contributors">
  <img src="https://contrib.rocks/image?repo=tinyBigGAMES/Game2D&max=250&columns=20&anon=1" />
</a>

## 🙏 Acknowledgments

**Game2D** stands on the shoulders of giants:

- The robust foundation that powers Game2D – [cute\_headers](https://github.com/RandyGaul/cute_headers), [Dlluminator](https://github.com/tinyBigGAMES/Dlluminator), [glfw](https://github.com/glfw/glfw), [miniaudio](https://github.com/mackron/miniaudio), [nuklear](https://github.com/Immediate-Mode-UI/Nuklear), [pl\_mpeg](https://github.com/phoboslab/pl_mpeg), [sqlite](https://sqlite.org), [stb](https://github.com/nothings/stb), [stdx](https://github.com/marciovmf/stdx), [zlib](https://github.com/madler/zlib)
- **Delphi Community**: For decades of innovation in rapid application development
- **Contributors**: Everyone who helps make Game2D better

## 📜 License

**Game2D** is distributed under the **BSD-3-Clause License**, allowing for redistribution and use in both source and binary forms, with or without modification, under specific conditions.  
See the [LICENSE](https://github.com/tinyBigGAMES/Game2D?tab=BSD-3-Clause-1-ov-file#BSD-3-Clause-1-ov-file) file for more details.

---

🎮 **Game2D** — Build, play, and innovate in pure Delphi. 🚀

<p align="center">
<img src="media/delphi.png" alt="Delphi">
</p>
<h5 align="center">
  
Made with ❤️ in Delphi  
</h5>