-- Insert our Course_Attendance.csv into staging table
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
