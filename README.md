<p align="center">
  <h1 align="center">HyPriv OS</h1>
  <p align="center">
    <strong>Universal Linux Server Management Platform</strong>
  </p>
</p>

## 🚀 What is HyPriv OS?

HyPriv OS is a lightweight, powerful, and secure Universal Linux Server Management Platform. It simplifies the complexities of managing Linux servers by providing a clean, modern dashboard and built-in tools for seamless administration. Whether you are managing a single VPS or an entire infrastructure, HyPriv OS puts complete control at your fingertips.

## ✨ Key Features & Benefits

- **⚡ Lightning Fast Setup:** Get your server management dashboard up and running in less than a minute with a single command.
- **🛡️ Highly Secure:** Built-in secure authentication, brute-force protection, and dynamic session management out of the box.
- **📊 Real-time Monitoring:** Keep an eye on system resources, running processes, and network activity live from the dashboard.
- **🌐 Universal Compatibility:** Works seamlessly across major Linux distributions (Ubuntu/Debian) on both AMD64 and ARM64 architectures.
- **📦 Zero Dependencies:** HyPriv OS automatically installs and isolates its own Node.js runtime and dependencies, ensuring it never conflicts with your existing server setup.
- **🛠️ Built-in CLI Tool:** Comes with a dedicated `hypriv` CLI tool for quick administrative tasks like password resets directly from your terminal.

---

## ⚙️ System Requirements

Before installing, ensure your server meets the following criteria:
- **Operating System:** Ubuntu or Debian
- **Architecture:** AMD64 (x86_64) or ARM64 (aarch64)
- **Permissions:** Root access or `sudo` privileges are required for installation.

---

## 📥 Installation

Installing HyPriv OS is incredibly simple. Just connect to your server via SSH and run the following command:

```bash
curl -sL https://raw.githubusercontent.com/HyPrivOS/HyprivOS/main/install.sh | sudo bash
```

**During Installation:**
1. The script will automatically verify your system architecture.
2. It will install all necessary background dependencies.
3. You will be prompted to choose a **Port** and set your **Admin Username & Password**.
4. Once completed, your dashboard will be instantly available online!

---

## 🖥️ Getting Started

After a successful installation, you can access your web dashboard by navigating to your server's IP address and the port you configured (Default is `3456`).

```text
http://<YOUR-SERVER-IP>:3456
```
Login with the Admin Username and Password you set during the installation.

---

## 🔧 Management Commands

HyPriv OS runs safely as a background systemd service (`hypriv-os`). Here are some helpful commands for managing your server:

**Check Status:**
```bash
sudo systemctl status hypriv-os
```

**Restart the Platform:**
```bash
sudo systemctl restart hypriv-os
```

**View Live Server Logs:**
```bash
sudo journalctl -u hypriv-os -f
```

**Reset Admin Password (via CLI):**
```bash
sudo hypriv reset-password
```

---

## 🤝 Support & Feedback

If you encounter any issues or have feature requests, please feel free to open an issue in this repository. 

<p align="center">Built with ❤️ for Linux Administrators.</p>
