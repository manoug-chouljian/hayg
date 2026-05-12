-- ==============================================================================
-- ADVANCED STREAK MAINTENANCE
-- Run this in your Supabase SQL Editor to automatically clean up stale streaks
-- ==============================================================================

-- 1. Enable the pg_cron extension (Supabase usually has this enabled by default)
CREATE EXTENSION IF NOT EXISTS pg_cron;

-- 2. Create the function that resets stale streaks
-- This finds anyone whose last active date is older than yesterday and resets them.
CREATE OR REPLACE FUNCTION public.reset_stale_streaks()
RETURNS void
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
BEGIN
  UPDATE public.profiles
  SET streak_count = 0
  -- If the last active date is less than yesterday (meaning they missed a full day)
  WHERE last_active_date < (CURRENT_DATE - INTERVAL '1 day')::date
  AND streak_count > 0;
END;
$$;

-- 3. Schedule the cron job to run every day at midnight (00:00 UTC)
-- This will automatically run our function behind the scenes.
SELECT cron.schedule(
  'reset-stale-streaks-daily', 
  '0 0 * * *', 
  $$SELECT public.reset_stale_streaks();$$
);

-- Note: If you ever need to unschedule this job, you can run:
-- SELECT cron.unschedule('reset-stale-streaks-daily');
