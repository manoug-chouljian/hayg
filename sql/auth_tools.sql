-- FIND A USER'S ID BY EMAIL
SELECT id, email, email_confirmed_at 
FROM auth.users 
WHERE email = 'user@example.com';

-- MANUALLY CONFIRM EMAIL
-- Use this if a user is having trouble receiving the verification code.
UPDATE auth.users 
SET email_confirmed_at = NOW(), 
    last_sign_in_at = NOW() 
WHERE email = 'user@example.com';

-- CHANGE USER NAME (AUTH METADATA)
-- Note: You should also run the command in user_profiles.sql to update the leaderboard name.
UPDATE auth.users 
SET raw_user_meta_data = raw_user_meta_data || '{"full_name": "NEW_NAME"}'::jsonb
WHERE email = 'user@example.com';
