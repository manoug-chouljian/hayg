-- GENERATE 10 DUMMY USERS FOR TESTING
-- This script creates 10 accounts with Armenian names, confirmed emails, and random scores.
-- Run this in the Supabase SQL Editor.

DO $$
DECLARE
    user_names TEXT[] := ARRAY['Արամ Երիցեան', 'Սօսէ Մայիլեան', 'Վարդան Սարգիսեան', 'Անի Յովհաննիսեան', 'Կարէն Պետրոսեան', 'Նարէ Գրիգորեան', 'Գրիգոր Մկրտչեան', 'Լուսինէ Աբրահամեան', 'Հայկ Պօղոսեան', 'Մարիամ Կարապետեան'];
    temp_id UUID;
    i INTEGER;
BEGIN
    FOR i IN 1..10 LOOP
        temp_id := gen_random_uuid();
        
        -- 1. Create User in auth.users
        INSERT INTO auth.users (id, instance_id, email, encrypted_password, email_confirmed_at, raw_user_meta_data, created_at, updated_at, role, aud, confirmation_token)
        VALUES (
            temp_id,
            '00000000-0000-0000-0000-000000000000',
            'dummy' || i || '@hayg.test',
            crypt('password123', gen_salt('bf')),
            NOW(),
            jsonb_build_object('full_name', user_names[i]),
            NOW(),
            NOW(),
            'authenticated',
            'authenticated',
            'dummy_token' || i
        );

        -- 2. Create Profile in public.profiles
        -- Note: If you have a trigger that auto-creates profiles, you might need to UPDATE instead of INSERT.
        -- But for manual seeding, we check if it exists first.
        INSERT INTO public.profiles (id, full_name, total_score, streak_count, wordle_score, typing_score, ztype_score, bee_score, faces_score, last_active_date)
        VALUES (
            temp_id,
            user_names[i],
            floor(random() * 5000 + 500),  -- Random XP between 500 and 5500
            floor(random() * 15 + 1),      -- Random streak between 1 and 15
            floor(random() * 300),
            floor(random() * 400),
            floor(random() * 200),
            floor(random() * 100),
            floor(random() * 300),
            CURRENT_DATE - (floor(random() * 3))::integer -- Active in last 3 days
        )
        ON CONFLICT (id) DO UPDATE 
        SET total_score = EXCLUDED.total_score,
            streak_count = EXCLUDED.streak_count;
            
    END LOOP;
END $$;
