CREATE TABLE dwh_college_data_optimized (
    student_id STRING,
    student_name STRING,
    course STRING,
    period STRING,
    program STRING,
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
PARTITIONED BY (batch STRING)
CLUSTERED BY (student_id) INTO 8 BUCKETS
ROW FORMAT SERDE 'org.apache.hadoop.hive.serde2.OpenCSVSerde'
WITH SERDEPROPERTIES (
  "separatorChar" = ",",
  "quoteChar" = "\""
)
STORED AS TEXTFILE;


-- Now insert:
INSERT INTO TABLE dwh_college_data_optimized
PARTITION (batch)
SELECT
    student_id,
    student_name,
    course,
    period,
    program,
    instructor_email,
    faculty_name,
    enrollment_status,
    course_type,
    course_variant,
    course_credit,
    obtained_grade,
    out_of_grade,
    exam_result,
    num_classes_attended,
    num_classes_absent,
    avg_attendance_percent,
    batch
FROM dwh_college_data;
