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
cd /opt/app/
git clone https://github.com/Pun-2510/midterm-devops-project.git devops
cd devops
cp phase1/.env.example .env
cat .env
npm install
```

If missing module: (If error occured)

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

1. Clone Project from Github (Only do this step when you haven't done Phase 1)

```bash
cd /opt/app
git clone https://github.com/Pun-2510/midterm-devops-project.git devops
cd devops
npm install
```

2. Start MongoDB

```bash
sudo systemctl start mongod
sudo systemctl enable mongod
```

Check the status of MongoDB (To check if it has started yet)
```bash
sudo systemctl status mongod
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

Access the website with url: http://PUBLIC_IP_OR_DOMAIN_NAME:3000

5. Configure Nginx

```bash
sudo nano /etc/nginx/sites-available/devops-app
```

```nginx
server {
    listen 80;
    server_name public ip;

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

6. Configure DNS with Nginx

```bash
sudo nano /etc/nginx/sites-available/devops-app
```

```nginx
server {
    listen 80;
    server_name yourdomain.com www.youdomain.com;

    location / {
        proxy_pass http://localhost:3000;
        proxy_set_header Host $host;
        proxy_set_header X-Forwarded-For $remote_addr;
    }
}
```

```bash
sudo nginx -t
sudo systemctl reload nginx
sudo systemctl restart nginx
sudo nginx -t
```

7. Switch to Caddy for HTTPS

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
sudo systemctl reload caddy
journalctl -u caddy -f
```

---

## 7.3 Phase 3 – Containerized Deployment

1. Stop and disable all the service

```bash
pm2 stop all
pm2 delete all
pm2 kill
pm2 unstartup
pm2 ls
ps aux | grep pm2
```

```bash
sudo systemctl stop mongod
sudo systemctl disable mongod
sudo systemctl status mongod
```

```bash
sudo systemctl stop caddy
sudo systemctl disable caddy
sudo systemctl status caddy
```

```bash
sudo ss -tulpn | grep -E ':(80|443)'
```

2. Install Docker and Docker Compose

```bash
sudo apt update

sudo install -m 0755 -d /etc/apt/keyrings

curl -fsSL https://download.docker.com/linux/ubuntu/gpg \
  | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg

sudo chmod a+r /etc/apt/keyrings/docker.gpg
```

```bash
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] \
  https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo "$VERSION_CODENAME") stable" \
  | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
```

```bash
sudo apt update
sudo apt install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
```

```bash
docker --version
docker compose version
```

```bash
sudo usermod -aG docker $USER
newgrp docker
```

3. Create .env for phase 3

```bash
cp phase3/.env.example .env
nano .env
```

4. Build images

> **Note:**  
> The image name must follow the format `username/repository:tag`.  
> `pun0205` is **only an example Docker Hub account** used in this project.  
> Please replace it with **your own Docker Hub username** before building  
> and pushing the image.

```bash
docker build -t pun0205/midterm-devops-app:phase3 -f phase3/Dockerfile .
docker images
```

5. Login into account

> **Note:**  
> After executing the command below, Docker will prompt you with:
>
> To sign in with your Docker Hub account, open the following URL in your browser:
>
> ```text
> https://login.docker.com/activate
> ```
>
> And provide a one-time code, for example:
>
> ```text
> ABCD-EFGH
> ```
>
> *(The code above is for demonstration purposes only.)*

```bash
docker login
```

6. Push images into Docker Hub

> **Note:**  
> Replace `pun0205` with your own Docker Hub username.  
> Format: `<username>/<repository>:<tag>`

```bash
docker push pun0205/midterm-devops-app:phase3
```

7. Run Docker Compose

```bash
cd phase3
docker compose up -d
```

# VIII. Automation Script

## 7.1 Purpose
The setup.sh script is designed to automatically prepare a clean Ubuntu environment for deploying the project.
It installs all required system dependencies, development tools, and services without starting any application or service by default, ensuring compatibility with a Docker-based deployment workflow.

## 7.2 Script Behavior Overview

### 1. System Update
- Updates the package list and upgrades all existing packages to their latest versions.
- Ensures the system is up-to-date and secure before installing new components.

### 2. Install Essential OS Packages
- Installs commonly required tools

### 3. Install Node.js (v20 LTS) and npm
- Installs Node.js 20 (LTS) from the official NodeSource repository.
- Automatically installs npm alongside Node.js.
- Verifies the installation by printing installed versions.

### 4. Install PM2 (Process Manager)
- Installs PM2 globally using npm.
- PM2 is included for development or legacy usage.
- PM2 is not configured to start any application automatically.

### 5. Install MongoDB (Disabled by Default)
- Installs MongoDB 7.0 from the official MongoDB repository.
- Immediately stops and disables the mongod service.
- MongoDB is installed only as a dependency, not as an active service.
- Prevents port conflicts with MongoDB running inside Docker containers.

### 6. Install Reverse Proxy Services (Disabled)
- Installs Nginx and Caddy.

### 7. Create Application Directories
- Creates the directory:
```text
/opt/app/uploads
```