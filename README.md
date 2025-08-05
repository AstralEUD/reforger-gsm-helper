# Reforger GSM Helper

A powerful CLI tool suite for LinuxGSM (Arma Reforger) server management, featuring comprehensive mod batch management capabilities.

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Platform](https://img.shields.io/badge/Platform-Linux%20%7C%20WSL-blue)](https://github.com/AstralEUD/reforger-gsm-helper)

**🇺🇸 English Version** | [🇰🇷 한국어 버전](README_KR.md)

## 🚀 Features

### Reforger Mod Manager CLI Tool
A comprehensive CLI tool for managing Arma Reforger server mods in batches. This tool helps you test different mod configurations by splitting your mod list into manageable batches, making server troubleshooting and mod testing much easier.

#### ✨ Key Features:
- 📦 **Smart Batch Management**: Automatically split mod lists into configurable batches (10-15 mods per batch)
- 🔄 **Easy Configuration Switching**: Switch between different mod configurations with simple menu selection
- 💾 **Automatic Backup System**: Creates timestamped backups of your original configuration
- 🧹 **Intelligent Addon Cleanup**: Automatically cleans addon directory when switching configurations
- ⚙️ **Flexible Configuration**: Customizable paths for config files and addon directories
- 📅 **Date-based Organization**: Organizes batch files by date for easy management
- 🔧 **Advanced Options**: 
  - Batch size adjustment (Menu 98)
  - Batch recreation (Menu 99)
  - Easy exit (q)
- 🪟 **Cross-platform Support**: Linux native + Windows WSL compatibility

## 📋 Table of Contents

- [Installation & Usage](#-installation--usage)
- [How It Works](#-how-it-works)
- [Menu Options](#-menu-options)
- [Configuration](#-configuration)
- [Directory Structure](#-directory-structure)
- [Troubleshooting](#-troubleshooting)
- [Contributing](#-contributing)
- [License](#-license)

## 🛠️ Installation & Usage

### Prerequisites
- Linux server with Arma Reforger (or WSL for Windows)
- `jq` package installed
- Bash shell environment

### Quick Installation

1. **Clone the repository:**
   ```bash
   git clone https://github.com/AstralEUD/reforger-gsm-helper.git
   cd reforger-gsm-helper
   ```

2. **Install dependencies:**
   ```bash
   # Ubuntu/Debian
   sudo apt-get update && sudo apt-get install jq
   
   # CentOS/RHEL/Rocky
   sudo yum install jq
   # or
   sudo dnf install jq
   ```

3. **Make executable and run:**
   ```bash
   # Linux
   chmod +x reforger-mod-manager.sh
   ./reforger-mod-manager.sh
   
   # Windows (requires WSL)
   reforger-mod-manager.bat
   ```

### 🎯 First Run Setup

When you run the tool for the first time, it will guide you through the setup process:

1. **📁 Create Helper Directory**: Prompts to create `/reforger-gsm-helper/` folder in your system
2. **⚙️ Configure Paths**: 
   - Config file path (default: `/armarserver/serverfiles/armaserver_config.json`)
   - Addon directory path (default: `/armarserver/serverfiles/profiles/server/addons`)
   - Batch size preference (default: 10 mods per batch)
3. **💾 Save Settings**: Automatically stores configuration in `settings.json`

## 🔍 How It Works

The tool follows a systematic approach to manage your mod configurations:

1. **🔍 Mod Detection**: Scans your `armaserver_config.json` and analyzes total mod count
2. **📦 Smart Batch Creation**: Creates multiple progressive config files with incremental mod counts
3. **📅 Daily Organization**: Stores all batches in date-organized folders for easy tracking
4. **🎮 Interactive Selection**: Provides an intuitive menu system for configuration switching
5. **🧹 Automatic Cleanup**: Cleans addon directory and applies selected configuration seamlessly

## 🎮 Menu Options

The tool provides an intuitive menu system with various options:

### Main Menu Options:
- **0**: 🔄 Restore original configuration (all mods)
- **1-N**: 📦 Apply batch configurations (N = number of batches created)
- **98**: ⚙️ Change batch size settings
- **99**: 🔄 Recreate all batches with current settings
- **q**: 🚪 Exit the application

### 📊 Example Workflow

Let's say you have 40 mods in your config with a batch size of 10:

```
📋 Original Configuration: 40 mods
├── 📦 Batch 1: Mods 1-10   (10 mods)
├── 📦 Batch 2: Mods 1-20   (20 mods)
├── 📦 Batch 3: Mods 1-30   (30 mods)
└── 📦 Batch 4: Mods 1-40   (40 mods - complete)
```

**🖥️ Interactive Menu Display:**
```
🚀 Reforger Mod Manager v1.0
════════════════════════════════════════════

📅 Available options for today (2025-08-05):

 0) 🔄 Restore original config (40 mods)
 1) 📦 Batch 1 (10 mods)
 2) 📦 Batch 2 (20 mods)
 3) 📦 Batch 3 (30 mods)
 4) 📦 Batch 4 (40 mods)

Advanced Options:
98) ⚙️  Change batch size
99) 🔄 Recreate batches
 q) 🚪 Exit

Enter your choice: 2
```

Selecting `2` will apply the first 20 mods and automatically clean the addon directory.

## 📁 Directory Structure

After running the tool, your directory structure will be organized as follows:

```
📂 reforger-gsm-helper/
├── ⚙️ settings.json
├── 📅 2025-08-05/
│   ├── 💾 armaserver_config_original.json.bak
│   ├── 📦 armaserver_config_batch_1.json
│   ├── 📦 armaserver_config_batch_2.json
│   ├── 📦 armaserver_config_batch_3.json
│   └── 📦 armaserver_config_batch_4.json
├── 📅 2025-08-06/
│   └── (additional batch files...)
└── 📅 (other dates...)
```

## ⚙️ Configuration

The `settings.json` file stores your personalized configuration:

```json
{
  "config_path": "/armarserver/serverfiles/armaserver_config.json",
  "addons_path": "/armarserver/serverfiles/profiles/server/addons", 
  "batch_size": 10,
  "created_date": "2025-08-05"
}
```

### Configuration Options:
- **`config_path`**: Path to your Arma Reforger server configuration file
- **`addons_path`**: Path to the server addons directory
- **`batch_size`**: Number of mods per batch (adjustable via Menu 98)
- **`created_date`**: Date when the configuration was created

## 🔧 Troubleshooting

### Common Issues & Solutions

#### 1. **`jq` Command Not Found**
```bash
# Ubuntu/Debian
sudo apt-get update && sudo apt-get install jq

# CentOS/RHEL/Rocky
sudo yum install jq
# or for newer versions
sudo dnf install jq

# Arch Linux
sudo pacman -S jq
```

#### 2. **Permission Denied Error**
```bash
# Make script executable
chmod +x reforger-mod-manager.sh

# Check file permissions
ls -la reforger-mod-manager.sh
```

#### 3. **Configuration File Not Found**
- Verify paths in `settings.json` are correct
- Ensure Arma Reforger server is properly installed
- Check if config file exists: `ls -la /armarserver/serverfiles/armaserver_config.json`

#### 4. **WSL Issues (Windows Users)**
```powershell
# Install WSL if not already installed
wsl --install

# Update WSL
wsl --update

# Set default WSL version
wsl --set-default-version 2
```

#### 5. **Batch Creation Fails**
- Ensure sufficient disk space
- Check write permissions in target directory
- Verify JSON syntax in original config file

### 🆘 Getting Help

If you encounter issues not covered above:

1. **📋 Check Prerequisites**: Ensure all dependencies are installed
2. **🔍 Verify File Paths**: Double-check all paths in `settings.json`
3. **🔐 Check Permissions**: Ensure proper read/write permissions
4. **🐛 Create an Issue**: Report bugs on [GitHub Issues](https://github.com/AstralEUD/reforger-gsm-helper/issues) with:
   - Operating system and version
   - Error messages (full output)
   - Steps to reproduce the issue
   - Your `settings.json` configuration (remove sensitive paths)

## 🤝 Contributing

We welcome contributions! Here's how you can help improve this project:

### Ways to Contribute:
- 🐛 **Report Bugs**: Submit detailed bug reports with reproduction steps
- 💡 **Feature Requests**: Suggest new features or improvements
- 📝 **Documentation**: Help improve documentation and examples
- 💻 **Code Contributions**: Submit pull requests with bug fixes or new features
- 🌐 **Translations**: Help translate documentation to other languages

### Development Setup:
1. Fork the repository
2. Create a feature branch: `git checkout -b feature/your-feature-name`
3. Make your changes and test thoroughly
4. Commit with clear messages: `git commit -m "Add: description of changes"`
5. Push to your fork: `git push origin feature/your-feature-name`
6. Create a Pull Request

### Code Guidelines:
- Follow existing code style and conventions
- Add comments for complex logic
- Test your changes on both Linux and WSL
- Update documentation for new features

## 📄 License

This project is licensed under the **MIT License** - see the [LICENSE](LICENSE) file for details.

### MIT License Summary:
- ✅ Commercial use allowed
- ✅ Modification allowed
- ✅ Distribution allowed
- ✅ Private use allowed
- ❌ No warranty provided
- ❌ No liability

---

## 🌟 Star This Project

If you find this tool helpful, please consider giving it a ⭐ on GitHub! It helps others discover the project and motivates continued development.

**Made with ❤️ for the Arma Reforger community**
