-- GIVE XP TO A SPECIFIC USER
UPDATE public.profiles 
SET total_score = total_score + 500 
WHERE id = 'PASTE_USER_ID_HERE';

-- RESET XP FOR A SPECIFIC USER
UPDATE public.profiles 
SET total_score = 0 
WHERE id = 'PASTE_USER_ID_HERE';

-- MANUALLY SET/UPDATE STREAK
UPDATE public.profiles 
SET streak_count = 5,
    last_active_date = CURRENT_DATE - INTERVAL '1 day' -- Set to yesterday so they can extend it today
WHERE id = 'PASTE_USER_ID_HERE';

-- CHANGE USER NAME (LEADERBOARD PROFILE)
-- Note: You should also run the command in auth_tools.sql to update the login name.
UPDATE public.profiles 
SET full_name = 'NEW_NAME'
WHERE id = 'PASTE_USER_ID_HERE';

-- SIMULATE MISSING A DAY (BREAK STREAK)
-- This sets the activity to 2 days ago. The next time they play, the streak will reset to 1.
UPDATE public.profiles 
SET last_active_date = CURRENT_DATE - INTERVAL '2 days'
WHERE id = 'PASTE_USER_ID_HERE';

