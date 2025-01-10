-- Thêm 10 Trainer
CALL add_new_user('trainer1', 'pass123', 'Trainer', '0901111111', 'trainer1@example.com', 'Trainer One', 30, 'Yoga');
CALL add_new_user('trainer2', 'pass123', 'Trainer', '0901222222', 'trainer2@example.com', 'Trainer Two', 35, 'Pilates');
CALL add_new_user('trainer3', 'pass123', 'Trainer', '0901333333', 'trainer3@example.com', 'Trainer Three', 40, 'Boxing');
CALL add_new_user('trainer4', 'pass123', 'Trainer', '0901444444', 'trainer4@example.com', 'Trainer Four', 28, 'HIIT');
CALL add_new_user('trainer5', 'pass123', 'Trainer', '0901555555', 'trainer5@example.com', 'Trainer Five', 33, 'Strength Training');
CALL add_new_user('trainer6', 'pass123', 'Trainer', '0901666666', 'trainer6@example.com', 'Trainer Six', 25, 'Cardio');
CALL add_new_user('trainer7', 'pass123', 'Trainer', '0901777777', 'trainer7@example.com', 'Trainer Seven', 38, 'Swimming');
CALL add_new_user('trainer8', 'pass123', 'Trainer', '0901888888', 'trainer8@example.com', 'Trainer Eight', 32, 'Martial Arts');
CALL add_new_user('trainer9', 'pass123', 'Trainer', '0901999999', 'trainer9@example.com', 'Trainer Nine', 29, 'CrossFit');
CALL add_new_user('trainer10', 'pass123', 'Trainer', '0902000000', 'trainer10@example.com', 'Trainer Ten', 36, 'Cycling');

-- Thêm 10 Customer
CALL add_new_user('customer1', 'pass123', 'Customer', '0911111111', 'customer1@example.com', 'Customer One', 25, NULL);
CALL add_new_user('customer2', 'pass123', 'Customer', '0911222222', 'customer2@example.com', 'Customer Two', 30, NULL);
CALL add_new_user('customer3', 'pass123', 'Customer', '0911333333', 'customer3@example.com', 'Customer Three', 27, NULL);
CALL add_new_user('customer4', 'pass123', 'Customer', '0911444444', 'customer4@example.com', 'Customer Four', 35, NULL);
CALL add_new_user('customer5', 'pass123', 'Customer', '0911555555', 'customer5@example.com', 'Customer Five', 29, NULL);
CALL add_new_user('customer6', 'pass123', 'Customer', '0911666666', 'customer6@example.com', 'Customer Six', 32, NULL);
CALL add_new_user('customer7', 'pass123', 'Customer', '0911777777', 'customer7@example.com', 'Customer Seven', 33, NULL);
CALL add_new_user('customer8', 'pass123', 'Customer', '0911888888', 'customer8@example.com', 'Customer Eight', 26, NULL);
CALL add_new_user('customer9', 'pass123', 'Customer', '0911999999', 'customer9@example.com', 'Customer Nine', 31, NULL);
CALL add_new_user('customer10', 'pass123', 'Customer', '0912000000', 'customer10@example.com', 'Customer Ten', 28, NULL);


INSERT INTO GumFacility (Facility_name, address, capacity) VALUES
('Fitness Center 1', '123 Main St, City A', 100),
('Fitness Center 2', '456 Oak St, City B', 150),
('Fitness Center 3', '789 Pine St, City C', 80),
('Fitness Center 4', '101 Maple St, City D', 120);

INSERT INTO MembershipPlan (plan_name, price, duration) VALUES
('Basic Plan', 50.00, 30),
('Standard Plan', 100.00, 60),
('Premium Plan', 150.00, 90),
('VIP Plan', 200.00, 180);

INSERT INTO Workout (workout_name, category, difficulty) VALUES
('Push-ups', 'Strength Training', 'Medium'),
('Treadmill', 'Cardio', 'Easy'),
('Yoga', 'Flexibility', 'Easy'),
('HIIT', 'High-Intensity', 'Hard'),
('Swimming', 'Cardio', 'Medium'),
('Boxing', 'Strength Training', 'Hard'),
('Pilates', 'Flexibility', 'Medium'),
('CrossFit', 'High-Intensity', 'Hard');

INSERT INTO "Class" (class_name, class_type, max_participants, facility_id) VALUES
('Morning Yoga', 'Yoga', 20, 1),
('Advanced Pilates', 'Pilates', 15, 2),
('HIIT Training', 'High-Intensity', 25, 3),
('Swimming Basics', 'Cardio', 10, 4),
('Boxing Fundamentals', 'Strength Training', 20, 1),
('Cardio Blast', 'Cardio', 30, 2),
('CrossFit Strength', 'High-Intensity', 20, 3),
('Flexibility & Strength', 'Strength Training', 25, 4);

INSERT INTO Class_Workout (class_id, workout_id) VALUES
(1, 3),  -- Morning Yoga -> Yoga
(2, 7),  -- Advanced Pilates -> Pilates
(3, 4),  -- HIIT Training -> HIIT
(4, 5),  -- Swimming Basics -> Swimming
(5, 6),  -- Boxing Fundamentals -> Boxing
(6, 2),  -- Cardio Blast -> Treadmill
(7, 8),  -- CrossFit Strength -> CrossFit
(8, 6);  -- Flexibility & Strength -> Boxing


INSERT INTO Customer_Membership (plan_id, customer_id, start_date, end_date) VALUES
(1, 11, '2025-01-01', '2025-01-31'),
(2, 12, '2025-01-01', '2025-02-28'),
(3, 13, '2025-01-01', '2025-03-31'),
(4, 14, '2025-01-01', '2025-06-30'),
(2, 15, '2025-01-01', '2025-02-28'),
(1, 16, '2025-01-01', '2025-01-31'),
(3, 17, '2025-01-01', '2025-03-31'),
(4, 18, '2025-01-01', '2025-06-30');


INSERT INTO Schedule (trainer_id, start_time, end_time, date) VALUES
(1, '08:00', '09:00', '2025-01-10'),
(2, '09:00', '10:00', '2025-01-10'),
(3, '10:00', '11:00', '2025-01-10'),
(4, '11:00', '12:00', '2025-01-10'),
(5, '12:00', '13:00', '2025-01-10'),
(6, '13:00', '14:00', '2025-01-10'),
(7, '14:00', '15:00', '2025-01-10'),
(8, '15:00', '16:00', '2025-01-10');


INSERT INTO Class_Enrollment (customer_id, class_id, enrollment_date) VALUES
(11, 1, '2026-01-01'),
(12, 2, '2026-01-01'),
(13, 3, '2026-01-01'),
(14, 4, '2026-01-01'),
(15, 5, '2026-01-01'),
(16, 6, '2026-01-01'),
(17, 7, '2026-01-01'),
(18, 8, '2026-01-01');



INSERT INTO Customer_Schedule (customer_id, schedule_id, class_id, trainer_id) VALUES
(11, 1, 1, 1),
(12, 2, 2, 2),
(13, 3, 3, 3),
(14, 4, 4, 4),
(15, 5, 5, 5),
(16, 6, 6, 6),
(17, 7, 7, 7),
(18, 8, 8, 8);