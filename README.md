# Azure Security Landing Zone & Cloud Compliance Lab

A secure-by-design Microsoft Azure cloud infrastructure project implemented using **Terraform (IaC)** and integrated with automated security compliance testing via **GitHub Actions** and **Checkov** (CIS Benchmarks).

---

## 🏗️ Architecture & Component Overview

This repository provisions a foundational, enterprise-grade Azure Landing Zone designed to prevent cloud security misconfigurations and comply with Microsoft Azure CIS Benchmarks.

### 1. Network Isolation & Boundary Security
* **Virtual Network (VNet):** Configured a dedicated, isolated VNet (`10.0.0.0/16`) with explicit subnetting (`10.0.1.0/24`) for internal workload segregation.
* **Restricted Network Security Group (NSG):** Bound a default-deny NSG to the internal subnet to strictly restrict unauthorized inbound and outbound traffic, enforcing Least-Privilege network access controls.

### 2. Audit Logging & SIEM/CSPM Readiness
* **Log Analytics Workspace (SIEM Foundation):** Deployed a central Log Analytics Workspace configured with a **365-day (1-year) retention policy** for long-term audit logging and compliance mandates.
* **Threat Detection Integration:** Engineered to serve as the log ingestion engine for **Microsoft Sentinel** analytics rules (KQL) and **Microsoft Defender for Cloud** posture assessment.

### 3. Data Protection & Encrypted Storage
* **Secure Storage Account Configuration:** Provisioned log storage with enforced **TLS 1.2 minimum version** to defeat legacy protocol vulnerabilities.
* **Infrastructure Encryption & Soft Delete:** Enabled infrastructure-level encryption and 30-day container/blob soft-delete retention policies to protect audit telemetry against accidental or malicious deletion.

### 4. DevSecOps & Automated Governance
* **Continuous IaC Security Scanning:** Automated Checkov scans via GitHub Actions to validate Terraform code against Azure CIS Benchmarks on every commit.

---

## 🛠️ Tech Stack & Tools

* **Cloud Infrastructure:** Microsoft Azure (VNet, Subnets, NSG, Log Analytics Workspace, Storage Accounts)
* **Infrastructure as Code (IaC):** Terraform
* **DevSecOps / CI/CD:** GitHub Actions
* **Security Compliance:** Checkov (Azure CIS Benchmarks)

---

## 🔄 Automated DevSecOps Pipeline

The repository features an automated GitHub Actions pipeline (`.github/workflows/checkov.yml`) that triggers on every `push` and `pull_request` to the `main` branch. 

### Scanning Process:
1. **Source Code Checkout:** Pulls the latest Azure Terraform configuration files (`main.tf`).
2. **Static Security Analysis:** Executes Checkov to scan IaC files against Azure CIS Benchmarks.
3. **Compliance Verification:** Ensures 0 critical or high-risk misconfigurations exist before code deployment.

---

## 📂 Project Structure

```text
azure-security-landing-zone/
├── .github/
│   └── workflows/
│       └── checkov.yml      # Azure CI/CD Security Pipeline definition
├── terraform/
│   └── main.tf              # Main Azure IaC Security Infrastructure definition
└── README.md                # Project documentation