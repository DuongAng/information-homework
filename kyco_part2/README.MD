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
  - [Customer](#Customer)
  - [Trainer](#Traner)
  - [MembershipPlan](#MembershipPlan)
  - [GymFacility](#GymFacility)
  - [Equipment](#Equipment)
  - [Workout](#Workout)
  - [Schedule](#Schedule)
  - [Class](#Class)
  - [ClassEnrollment](#ClassEnrollment)
  - [CustomerSchedule](#CustomerSchedule)
  - [ClassWorkout](#ClassWorkout)
  - [CustomerMembership](#CustomerMembership)
- [Целостность данных](#Целостность-данных)
  - [Triggers](#Triggers)
- [SQL-скрипты](#sql-скрипты)
- [ER-модель](#er-модель)
- [Даталогическая модель](#даталогическая-модель)
- [Тестирование производительности, создание индексов](#тестирование-производительности-создание-индексов)

## Сущности

### Customer

| Column Name      | Data Type      | Constraints       | References |
|------------------|----------------|-------------------|------------|
| CustomerID       | SERIAL         | PRIMARY KEY       | -          |
| FullName         | VARCHAR(100)   | NOT NULL          | -          |
| Phone            | VARCHAR(15)    | -                 | -          |
| Email            | VARCHAR(100)   | UNIQUE            | -          |
| Age              | INT            | NOT NULL          | -          |
| RegistrationDate | DATE           | NOT NULL          | -          |

### Trainer

| Column Name      | Data Type      | Constraints       | References |
|------------------|----------------|-------------------|------------|
| TrainerID        | SERIAL         | PRIMARY KEY       | -          |
| FullName         | VARCHAR(100)   | NOT NULL          | -          |
| Age              | INT            | NOT NULL          | -          |
| Phone            | VARCHAR(15)    | -                 | -          |
| Specialty        | VARCHAR(100)   | -                 | -          |

### MembershipPlan

| Column Name      | Data Type      | Constraints       | References |
|------------------|----------------|-------------------|------------|
| PlanID           | SERIAL         | PRIMARY KEY       | -          |
| PlanName         | VARCHAR(100)   | NOT NULL          | -          |
| Price            | DECIMAL(10, 2) | NOT NULL          | -          |
| Duration         | INT            | NOT NULL          | -          |

### GymFacility

| Column Name      | Data Type      | Constraints       | References |
|------------------|----------------|-------------------|------------|
| FacilityID       | SERIAL         | PRIMARY KEY       | -          |
| FacilityName     | VARCHAR(100)   | NOT NULL          | -          |
| Address          | VARCHAR(255)   | -                 | -          |
| Capacity         | INT            | -                 | -          |

### Equipment

| Column Name      | Data Type      | Constraints       | References |
|------------------|----------------|-------------------|------------|
| EquipmentID      | SERIAL         | PRIMARY KEY       | -          |
| EquipmentName    | VARCHAR(100)   | NOT NULL          | -          |
| Type             | VARCHAR(100)   | -                 | -          |
| Status           | VARCHAR(50)    | -                 | -          |

### Workout

| Column Name      | Data Type      | Constraints       | References |
|------------------|----------------|-------------------|------------|
| WorkoutID        | SERIAL         | PRIMARY KEY       | -          |
| WorkoutName      | VARCHAR(100)   | NOT NULL          | -          |
| Category         | VARCHAR(50)    | -                 | -          |
| Difficulty       | VARCHAR(50)    | -                 | -          |

### Schedule

| Column Name      | Data Type      | Constraints       | References                  |
|------------------|----------------|-------------------|-----------------------------|
| ScheduleID       | SERIAL         | PRIMARY KEY       | -                           |
| StartTime        | TIME           | NOT NULL          | -                           |
| EndTime          | TIME           | NOT NULL          | -                           |
| Date             | DATE           | NOT NULL          | -                           |
| TrainerID        | INT            | REFERENCES Trainer(TrainerID) | -        |

### Class

| Column Name      | Data Type      | Constraints       | References                  |
|------------------|----------------|-------------------|-----------------------------|
| ClassID          | SERIAL         | PRIMARY KEY       | -                           |
| ClassName        | VARCHAR(100)   | NOT NULL          | -                           |
| ClassType        | VARCHAR(100)   | -                 | -                           |
| MaxParticipants  | INT            | NOT NULL          | -                           |
| FacilityID       | INT            | REFERENCES GymFacility(FacilityID) | -   |

### ClassEnrollment

| Column Name      | Data Type      | Constraints       | References                  |
|------------------|----------------|-------------------|-----------------------------|
| EnrollmentID     | SERIAL         | PRIMARY KEY       | -                           |
| CustomerID       | INT            | REFERENCES Customer(CustomerID) | -        |
| ClassID          | INT            | REFERENCES Class(ClassID) | -               |
| EnrollmentDate   | DATE           | NOT NULL          | -                           |

### CustomerSchedule

| Column Name      | Data Type      | Constraints       | References                              |
|------------------|----------------|-------------------|-----------------------------------------|
| CustomerID       | INT            | REFERENCES Customer(CustomerID) | PRIMARY KEY (CustomerID, ScheduleID) |
| ScheduleID       | INT            | REFERENCES Schedule(ScheduleID) | -                                     |
| TrainerID        | INT            | REFERENCES Trainer(TrainerID) ON DELETE SET NULL | -        |

### ClassWorkout

| Column Name      | Data Type      | Constraints       | References                  |
|------------------|----------------|-------------------|-----------------------------|
| ClassID          | INT            | REFERENCES Class(ClassID) | PRIMARY KEY (ClassID, WorkoutID) |
| WorkoutID        | INT            | REFERENCES Workout(WorkoutID) | -                        |

### CustomerMembership

| Column Name      | Data Type      | Constraints       | References                      |
|------------------|----------------|-------------------|---------------------------------|
| MembershipID     | SERIAL         | PRIMARY KEY       | -                               |
| CustomerID       | INT            | REFERENCES Customer(CustomerID) | -                     |
| PlanID           | INT            | REFERENCES MembershipPlan(PlanID) | -                   |
| StartDate        | DATE           | NOT NULL          | -                               |
| EndDate          | DATE           | NOT NULL          | -                               |


## Целостность данных


```sql
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
```

### Триггеры

- триггер Отображается, если количество членов в классе заполнено

```sql
CREATE OR REPLACE FUNCTION check_class_capacity()
RETURNS TRIGGER AS $$
BEGIN
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
```

- Триггер автоматически рассчитывает дату истечения срока действия пакета

```sql
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

```

- Триггерная проверка действительного времени расписания обучения

```sql
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

```

## SQL-скрипты

- [Создание базы данных, таблиц, функций ...](/SQL/create.sql)
- [Вставка тестовых данных](/SQL/create_data.sql)
- [Скрипт для удаления](/SQL/deleteAll.sql)


## ER-модель

![image](/kyco_part2/ER.png)

## Даталогическая модель

![image](/kyco_part2/schema.png)

## Тестирование производительности, создание индексов

### [Индексы](/kyco_part2/indexes.sql)

### Фильтрация клиентов по электронной почте или идентификатору

```sql
CREATE INDEX idx_customer_email ON Customer(Email);
CREATE INDEX idx_customer_id ON Customer(CustomerID);
```


### Быстрый поиск классов, на которые зарегистрировались клиенты, или конкретной информации о классе.

```sql
CREATE INDEX idx_class_enrollment_customer ON ClassEnrollment(CustomerID);
CREATE INDEX idx_class_enrollment_class ON ClassEnrollment(ClassID);
CREATE INDEX idx_class_id ON Class(ClassID);
```

### Получите графики предстоящих тренировок для отправки уведомлений.

```sql
CREATE INDEX idx_schedule_upcoming ON Schedule(Date, StartTime);
```

### Быстрое получение данных для организации расписаний

```sql
CREATE INDEX idx_trainer_schedule ON Schedule(TrainerID, Date);
```

### Отображает упражнения, в которых участвовал клиент.

```sql
CREATE INDEX idx_workout_customer ON CustomerSchedule(CustomerID);
CREATE INDEX idx_workout_class ON ClassWorkout(ClassID);
CREATE INDEX idx_workout_id ON Workout(WorkoutID);
```

Было: 0,053 мс

Стало: 0,044 мс

### Получение отзывов пользователей о конкретном продукте, включая рейтинг и текст отзыва

```sql
EXPLAIN ANALYZE
SELECT
f.id AS feedback_id,
u.username AS author_name,
f.stars,
f.text,
f.created_at
FROM
feedback f
JOIN app_user u ON f.author_id = u.id
WHERE
f.product_id = 3
ORDER BY
f.created_at DESC;
```

Было: 0,447 мс

Стало: 0,026 мс

### Получить список музыкантов, на которых подписан пользователь

```sql
EXPLAIN ANALYZE
SELECT
m.id AS musician_id,
m.name AS musician_name,
m.subscribers
FROM
user_musician_subscription ums
JOIN musician m ON ums.musician_id = m.id
WHERE
ums.user_id = 4
ORDER BY
m.subscribers DESC;
```

Было: 0,035 мс

Стало: 0,032 мс

### Получить темы форума, созданные пользователем

```sql
EXPLAIN ANALYZE
SELECT
ft.id AS topic_id,
ft.title,
ft.description,
ft.created_at,
ft.is_closed
FROM
forum_topic ft
WHERE
ft.author_id = 4
ORDER BY
ft.created_at DESC;
```

Было: 0,034 мс

Стало: 0,026 мс

### Поиск продуктов с самым высоким рейтингом по всем типам

```sql
EXPLAIN ANALYZE
SELECT
p.id AS product_id,
p.name AS product_name,
p.rate,
p.avg_price,
p.type_of_product
FROM
product p
WHERE
p.rate >= 4.5
ORDER BY
p.rate DESC, p.avg_price ASC;
```

Было: 16,732 мс

Стало: 2,834 мс

### Список всех пользователей, музыкантов, на которых они подписаны, продукты, на которые они оставили отзывы, статьи, на которые они написали отзывы, магазины, продающие эти продукты, и жанр музыканта

```sql
EXPLAIN ANALYZE
SELECT
au.username AS user_name,
m.name AS musician_name,
m.subscribers AS musician_subscribers,
p.name AS product_name,
p.type_of_product AS product_type,
p.avg_price AS average_price,
f.text AS feedback_text,
f.stars AS feedback_rating,
a.header AS article_title,
a.accepted AS article_status,
s.name AS shop_name,
sp.price AS shop_price,
g.genre AS musician_genre
FROM app_user au
LEFT JOIN user_musician_subscription ums
ON au.id = ums.user_id
LEFT JOIN musician m
ON ums.musician_id = m.id
LEFT JOIN feedback f
ON f.author_id = au.id
LEFT JOIN product p
ON f.product_id = p.id
LEFT JOIN articles a
ON f.article_id = a.id
LEFT JOIN shop_product sp
ON p.id = sp.product_id
LEFT JOIN shop s
ON sp.shop_id = s.id
LEFT JOIN musician_genre mg
ON m.id = mg.musician_id
LEFT JOIN genre_user g
ON mg.genre = g.genre AND g.user_id = au.id
WHERE
p.avg_price > 500
AND f.stars >= 4
AND a.accepted = TRUE
ORDER BY
au.username, p.avg_price DESC;
```

Было: 171,304 мс

Стало: 128,234 мс
