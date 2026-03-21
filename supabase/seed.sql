-- 1. Create a Test User in the Auth Schema
-- This allows you to "Log In" with email: pilot@test.com / password: password123
INSERT INTO auth.users (instance_id, id, aud, role, email, encrypted_password, email_confirmed_at, recovery_sent_at, last_sign_in_at, raw_app_meta_data, raw_user_meta_data, created_at, updated_at, 
confirmation_token, email_change, email_change_token_new, recovery_token)
VALUES (
    '00000000-0000-0000-0000-000000000000',
    'da05060b-5373-4561-9174-893c5d8084a4',
    'authenticated',
    'authenticated',
    'pilot@test.com',
    crypt('password123', gen_salt('bf')),
    now(),
    now(),
    now(),
    '{"provider":"email","providers":["email"]}',
    '{"full_name":"Test Pilot"}',
    now(),
    now(),
    '',
    '',
    '',
    ''
);

-- 2. Create the corresponding Public Profile
-- This matches the 'profiles' table we designed earlier
INSERT INTO public.profiles (id, full_name, email, is_pro, credits)
VALUES (
    'da05060b-5373-4561-9174-893c5d8084a4', 
    'Test Pilot', 
    'pilot@test.com', 
    true, 
    10
);

-- 3. Insert Sample Resumes for Testing the List View
INSERT INTO public.resumes (user_id, title, content)
VALUES 
(
    'da05060b-5373-4561-9174-893c5d8084a4', 
    'Software Engineer - Master', 
    '{"summary": "Full-stack developer with 5 years experience.", "skills": ["SwiftUI", "Node.js", "PostgreSQL"]}'
),
(
    'da05060b-5373-4561-9174-893c5d8084a4', 
    'Project Manager - Backup', 
    '{"summary": "Agile specialist focused on mobile app delivery.", "skills": ["Jira", "Scrum", "Budgeting"]}'
);

-- 4. Insert a Sample Application/Tailoring Result
INSERT INTO public.applications (user_id, job_title, company_name, ats_score)
VALUES (
    'da05060b-5373-4561-9174-893c5d8084a4',
    'Senior iOS Engineer',
    'Tech-Kenya Solutions',
    85
);
