// Serves the static site and adds byte-range support for /media/*, which static assets lack.
// Safari only plays <video> when the server answers Range requests with 206 Partial Content.
export default {
  async fetch(request, env) {
    const response = await env.ASSETS.fetch(request);
    const range = request.headers.get("Range");
    if (!range || response.status !== 200) return withAcceptRanges(response);

    const body = await response.arrayBuffer();
    const bounds = parseRange(range, body.byteLength);
    if (!bounds) {
      return new Response(null, {
        status: 416,
        headers: { "Content-Range": `bytes */${body.byteLength}`, "Accept-Ranges": "bytes" },
      });
    }

    const [start, end] = bounds;
    const headers = new Headers(response.headers);
    headers.set("Accept-Ranges", "bytes");
    headers.set("Content-Range", `bytes ${start}-${end}/${body.byteLength}`);
    headers.set("Content-Length", String(end - start + 1));
    return new Response(body.slice(start, end + 1), { status: 206, headers });
  },
};

function withAcceptRanges(response) {
  const headers = new Headers(response.headers);
  headers.set("Accept-Ranges", "bytes");
  return new Response(response.body, { status: response.status, statusText: response.statusText, headers });
}

/** Parses a single `bytes=` range into inclusive [start, end], or null when it can't be satisfied. */
function parseRange(header, size) {
  const match = /^bytes=(\d*)-(\d*)$/.exec(header.trim());
  if (!match || (match[1] === "" && match[2] === "")) return null;

  if (match[1] === "") {
    const suffix = Number(match[2]);
    if (suffix === 0) return null;
    return [Math.max(0, size - suffix), size - 1];
  }

  const start = Number(match[1]);
  const end = match[2] === "" ? size - 1 : Math.min(Number(match[2]), size - 1);
  return start <= end ? [start, end] : null;
}
