

:-dynamic student/2.
:-dynamic available_slots/1.
:-dynamic room_capacity/2.

%clear_knowledge_base
%Clears the knowledge base and prints the number of student,room,slot that has been cleared
clear_knowledge_base:-
	findall(X,student(_,_), L),					%put all students in a list 
	count(L,_,A),								%count the length of the list
	findall(Y,available_slots(_), K),			%put all the slots in a list
	count(K,_,B),								%count the number of slots
	findall(Z,room_capacity(_,_), M),			%find all rooms
	count(M,_,C),								%count the number of rooms
	write("student/2: "),						%print numbers that has been counted
	write(A),
	write(" available_slots/1: "),
	write(B),
	write(" room_capacity/2: "),
	write(C),
	retractall(student(_,_)), 					%clear the knowledge bases
	retractall(available_slots(_)), 
	retractall(room_capacity(_,_)),
	!.

%all_students(-StudentList)
%Finds all students and prints their numbers
all_students(X):- 
	findall(Y, student(Y,_), X),				%find all students and put them in a list
	!.											%there is no other possible list

%all_courses(-AllCourses)
%Finds all courses and prints their names 
all_courses(X):- 
	findall(Y, student(_,Y) , L),				%find all courses and put them in a list
	flatten(L,S),								%flatten the list to avoid a list of lists
	sort(S,X),									%sort the list for better organization and removing dublicates
	!.											%there is no other possible list

%all_rooms(-AllRooms)
%Finds all rooms and prints their names
all_rooms(X):-
	findall(Y,room_capacity(Y,_),X),			%find all rooms and put them in a list
	!.											%there is no other possible list

%student_count(-CourseID,+StudentCount)
%Finds the number of students that takes the course
student_count(CourseID,StudentCount):- 
	findall(Y, student(_,Y), L),				%put all the course lists of different students in a list
	flatten(L,S),								%flatten the list to avoid having a list of lists
	count(S,CourseID,StudentCount),				%count the number of appereances of the course
	!.											%there is no other possible number

%common_students(-Course1,-Course2,-Count)
%Counts the number of students that takes both courses
common_students(X,0,StudentCount).
common_students(CourseID1,CourseID2,StudentCount):-
	findall(Y, student(_,Y), L),
	take_first_list(CourseID1,CourseID2,L,StudentCount),
	!.											%there is no other possible number

%errors_for_plan(-Plan,Count)
%Counts the number of errors in a given final_plan
errors_for_plan([],ErrorCount).
errors_for_plan(FinalPlan,ErrorCount):-
	findall(X,(member(A,FinalPlan),nth0(2,A,Slot),member(B,FinalPlan),nth0(2,B,Slot),not(A = B),nth0(0,A,X)),L),	%find all the courses that have the same slot
	member(M,L),member(N,L),not(M = N),
	common_students(M,N,Common),			%check for common students for the courses with the same slots
	member(O,FinalPlan),
	nth0(0,O,C),
	nth0(1,O,R),
	check_room_capacity(C,R,Capacity),		%check room capacity for every exam place
	ErrorCount is Common + Capacity,		%error count is total of recent 2 numbers that had been counted
	!.										%there is no other possible number

%final_plan(-FinalPlan)
%Prints a final plan with no error
final_plan(FinalPlan):-
	all_courses(Allcourses),
	member(Course,Allcourses),
	room_capacity(Room,_),
	available_slots(Slots),
	member(Slot,Slots),
	findall(X,(check_room_capacity(Course,Room,Roomcount),Roomcount=0),FinalPlan).

%Increments given number by 1	
incr(X, X1) :-
    X1 is X+1.

%prints the given array
print_array([]):-write().
print_array([X]):-write(X).
print_array([X|T]):-write(X),write(,),print_array(T).

%count(-List,-Item,-Number)
%counts the number of appereances of the item in a list
count([],_,0).
count([X|Y],X,A):-count(Y,X,B),A is B+1.
count([X|Y],Z,B):-count(Y,Z,B),not(X=Z).

%take_first_list(-Course1,-Course2,+List,-Count)
%takes a list of list and counts the number of lists that have both items 
take_first_list(X,Y,[],0).
take_first_list(X,Y,[Head|Tail],Count1):-
	take_first_list(X,Y,Tail,Count2),				%starts the recursion until the end of the list
	member(X,Head),
	member(Y,Head),
	Count1 is Count2 + 1.							%if they are both member,increase count by 1
take_first_list(X,Y,[Head|Tail],Count1):-
	take_first_list(X,Y,Tail,Count1),
	(not(member(X,Head));not(member(Y,Head))).

%check_room_capacity(-Course,+Room,-Count)
%Checks if there is enough place for students taking the course
%returns
%	- 0 if there is enough place for students
%	- surplus number of students if there is no enough place
check_room_capacity(Course,Room,Count):-
	student_count(Course,Y),
	room_capacity(Room,X),
	(X < Y),
	Count is Y - X.
check_room_capacity(Course,Room,Count):-
	student_count(Course,Y),
	room_capacity(Room,X),
	(X >= Y),
	Count is 0.
	








	












