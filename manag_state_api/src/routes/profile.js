/**
 * Profile Routes (Pure Node.js)
 * Handles /profile, /users/me/profile, and /users/me/update
 */

const store = require('../data/store');
const { sendJson, parseJsonBody } = require('../utils/http');

const handleProfileRoutes = async (pathname, method, req, res) => {
  // Get Profile: GET /profile, /users/me/profile, or /api/profile
  if (['/profile', '/users/me/profile', '/api/profile'].includes(pathname) && method === 'GET') {
    sendJson(res, 200, store.userProfile);
    return true;
  }

  // Update Profile: PUT /profile, /users/me/update, or /api/profile
  if (['/profile', '/users/me/update', '/api/profile'].includes(pathname) && method === 'PUT') {
    const body = await parseJsonBody(req);
    store.userProfile = { ...store.userProfile, ...body };
    sendJson(res, 200, store.userProfile);
    return true;
  }

  return false;
};

module.exports = handleProfileRoutes;
