CREATE TABLE dwh_college_data (
    student_id STRING,
    student_name STRING,
    course STRING,
    period STRING,
    program STRING,
    batch STRING,
    instructor_email STRING,
    faculty_name STRING,
    enrollment_status STRING,
    course_type STRING,
    course_variant STRING,
    course_credit INT,
    obtained_grade STRING,
    out_of_grade STRING,
    exam_result STRING,
    num_classes_attended INT,
    num_classes_absent INT,
    avg_attendance_percent FLOAT
)
ROW FORMAT SERDE 'org.apache.hadoop.hive.serde2.OpenCSVSerde'
WITH SERDEPROPERTIES (
  "separatorChar" = ",",
  "quoteChar" = "\""
)
STORED AS TEXTFILE;

-- Now lets insert into this dwh_college_data
INSERT INTO dwh_college_data
SELECT 
  COALESCE(e.student_id, g.student_id, a.member_id), -- student_id
  COALESCE(e.student_name, g.student_name, a.name), --member_id
  e.course,
  e.period,
  e.program,
  e.batch,
  a.instructor,
  COALESCE(e.primary_faculty, g.faculty_name),
  e.status,
  e.course_type,
  e.course_variant,
  CASE
    WHEN g.course_credit IS NULL THEN -1
    ELSE g.course_credit
  END AS course_credit,
  g.obtained_grade,
  g.out_of_grade,
  g.exam_result,
  a.num_classes_attended,
  a.num_classes_absent,
  a.avg_attendance_percent
FROM enrollment_data e
LEFT JOIN grade_roster_report g
  ON e.student_id = g.student_id
LEFT JOIN course_attendance a
  ON e.student_id = a.member_id
WHERE 
  COALESCE(e.student_id, g.student_id, a.member_id) IS NOT NULL AND COALESCE(e.student_id, g.student_id, a.member_id) <> '' AND
  COALESCE(e.student_name, g.student_name, a.name) IS NOT NULL AND COALESCE(e.student_name, g.student_name, a.name) <> '' AND
  e.course IS NOT NULL AND e.course <> '' AND
  e.period IS NOT NULL AND e.period <> '' AND
  e.program IS NOT NULL AND e.program <> '' AND
  e.batch IS NOT NULL AND e.batch <> '' AND
  a.instructor IS NOT NULL AND a.instructor <> '' AND
  COALESCE(e.primary_faculty, g.faculty_name) IS NOT NULL AND COALESCE(e.primary_faculty, g.faculty_name) <> '' AND
  e.status IS NOT NULL AND e.status <> '' AND
  e.course_type IS NOT NULL AND e.course_type <> '' AND
  e.course_variant IS NOT NULL AND e.course_variant <> '' AND
  g.obtained_grade IS NOT NULL AND g.obtained_grade <> '' AND
  g.out_of_grade IS NOT NULL AND g.out_of_grade <> '' AND
  g.exam_result IS NOT NULL AND g.exam_result <> '' AND
  a.num_classes_attended IS NOT NULL AND
  a.num_classes_absent IS NOT NULL AND
  a.avg_attendance_percent IS NOT NULL;

-- ------------------------------------------------------------------------------------

-- Error logging