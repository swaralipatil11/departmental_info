# Presentation Outline (8 Slides)

## Slide 1 — Project Title
- Departmental Information Portal (Dockerized)
- [Department Name], [College Name]
- Activity 8 — Group project
- Team: [Member 1], [Member 2], [Member 3], [Member 4]
- Date: [Presentation Date]

**Speaker notes:** Introduce the project title and team, and briefly state that this is a static departmental website packaged and run using Docker.

## Slide 2 — Problem Statement and Objectives
- Departmental information needs to be accessible consistently across systems
- Goal: build a simple departmental portal and run it reproducibly with Docker
- Objectives: develop the portal, write a Dockerfile, build/tag an image, run it in a container, verify and document access

**Speaker notes:** Explain that inconsistent environments (missing web server, OS differences) make manual setup unreliable, and that Docker solves this by packaging the app with everything it needs.

## Slide 3 — Technologies Used
- HTML5 and CSS3 for the website
- Docker for containerization
- Nginx (`nginx:alpine`) as the web server inside the container
- Git and GitHub for version control and collaboration

**Speaker notes:** Mention that no backend, database, or JavaScript framework was needed since the portal is purely informational.

## Slide 4 — Architecture / Workflow
- HTML + CSS Website → Dockerfile → Docker Image → Docker Container (Nginx) → Website at localhost:8080
- (Show the workflow diagram from `docs/workflow-diagram.md`)

**Speaker notes:** Walk through each arrow in the diagram, explaining what happens at each stage from source files to a browser-accessible site.

## Slide 5 — Website Implementation
- Single-page site with sticky navigation
- Sections: Home, About the Department, Faculty Information, Courses Offered, Contact Information
- Responsive layout using CSS variables and a mobile-friendly design

**Speaker notes:** Briefly demo or screenshot each section, noting that it is fully static and works offline.

## Slide 6 — Docker Implementation
- `Dockerfile` based on `nginx:alpine`
- Copies `index.html` and `style.css` into Nginx's web root
- Built as image `department-portal`, run as container `portal` on port 8080

**Speaker notes:** Show the Dockerfile contents and explain `docker build` vs `docker run`, and the port mapping `-p 8080:80`.

## Slide 7 — Testing and Output
- Build, run, access, stop, restart, and log checks all verified
- Automated via `scripts/test.ps1`
- Screenshots: build success, `docker images`, `docker ps`, website before/after restart

**Speaker notes:** Summarize the testing table from `docs/TESTING.md` and show 1–2 key screenshots.

## Slide 8 — Conclusion and Team Contributions
- Successfully containerized and ran a departmental portal using Docker and Nginx
- Confirms reproducibility across machines
- Future scope: docker-compose, CI/CD, dynamic content
- Contributions: Member 1 (website + Docker), Member 2 (GitHub + README), Member 3 (testing), Member 4 (report/PPT/diagram)

**Speaker notes:** Close by reinforcing that the exercise demonstrates core Docker skills (image building, containers, port mapping) applied to a real, practical use case.
