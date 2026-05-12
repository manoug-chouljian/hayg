# Setting up Google OAuth with Supabase

To enable the "Continue with Google" functionality in your application, you need to configure both the **Google Cloud Console** and the **Supabase Dashboard**.

## Phase 1: Google Cloud Console Setup

1.  **Go to Google Cloud Console**: [console.cloud.google.com](https://console.cloud.google.com/)
2.  **Create a New Project** (or select an existing one).
3.  **Configure OAuth Consent Screen**:
    *   Navigate to **APIs & Services > OAuth consent screen**.
    *   Choose **External** user type.
    *   Fill in required app information (App name, support email, developer contact info).
    *   Add the `.../auth/userinfo.email` and `.../auth/userinfo.profile` scopes.
4.  **Create OAuth Credentials**:
    *   Go to **APIs & Services > Credentials**.
    *   Click **Create Credentials > OAuth client ID**.
    *   Select **Web application** as the application type.
    *   **Authorized JavaScript origins**: Add `https://knacmotvgkssgnjrpamh.supabase.co` (Your Supabase URL).
    *   **Authorized redirect URIs**: You will get this from the Supabase dashboard in the next phase.
5.  **Save Client ID and Client Secret**: You will need these for Supabase.

## Phase 2: Supabase Dashboard Setup

1.  **Go to Supabase Dashboard**: [supabase.com/dashboard](https://supabase.com/dashboard/)
2.  **Select your Project**: "knacmotvgkssgnjrpamh".
3.  **Navigate to Authentication**: Click on **Authentication** in the sidebar, then **Providers**.
4.  **Enable Google Provider**:
    *   Find **Google** in the list of providers and toggle it **On**.
    *   **Client ID**: Paste the Client ID from Google Cloud Console.
    *   **Client Secret**: Paste the Client Secret from Google Cloud Console.
5.  **Copy Callback URL**:
    *   Supabase will show a "Redirect URL" (usually something like `https://knacmotvgkssgnjrpamh.supabase.co/auth/v1/callback`).
    *   **IMPORTANT**: Go back to your Google Cloud Console (the OAuth client ID you created) and add this URL to the **Authorized redirect URIs** list.
6.  **Save Changes**: Click **Save** on the Supabase Google Provider settings.

## Phase 3: Verify Redirects

In your `app.js`, we have already configured the redirect to `window.location.origin`:

```javascript
const { error } = await sb.auth.signInWithOAuth({
    provider: 'google',
    options: {
        redirectTo: window.location.origin
    }
});
```

Ensure that your `window.location.origin` (e.g., `http://localhost:5500` or your production domain) is added to the **Redirect URLs** list in **Supabase > Authentication > URL Configuration**.

## How it works in code

1.  **Button**: We added a `.btn-google` to your forms.
2.  **Listener**: When clicked, it calls `sb.auth.signInWithOAuth({ provider: 'google' })`.
3.  **Redirect**: The browser redirects the user to Google's login page.
4.  **Callback**: After successful login, Google redirects back to Supabase, which then redirects back to your site with the user session.
5.  **Profile**: Since you have a trigger/logic to create profiles for new users, the Google login will automatically create a profile for the user if it's their first time.

> [!TIP]
> Google OAuth usually provides the user's name in `user.user_metadata.full_name`. Your existing logic in `updateUIForUser` already handles this!
