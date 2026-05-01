# 🎓 Grievance.edu – Student Complaint Management System

![Java](https://img.shields.io/badge/Java-ED8B00?style=for-the-badge\&logo=java\&logoColor=white)
![JSP](https://img.shields.io/badge/JSP-007396?style=for-the-badge\&logo=java\&logoColor=white)
![PostgreSQL](https://img.shields.io/badge/PostgreSQL-316192?style=for-the-badge\&logo=postgresql\&logoColor=white)
![TailwindCSS](https://img.shields.io/badge/Tailwind_CSS-38B2AC?style=for-the-badge\&logo=tailwind-css\&logoColor=white)
![Apache Tomcat](https://img.shields.io/badge/Apache_Tomcat-F8DC75?style=for-the-badge\&logo=apachetomcat\&logoColor=black)

## 📌 Overview

**Grievance.edu** is a centralized web-based platform designed to streamline the student grievance redressal process in educational institutions.

It replaces fragmented communication methods like emails and paperwork with a structured, transparent, and trackable system — improving accountability and response time between students and administration.

---

## ✨ Features

### 👨‍🎓 Student Panel

* 🔐 **Secure Authentication** with session management and anti-cache protection
* 📝 **Smart Complaint Submission** categorized by departments (Academics, IT, Hostel, Finance, etc.)
* 📎 **File Upload Support** (Images/PDFs up to 5MB) using secure `multipart/form-data`
* 📊 **Real-Time Status Tracking** (Pending, Resolved, Rejected)
* 💬 **Direct Admin Responses** visible on dashboard

### 👨‍💻 Admin Panel

* 🗂️ **Department-Based Filtering** (Admins only see relevant complaints)
* ⚡ **Quick Status Updates** with remarks
* 📈 **Live Analytics Dashboard** showing:

  * Total complaints
  * Active complaints
  * Resolved complaints

---

## 🏗️ Architecture

This project follows the **MVC (Model-View-Controller)** architecture for better scalability and maintainability.

* **Model:** Database + DAO Layer (JDBC)
* **View:** JSP + Tailwind CSS
* **Controller:** Java Servlets

---

## 🛠️ Tech Stack

| Layer        | Technology                           |
| ------------ | ------------------------------------ |
| Frontend     | HTML5, JavaScript, Tailwind CSS, JSP |
| Backend      | Java (Servlets), Apache Tomcat       |
| Database     | PostgreSQL                           |
| Connectivity | JDBC                                 |

---

## 🚀 Installation & Setup

### 1️⃣ Prerequisites

* Java JDK 11+
* Apache Tomcat (v9 or v10)
* PostgreSQL (v12+)
* IDE (NetBeans / Eclipse / IntelliJ)

---

### 2️⃣ Database Setup

1. Create database:

```sql
CREATE DATABASE grievance_db;
```

2. Run SQL scripts from `/sql` folder to create tables.

3. Configure database in:

```
src/java/com/college/dao/DBConnection.java
```

```java
private static final String URL = "jdbc:postgresql://localhost:5432/grievance_db";
private static final String USER = "postgres";
private static final String PASSWORD = "your_postgres_password";
```

---

### 3️⃣ Run the Project

1. Clone the repository:

```bash
git clone https://github.com/YourUsername/Grievance-System.git
```

2. Open in your IDE

3. Build the project

4. Deploy on Apache Tomcat

5. Open in browser:

```
http://localhost:8080/GrievanceSystem
```

---

## 📸 Future Enhancements

* 🔔 Email & SMS notifications
* 🤖 AI-based complaint categorization
* 📍 Location-based issue tagging
* 📱 Progressive Web App (PWA) support
* 📊 Advanced analytics dashboard

---

## 🤝 Contributing

Contributions are welcome! Feel free to fork the repo and submit a pull request.

---

## 📄 License

This project is licensed under the MIT License.

---

## 👨‍💻 Author

**Piyush Prajapati**
Computer Science (AIML) Student

---

⭐ If you found this project useful, give it a star!
