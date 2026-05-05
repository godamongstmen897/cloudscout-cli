# 🛡️ CloudScout CLI

![Rust](https://img.shields.io/badge/rust-v1.75%2B-orange?style=flat-square&logo=rust)
![License](https://img.shields.io/badge/license-MIT%2FApache--2.0-blue?style=flat-square)
![PRs Welcome](https://img.shields.io/badge/PRs-welcome-brightgreen.svg?style=flat-square)
![Status](https://img.shields.io/badge/status-active_development-success?style=flat-square)

**CloudScout** is a lightning-fast, highly extensible Cloud Security Posture Management (CSPM-lite) CLI tool built in Rust. It is designed to automatically audit cloud infrastructure (AWS) and local host environments (Linux/Docker) for critical security misconfigurations.

By shifting security left, CloudScout empowers developers, sysadmins, and DevOps engineers to catch vulnerabilities—such as exposed SSH ports, overly permissive IAM roles, and insecure Docker daemon configurations—before they reach production.

---

## ✨ Key Features

*   **⚡ Blazing Fast Execution:** Powered by Rust, CloudScout executes parallelized security audits across multiple environments with minimal memory footprint.
*   **☁️ AWS Security Auditing:** Native integration with the AWS SDK to seamlessly evaluate EC2 instances, S3 buckets, IAM policies, and VPC configurations against industry best practices.
*   **🐳 Local Hardening (Linux & Docker):** Robust local scanning engine to evaluate container privileges, `Dockerfile` setups, and Linux host baselines (UFW, SSH configurations).
*   **💾 Historical Posture Tracking:** Embedded SQLite database automatically stores historical scan data, allowing teams to query and track their security posture over time.
*   **🔌 Extensible `Rule` Architecture:** Designed with a modular `Rule` trait, making it incredibly simple for open-source contributors to write and integrate new security checks.

---

## 🏗️ Architecture

CloudScout is designed with modularity in mind. The core engine handles argument parsing (via `clap`), output formatting (JSON, Terminal Tables), and state management. Individual security checks are implemented as isolated modules that conform to a standard interface.

**Tech Stack:**
*   **Core:** Rust 🦀
*   **CLI Framework:** `clap`
*   **Data Storage:** SQLite (Embedded)
*   **Cloud Provider:** AWS SDK for Rust
*   **Documentation:** Next.js & Tailwind CSS (Docs site)

---

## 🚀 Usage (Coming Soon)

CloudScout uses an intuitive, verb-based command structure. 

```bash
# Initialize the local database and configuration
$ cloudscout init

# Run a comprehensive audit of an AWS environment
$ cloudscout scan aws --region us-east-1

# Run a local Docker security audit
$ cloudscout scan docker --format json