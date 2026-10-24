# Testing

## Test Results

> These results come from running `scripts/test.ps1` from the project root on 2026-10-24. The "Actual Result" and "Status" columns reflect the real output of that run.

| Test | Expected Result | Actual Result | Status |
|---|---|---|---|
| Build image | `docker build -t department-portal .` completes with no errors | `docker build` completed with exit code 0 | PASS |
| Start container | Container `portal` starts and appears in `docker ps` | `docker ps` listed `portal` as running | PASS |
| Open website | `http://localhost:8080` returns HTTP 200 and the page contains all 5 sections (Home, About the Department, Faculty Information, Courses Offered, Contact Information) | Response status 200; all 5 section strings found, none missing | PASS |
| Stop container | `docker stop portal` succeeds; a request to `http://localhost:8080` then fails | Request to `http://localhost:8080` failed as expected after stop | PASS |
| Restart container | `docker start portal` succeeds; a request to `http://localhost:8080` returns HTTP 200 again | Response status 200 after restart | PASS |
| View logs | `docker logs portal` contains no lines matching `[error]`, `[emerg]`, or `[crit]` | 0 matching lines found | PASS |

All 6 tests passed. The `portal` container was left running at the end, as required.

**Note on a script bug found and fixed during testing:** the original `test.ps1` used `$ErrorActionPreference = "Stop"` together with `docker build ... 2>&1`, which caused PowerShell 5.1 to treat Docker's normal build progress output (written to stderr) as a fatal error even though the build succeeded (exit code 0). Similarly, `docker logs portal 2>&1` wrapped each stderr line in a `NativeCommandError` object whose own type name contains the substring "Error", causing a false-positive match against the `error|emerg|crit` pattern. Both were fixed by switching to `$ErrorActionPreference = "Continue"`, checking `$LASTEXITCODE` directly for the build step, and merging streams through `cmd /c "docker logs portal 2>&1"` for the log-check step so PowerShell receives plain text instead of error-wrapped objects.

**To re-run these tests yourself:**
1. Start Docker Desktop and wait until it is fully running (`docker info` succeeds).
2. From the project root, run: `.\scripts\test.ps1`

## Troubleshooting Notes

- **Docker engine not running** — `docker` commands fail with a connection error (e.g. "cannot connect to the Docker daemon" or a named pipe error on Windows). Start Docker Desktop from the Start menu and wait for it to report "Engine running" before retrying.
- **Port 8080 already in use** — `docker run` fails with "port is already allocated" or similar. Find what's using the port (`netstat -ano | findstr :8080` on Windows) and stop it, or run the container on a different host port, e.g. `docker run -d -p 8081:80 --name portal department-portal`, and browse to `http://localhost:8081` instead.
- **Container name already in use** — `docker run` fails with "the container name '/portal' is already in use". Remove the old container first: `docker rm -f portal`, then run again.
- **Changes to HTML not showing** — Docker images are snapshots; editing `index.html`/`style.css` does not update a container that's already running. Rebuild the image (`docker build -t department-portal .`) and recreate the container (`docker rm -f portal` then `docker run ...` again).
- **`docker build` can't find files** — Make sure you are running the command from the `Departmental-Portal/` folder that contains the `Dockerfile`, `index.html`, and `style.css`. Running it from the wrong directory causes a "no such file or directory" or "Dockerfile not found" error.
- **WSL2 / virtualization issues on Windows** — If Docker Desktop reports WSL2 or virtualization errors, make sure virtualization is enabled in the BIOS/UEFI and that WSL2 is installed and updated (`wsl --update` in an elevated terminal), then restart Docker Desktop.

## Screenshot Checklist

Capture the following screenshots and save them into `docs/screenshots/` with these exact filenames (referenced from `README.md` and `REPORT.md`):

- `01-website-running.png` — Browser window showing the portal at `http://localhost:8080`.
- `02-docker-build-success.png` — Terminal output of a successful `docker build -t department-portal .`.
- `03-docker-images.png` — Output of `docker images` showing the `department-portal` image.
- `04-docker-ps.png` — Output of `docker ps` showing the `portal` container running.
- `05-website-after-restart.png` — Browser window showing the portal still working after `docker stop portal` followed by `docker start portal`.
