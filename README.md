# VoltixIO - Intelligent Automation. Real Results.

VoltixIO is a static marketing site for an automation and AI workflow consultancy.  
This repo is structured for:

- Static hosting via Docker + NGINX
- Simple local development with Node

## Production deployment (Hostinger)

The live site at https://voltixio.com is served from Hostinger shared hosting, not Docker.
`src/index.html` is the exact homepage file running in production. To deploy:

1. In hPanel File Manager, open `public_html` and rename the current `index.html` to a dated backup.
2. Upload the new `src/index.html` as `index.html`.
3. Purge LiteSpeed Cache, then check https://voltixio.com in an incognito window.

Apache serves `index.html` for `/` ahead of WordPress via `DirectoryIndex index.html index.php`.
Every other URL is still handled by WordPress. The Docker files below are for local use only.

Click tracking: any link or button with `data-ghl-event` and `data-ghl-label` fires GA4, GTM,
Facebook Pixel and a GHL webhook through one delegated listener in `index.html`.

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
