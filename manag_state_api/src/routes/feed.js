/**
 * Feed & Stories Routes (Pure Node.js)
 * Handles /home/stories, /home/feed, /home/posts
 */

const store = require('../data/store');
const { sendJson, parseJsonBody } = require('../utils/http');

const handleFeedRoutes = async (pathname, method, req, res) => {
  // Stories: GET /home/stories or /api/home/stories
  if (['/home/stories', '/api/home/stories'].includes(pathname) && method === 'GET') {
    sendJson(res, 200, store.stories);
    return true;
  }

  // Posts Feed: GET /home/feed, /home/posts, /posts
  if (['/home/feed', '/home/posts', '/posts', '/api/home/feed', '/api/home/posts'].includes(pathname) && method === 'GET') {
    sendJson(res, 200, store.posts);
    return true;
  }

  // Create Post: POST /home/posts or /api/home/posts
  if (['/home/posts', '/posts', '/api/home/posts'].includes(pathname) && method === 'POST') {
    const body = await parseJsonBody(req);
    const newPost = {
      id: String(store.posts.length + 1),
      authorName: store.currentUser.name,
      authorAvatar: store.userProfile.avatarUrl,
      timeAgo: 'Just now',
      content: body.content || '',
      imageUrl: body.imageUrl || '',
      likes: 0,
      comments: 0,
      shares: 0,
      isLiked: false,
    };
    store.posts.unshift(newPost);
    sendJson(res, 201, newPost);
    return true;
  }

  return false;
};

module.exports = handleFeedRoutes;
