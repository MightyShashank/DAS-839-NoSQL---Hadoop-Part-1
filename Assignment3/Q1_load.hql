
-- Insert into Course_Attendance.csv
LOAD DATA LOCAL INPATH '/home/hadoopuser/assignment3/Course_Attendance_no_header.csv'
OVERWRITE INTO TABLE staging_course_attendance;

-- Now lets insert valid records into final table
INSERT INTO TABLE course_attendance
SELECT
  course,
  instructor,
  name,
  email_id,
  member_id,

  CASE
    WHEN num_classes_attended IS NULL OR NOT num_classes_attended RLIKE '^[0-9]+$' THEN -1
    ELSE CAST(num_classes_attended AS INT)
  END,

  CASE
    WHEN num_classes_absent IS NULL OR NOT num_classes_absent RLIKE '^[0-9]+$' THEN -1
    ELSE CAST(num_classes_absent AS INT)
  END,

  CASE
    WHEN avg_attendance_percent IS NULL OR NOT regexp_replace(avg_attendance_percent, '%', '') RLIKE '^[0-9]*\\.?[0-9]+$'
    THEN -1.0
    ELSE CAST(regexp_replace(avg_attendance_percent, '%', '') AS FLOAT)
  END
FROM staging_course_attendance;





-- Now lets insert errors for this table to error_log table
INSERT INTO TABLE error_log
SELECT
  'course_attendance' AS source_table,
  
  CASE
    WHEN num_classes_attended IS NULL OR NOT num_classes_attended RLIKE '^[0-9]+$' THEN 'num_classes_attended'
    WHEN num_classes_absent IS NULL OR NOT num_classes_absent RLIKE '^[0-9]+$' THEN 'num_classes_absent'
    WHEN avg_attendance_percent IS NULL 
         OR NOT regexp_replace(avg_attendance_percent, '%', '') RLIKE '^[0-9]*\\.?[0-9]+$' THEN 'avg_attendance_percent'
  END AS column_name,

  CONCAT_WS(',', course, instructor, name, email_id, member_id, num_classes_attended, num_classes_absent, avg_attendance_percent) AS row_data,

  CASE
    WHEN num_classes_attended IS NULL 
         OR num_classes_absent IS NULL 
         OR avg_attendance_percent IS NULL THEN 'Missing Value'
    ELSE 'Invalid Format'
  END AS error_type

FROM staging_course_attendance
WHERE 
  num_classes_attended IS NULL OR NOT num_classes_attended RLIKE '^[0-9]+$'
  OR num_classes_absent IS NULL OR NOT num_classes_absent RLIKE '^[0-9]+$'
  OR avg_attendance_percent IS NULL OR NOT regexp_replace(avg_attendance_percent, '%', '') RLIKE '^[0-9]*\\.?[0-9]+$';

-- ----------------------------------------------------------------------------------------------------------------------------------------

-- Lets do for Enrollment_data.csv
LOAD DATA LOCAL INPATH '/home/hadoopuser/assignment3/Enrollment_Data_no_header.csv'
OVERWRITE INTO TABLE staging_enrollment_data;

-- Now lets insert valid records into final table
INSERT INTO TABLE enrollment_data
SELECT
  CASE
    WHEN serial_no IS NULL OR NOT serial_no RLIKE '^[0-9]+$' THEN -1
    ELSE CAST(serial_no AS INT)
  END,
  course,
  status,
  course_type,
  course_variant,
  academia_lms,
  student_id,
  student_name,
  program,
  batch,
  period,
  enrollment_date,
  primary_faculty
FROM staging_enrollment_data;


-- Now lets insert errors for this table to error_log table
INSERT INTO TABLE error_log
SELECT
  'enrollment_data' AS source_table,
  
  'serial_no' AS column_name,

  CONCAT_WS(',', serial_no, course, status, course_type, course_variant, academia_lms, student_id, student_name, program, batch, period, enrollment_date, primary_faculty) AS row_data,

  CASE
    WHEN serial_no IS NULL THEN 'Missing Value'
    ELSE 'Invalid Format'
  END AS error_type

FROM staging_enrollment_data
WHERE serial_no IS NULL OR NOT serial_no RLIKE '^[0-9]+$';

-- --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- Lets do for Enrollment_data.csv
LOAD DATA LOCAL INPATH '/home/hadoopuser/assignment3/GradeRosterReport_no_header.csv'
OVERWRITE INTO TABLE staging_grade_roster_report;

-- Now lets insert valid records into final table
INSERT INTO TABLE grade_roster_report
SELECT
  academy_location,
  student_id,
  student_status,
  admission_id,
  admission_status,
  student_name,
  program_name,
  batch,
  period,
  subject_name,
  course_type,
  section,
  faculty_name,
  CASE
    WHEN course_credit IS NULL OR NOT course_credit RLIKE '^[0-9]+$' THEN -1
    ELSE CAST(course_credit AS INT)
  END,
  obtained_grade,
  out_of_grade,
  exam_result
FROM staging_grade_roster_report;

-- Now lets insert errors for this table to error_log table
INSERT INTO TABLE error_log
SELECT
  'grade_roster_report' AS source_table,
  'course_credit' AS column_name,

  CONCAT_WS(',', academy_location, student_id, student_status, admission_id, admission_status, student_name, program_name, batch, period, subject_name, course_type, section, faculty_name, course_credit, obtained_grade, out_of_grade, exam_result) AS row_data,

  CASE
    WHEN course_credit IS NULL OR TRIM(course_credit) = '' THEN 'Missing Value'
    ELSE 'Invalid Format'
  END AS error_type

FROM staging_grade_roster_report
WHERE course_credit IS NULL OR NOT TRIM(course_credit) RLIKE '^[0-9]+$';
