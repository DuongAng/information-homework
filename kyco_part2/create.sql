-- 1. User (for login purposes)
CREATE TABLE "User" (
    user_id SERIAL PRIMARY KEY,
    user_name VARCHAR(255) NOT NULL UNIQUE,
    password VARCHAR(255) NOT NULL,
    role VARCHAR(100) NOT NULL,
    phone_number VARCHAR(15),
    email_address VARCHAR(255),
    createdAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 2. Trainer
CREATE TABLE Trainer (
    user_id INT PRIMARY KEY REFERENCES "User"(user_id),
    name VARCHAR(255) NOT NULL,
    age INT NOT NULL,
    specialty VARCHAR(255) NOT NULL
);

-- 3. Gym Facility
CREATE TABLE GumFacility (
    Facility_id SERIAL PRIMARY KEY,
    Facility_name VARCHAR(255) NOT NULL,
    address VARCHAR(255) NOT NULL,
    capacity INT NOT NULL
);

-- 4. Membership Plan
CREATE TABLE MembershipPlan (
    plan_id SERIAL PRIMARY KEY,
    plan_name VARCHAR(255) NOT NULL,
    price DECIMAL(10, 2) NOT NULL,
    duration INT NOT NULL -- Duration in days
);

-- 5. Customer
CREATE TABLE Customer (
    user_id INT PRIMARY KEY REFERENCES "User"(user_id),
    full_name VARCHAR(255) NOT NULL,
    age INT NOT NULL,
    registration_date DATE NOT NULL
);

-- 6. Workout
CREATE TABLE Workout (
    workout_id SERIAL PRIMARY KEY,
    workout_name VARCHAR(255) NOT NULL,
    category VARCHAR(100) NOT NULL,
    difficulty VARCHAR(50) NOT NULL
);

-- 7. Class
CREATE TABLE "Class" (
    class_id SERIAL PRIMARY KEY,
    class_name VARCHAR(255) NOT NULL,
    class_type VARCHAR(100) NOT NULL,
    max_participants INT NOT NULL,
    facility_id INT REFERENCES GumFacility(Facility_id) ON DELETE SET NULL
);

-- 8. Class Workout
CREATE TABLE Class_Workout (
    class_id INT REFERENCES "Class"(class_id) ON DELETE CASCADE,
    workout_id INT REFERENCES Workout(workout_id) ON DELETE CASCADE,
    PRIMARY KEY (class_id, workout_id)
);

-- 9. Customer Membership
CREATE TABLE Customer_Membership (
    customer_membership_id SERIAL PRIMARY KEY,
    plan_id INT REFERENCES MembershipPlan(plan_id) ON DELETE CASCADE,
    customer_id INT REFERENCES Customer(user_id) ON DELETE CASCADE,
    start_date DATE NOT NULL,
    end_date DATE NOT NULL
);

-- 10. Schedule
CREATE TABLE Schedule (
    Schedule_id SERIAL PRIMARY KEY,
    trainer_id INT REFERENCES Trainer(user_id) ON DELETE CASCADE,
    start_time TIME NOT NULL,
    end_time TIME NOT NULL,
    date DATE NOT NULL
);

-- 11. Class Enrollment
CREATE TABLE Class_Enrollment (
    enrollment_id SERIAL PRIMARY KEY,
    customer_id INT REFERENCES Customer(user_id) ON DELETE CASCADE,
    class_id INT REFERENCES "Class"(class_id) ON DELETE CASCADE,
    enrollment_date DATE NOT NULL
);

-- 12. Customer Schedule
CREATE TABLE Customer_Schedule (
    customer_id INT REFERENCES Customer(user_id) ON DELETE CASCADE,
    schedule_id INT REFERENCES Schedule(Schedule_id) ON DELETE CASCADE,
    class_id INT REFERENCES "Class"(class_id) ON DELETE CASCADE,
    trainer_id INT REFERENCES Trainer(user_id) ON DELETE CASCADE,
    PRIMARY KEY (customer_id, schedule_id, class_id, trainer_id)
);


-- Thêm các ràng buộc
-- Ràng buộc mail 
ALTER TABLE "User"
ADD CONSTRAINT email_format CHECK (email_address ~* '^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$');

-- Ràng buộc thời gian trong lịch 
ALTER TABLE Schedule
ADD CONSTRAINT valid_schedule_time CHECK (start_time < end_time);

-- Ràng buộc tuổi 
ALTER TABLE Customer
ADD CONSTRAINT valid_age CHECK (age >= 0);

-- Ràng buộc giá tiền 
ALTER TABLE MembershipPlan
ADD CONSTRAINT valid_price CHECK (price >= 0);

-- Ràng buộc thời gian bắt đầu phải trước kết thúc
ALTER TABLE Customer_Membership
ADD CONSTRAINT valid_membership_dates CHECK (start_date < end_date);

-- Ràng buộc số lượng tối đa > 0
ALTER TABLE "Class"
ADD CONSTRAINT valid_max_participants CHECK (max_participants > 0);

-- Ràng buộc độ khó
ALTER TABLE Workout
ADD CONSTRAINT valid_difficulty CHECK (difficulty IN ('Easy', 'Medium', 'Hard'));

-- Triggers
CREATE OR REPLACE FUNCTION check_class_capacity()
RETURNS TRIGGER AS $$
BEGIN
    -- Kiểm tra số lượng học viên hiện tại trong lớp
    IF (SELECT COUNT(*) FROM Class_Enrollment WHERE class_id = NEW.class_id) >= (SELECT max_participants FROM "Class" WHERE class_id = NEW.class_id) THEN
        RAISE EXCEPTION 'Class is full!';
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_check_class_capacity
BEFORE INSERT ON Class_Enrollment
FOR EACH ROW
EXECUTE FUNCTION check_class_capacity();


-- 

CREATE OR REPLACE FUNCTION set_end_date_for_membership()
RETURNS TRIGGER AS $$
BEGIN
    -- Tính toán ngày kết thúc dựa trên ngày bắt đầu và duration của gói
    NEW.end_date := NEW.start_date + INTERVAL '1 day' * (SELECT duration FROM MembershipPlan WHERE plan_id = NEW.plan_id);
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_set_end_date_for_membership
BEFORE INSERT ON Customer_Membership
FOR EACH ROW
EXECUTE FUNCTION set_end_date_for_membership();

-- 

CREATE OR REPLACE FUNCTION check_enrollment_date_validity()
RETURNS TRIGGER AS $$
BEGIN
    -- Kiểm tra rằng ngày đăng ký không phải trong quá khứ
    IF NEW.enrollment_date < CURRENT_DATE THEN
        RAISE EXCEPTION 'The registration date cannot be in the past';
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_check_enrollment_date_validity
BEFORE INSERT ON Class_Enrollment
FOR EACH ROW
EXECUTE FUNCTION check_enrollment_date_validity();

--

-- Hàm và thủ tục
-- Thủ tục thêm người dùng vào. Nên dùng cách này khi thêm dữ liệu. 
CREATE OR REPLACE PROCEDURE add_new_user(
    p_user_name VARCHAR,
    p_password VARCHAR,
    p_role VARCHAR,
    p_phone_number VARCHAR DEFAULT NULL,
    p_email_address VARCHAR DEFAULT NULL,
    p_full_name VARCHAR DEFAULT NULL,
    p_age INT DEFAULT NULL,
    p_specialty VARCHAR DEFAULT NULL
)
AS $$
DECLARE
    new_user_id INT;
BEGIN
    -- Thêm người dùng mới vào bảng "User"
    INSERT INTO "User" (user_name, password, role, phone_number, email_address)
    VALUES (p_user_name, p_password, p_role, p_phone_number, p_email_address)
    RETURNING user_id INTO new_user_id;


    IF p_role = 'Customer' THEN
        -- Nếu vai trò là Customer, thêm vào bảng Customer
        INSERT INTO Customer (user_id, full_name, age, registration_date)
        VALUES (new_user_id, p_full_name, p_age, CURRENT_DATE);


    ELSIF p_role = 'Trainer' THEN
        -- Nếu vai trò là Trainer, thêm vào bảng Trainer
        INSERT INTO Trainer (user_id, name, age, specialty)
        VALUES (new_user_id, p_full_name, p_age, p_specialty);

    ELSE
        RAISE EXCEPTION 'Invalid role. Role must be "Customer" or "Trainer"';
    END IF;
END;
$$ LANGUAGE plpgsql;


-- Hàm tính chi phí của khách hàng
CREATE OR REPLACE FUNCTION calculate_total_membership_cost(customer_id INT)
RETURNS DECIMAL AS $$
DECLARE
    total_cost DECIMAL := 0;
BEGIN
    -- Tính tổng chi phí của các gói thành viên
    SELECT SUM(mp.price) INTO total_cost
    FROM Customer_Membership cm
    JOIN MembershipPlan mp ON cm.plan_id = mp.plan_id
    WHERE cm.customer_id = customer_id;

    RETURN total_cost;
END;
$$ LANGUAGE plpgsql;



