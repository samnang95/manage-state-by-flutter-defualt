const fs = require('fs');
const path = require('path');
const { uploadsDir, MIME_TYPES } = require('../config/config');
const { sendJson } = require('./http');

const serveStaticUpload = (pathname, res) => {
  const filename = path.basename(pathname);
  const filePath = path.join(uploadsDir, filename);

  if (fs.existsSync(filePath)) {
    const ext = path.extname(filename).toLowerCase();
    const contentType = MIME_TYPES[ext] || 'application/octet-stream';
    res.writeHead(200, { 'Content-Type': contentType });
    return fs.createReadStream(filePath).pipe(res);
  } else {
    return sendJson(res, 404, { error: 'File not found' });
  }
};

const handleUpload = (req, res, port) => {
  const chunks = [];
  req.on('data', (chunk) => chunks.push(chunk));
  req.on('end', () => {
    const buffer = Buffer.concat(chunks);
    const contentType = req.headers['content-type'] || '';
    let fileData = buffer;
    let filename = `media_${Date.now()}.jpg`;

    // Parse multipart boundary if sent by Flutter ApiClient.uploadFile
    if (contentType.includes('multipart/form-data')) {
      const boundaryMatch = contentType.match(/boundary=(?:"([^"]+)"|([^;]+))/i);
      if (boundaryMatch) {
        const boundary = boundaryMatch[1] || boundaryMatch[2];
        const boundaryBuffer = Buffer.from(`--${boundary}`);
        const headerSeparator = Buffer.from('\r\n\r\n');

        const boundaryIndex = buffer.indexOf(boundaryBuffer);
        if (boundaryIndex !== -1) {
          const partStart = boundaryIndex + boundaryBuffer.length + 2;
          const headerEnd = buffer.indexOf(headerSeparator, partStart);
          if (headerEnd !== -1) {
            const headersPart = buffer.subarray(partStart, headerEnd).toString();
            const filenameMatch = headersPart.match(/filename="([^"]+)"/);
            if (filenameMatch) {
              const ext = path.extname(filenameMatch[1]) || '.jpg';
              filename = `media_${Date.now()}_${Math.round(Math.random() * 1e9)}${ext}`;
            }
            const contentStart = headerEnd + headerSeparator.length;
            const nextBoundary = buffer.indexOf(boundaryBuffer, contentStart);
            if (nextBoundary !== -1) {
              fileData = buffer.subarray(contentStart, nextBoundary - 2);
            }
          }
        }
      }
    }

    const filePath = path.join(uploadsDir, filename);
    fs.writeFileSync(filePath, fileData);

    const host = req.headers.host || `localhost:${port}`;
    const fileUrl = `http://${host}/uploads/${filename}`;

    sendJson(res, 200, {
      url: fileUrl,
      filename,
      size: fileData.length,
    });
  });
};

module.exports = {
  serveStaticUpload,
  handleUpload,
};
