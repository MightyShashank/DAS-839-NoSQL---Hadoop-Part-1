-- Export the dwh as csv file to hdfs (run for hive on terminal)

INSERT OVERWRITE DIRECTORY '/output/dwh_college_data_csv'
ROW FORMAT DELIMITED
FIELDS TERMINATED BY ','
STORED AS TEXTFILE
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
FROM dwh_college_data_optimized;

-- Loading the csv to pig
dwh_college_data = LOAD '/output/dwh_college_data_csv' USING PigStorage(',') AS (
    student_id:chararray,
    student_name:chararray,
    course:chararray,
    period:chararray,
    program:chararray,
    instructor_email:chararray,
    faculty_name:chararray,
    enrollment_status:chararray,
    course_type:chararray,
    course_variant:chararray,
    course_credit:int,
    obtained_grade:chararray,
    out_of_grade:chararray,
    exam_result:chararray,
    num_classes_attended:int,
    num_classes_absent:int,
    avg_attendance_percent:float,
    batch:chararray
);

-- our 3 scripts

-- Script 1
filtered = FILTER dwh_college_data BY avg_attendance_percent IS NOT NULL;
projected = FOREACH filtered GENERATE student_id, course, period, avg_attendance_percent;
uniq_data = DISTINCT projected;

grouped = GROUP uniq_data BY course;

attendance_stats = FOREACH grouped {
    distinct_ids = DISTINCT uniq_data.student_id;
    GENERATE
        group AS course,
        COUNT(distinct_ids) AS total_students,
        AVG(uniq_data.avg_attendance_percent) AS avg_attendance;
};

result1 = FILTER attendance_stats BY total_students >= 10;
sorted1 = ORDER result1 BY avg_attendance DESC;
DUMP sorted1;



-- Script 2:
filtered_data = FILTER dwh_college_data BY obtained_grade IS NOT NULL AND obtained_grade != '';
unique_data = FOREACH filtered_data GENERATE student_id, course, period, faculty_name, obtained_grade;
graded_data = FOREACH unique_data GENERATE
    faculty_name,
    course,
    (CASE obtained_grade
        WHEN 'A' THEN 4.0F
        WHEN 'A-' THEN 3.7F
        WHEN 'B+' THEN 3.4F
        WHEN 'B' THEN 3.0F
        WHEN 'B-' THEN 2.7F
        WHEN 'C+' THEN 2.4F
        WHEN 'C' THEN 2.0F
        WHEN 'C-' THEN 1.7F
        WHEN 'D' THEN 1.0F
        ELSE 0.0F
    END) AS grade_score;
grouped_by_faculty = GROUP graded_data BY faculty_name;
final_result = FOREACH grouped_by_faculty {
    distinct_courses = DISTINCT graded_data.course;
    course_count = COUNT(distinct_courses);
    student_count = COUNT(graded_data);
    total_score = SUM(graded_data.grade_score);
    avg_score = (float) total_score / student_count;
 avg_grade_score = ((int)(avg_score * 100)) / 100.0;
    GENERATE
        group AS faculty_name,
        course_count AS courses_handled,
        student_count AS total_students_taught,
         avg_grade_score AS avg_grade_score;
};
sorted_result = ORDER final_result BY avg_grade_score DESC;
DUMP sorted_result;


-- script 3
filtered = FILTER dwh_college_data BY 
    (obtained_grade IS NOT NULL AND obtained_grade != '') AND 
    (avg_attendance_percent IS NOT NULL);
unique_data = DISTINCT FOREACH filtered GENERATE 
    student_id, student_name, course, period, 
    avg_attendance_percent, obtained_grade, course_credit;
grade_mapped = FOREACH unique_data GENERATE 
    student_id, 
    student_name,
    avg_attendance_percent,
    course_credit,
    (CASE obtained_grade
        WHEN 'A' THEN 4.0
        WHEN 'A-' THEN 3.7
        WHEN 'B+' THEN 3.4
        WHEN 'B' THEN 3.0
        WHEN 'B-' THEN 2.7
        WHEN 'C+' THEN 2.4
        WHEN 'C' THEN 2.0
        WHEN 'C-' THEN 1.7
        WHEN 'D' THEN 1.0
        ELSE 0.0
    END) AS grade_score;
student_group = GROUP grade_mapped BY (student_id, student_name);
student_stats = FOREACH student_group {
    total_credit = SUM(grade_mapped.course_credit);
    weighted_score = SUM(grade_mapped.grade_score * grade_mapped.course_credit);
    avg_grade_point = weighted_score / total_credit;
    total_attendance = AVG(grade_mapped.avg_attendance_percent);
    avg_gp_rounded = ((int)(avg_grade_point * 100)) / 100.0;
    attendance_rounded = ((int)(total_attendance * 100)) / 100.0;
    GENERATE 
        FLATTEN(group) AS (student_id, student_name),
        attendance_rounded AS avg_attendance,
        avg_gp_rounded AS avg_grade_point;
};
ow_performers = FILTER student_stats BY 
    avg_attendance < 75.0 AND avg_grade_point <= 2.7;
ordered_result = ORDER low_performers BY avg_attendance ASC, avg_grade_point ASC;
DUMP ordered_result;