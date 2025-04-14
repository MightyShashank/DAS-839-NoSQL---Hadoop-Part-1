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