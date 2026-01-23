# I. Project Title
> **Mid-term DevOps**  
> Course Code: **502094 – Software Deployment, Operations and Maintenance**

---

# II. Project Overview
The objective of this project is to deploy a fully functional web application to a cloud environment using two distinct deployment models:

1. **Traditional server-based deployment**, where the application and its dependencies run directly on the host operating system.
2. **Modern containerized deployment**, where the entire application stack is packaged and orchestrated using Docker and Docker Compose.

Through these deployments, the project demonstrates professional practices in Git-based collaboration, Linux automation, cloud server provisioning, reverse proxy configuration, HTTPS enablement, database integration, persistent storage handling, and deployment reliability. A comparative analysis is later conducted to evaluate the strengths and trade-offs of both deployment approaches.

---

# III. Technology Stack
The project utilizes the following core technologies:
- **Operating System:** Ubuntu (Cloud Server)
- **Backend Runtime:** Node.js (LTS)
- **Web Framework:** Express.js
- **Database:** MongoDB
- **Reverse Proxy:** Nginx
- **Process Management (Phase 2):** PM2
- **Containerization (Phase 3):** Docker & Docker Compose
- **Version Control:** Git & GitHub
- **Security:** HTTPS via Let’s Encrypt 

---

# IV. Repository Structure

The repository is organized according to a phase-based structure, ensuring clarity, separation of concerns, and alignment with the project specification:

```text
.
├── src/
│   ├── controllers/
│   ├── models/
│   ├── public/
│   ├── routes/
│   ├── services/
│   ├── validators/
│   ├── views/
│   └── main.js
│
├── phase1/
│   ├── scripts/
│   │   └── setup.sh
│   ├── screenshots/
│   └── .env.example
│
├── phase2/
│   ├── screenshots/
│   └── .env.example
│
├── phase3/
│   ├── screenshots/
│   └── .env.example
│
├── .gitignore
├── package.json
└── package-lock.json
```

# V. Local Development Setup
**Prerequisites**
> Before running the application locally, ensure that the following software is installed:
> Node.js (at least or higher than 18)
> npm
> MongoDB

**Installation**

