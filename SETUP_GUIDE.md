# Getting your shared budget app live — honest walkthrough

## First, the honest part

The file that was already in your folder ("Shared Budget.dc.html") was a **clickable mockup** — it showed what the app could look like, but had no real database behind it. Nothing you tapped in it was actually being saved anywhere, and there was no way for a second phone to see it.

What's in this `budget-app` folder now is a **real, working app**: plain HTML/JavaScript on the front end, talking to a free hosted database ([Supabase](https://supabase.com)) on the back end. Once you finish the steps below, it will:

- save every expense to a real database
- show new expenses on both phones within a second or two (no refresh needed)
- work as an "app" on your iPhone home screens (via Safari's "Add to Home Screen")
- cost $0/month, indefinitely, at the scale of two people tracking a household budget

The tradeoff: getting it live requires about 20–30 minutes of one-time setup on two free websites (Supabase and GitHub). There's no way around this — a real shared app needs *somewhere* to live, and Claude can't sign up for accounts on your behalf (that requires your email/password). You only have to do this once.

---

## Step 1 — Create a free Supabase project

1. Go to [supabase.com](https://supabase.com) → **Start your project** → sign up (GitHub or email, no credit card required).
2. Click **New project**. Name it anything ("household-budget"), pick any region close to you, set a database password (save it somewhere — you likely won't need it again, but just in case).
3. Wait ~2 minutes for it to provision.

## Step 2 — Create the database tables

1. In your new project, open the **SQL Editor** (left sidebar) → **New query**.
2. Open `supabase_setup.sql` (in this folder) → copy all of it → paste into the SQL editor → click **Run**.
3. This creates two tables (`expenses`, `categories`), locks them so only signed-in users can touch them, seeds some starter categories/budgets based on your spreadsheet, and turns on realtime sync.

## Step 3 — Create your two logins (no public sign-up)

You and your wife need accounts, but the app has no public "sign up" screen — you create both accounts yourself so no stranger can ever register one.

1. In Supabase: **Authentication** → **Providers** → make sure **Email** is enabled.
2. **Authentication** → **Users** → **Add user** → **Create new user**. Enter your email + a password. Repeat for your wife's email + a password (she'll use this to log in — no Claude access needed, it's just an email/password screen).
3. Still in **Authentication** → **Settings** (or **Sign In / Providers** depending on the current Supabase UI) → turn **OFF** "Allow new users to sign up." This ensures only the two accounts you just made can ever log in.

## Step 4 — Connect the app to your database

1. In Supabase: **Project Settings** → **API Keys**.
2. Copy the **Project URL**, and the key that starts with `sb_publishable_...` (Supabase renamed the old "anon key" to "publishable key" — same purpose, safe to use in client-side code). Do **not** use the `sb_secret_...` key — that one must never appear in the app.
3. Open `config.js` in this folder and paste them in:
   ```js
   window.SUPABASE_URL = "https://xxxxxxxx.supabase.co";
   window.SUPABASE_ANON_KEY = "sb_publishable_...";
   ```
4. Save the file.

(The publishable key is *meant* to be public — it's not a secret. The real protection is the row-level security you set up in Step 2, which only lets signed-in users through.)

## Step 5 — Put it online for free (GitHub Pages)

1. Go to [github.com](https://github.com) → sign up (free).
2. Click **New repository**. Name it e.g. `our-budget`. Keep it **Public**. Create it.
3. On the new repo page, click **uploading an existing file** (or **Add file → Upload files**).
4. Drag in all the files from this `budget-app` folder (`index.html`, `config.js`, `manifest.json`, `sw.js`, `icon.png`) → **Commit changes**.
5. Go to the repo's **Settings** → **Pages** → under "Build and deployment," set **Source: Deploy from a branch**, branch **main**, folder **/(root)** → **Save**.
6. Wait ~1 minute, then refresh — GitHub will show your live URL, something like:
   `https://yourusername.github.io/our-budget/`

That URL is your app, live on the internet, for free, forever (public GitHub repos and GitHub Pages have no cost).

## Step 6 — Add it to both iPhones

1. Open the GitHub Pages URL in **Safari** on your iPhone (must be Safari, not Chrome, for this to work).
2. Sign in with your email/password from Step 3.
3. Tap the **Share** icon → **Add to Home Screen**.
4. Send your wife the same URL (text it to her) — she does the same on her phone, signing in with the account you made for her.

Now you both have a home-screen icon that opens straight to the budget, and expenses either of you add show up on the other's phone automatically.

---

## Being fully honest about the free tier

- **Supabase free tier**: 500MB database and generous request limits — far more than a household budget will ever use. The one catch: a free project pauses itself after **7 days with no activity**. If you both use the app regularly this never triggers; if you go on vacation for two weeks, you may need to log into supabase.com and click "Restore/Unpause project" (one click, no data lost).
- **GitHub Pages**: free with no practical limits for a small app like this, and no inactivity pause.
- Nothing here requires a credit card, and nothing will start charging you — if either service ever asks for payment info to do something, that's a sign you've gone in a different direction than this guide, not a requirement.

## Making changes later

If you want a feature added or changed (new categories by default, different colors, a new screen), just tell me — I'll edit the code and hand you the updated files. You'd then re-upload the changed file(s) to your GitHub repo (same "Upload files" button, it overwrites) and the live site updates within a minute automatically.
