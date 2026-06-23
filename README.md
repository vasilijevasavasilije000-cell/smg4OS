# smg4OS - SMG4 Based Linux Distribution

![Status](https://img.shields.io/badge/status-in_development-yellow)
![License](https://img.shields.io/badge/license-GPL3-blue)

A fun, community-driven Linux distribution inspired by SMG4 (SuperMarioGlitchy4). smg4OS aims to be a lightweight, user-friendly Linux distro with a unique personality.

## 🎮 About smg4OS

smg4OS is a Linux distribution built with the spirit of SMG4 in mind - creative, chaotic, and full of personality. Whether you're looking for a gaming-focused distro or just want to join the meme-powered revolution, smg4OS has you covered.

**Key Features:**
- Lightweight and fast
- SMG4-themed aesthetics
- Community-driven development
- Gaming-friendly optimizations
- Modern tooling and package management

## 📋 System Requirements

- **Minimum:** 2GB RAM, 10GB disk space, 1GHz processor
- **Recommended:** 4GB RAM, 20GB disk space, 2GHz multi-core processor
- UEFI or BIOS boot support

## 🚀 Quick Start

See [BUILDING.md](docs/BUILDING.md) for detailed build instructions.

```bash
# Clone the repository
git clone https://github.com/vasilijevasavasilije000-cell/smg4OS.git
cd smg4OS

# Build the distro
./scripts/build.sh
```

## 📁 Project Structure

```
smg4OS/
├── docs/                    # Documentation
├── scripts/                 # Build and development scripts
├── src/                     # Source files
│   ├── kernel/             # Kernel configuration
│   ├── bootloader/         # Bootloader setup
│   └── filesystem/         # Filesystem layout
├── config/                 # Configuration files
├── packages/               # Package definitions
├── setup-wizard/           # Interactive setup assistant with SMG4 guidance
├── stonks/                 # STONKS app market (50+ apps)
├── meme-explorer/          # Meme Explorer browser (legendary meme sites)
├── bob-player/             # Bob Player media player (Bob's raps)
└── iso/                    # ISO build output
```

## 🛠️ Development

### Prerequisites
- Linux host system
- Build tools: gcc, make, bash
- Package manager: apt (for Debian-based) or similar

### Getting Started

1. Clone the repo
2. Read [DEVELOPMENT.md](docs/DEVELOPMENT.md)
3. Check [Contributing Guidelines](CONTRIBUTING.md)

## 📦 Components

- **Base:** Linux kernel (LTS) + GNU utilities
- **Init System:** systemd
- **Package Manager:** APT-based
- **Desktop:** XFCE/Openbox (lightweight)
- **Bootloader:** GRUB2

## 📈 STONKS App Market

**The legendary app market where apps go BRRR with GAINS! 📈🚀**

STONKS is smg4OS's themed app store powered by stock market memes and SMG4 personality. Browse and install apps from a menu featuring:

- **50+ Applications** across 9 categories
- **Stock Market Theme** with live ticker and gains visualization
- **SMG4 Personality** throughout the interface
- **Easy Installation** with interactive workflow
- **Extensible Design** - add apps to apps.conf

### Quick Start with STONKS

```bash
./stonks/stonks.sh
```

**Categories:** Gaming, Development, Creative, Productivity, Utilities, Security, System Tools, Meme Apps

See [stonks/README.md](stonks/README.md) for full documentation.

## 🌐 Meme Explorer Browser

**The dankest browser where memes go to be LEGENDARY! 🌐🎉**

Meme Explorer is smg4OS's themed web browser focused on finding and organizing the internet's best meme content. Features include:

- **10+ Pre-loaded Bookmarks** to legendary meme sites
- **Search Integration** across major meme sources (Know Your Meme, Reddit, YouTube, Twitter)
- **Bookmark Management** - save and organize your favorite meme sites
- **Browse History** - track your meme journey with timestamps
- **Random Discovery** - surprise yourself with random meme sites
- **Pro Meme Tips** - learn how to find and understand legendary memes
- **SMG4 Personality** throughout the interface

### Quick Start with Meme Explorer

```bash
./meme-explorer/meme-explorer.sh
```

**Default Bookmarks:** Reddit Memes, Know Your Meme, Twitter, YouTube, 4chan, TikTok, Imgur, 9GAG, Tumblr, Urban Dictionary

See [meme-explorer/README.md](meme-explorer/README.md) for full documentation.

## � Bob Player - The Legendary Media Player

**Where Bob's Music Goes To Be LEGENDARY! 🔥🎵**

Bob Player is smg4OS's ultimate media player dedicated to all of Bob's iconic raps and songs from SuperMarioGlitchy4. Experience chaotic, legendary music with full playlist management:

- **25+ Bob Tracks** - All of Bob's legendary raps
- **Multiple Albums** - Bob The Legendary, Spooky Scary Raps, Chaos Sessions, and more
- **Full Playback Control** - Play, pause, skip, shuffle, repeat
- **Playlist Management** - Create custom playlists with any name
- **Search Functionality** - Find tracks by title instantly
- **Listening History** - Track your Bob journey with timestamps
- **Bob's Rap Tips** - 10 pro tips for enjoying Bob's music
- **SMG4 Personality** - Bob's legendary catchphrases throughout
- **Advanced Settings** - Volume, repeat, equalizer, quality control

### Quick Start with Bob Player

```bash
./bob-player/bob-player.sh
```

**Featured Tracks:** MAMA LUIGI REMIX, It's Me Bob!, The Bob Anthem, Chaos Incarnate Flow, Bob's Battle Rap, and 20+ more legendary raps!

See [bob-player/README.md](bob-player/README.md) for full documentation.

## �🎨 Customization

smg4OS is highly customizable. See [CUSTOMIZATION.md](docs/CUSTOMIZATION.md) for theming, package selection, and more.

## 📚 Documentation

- [Building smg4OS](docs/BUILDING.md) - Complete build guide
- [Development Guide](docs/DEVELOPMENT.md) - For contributors
- [Architecture](docs/ARCHITECTURE.md) - System design
- [Customization](docs/CUSTOMIZATION.md) - Theming and tweaks
- [FAQ](docs/FAQ.md) - Common questions

## 🤝 Contributing

We love contributions! Please see [CONTRIBUTING.md](CONTRIBUTING.md) for guidelines.

## 📄 License

smg4OS is released under the GNU General Public License v3. See [LICENSE](LICENSE) for details.

## 💬 Community

- **Issues:** Report bugs and request features
- **Discussions:** Join community discussions
- **Wiki:** Community-maintained wiki

## 🙋 Support

For support, please:
1. Check the [FAQ](docs/FAQ.md)
2. Search existing [Issues](https://github.com/vasilijevasavasilije000-cell/smg4OS/issues)
3. Open a new issue with details

---

**Made with ❤️ and powered by memes. Let's make Linux fun again!**
