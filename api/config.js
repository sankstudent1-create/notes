// api/config.js
// Vercel Edge Function — injects Supabase keys safely at runtime
// This file stays on the server, keys never go into your repo

export default function handler(req, res) {
  res.setHeader('Content-Type', 'application/javascript; charset=utf-8');
  res.setHeader('Cache-Control', 'no-store'); // never cache — keys may rotate
  res.send(
    'window.__SB_URL__="' + (process.env.SUPABASE_URL  || '') + '";' +
    'window.__SB_KEY__="' + (process.env.SUPABASE_ANON_KEY || '') + '";'
  );
}
