-- Index
-- Chỉ mục cho user_name để tăng tốc độ tìm kiếm theo user_name
CREATE INDEX idx_user_name ON "User" (user_name);

-- Chỉ mục cho email_address để tìm kiếm nhanh theo địa chỉ email
CREATE INDEX idx_user_email ON "User" (email_address);

-- Chỉ mục cho facility_name để tìm kiếm nhanh theo tên cơ sở
CREATE INDEX idx_gumfacility_name ON GumFacility (Facility_name);

-- Chỉ mục cho class_name để tìm kiếm nhanh theo tên lớp
CREATE INDEX idx_class_name ON "Class" (class_name);

-- Chỉ mục cho date để tìm kiếm lịch theo ngày
CREATE INDEX idx_schedule_date ON Schedule (date);

-- Chỉ mục cho customer_id để tìm kiếm lịch của khách hàng
CREATE INDEX idx_customer_schedule_customer_id ON Customer_Schedule (customer_id);