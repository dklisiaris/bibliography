function escapeHtml(text) {
  return String(text)
    .replace(/&/g, "&amp;")
    .replace(/</g, "&lt;")
    .replace(/>/g, "&gt;")
    .replace(/"/g, "&quot;")
}

export function formatCommentBody(text) {
  return text.replace(/\r?\n{2,}/g, "<br/><br/>").replace(/\r?\n/g, "<br/>")
}

export function apiAuthHeaders(email, token) {
  return {
    Authorization: `Token token="${token}", email="${email}"`,
    "Content-Type": "application/json",
    Accept: "application/json",
  }
}

export function buildBookCommentHtml(options) {
  const size = options.size || 40

  return `
    <li class="book-comment" id="comment-${options.id}" data-book-id="${options.bookId}">
      <div class="book-comment__layout">
        <a href="/library/${options.userId}/" class="book-comment__avatar-link">
          <img src="${escapeHtml(options.avatar)}" alt="Avatar" width="${size}" height="${size}" class="book-comment__avatar">
        </a>
        <div class="book-comment__body">
          <div class="book-comment__header">
            <a href="/library/${options.userId}/" class="book-comment__author">${escapeHtml(options.userName)}</a>
            <button type="button" class="book-comment__delete delete-comment" data-action="book-comments#delete" aria-label="Delete">
              <i class="fa fa-trash-o"></i>
            </button>
          </div>
          <div class="book-comment__text"><p>${options.body}</p></div>
        </div>
      </div>
    </li>
  `
}
