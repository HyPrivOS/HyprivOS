<p align="center">
  <img src="https://hypriv.com/logo.png" alt="HyPriv OS Logo" width="120" />
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

> ```bash
> curl -sL https://raw.githubusercontent.com/HyPrivOS/HyprivOS/main/install.sh | sudo bash
> ```

**During Installation:**
1. The script will automatically verify your system architecture.
2. It will install all necessary background dependencies.
3. You will be prompted to choose a **Port** and set your **Admin Username & Password**.
4. Once completed, your dashboard will be instantly available online!

---

## 🖥️ Getting Started

After a successful installation, you can access your web dashboard by navigating to your server's IP address and the port you configured (Default is `3456`).

> ```text
> http://<YOUR-SERVER-IP>:3456
> ```
Login with the Admin Username and Password you set during the installation.

---

## 🔧 Native System Management (No PM2 Required)

HyPriv OS is designed to be lightweight and robust. It runs as a **Native SystemD Service** (`hypriv-os.service`), meaning it integrates perfectly with your OS without relying on external process managers like PM2. 

**Auto-Start on Boot:** The service is automatically enabled during installation. If your server restarts, HyPriv OS will instantly turn back on by itself.

Here are the standard commands you can use to manage the platform:

**Check Status:**
> ```bash
> sudo systemctl status hypriv-os
> ```

**Restart the Platform:**
> ```bash
> sudo systemctl restart hypriv-os
> ```

**Stop the Platform:**
> ```bash
> sudo systemctl stop hypriv-os
> ```

**View Live Server Logs:**
> ```bash
> sudo journalctl -u hypriv-os -f
> ```

**Reset Admin Password (via CLI):**
> ```bash
> sudo hypriv reset-password
> ```

---

## 🤝 Support & Feedback

If you encounter any issues or have feature requests, please feel free to open an issue in this repository. 

---

## ☕ Buy Me A Coffee

If you find HyPriv OS helpful and want to support its development, consider buying me a coffee! 

**UPI ID:** `warriorabhiii@axisb`

<img src="https://api.qrserver.com/v1/create-qr-code/?size=150x150&data=upi://pay?pa=warriorabhiii@axisb%26pn=HyPriv%20OS" alt="UPI QR Code" width="150" />

<br/>
<p align="center">Built with ❤️ for Linux Administrators.</p>
