INSERT INTO Customer (FullName, Phone, Email, Age, RegistrationDate)
VALUES 
    ('Nguyen Van A', '0912345678', 'a.nguyen@example.com', 25, '2024-01-01'),
    ('Le Thi B', '0987654321', 'b.le@example.com', 30, '2024-01-05'),
    ('Tran Van C', '0934567890', 'c.tran@example.com', 35, '2024-01-10'),
    ('Pham Thi D', '0976543210', 'd.pham@example.com', 40, '2024-01-15'),
    ('Hoang Van E', '0901234567', 'e.hoang@example.com', 28, '2024-01-20');

INSERT INTO Trainer (FullName, Phone, Specialty, Age)
VALUES 
    ('Nguyen Huong', '0911111111', 'Yoga', 32),
    ('Tran Quang', '0922222222', 'Cardio', 29),
    ('Pham Long', '0933333333', 'Weightlifting', 40),
    ('Le Minh', '0944444444', 'CrossFit', 35),
    ('Do An', '0955555555', 'HIIT', 27);

INSERT INTO MembershipPlan (PlanName, Price, Duration)
VALUES 
    ('Basic Plan', 500000, 30),
    ('Standard Plan', 700000, 60),
    ('Premium Plan', 1000000, 90),
    ('Annual Plan', 10000000, 365);

INSERT INTO GymFacility (FacilityName, Address, Capacity)
VALUES 
    ('Room A', '123 Street A', 20),
    ('Room B', '456 Street B', 25),
    ('Room C', '789 Street C', 30);

INSERT INTO Equipment (EquipmentName, Type, Status)
VALUES 
    ('Treadmill', 'Cardio', 'Available'),
    ('Dumbbells', 'Weightlifting', 'Available'),
    ('Yoga Mats', 'Yoga', 'Available'),
    ('Stationary Bike', 'Cardio', 'Maintenance'),
    ('Kettlebell', 'CrossFit', 'Available');

INSERT INTO Workout (WorkoutName, Category, Difficulty)
VALUES 
    ('Push-up', 'Strength', 'Easy'),
    ('Squat', 'Strength', 'Medium'),
    ('Plank', 'Core', 'Medium'),
    ('Burpee', 'Cardio', 'Hard'),
    ('Deadlift', 'Strength', 'Hard');

INSERT INTO Schedule (StartTime, EndTime, Date, TrainerID)
VALUES 
    ('08:00:00', '09:00:00', '2024-01-25', 1),
    ('10:00:00', '11:00:00', '2024-01-25', 2),
    ('14:00:00', '15:00:00', '2024-01-26', 3),
    ('16:00:00', '17:00:00', '2024-01-27', 4),
    ('18:00:00', '19:00:00', '2024-01-28', 5);

INSERT INTO Class (ClassName, ClassType, MaxParticipants, FacilityID)
VALUES 
    ('Yoga Basics', 'Yoga', 15, 1),
    ('Cardio Blast', 'Cardio', 20, 2),
    ('Strength Training', 'Weightlifting', 10, 3),
    ('HIIT Challenge', 'HIIT', 12, 2),
    ('CrossFit Advanced', 'CrossFit', 8, 1);

INSERT INTO ClassEnrollment (CustomerID, ClassID, EnrollmentDate)
VALUES 
    (1, 1, '2024-01-21'),
    (2, 2, '2024-01-22'),
    (3, 3, '2024-01-23'),
    (4, 4, '2024-01-24'),
    (5, 5, '2024-01-25');

INSERT INTO CustomerSchedule (CustomerID, ScheduleID, TrainerID)
VALUES 
    (1, 1, 1),
    (2, 2, 2),
    (3, 3, 3),
    (4, 4, 4),
    (5, 5, 5);

INSERT INTO ClassWorkout (ClassID, WorkoutID)
VALUES 
    (1, 1),
    (2, 2),
    (3, 3),
    (4, 4),
    (5, 5);

INSERT INTO CustomerMembership (CustomerID, PlanID, StartDate, EndDate)
VALUES 
    (1, 1, '2024-01-01', '2024-01-31'),
    (2, 2, '2024-01-05', '2024-03-05'),
    (3, 3, '2024-01-10', '2024-04-10'),
    (4, 4, '2024-01-15', '2025-01-14'),
    (5, 2, '2024-01-20', '2024-03-20');
