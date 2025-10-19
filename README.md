# CI/CD demo

This repository is a minimal Python (Flask) app with a GitHub Actions workflow that builds a Docker image and publishes it to GitHub Container Registry (GHCR).

Files added:
- `app.py` - minimal Flask API
- `Dockerfile` - builds the app image
- `.github/workflows/ci-cd.yml` - GitHub Actions workflow triggered on pushes to `main`

Required setup before the workflow will work:

1. (Optional) Create a Docker Hub repository named `cicd-demo` under your Docker Hub account if you want to push to Docker Hub as well. The current workflow publishes to GHCR by default.
2. Add any repository secrets you need for other integrations (for GHCR the default GITHUB_TOKEN is usually sufficient when package write permissions are enabled).

Testing locally:

1. Build and run locally:
```
docker build -t cicd-demo:local .
docker run -p 8080:8080 cicd-demo:local
```
2. Hit the endpoint: `http://localhost:8080/`

How the workflow works:

- On push to `main`, GitHub Actions builds the Docker image and pushes it to GitHub Container Registry (GHCR) at `ghcr.io/<your-username>/cicd-demo:latest`.


Deploying to Railway
--------------------

You can deploy the app to Railway in two main ways. Both are supported by the updated GitHub Actions workflow included in this repo (it now publishes to GitHub Container Registry).

Option A — Recommended: Connect your GitHub repo to Railway

- In Railway (https://railway.app) create a new Project and add a Service by connecting your GitHub repository. Grant Railway access to this repo when prompted.
- Railway will detect the `Dockerfile` and build the image on each push to the connected branch (e.g., `main`). No additional CI deploy steps are required in your workflow.
- Add any runtime environment variables in the Railway dashboard (for example, DB connection strings).

Option B — Deploy from the published container image

- The workflow pushes an image to GitHub Container Registry (GHCR) at `ghcr.io/<your-username>/cicd-demo:latest`.
- In Railway create a Service and choose "Deploy from Docker Image" and supply the GHCR image URL. If the image is private, configure Railway to have access (you may need to create a personal access token with package read permissions and set it as an environment/secret for Railway).

Railway-related secrets and CI notes

- If you want to trigger Railway deploys directly from the workflow (automation), you can use the Railway CLI or API. That requires a `RAILWAY_API_KEY` (set as a GitHub secret) and optionally `RAILWAY_PROJECT_ID` / `RAILWAY_SERVICE_ID` depending on your deploy flow.
- The workflow included here pushes to GHCR by default. If you prefer Docker Hub, enable the `DOCKERHUB_USERNAME` and `DOCKERHUB_TOKEN` repository secrets in GitHub Settings (Actions > Secrets) and the workflow will optionally push there as well.


Notes and caveats:


- For production use, harden the deployment (use user accounts, non-root user, better rollback, health checks, and deployment strategies like blue/green or canary).


Update readme