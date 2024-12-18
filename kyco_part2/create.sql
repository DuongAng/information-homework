-- Bảng Khách hàng
CREATE TABLE Customer (
    CustomerID SERIAL PRIMARY KEY,
    FullName VARCHAR(100) NOT NULL,
    Phone VARCHAR(15),
    Email VARCHAR(100) UNIQUE,
    Age INT NOT NULL,
    RegistrationDate DATE NOT NULL
);

-- Bảng Huấn luyện viên
CREATE TABLE Trainer (
    TrainerID SERIAL PRIMARY KEY,
    FullName VARCHAR(100) NOT NULL,
    Age INT NOT NULL,
    Phone VARCHAR(15),
    Specialty VARCHAR(100)
);

-- Bảng Gói tập
CREATE TABLE MembershipPlan (
    PlanID SERIAL PRIMARY KEY,
    PlanName VARCHAR(100) NOT NULL,
    Price DECIMAL(10, 2) NOT NULL,
    Duration INT NOT NULL -- Thời hạn tính bằng ngày
);

-- Bảng Phòng tập
CREATE TABLE GymFacility (
    FacilityID SERIAL PRIMARY KEY,
    FacilityName VARCHAR(100) NOT NULL,
    Address VARCHAR(255),
    Capacity INT
);

-- Bảng Thiết bị
CREATE TABLE Equipment (
    EquipmentID SERIAL PRIMARY KEY,
    EquipmentName VARCHAR(100) NOT NULL,
    Type VARCHAR(100),
    Status VARCHAR(50)
);

-- Bảng Bài tập
CREATE TABLE Workout (
    WorkoutID SERIAL PRIMARY KEY,
    WorkoutName VARCHAR(100) NOT NULL,
    Category VARCHAR(50),
    Difficulty VARCHAR(50)
);

-- Bảng Lịch tập
CREATE TABLE Schedule (
    ScheduleID SERIAL PRIMARY KEY,
    StartTime TIME NOT NULL,
    EndTime TIME NOT NULL,
    Date DATE NOT NULL,
    TrainerID INT REFERENCES Trainer(TrainerID)
);

-- Bảng Lớp tập
CREATE TABLE Class (
    ClassID SERIAL PRIMARY KEY,
    ClassName VARCHAR(100) NOT NULL,
    ClassType VARCHAR(100),
    MaxParticipants INT NOT NULL,
    FacilityID INT REFERENCES GymFacility(FacilityID)
);

-- Bảng Đăng ký lớp tập (Quan hệ nhiều-nhiều giữa Khách hàng và Lớp tập)
CREATE TABLE ClassEnrollment (
    EnrollmentID SERIAL PRIMARY KEY,
    CustomerID INT REFERENCES Customer(CustomerID),
    ClassID INT REFERENCES Class(ClassID),
    EnrollmentDate DATE NOT NULL
);

-- Bảng Khách hàng và Lịch tập (Quan hệ nhiều-nhiều giữa Khách hàng và Lịch tập)
CREATE TABLE CustomerSchedule (
    CustomerID INT REFERENCES Customer(CustomerID),
    ScheduleID INT REFERENCES Schedule(ScheduleID),
    TrainerID INT REFERENCES Trainer(TrainerID) ON DELETE SET NULL,
    PRIMARY KEY (CustomerID, ScheduleID)
);

-- Bảng Quan hệ nhiều-nhiều giữa Lớp tập và Bài tập
CREATE TABLE ClassWorkout (
    ClassID INT REFERENCES Class(ClassID),
    WorkoutID INT REFERENCES Workout(WorkoutID),
    PRIMARY KEY (ClassID, WorkoutID)
);

-- Bảng Quan hệ 1-nhiều giữa Gói tập và Khách hàng
CREATE TABLE CustomerMembership (
    MembershipID SERIAL PRIMARY KEY,
    CustomerID INT REFERENCES Customer(CustomerID),
    PlanID INT REFERENCES MembershipPlan(PlanID),
    StartDate DATE NOT NULL,
    EndDate DATE NOT NULL
);

-- Thêm các ràng buộc
ALTER TABLE Schedule
ADD CONSTRAINT CK_ScheduleTime CHECK (StartTime < EndTime);

ALTER TABLE Class
ADD CONSTRAINT CK_Class_Capacity CHECK (MaxParticipants > 0);

ALTER TABLE Customer
ADD CONSTRAINT CK_Email_Format CHECK (Email ~* '^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$');

ALTER TABLE MembershipPlan
ADD CONSTRAINT CK_Plan_Price CHECK (Price > 0);

ALTER TABLE GymFacility
ADD CONSTRAINT CK_Facility_Capacity CHECK (Capacity > 0);

-- Triggers
CREATE OR REPLACE FUNCTION check_class_capacity()
RETURNS TRIGGER AS $$
BEGIN
    -- Đếm số người đã đăng ký
    IF (
        (SELECT COUNT(*) FROM ClassEnrollment WHERE ClassID = NEW.ClassID) >= 
        (SELECT MaxParticipants FROM Class WHERE ClassID = NEW.ClassID)
    ) THEN
        RAISE EXCEPTION 'Class is already full!';
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_check_class_capacity
BEFORE INSERT ON ClassEnrollment
FOR EACH ROW
EXECUTE FUNCTION check_class_capacity();

-- 

CREATE OR REPLACE FUNCTION set_membership_end_date()
RETURNS TRIGGER AS $$
BEGIN
    NEW.EndDate := NEW.StartDate + 
                   (SELECT Duration FROM MembershipPlan WHERE PlanID = NEW.PlanID) * INTERVAL '1 day';
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_set_membership_end_date
BEFORE INSERT ON CustomerMembership
FOR EACH ROW
EXECUTE FUNCTION set_membership_end_date();

-- 

CREATE OR REPLACE FUNCTION check_schedule_conflict()
RETURNS TRIGGER AS $$
BEGIN
    IF EXISTS (
        SELECT 1
        FROM Schedule
        WHERE TrainerID = NEW.TrainerID
          AND Date = NEW.Date
          AND (
              (NEW.StartTime >= StartTime AND NEW.StartTime < EndTime) OR
              (NEW.EndTime > StartTime AND NEW.EndTime <= EndTime)
          )
    ) THEN
        RAISE EXCEPTION 'Schedule conflict detected for Trainer %', NEW.TrainerID;
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_check_schedule_conflict
BEFORE INSERT OR UPDATE ON Schedule
FOR EACH ROW
EXECUTE FUNCTION check_schedule_conflict();


