const store = require('../data/store');
const { sendJson, parseJsonBody } = require('../utils/http');

const handleAuthRoutes = async (pathname, method, req, res) => {
  if (['/auth/login', '/api/auth/login'].includes(pathname) && method === 'POST') {
    const body = await parseJsonBody(req);
    const user = {
      id: store.currentUser.id,
      email: body.email || store.currentUser.email,
      name: store.currentUser.name,
    };
    sendJson(res, 200, {
      accessToken: `access_token_${Date.now()}`,
      refreshToken: `refresh_token_${Date.now()}`,
      user,
    });
    return true;
  }
  if (['/auth/refresh', '/api/auth/refresh'].includes(pathname) && method === 'POST') {
    sendJson(res, 200, {
      accessToken: `refreshed_access_token_${Date.now()}`,
      refreshToken: `refreshed_refresh_token_${Date.now()}`,
    });
    return true;
  }
  if (['/users/me', '/api/users/me'].includes(pathname) && method === 'GET') {
    sendJson(res, 200, store.currentUser);
    return true;
  }

  return false;
};

module.exports = handleAuthRoutes;
