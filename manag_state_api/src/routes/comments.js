const store = require('../data/store');
const { sendJson, parseJsonBody } = require('../utils/http');

const handleCommentRoutes = async (pathname, method, req, res) => {
  // 1. GET /comments or /api/comments (List all comments)
  if (['/comments', '/api/comments'].includes(pathname) && method === 'GET') {
    sendJson(res, 200, { comments: store.comments });
    return true;
  }

  // 2. POST /comments or /api/comments (Create a new comment)
  if (['/comments', '/api/comments'].includes(pathname) && method === 'POST') {
    const body = await parseJsonBody(req);
    const nextId = store.comments.length > 0
      ? Math.max(...store.comments.map((c) => Number(c.id) || 0)) + 1
      : 1;

    const newComment = {
      id: nextId,
      body: body.body || '',
      postId: Number(body.postId) || 1,
      likes: 0,
      timeAgo: 'Just now',
      user: {
        id: Number(store.currentUser.id),
        username: store.currentUser.name.toLowerCase().replace(/\s+/g, '_'),
        fullName: store.currentUser.name,
      },
    };
    store.comments.unshift(newComment);
    sendJson(res, 201, newComment);
    return true;
  }

  // Check for ID-based routes: /comments/:id or /api/comments/:id
  const idMatch = pathname.match(/^(?:\/api)?\/comments\/([^/]+)$/);
  if (idMatch) {
    const commentId = idMatch[1];
    const commentIndex = store.comments.findIndex(
      (c) => String(c.id) === String(commentId)
    );

    // 3. GET /comments/:id (Read a single comment)
    if (method === 'GET') {
      if (commentIndex === -1) {
        sendJson(res, 404, { error: 'Comment not found', id: commentId });
        return true;
      }
      sendJson(res, 200, store.comments[commentIndex]);
      return true;
    }

    // 4. PUT / PATCH /comments/:id (Update a comment)
    if (['PUT', 'PATCH'].includes(method)) {
      if (commentIndex === -1) {
        sendJson(res, 404, { error: 'Comment not found', id: commentId });
        return true;
      }
      const body = await parseJsonBody(req);
      store.comments[commentIndex] = {
        ...store.comments[commentIndex],
        ...(body.body !== undefined && { body: body.body }),
        ...(body.likes !== undefined && { likes: Number(body.likes) }),
        ...(body.timeAgo !== undefined && { timeAgo: body.timeAgo }),
        updatedAt: new Date().toISOString(),
      };
      sendJson(res, 200, store.comments[commentIndex]);
      return true;
    }

    // 5. DELETE /comments/:id (Delete a comment)
    if (method === 'DELETE') {
      if (commentIndex === -1) {
        sendJson(res, 404, { error: 'Comment not found', id: commentId });
        return true;
      }
      const deletedComment = store.comments.splice(commentIndex, 1)[0];
      sendJson(res, 200, {
        message: 'Comment deleted successfully',
        deletedId: commentId,
        comment: deletedComment,
      });
      return true;
    }
  }

  return false;
};

module.exports = handleCommentRoutes;
