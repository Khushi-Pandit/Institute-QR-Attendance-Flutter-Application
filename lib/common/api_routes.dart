
String baseUrl = "http://192.168.239.121:3000/";

String signUpUrl = "${baseUrl}api/v1/users/add-student";
String loginUrl = "${baseUrl}api/v1/users/login";

String classSchedulesUrl = "${baseUrl}api/v1/course/scheduledClasses";

String allCoursesUrl = "${baseUrl}api/v1/students/getcoursesId";
String todayClassesUrl = "${baseUrl}api/v1/students/getTodaysClasses";
String studentCoursesUrl = "${baseUrl}api/v1/students/myCourses";
String attendanceDetailsUrl = "${baseUrl}api/v1/students/getCourseDetails";

String markAttendanceUrl = "${baseUrl}api/v1/students/markAttendance";