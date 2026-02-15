# 🐄 Pashudhan — Digital Livestock Management Portal

Pashudhan is a **cross-platform Flutter application** designed to digitize livestock management while ensuring compliance with **Maximum Residue Limits (MRL)** and monitoring **Antimicrobial Usage (AMU)**.

It connects **Farmers, Veterinarians, and Shopkeepers** on a single platform to enable safe treatment tracking, verified product release, and transparent supply flow.

---

## 🚀 Features

### 👨‍🌾 Farmer Interface

* Add & manage livestock records
* Track treatments and antimicrobial usage
* Automatic **withdrawal period validation (MRL compliance)**
* AI-powered first-aid assistant
* Chat/call with veterinarians
* Notify nearby shopkeepers when safe products are ready

### 🩺 Veterinarian Interface

* View and respond to farmer queries
* Upload prescriptions (animal info, dosage, duration, etc.)
* Maintain treatment history for follow-ups
* Monitor farmer treatment status

### 🛒 Shopkeeper Interface

* Map view with nearby farmers
* View available verified products
* Place and track orders
* Access ongoing & completed orders

---

## 🤖 AI Assistant

* Built using **LangChain** (Django backend)
* Provides FSSAI-aligned first-aid recommendations
* Activated when veterinarians are unavailable
* Reduces emergency response time

---

## 🏗️ Tech Stack

| Layer          | Technology                      |
| -------------- | ------------------------------- |
| Frontend       | Flutter (Cross-platform)        |
| Backend        | Node.js                         |
| Database       | PostgreSQL                      |
| AI Assistant   | LangChain + Django              |
| Authentication | Email-based login               |
| Maps           | Location-based farmer discovery |

---

## 🔐 Compliance Focus

* Monitors **Antimicrobial Usage (AMU)**
* Ensures adherence to **Maximum Residue Limits (MRL)**
* Prevents marketing of products within unsafe withdrawal periods

---

## 📂 Project Structure (High-Level)

```
pashudhan/
│
├── flutter_app/          # Frontend (Farmer, Vet, Shopkeeper UI)
├── node_backend/         # API & business logic
├── django_ai_service/    # LangChain-powered AI assistant
└── database/             # PostgreSQL schemas & migrations
```
---

## 🌍 Vision

Pashudhan aims to create a **safe, transparent, and compliant livestock ecosystem** by digitizing farm operations and ensuring responsible antimicrobial practices.

---

## 📌 Future Enhancements

* IoT-based livestock health monitoring
* Predictive disease outbreak alerts
* Government compliance dashboard
* Analytics for antimicrobial usage trends

---

## 👨‍💻 Contributors

* Shuvam Swapnil Dash
* Kunal Bansal
* Bishwa Thakur
* Shashwat Mandal
