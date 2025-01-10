<div align="center">

## Министерство науки и высшего образования Российской Федерации
## Федеральное государственное автономное образовательное учреждение высшего образования
## «Национальный исследовательский университет ИТМО»
## Факультет программной инженерии и компьютерной техники
**Отчёт по курсовой работе**

**2 этап**

по дисциплине
"Информационные системы"
</div>

<div align="right" style="margin-top: 50px;">
<b>Выполнили студенты группы P3307:</b>

Зыонг Динь Ань

<b>Преподаватель:</b>
Пименов Данила Дмитриевич
</div>






<div align="center" style="margin-top: 200px; text: center">
г. Санкт-Петербург

2024г.
</div>

<div style="page-break-after: always;"></div>


## Содержание

- [Сущности](#сущности)
  - [User](#User)
  - [Trainer](#Trainer)
  - [GumFacility](#GumFacility)
  - [MembershipPlan](#MembershipPlan)
  - [Customer](#Customer)
  - [Workout](#Workout)
  - [Class](#Class)
  - [Class_Workout](#Class_Workout)
  - [Customer_Membership](#Customer_Membership)
  - [Schedule](#Schedule)
  - [Class_Enrollment](#Class_Enrollment)
  - [Customer_Schedule](#Customer_Schedule)
- [Целостность данных](#Целостность-данных)
  - [Triggers](#Triggers)
- [SQL-скрипты](#sql-скрипты)
- [Функции и процедуры](#Функции-и-процедуры)
- [ER-модель](#er-модель)
- [Даталогическая модель](#даталогическая-модель)
- [Тестирование производительности, создание индексов](#тестирование-производительности-создание-индексов)

## Сущности

### User

| Column Name      | Data Type      | Constraints       | References |
|------------------|----------------|-------------------|------------|
| user_id          | SERIAL         | PRIMARY KEY       | -          |
| user_name        | VARCHAR(255)   | NOT NULL, UNIQUE  | -          |
| password         | VARCHAR(255)   | NOT NULL          | -          |
| role             | VARCHAR(100)   | NOT NULL          | -          |
| phone_number     | VARCHAR(15)    | -                 | -          |
| email_address    | VARCHAR(255)   | -                 | -          |
| createdAt        | TIMESTAMP      | -                 | -          |


### Trainer

| Column Name      | Data Type      | Constraints       | References |
|------------------|----------------|-------------------|------------|
| user_id          | INT            | PRIMARY KEY       | -          |
| name             | VARCHAR(255)   | NOT NULL          | -          |
| age              | INT            | NOT NULL          | -          |
| specialty        | VARCHAR(255)   | NOT NULL          | -          |


### GumFacility

| Column Name      | Data Type      | Constraints       | References |
|------------------|----------------|-------------------|------------|
| Facility_id      | SERIAL         | PRIMARY KEY       | -          |
| Facility_name    | VARCHAR(255)   | NOT NULL          | -          |
| address          | VARCHAR(255)   | NOT NULL          | -          |
| capacity         | INT            | NOT NULL          | -          |


### MembershipPlan

| Column Name      | Data Type      | Constraints       | References |
|------------------|----------------|-------------------|------------|
| plan_id          | SERIAL         | PRIMARY KEY       | -          |
| plan_name        | VARCHAR(255)   | NOT NULL          | -          |
| price            | DECIMAL(10     | -                 | -          |
| NOT              | NULL           | -                 | -          |
| duration         | INT            | NOT NULL          | -          |


### Customer

| Column Name      | Data Type      | Constraints       | References |
|------------------|----------------|-------------------|------------|
| user_id          | INT            | PRIMARY KEY       | -          |
| full_name        | VARCHAR(255)   | NOT NULL          | -          |
| age              | INT            | NOT NULL          | -          |
| registration_date | DATE           | NOT NULL          | -          |


### Workout

| Column Name      | Data Type      | Constraints       | References |
|------------------|----------------|-------------------|------------|
| workout_id       | SERIAL         | PRIMARY KEY       | -          |
| workout_name     | VARCHAR(255)   | NOT NULL          | -          |
| category         | VARCHAR(100)   | NOT NULL          | -          |
| difficulty       | VARCHAR(50)    | NOT NULL          | -          |


### Class

| Column Name      | Data Type      | Constraints       | References |
|------------------|----------------|-------------------|------------|
| class_id         | SERIAL         | PRIMARY KEY       | -          |
| class_name       | VARCHAR(255)   | NOT NULL          | -          |
| class_type       | VARCHAR(100)   | NOT NULL          | -          |
| max_participants | INT            | NOT NULL          | -          |
| facility_id      | INT            | -                 | GumFacility |


### Class_Workout

| Column Name      | Data Type      | Constraints       | References |
|------------------|----------------|-------------------|------------|
| class_id         | INT            | -                 | -          |
| workout_id       | INT            | -                 | Workout    |
| PRIMARY          | KEY            | -                 | -          |


### Customer_Membership

| Column Name      | Data Type      | Constraints       | References |
|------------------|----------------|-------------------|------------|
| customer_membership_id | SERIAL         | PRIMARY KEY       | -          |
| plan_id          | INT            | -                 | MembershipPlan |
| customer_id      | INT            | -                 | Customer   |
| start_date       | DATE           | NOT NULL          | -          |
| end_date         | DATE           | NOT NULL          | -          |


### Schedule

| Column Name      | Data Type      | Constraints       | References |
|------------------|----------------|-------------------|------------|
| Schedule_id      | SERIAL         | PRIMARY KEY       | -          |
| trainer_id       | INT            | -                 | Trainer    |
| start_time       | TIME           | NOT NULL          | -          |
| end_time         | TIME           | NOT NULL          | -          |
| date             | DATE           | NOT NULL          | -          |


### Class_Enrollment

| Column Name      | Data Type      | Constraints       | References |
|------------------|----------------|-------------------|------------|
| enrollment_id    | SERIAL         | PRIMARY KEY       | -          |
| customer_id      | INT            | -                 | Customer   |
| class_id         | INT            | -                 | -          |
| enrollment_date  | DATE           | NOT NULL          | -          |


### Customer_Schedule

| Column Name      | Data Type      | Constraints       | References |
|------------------|----------------|-------------------|------------|
| customer_id      | INT            | -                 | Customer   |
| schedule_id      | INT            | -                 | Schedule   |
| class_id         | INT            | -                 | -          |
| trainer_id       | INT            | -                 | Trainer    |
| PRIMARY          | KEY            | -                 | -          |


## Целостность данных


```sql
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

```

### Триггеры

- Триггер автоматически рассчитывает дату истечения срока действия пакета.

```sql
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
```

- Проверьте, что дата регистрации не в прошлом.

```sql
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

```


## SQL-скрипты

- [Создание базы данных, таблиц, функций ...](/kyco_part2/create.sql)
- [Вставка тестовых данных](/kyco_part2/create_data.sql)
- [Скрипт для удаления](/kyco_part2/deleteAll.sql)

## Функции и процедуры

- Функция затрат клиента
```sql
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
```

- Процедура добавления пользователя.
```sql
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
```

## ER-модель

![image](/kyco_part2/ER.png)

## Даталогическая модель

![image](/kyco_part2/schema.png)

## Тестирование производительности, создание индексов

### [Индексы](/kyco_part2/index.sql)

### Индекс для user_name для ускорения поиска по user_name.

```sql
CREATE INDEX idx_user_name ON "User" (user_name);
```

### Индекс email_address для быстрого поиска по адресу электронной почты.
```sql
CREATE INDEX idx_user_email ON "User" (email_address);
```

### Индекс facility_name для быстрого поиска по названию объекта.

```sql
CREATE INDEX idx_gumfacility_name ON GumFacility (Facility_name);
```

### Индекс для class_name для быстрого поиска по имени класса.

```sql
CREATE INDEX idx_class_name ON "Class" (class_name);
```

### Индекс даты для поиска календаря по дате.

```sql
CREATE INDEX idx_schedule_date ON Schedule (date);
```

### Индекс для customer_id для поиска в календаре клиента.

```sql
CREATE INDEX idx_customer_schedule_customer_id ON Customer_Schedule (customer_id);
```