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
- **Reverse Proxy:** Nginx | Caddy
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
│   ├── README.md
│   └── .env.example
│
├── phase2/
|   ├── nginx
│   │   └── nginx.conf
│   ├── screenshots/
│   └── .env.example
│
├── phase3/
|   ├── Dockerfile
|   ├── docker-compose.yml
│   ├── screenshots/
│   └── .env.example
│
├── .gitignore
├── package.json
└── package-lock.json
```

---

# V. Local Development Setup

## Prerequisites

- Node.js ≥ 20
- npm
- MongoDB
- PM2
- Nginx
- Caddy
- Docker & Docker Compose (Phase 3)

---

# VI. Environment Variables Management

## 6.1 Purpose

Environment variables are used to separate configuration from source code, allowing the application to be deployed across different environments without modifying the codebase.

## 6.2 Environment Files

- `.env.example`: Template file (committed to repository)
- `.env`: Actual environment file (excluded from version control)

Each deployment phase maintains its own `.env.example` file:
- `phase1/.env.example`
- `phase2/.env.example`
- `phase3/.env.example`

## 6.3 Common Environment Variables

- `PORT`
- `MONGO_URI`
- `UPLOAD_DIR`

---

# VII. Deployment Phases

## 7.1 Phase 1 – Traditional Deployment

The application is deployed directly on an Ubuntu server without containerization.

### Steps

1. Clone repository

```bash
git clone https://github.com/Pun-2510/midterm-devops-project.git devops
cd devops
git checkout feature/phase1
```

2. Create environment file

```bash
cp phase1/.env.example .env
nano .env
```

3. Prepare and run setup script

```bash
sudo apt install -y dos2unix
dos2unix phase1/scripts/setup.sh
chmod +x phase1/scripts/setup.sh

cd phase1/scripts
./setup.sh
```

4. Install dependencies

```bash
cd ../../
npm install
```

If missing module:

```bash
npm install dotenv
```

5. Start application

```bash
npm start
```

---

## 7.2 Phase 2 – Reverse Proxy & Process Management

This phase introduces HTTPS, reverse proxy, and PM2.

> Phase 2 must be executed after Phase 1.

1. Clone Phase 2 branch

```bash
cd /opt/app
git clone https://github.com/Pun-2510/midterm-devops-project.git devops
cd devops
git checkout feature/phase2
npm install
```

2. Start MongoDB

```bash
sudo systemctl start mongod
sudo systemctl enable mongod
```

3. Create `.env`

```bash
cp phase2/.env.example .env
nano .env
```

4. Run application with PM2

```bash
pm2 start src/main.js --name devops-app
pm2 status
pm2 save
pm2 startup
```

5. Configure Nginx

```bash
sudo nano /etc/nginx/sites-available/devops-app
```

```nginx
server {
    listen 80;
    server_name yourdomain.com or public ip;

    location / {
        proxy_pass http://localhost:3000;
        proxy_set_header Host $host;
        proxy_set_header X-Forwarded-For $remote_addr;
    }
}
```

```bash
sudo ln -s /etc/nginx/sites-available/devops-app /etc/nginx/sites-enabled/
sudo nginx -t
sudo systemctl start nginx
sudo systemctl enable nginx
sudo nginx -t
sudo systemctl reload nginx
```

6. Switch to Caddy for HTTPS

```bash
sudo systemctl stop nginx
sudo systemctl disable nginx
sudo systemctl start caddy
```

```bash
sudo nano /etc/caddy/Caddyfile
```

```caddy
yourdomain.com {
    reverse_proxy localhost:3000
}
```

```bash
sudo caddy validate
sudo systemctl reload caddy
journalctl -u caddy -f
```

---

## 7.3 Phase 3 – Containerized Deployment

