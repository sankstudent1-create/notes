# 📓 SW Notes — Complete Setup Guide
**by SWInfoSystems** · Vercel + Supabase + PWA

---

## 🗂️ Project Structure

```
sw-notes-app/
├── index.html          ← Main app (entire frontend)
├── public/
│   ├── sw.js           ← Service Worker (offline PWA)
│   └── manifest.json   ← PWA manifest
├── vercel.json         ← Vercel routing config
├── supabase-schema.sql ← Run this in Supabase SQL editor
├── .env.example        ← Copy to .env with your keys
└── README.md           ← This file
```

---

## 🚀 Deploy on Vercel (Step by Step)

### Step 1 — Push to GitHub
```bash
# In your terminal
git init
git add .
git commit -m "SW Notes v1"
git remote add origin https://github.com/YOUR_USERNAME/sw-notes.git
git push -u origin main
```

### Step 2 — Connect to Vercel
1. Go to **https://vercel.com** → Sign in with GitHub
2. Click **"New Project"** → Import your `sw-notes` repo
3. Framework Preset: **Other** (it's plain HTML, no build step)
4. Root Directory: leave as `/` (default)
5. Click **Deploy** — done in ~30 seconds ✅

### Step 3 — Add Environment Variables on Vercel
1. Go to your project on Vercel → **Settings** → **Environment Variables**
2. Add these two:
   - `SUPABASE_URL` = `https://your-project.supabase.co`
   - `SUPABASE_ANON_KEY` = `your-anon-public-key`
3. Redeploy (Vercel Dashboard → Deployments → Redeploy)

> **Note:** Since this is a plain HTML file, environment variables from Vercel are not automatically injected. See the "Injecting Supabase Keys" section below.

---

## 🔑 Injecting Supabase Keys (Two Options)

### Option A — Hardcode directly in index.html (simplest, fine for public anon key)
Open `index.html`, find these lines near the top of the `<script>` section:
```javascript
var SB_URL = window.__SB_URL__ || '';
var SB_KEY = window.__SB_KEY__ || '';
```
Replace with:
```javascript
var SB_URL = 'https://your-project-ref.supabase.co';
var SB_KEY = 'your-anon-public-key-here';
```
> ✅ The Supabase **anon key** is safe to put in frontend code — it's public by design.
> Row Level Security (RLS) protects your data, not key secrecy.

### Option B — Use a Vercel Edge Function to inject keys at build time
Create `api/config.js`:
```javascript
export default function handler(req, res) {
  res.setHeader('Content-Type', 'application/javascript');
  res.send(`
    window.__SB_URL__ = "${process.env.SUPABASE_URL}";
    window.__SB_KEY__ = "${process.env.SUPABASE_ANON_KEY}";
  `);
}
```
Then add in `index.html` `<head>`:
```html
<script src="/api/config"></script>
```
Add `api/config.js` to your project and redeploy.

---

## 🗄️ Supabase Setup (Step by Step)

### Step 1 — Create Supabase project
1. Go to **https://supabase.com** → Sign up free
2. Click **New Project** → Choose a name (e.g. `sw-notes`)
3. Set a strong database password → Choose region closest to India (e.g. `ap-south-1 Mumbai`)
4. Wait ~2 minutes for project to be ready

### Step 2 — Run the schema
1. In your Supabase project → Go to **SQL Editor**
2. Click **"New Query"**
3. Paste the entire contents of `supabase-schema.sql`
4. Click **Run** (or press Ctrl+Enter)
5. You should see "Success. No rows returned"

### Step 3 — Get your API keys
1. In Supabase → **Settings** (gear icon) → **API**
2. Copy:
   - **Project URL** → paste as `SUPABASE_URL`
   - **anon public** key → paste as `SUPABASE_KEY`

### Step 4 — Configure Auth
1. Supabase → **Authentication** → **Settings**
2. Under **Email**, make sure "Enable email signups" is ON
3. Optional: turn OFF "Confirm email" for easier testing
   (Auth → Settings → scroll to "Email Confirmations" → disable)
4. Optional: add your Vercel domain to **URL Configuration**:
   - Site URL: `https://your-app.vercel.app`
   - Redirect URLs: `https://your-app.vercel.app`

---

## 📱 Why This Works on Every Device (Including Jio Phones)

### Technology choices for maximum compatibility:

| Choice | Why |
|--------|-----|
| **Vanilla JS (ES5 style)** | Runs on Android 4+, iOS 9+, any browser made after 2013 |
| **No React / Vue / Angular** | No 300KB+ JS bundle, loads in <1s on 2G |
| **No build step** | Zero webpack/vite — just one HTML file |
| **CSS variables with fallbacks** | Works on Chrome 49+, Firefox 31+, Safari 9.1+ |
| **Service Worker** | Caches app after first load — works offline completely |
| **IndexedDB / localStorage** | Offline data storage, no network needed |
| **Supabase JS v2 UMD build** | Works via CDN, no bundler required |
| **`var` instead of `const/let`** | Safe on very old Android WebView |
| **No arrow functions in critical paths** | Works on Android 4 stock browser |
| **`font-display:swap` via Google Fonts** | Text shows even if fonts don't load |
| **PWA manifest** | "Add to Home Screen" on Android Chrome, iOS Safari |

### Performance on 2G/3G:
- First load: ~95KB HTML + ~40KB fonts (cached after first visit)
- After cache: **loads in <100ms even with no internet**
- localStorage saves every 700ms automatically
- Supabase sync happens in background, never blocks UI

---

## ✨ Features List

### Writing
- [x] Ruled paper UI (blue lines + red margin, like Classmate notebook)
- [x] 4 font choices: Nunito, Lora, Kalam (handwritten), Patrick Hand
- [x] Heading styles: H1, H2, H3, Paragraph, Blockquote, Code block
- [x] Bold, Italic, Underline, Strikethrough
- [x] Text alignment: Left, Centre, Right, Justify
- [x] Increase / Decrease indent
- [x] Tables (3-column starter)

### Lists
- [x] 11 bullet styles: Disc, Circle, Square, Arrow →, Thick Arrow ➤, Dash –, Star ★, Check ✓, Diamond ◆, Fill dot ●, Leaf 🌿
- [x] 4 numbered styles: 1.2.3., A.B.C., i.ii.iii., I.II.III.
- [x] Interactive checkboxes (click to complete)

### Highlighting
- [x] 6 highlighter colours: Yellow, Green, Pink, Blue, Orange, Purple
- [x] Floating highlight bar appears on text selection
- [x] Right-click context menu with highlight options
- [x] Remove highlight from selected text
- [x] 4 pen colours: Red, Blue, Green, Purple
- [x] Remove pen color

### Organisation
- [x] Multiple notebooks with colour coding
- [x] Tags per note with colour labels
- [x] Star / favourite notes
- [x] Search across all notes
- [x] Filter: All / Today / This Week / Starred
- [x] Sort: Last edited / Date created / A→Z
- [x] Tag sidebar with click-to-filter
- [x] Note count per notebook

### Special inserts
- [x] 5 callout boxes: Note 📘, Important 🔴, Tip 💚, Warning ⚠️, Idea 💜
- [x] 4 divider styles: Thin, Thick, Double, Fancy ✦
- [x] Draggable sticky notes (6 colours, drag anywhere, works on touch)
- [x] Insert table

### UI / UX
- [x] Sidebar toggle (☰) — hide/show sidebar
- [x] List pane toggle (📋) — hide/show notes list
- [x] **Zen / Distraction-free mode** — hides everything, full-screen writing
- [x] Night mode — warm dark brown (not blue-black)
- [x] Sepia mode — aged paper look
- [x] Reading mode — switches to Lora serif font
- [x] Mobile bottom navigation bar
- [x] Responsive layout (works 320px to 4K)
- [x] Keyboard shortcuts (Ctrl+N, Ctrl+S, Ctrl+F, Ctrl+\, Esc)

### Export
- [x] Export as PDF (browser print dialog, print to PDF)
- [x] Export as HTML (self-contained, styled file)
- [x] Export as Markdown (.md file)
- [x] Export as plain text (.txt file)

### Productivity
- [x] 🍅 Pomodoro focus timer (25 min, pause/resume/reset)
- [x] Auto-save every 700ms
- [x] Ctrl+S manual save
- [x] Stats panel (words, notes, notebooks, tags, streak)

### Accounts (with Supabase)
- [x] Email + password sign up
- [x] Email + password sign in
- [x] Sign out
- [x] Guest mode (no account needed)
- [x] Notes sync to cloud when logged in
- [x] Row Level Security — users only see their own data

### PWA
- [x] Installable on Android, iOS, Windows, macOS
- [x] Works fully offline after first load
- [x] Service Worker caches all assets
- [x] App icon + splash screen

---

## ⌨️ Keyboard Shortcuts

| Shortcut | Action |
|----------|--------|
| `Ctrl + N` | New note |
| `Ctrl + S` | Save note |
| `Ctrl + F` | Focus search bar |
| `Ctrl + \` | Toggle sidebar |
| `Esc` | Close modals / Exit zen mode |
| `Enter` in title | Jump to editor |
| `Enter` in checkbox | New checkbox item |

---

## 🔧 Customisation

### Change Supabase keys
Edit `index.html` — find `var SB_URL` and `var SB_KEY` near the top of the script.

### Change default notebooks
Find `function seedDefaults()` in `index.html` — edit the array.

### Change Pomodoro timer duration
Find `var fSec = 25 * 60` — change 25 to your preferred minutes.

### Change paper colour
In `:root` CSS, change `--bg: #FDF8EF` to any warm hex colour.

### Add your own domain on Vercel
Vercel Dashboard → Your Project → Settings → Domains → Add domain.

---

## 🐛 Troubleshooting

**"Notes not syncing to Supabase"**
→ Check that your `SB_URL` and `SB_KEY` are correctly set.
→ Check browser console for errors.
→ Make sure you ran the schema SQL and RLS policies are applied.

**"App not installing as PWA"**
→ Must be served over HTTPS (Vercel does this automatically).
→ Chrome: look for install icon in address bar.
→ iOS Safari: Share → Add to Home Screen.

**"Fonts not loading on slow connection"**
→ The app works without fonts (system fonts are the fallback).
→ After first load, fonts are cached by the service worker.

**"Auth email not received"**
→ Check spam folder.
→ In Supabase → Auth → Settings, disable email confirmation for testing.

**"App slow on old Android"**
→ Works on Android 4.4+ (Chrome 30+).
→ If very slow, try disabling night mode (reduces CSS variables repaints).

---

## 📞 Support
**SWInfoSystems** · swinfosystems.online
#   n o t e s  
 