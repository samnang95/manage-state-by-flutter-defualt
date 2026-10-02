const path = require('path');
const fs = require('fs');

const PORT = process.env.PORT || 3001;
const uploadsDir = path.join(__dirname, '../../uploads');

if (!fs.existsSync(uploadsDir)) {
  fs.mkdirSync(uploadsDir, { recursive: true });
}

const MIME_TYPES = {
  '.jpg': 'image/jpeg',
  '.jpeg': 'image/jpeg',
  '.png': 'image/png',
  '.gif': 'image/gif',
  '.mp4': 'video/mp4',
  '.webp': 'image/webp',
};

module.exports = {
  PORT,
  uploadsDir,
  MIME_TYPES,
};
