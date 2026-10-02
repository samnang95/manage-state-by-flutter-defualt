/**
 * Social & Content Routes (Pure Node.js)
 * Handles /reels, /friends/requests, /marketplace/items, /notifications
 */

const store = require('../data/store');
const { sendJson } = require('../utils/http');

const handleSocialRoutes = async (pathname, method, req, res) => {
  // Reels: GET /reels or /api/reels
  if (['/reels', '/api/reels'].includes(pathname) && method === 'GET') {
    sendJson(res, 200, store.reels);
    return true;
  }

  // Friends: GET /friends/requests or /api/friends/requests
  if (['/friends/requests', '/api/friends/requests'].includes(pathname) && method === 'GET') {
    sendJson(res, 200, store.friendRequests);
    return true;
  }

  // Marketplace: GET /marketplace/items or /api/marketplace/items
  if (['/marketplace/items', '/api/marketplace/items'].includes(pathname) && method === 'GET') {
    sendJson(res, 200, store.marketplaceItems);
    return true;
  }

  // Notifications: GET /notifications/new or /api/notifications/new
  if (['/notifications/new', '/api/notifications/new'].includes(pathname) && method === 'GET') {
    sendJson(res, 200, store.notifications.filter((n) => !n.isRead));
    return true;
  }

  // Notifications: GET /notifications/today or /api/notifications/today
  if (['/notifications/today', '/api/notifications/today'].includes(pathname) && method === 'GET') {
    sendJson(res, 200, store.notifications.filter((n) => n.isRead));
    return true;
  }

  // Notifications: GET /notifications or /api/notifications
  if (['/notifications', '/api/notifications'].includes(pathname) && method === 'GET') {
    sendJson(res, 200, store.notifications);
    return true;
  }

  return false;
};

module.exports = handleSocialRoutes;
