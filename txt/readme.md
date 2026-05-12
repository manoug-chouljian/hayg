# Hayg Project SQL Administration Guide

Use these scripts in the **Supabase SQL Editor** to manage your game ecosystem.

## 📁 Files Overview

- **`auth_tools.sql`**: Use this for finding user IDs, manually verifying emails, and changing names in the login system.
- **`user_profiles.sql`**: Use this for individual player management: giving XP, adjusting streaks, and updating leaderboard names.
- **`maintenance.sql`**: Use this for bulk actions like clearing the leaderboard or starting a new season.
- **`seed_data.sql`**: Use this to generate 10 dummy Armenian users with random scores for testing the leaderboard.

## 🚀 Common Workflows

### How to change a user's name:
1. Run the command in `auth_tools.sql` to update their login metadata.
2. Run the command in `user_profiles.sql` to update their name on the leaderboard.

### How to fix a broken streak:
1. Get the user's ID using the lookup command in `auth_tools.sql`.
2. Run the streak update command in `user_profiles.sql`.

---
*Note: Always double-check the `WHERE` clause to avoid updating the wrong user!*
