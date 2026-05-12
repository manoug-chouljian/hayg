-- RESET ALL USER XP (CLEARS LEADERBOARD)
UPDATE public.profiles 
SET total_score = 0;

-- RESET EVERYTHING FOR ALL USERS (FRESH SEASON)
-- This clears XP, Streaks, High Scores, and Dates.
UPDATE public.profiles 
SET total_score = 0,
    streak_count = 0,
    wordle_score = 0,
    typing_score = 0,
    ztype_score = 0,
    bee_score = 0,
    faces_score = 0,
    last_active_date = NULL;
