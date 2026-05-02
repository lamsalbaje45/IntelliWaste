# Smart Waste Management System

## 📌 Project Overview
The Smart Waste Management System is a Java-based web application designed to improve waste reporting and collection efficiency. It allows users to report waste issues, administrators to manage operations, and workers to handle assigned tasks.

The system follows the **MVC (Model-View-Controller)** architecture and uses **Java Servlets, JSP, and MySQL** for dynamic web development.

---

## 🎯 Objectives
- Provide an easy platform for users to report waste issues
- Enable administrators to manage waste reports and assign tasks
- Allow workers to update the status of assigned tasks
- Improve waste management efficiency and tracking

---

## 🧩 System Modules

### 👤 User Module
- Register account
- Login securely
- Report waste issues
- View submitted reports
- Track waste status

### 🛠️ Admin Module
- Admin login
- View all waste reports
- Assign tasks to workers
- Manage users and workers
- Monitor system activity

### 👷 Worker Module
- Worker login
- View assigned tasks
- Accept/reject tasks
- Update task status
- View work history

---

## ⚙️ Core Features
- Authentication & Authorization (role-based access)
- Waste Reporting System
- Waste Tracking (Pending → Completed)
- Task Assignment System
- Dashboard & Reporting

---

## 🏗️ Technologies Used

- **Backend:** Java (Servlets, JDBC)
- **Frontend:** JSP, CSS, JavaScript
- **Architecture:** MVC
- **Database:** MySQL
- **Server:** Apache Tomcat
- **Build Tool:** Maven
- **IDE:** IntelliJ IDEA
- **Version Control:** Git & GitHub

---

## 🗄️ Database Tables (Basic)

- Users (id, name, email, password, role)
- Waste Reports (id, location, type, status, user_id)
- Workers (id, name, status)
- Assignments (id, waste_id, worker_id, status)

---
