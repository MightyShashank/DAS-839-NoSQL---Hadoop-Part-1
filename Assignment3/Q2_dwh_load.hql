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
JOIN grade_roster_report g
  ON e.student_id = g.student_id
JOIN course_attendance a
  ON e.student_id = a.member_id;
