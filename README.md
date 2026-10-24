# Departmental Information Portal

## Objective

A simple, static departmental information portal (HTML + CSS) packaged and served using Docker and Nginx, so it can be built once and run identically on any machine that has Docker installed.

## Technologies

- HTML5 / CSS3 (plain, no frameworks)
- Docker
- Nginx (`nginx:alpine` base image)
- Git / GitHub

## Prerequisites

- [Docker Desktop](https://www.docker.com/products/docker-desktop/) installed and running
- A modern web browser
- [Git](https://git-scm.com/) (for cloning/version control)

## Build & Run

From the project root (the folder containing the `Dockerfile`):

```bash
docker build -t department-portal .
docker run -d -p 8080:80 --name portal department-portal
```

Then open **http://localhost:8080** in your browser.

Windows users can instead run the helper script:

```powershell
.\scripts\build-and-run.ps1
```

## Stop / Restart / Remove

```bash
# Stop the container (keeps it for later)
docker stop portal

# Start it again
docker start portal

# Remove the container entirely
docker rm -f portal

# Remove the image as well
docker rmi department-portal
```

## Running the Automated Tests

```powershell
.\scripts\test.ps1
```

This builds the image, runs the container, checks the website loads correctly, stops and restarts the container, and checks the logs for errors — printing PASS/FAIL for each step. See `docs/TESTING.md` for the full results table and troubleshooting tips.

## Project Structure

```
Departmental-Portal/
├── index.html                  # Website markup
├── style.css                   # Website styling
├── Dockerfile                  # Docker build instructions
├── .dockerignore
├── .gitignore
├── README.md
├── docs/
│   ├── TESTING.md              # Test results + troubleshooting
│   ├── REPORT.md               # Full project report
│   ├── PRESENTATION_OUTLINE.md # 8-slide outline with speaker notes
│   ├── workflow-diagram.md     # Mermaid + ASCII workflow diagram
│   ├── CONTRIBUTIONS.md        # Per-member contributions
│   └── screenshots/            # Screenshots referenced below
└── scripts/
    ├── build-and-run.ps1       # Windows helper: build + run
    └── test.ps1                # Automated test sequence
```

## Screenshots

The following screenshots document the working deployment (see `docs/TESTING.md` for the full checklist):

- `docs/screenshots/01-website-running.png` — Portal running at localhost:8080
- `docs/screenshots/02-docker-build-success.png` — Successful `docker build`
- `docs/screenshots/03-docker-images.png` — `docker images` listing
- `docs/screenshots/04-docker-ps.png` — `docker ps` showing the running container
- `docs/screenshots/05-website-after-restart.png` — Portal working after stop/start

## Team Members

| Member | Name | Role |
|---|---|---|
| Member 1 | [Member 1 Name] | Website + Docker |
| Member 2 | [Member 2 Name] | GitHub + README |
| Member 3 | [Member 3 Name] | Testing + Screenshots |
| Member 4 | [Member 4 Name] | Report + PPT + Diagram |

See `docs/CONTRIBUTIONS.md` for detailed task breakdowns.
