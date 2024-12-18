-- lọc khách hàng theo email 

CREATE INDEX idx_customer_email ON Customer(Email);
CREATE INDEX idx_customer_id ON Customer(CustomerID);

-- TÌm kiếm lịch theo customerId hoặc lịch date

CREATE INDEX idx_schedule_customer ON CustomerSchedule(CustomerID);
CREATE INDEX idx_schedule_date ON Schedule(Date);
CREATE INDEX idx_schedule_trainer ON Schedule(TrainerID);

-- Tìm kiếm nhanh các lớp học mà khách hàng đã đăng ký hoặc thông tin lớp học cụ thể.

CREATE INDEX idx_class_enrollment_customer ON ClassEnrollment(CustomerID);
CREATE INDEX idx_class_enrollment_class ON ClassEnrollment(ClassID);
CREATE INDEX idx_class_id ON Class(ClassID);

-- Hoạt động: Truy xuất các lịch tập sắp tới để gửi thông báo.

CREATE INDEX idx_schedule_upcoming ON Schedule(Date, StartTime);

-- Hiển thị các bài tập mà khách hàng đã tham gia.

CREATE INDEX idx_workout_customer ON CustomerSchedule(CustomerID);
CREATE INDEX idx_workout_class ON ClassWorkout(ClassID);
CREATE INDEX idx_workout_id ON Workout(WorkoutID);

-- Truy xuất dữ liệu nhanh chóng để sắp xếp lịch trình

CREATE INDEX idx_trainer_schedule ON Schedule(TrainerID, Date);

