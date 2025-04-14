-- First lets create our DB

CREATE DATABASE IF NOT EXISTS nosqldb;
USE nosqldb;

-- for Course_Attendance.csv table
CREATE TABLE course_attendance (
    course STRING, --
    instructor STRING, --
    name STRING, --
    email_id STRING,
    member_id STRING, --
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

CREATE TABLE staging_course_attendance (
    course STRING, 
    instructor STRING,
    name STRING,
    email_id STRING,
    member_id STRING, 
    num_classes_attended STRING,
    num_classes_absent STRING,
    avg_attendance_percent STRING
)
ROW FORMAT SERDE 'org.apache.hadoop.hive.serde2.OpenCSVSerde'
WITH SERDEPROPERTIES (
  "separatorChar" = ",",
  "quoteChar" = "\""
)
STORED AS TEXTFILE;


-- -----------------------------------------------------------------------------------------------------------------------------------------------

-- for Enrollment_Data.csv table
CREATE TABLE enrollment_data (
    serial_no INT,
    course STRING,
    status STRING,
    course_type STRING,
    course_variant STRING,
    academia_lms STRING,
    student_id STRING, --
    student_name STRING, --
    program STRING,
    batch STRING, --
    period STRING, --
    enrollment_date STRING,
    primary_faculty STRING
)
ROW FORMAT SERDE 'org.apache.hadoop.hive.serde2.OpenCSVSerde'
WITH SERDEPROPERTIES (
  "separatorChar" = ",",
  "quoteChar" = "\""
)
STORED AS TEXTFILE;

CREATE TABLE staging_enrollment_data (
    serial_no STRING,
    course STRING,
    status STRING,
    course_type STRING,
    course_variant STRING,
    academia_lms STRING,
    student_id STRING,
    student_name STRING,
    program STRING,
    batch STRING,
    period STRING,
    enrollment_date STRING,
    primary_faculty STRING
)
ROW FORMAT SERDE 'org.apache.hadoop.hive.serde2.OpenCSVSerde'
WITH SERDEPROPERTIES (
  "separatorChar" = ",",
  "quoteChar" = "\""
)
STORED AS TEXTFILE;

-----------------------------------------------------------------------------------------------------------------------------------------

-- for GradeRosterReport.csv table
CREATE TABLE grade_roster_report (
    academy_location STRING,
    student_id STRING, --
    student_status STRING,
    admission_id STRING,
    admission_status STRING,
    student_name STRING, --
    program_name STRING,
    batch STRING, --
    period STRING, -- 
    subject_name STRING,
    course_type STRING,
    section STRING,
    faculty_name STRING,
    course_credit INT,
    obtained_grade STRING,
    out_of_grade STRING,
    exam_result STRING
)
ROW FORMAT SERDE 'org.apache.hadoop.hive.serde2.OpenCSVSerde'
WITH SERDEPROPERTIES (
  "separatorChar" = ",",
  "quoteChar" = "\""
)
STORED AS TEXTFILE;

CREATE TABLE staging_grade_roster_report (
    academy_location STRING,
    student_id STRING,
    student_status STRING,
    admission_id STRING,
    admission_status STRING,
    student_name STRING,
    program_name STRING,
    batch STRING,
    period STRING,  
    subject_name STRING,
    course_type STRING,
    section STRING,
    faculty_name STRING,
    course_credit STRING,
    obtained_grade STRING,
    out_of_grade STRING,
    exam_result STRING
)
ROW FORMAT SERDE 'org.apache.hadoop.hive.serde2.OpenCSVSerde'
WITH SERDEPROPERTIES (
  "separatorChar" = ",",
  "quoteChar" = "\""
)
STORED AS TEXTFILE;

-------------------------------------------------------------------------------------------------------------------------------------------

CREATE TABLE error_log (
  source_table STRING,
  column_name STRING,
  row_data STRING,
  error_type STRING
)
ROW FORMAT SERDE 'org.apache.hadoop.hive.serde2.OpenCSVSerde'
WITH SERDEPROPERTIES (
  "separatorChar" = ",",
  "quoteChar" = "\""
)
STORED AS TEXTFILE;