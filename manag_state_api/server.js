const http = require('http');const { URL } = require('url');
const { PORT } = require('./src/config/config');
const { setCorsHeaders, sendJson } = require('./src/utils/http');
const { serveStaticUpload, handleUpload } = require('./src/utils/upload');
const handleAuthRoutes = require('./src/routes/auth');
const handleProfileRoutes = require('./src/routes/profile');
const handleFeedRoutes = require('./src/routes/feed');
const handleCommentRoutes = require('./src/routes/comments');
const handleSocialRoutes = require('./src/routes/social');

const server = http.createServer(async (req, res) => {
  // 1. CORS headers for Flutter Web & Mobile
  setCorsHeaders(res);
  if (req.method === 'OPTIONS') {
    res.writeHead(204);
    res.end();
    return;
  }

  // 2. Parse and normalize path
  const parsedUrl = new URL(req.url, `http://${req.headers.host || 'localhost'}`);
  let pathname = parsedUrl.pathname.replace(/\/+$/, '') || '/';
  const method = req.method.toUpperCase();

  try {
    // 3. Static uploads
    if (pathname.startsWith('/uploads/')) {
      return serveStaticUpload(pathname, res);
    }

    // 4. File upload (Multipart)
    if (['/upload', '/api/upload'].includes(pathname) && method === 'POST') {
      return handleUpload(req, res, PORT);
    }

    // 5. Health Check
    if (['/', '/api'].includes(pathname) && method === 'GET') {
      return sendJson(res, 200, {
        status: 'ok',
        message: 'ManageState Pure Node.js API (Modular Architecture)',
      });
    }

    // 6. Delegate to Domain Route Handlers
    if (await handleAuthRoutes(pathname, method, req, res)) return;
    if (await handleProfileRoutes(pathname, method, req, res)) return;
    if (await handleFeedRoutes(pathname, method, req, res)) return;
    if (await handleCommentRoutes(pathname, method, req, res)) return;
    if (await handleSocialRoutes(pathname, method, req, res)) return;

    // 7. 404 Fallback
    sendJson(res, 404, {
      error: 'Not Found',
      method,
      path: pathname,
    });
  } catch (err) {
    console.error('Server Error:', err);
    sendJson(res, 500, {
      error: 'Internal Server Error',
      message: err.message,
    });
  }
});

server.listen(PORT, '0.0.0.0', () => {
  console.log(`====================================================`);
  console.log(`🚀 Pure Node.js Server running (Modular Architecture)`);
  console.log(`📡 Local:            http://localhost:${PORT}`);
  console.log(`📱 Android Emulator: http://10.0.2.2:${PORT}`);
  console.log(`====================================================`);
});
