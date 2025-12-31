# VoltixIO - Intelligent Automation. Real Results.

VoltixIO is a static marketing site for an automation and AI workflow consultancy.  
This repo is structured for:

- Static hosting via Docker + NGINX
- Simple local development with Node

## Project structure

- `Dockerfile` – NGINX-based static hosting
- `package.json` – local dev scripts
- `.env.example` – sample environment variables
- `src/` – all HTML, CSS, JS, and assets

## Local development

```bash
npm install
npm start
```

This serves the `src/` directory at a local port (default 3000 or 5000 depending on `serve`).

## Docker build and run

```bash
docker build -t voltixio .
docker run -d -p 8080:80 --name voltixio voltixio
```

Then visit: `http://localhost:8080`

## Deploying to a Docker host (MCP server)

1. Clone this repo onto your server:

   ```bash
   git clone https://github.com/Deji147x/voltixio.com.git
   cd voltixio.com
   ```

2. Build the image:

   ```bash
   docker build -t voltixio .
   ```

3. Run the container:

   ```bash
   docker run -d -p 80:80 --name voltixio voltixio
   ```

   Or map to another port if behind a reverse proxy.

## Environment variables

Use `.env.example` as a reference to create a `.env` file if you later implement server-side components or build-time injection of configuration (e.g., n8n webhook URL).

## License

Proprietary – VoltixIO.
