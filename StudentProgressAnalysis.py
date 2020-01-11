import tkinter as tk
import tkinter.font as tkFont
import tkinter.ttk as ttk
import tkinter.messagebox
import pandas as pd
import psycopg2 as db

students_header = ['student_id', 'department_id', 'is_major', 'student.email']
courses_header = ['Course Code', 'Course Name', 'Year and Term', 'Department Name', 'Section Name']
courses_students_header = ['Student ID', 'Student Name', 'Department Name', 'Student Email', 'Letter Grade', 'Average']
course_outcomes_header = ['Course Outcome Code', 'Explanation', 'Measured Average']
program_outcomes_header = ['Program Outcome Code', 'Explanation']

current_page = 0
# 0 for courses given by instructor and its students, 1 for course outcomes
current_view = 0
# selected row for course outcome -> program outcome
last_selected_row = []

masterSlaveD2 = pd.DataFrame()
masterSlaveD3 = pd.DataFrame()
master = None
masterColumn = None
masterOld = master
masterNewOld = None
screenWidth, screenHeight = 300, 325

msScreenWidth, msScreenHeight, msScreenX, msScreenY = 500, 1200, 0, 0

lArr = []


class MultiColumnListbox(object):
    """use a ttk.TreeView as a multicolumn ListBox"""

    def __init__(self, frame):
        self.tree = None

        self._setup_widgets(frame)
        self._build_tree()

    def selectItem(self, a):
        curItem = self.tree.focus()

    def redirectItem(self, a):
        curItem = self.tree.focus()
        if current_view == 1:
            students_list(self.tree.item(curItem)['values'])
        elif current_view == 2:
            list_course_outcome_by_given_by_instructor(self.tree.item(curItem)['values'])
        elif current_view == 3:
            list_program_outcome_by_given_co(self.tree.item(curItem)['values'])

    def _setup_widgets(self, container):
        # create a treeview with dual scrollbars
        self.tree = ttk.Treeview(columns=data_header, show="headings")

        self.tree.bind('<ButtonRelease-1>', self.selectItem)
        self.double_click_funcid = self.tree.bind('<Double-1>', self.redirectItem, "+")

        vsb = ttk.Scrollbar(orient="vertical",
                            command=self.tree.yview)
        hsb = ttk.Scrollbar(orient="horizontal",
                            command=self.tree.xview)
        self.tree.configure(yscrollcommand=vsb.set,
                            xscrollcommand=hsb.set)
        self.tree.grid(column=0, row=0, sticky='nsew', in_=container)
        vsb.grid(column=1, row=0, sticky='ns', in_=container)
        hsb.grid(column=0, row=1, sticky='ew', in_=container)
        container.grid_columnconfigure(0, weight=1)
        container.grid_rowconfigure(0, weight=1)

    def _build_tree(self):
        for col in data_header:
            self.tree.heading(col, text=col.title(),
                              command=lambda c=col: sortby(self.tree, c, 0))
            # adjust the column's width to the header string
            self.tree.column(col,
                             width=tkFont.Font().measure(col.title()))

        for item in data_list:
            self.tree.insert('', 'end', values=item)
            # adjust column's width if necessary to fit each value
            for ix, val in enumerate(item):
                col_w = tkFont.Font().measure(val)
                if self.tree.column(data_header[ix], width=None) < col_w:
                    self.tree.column(data_header[ix], width=col_w)


def sortby(tree, col, descending):
    """sort tree contents when a column header is clicked on"""
    # grab values to sort
    data = [(tree.set(child, col), child) \
            for child in tree.get_children('')]
    # if the data to be sorted is numeric change to float
    # data =  change_numeric(data)
    # now sort the data in place
    data.sort(reverse=descending)
    for ix, item in enumerate(data):
        tree.move(item[1], '', ix)
    # switch the heading so it will sort in the opposite direction
    tree.heading(col, command=lambda col=col: sortby(tree, col, \
                                                     int(not descending)))


students_data = []
courses_data = []

data_header = []
data_list = []

database_credidentals = {'host': 'ec2-46-137-120-243.eu-west-1.compute.amazonaws.com',
                         'database': 'dq5h1isfnp50m',
                         'user': 'wgkcsgtxgehttt',
                         'password': '53392ce5f1454730048afcdb64bd0bb3235595bd86dab90d3d1c7613b7ce16d1'}

düdük = db.connect(host=database_credidentals['host'], database=database_credidentals['database'],
                   user=database_credidentals['user'], password=database_credidentals['password'])
loginCheckQuerry = 'SELECT * FROM public.user'
data = pd.read_sql(loginCheckQuerry, düdük)


def update_row_col(db_data, type):
    global data_header
    global data_list
    global listbox
    global mainarea
    global current_view, current_page
    data_list = []
    if current_page == 3 or current_page == 5:
        return None
    if type == 2:
        data_header = courses_header
        for i in db_data:
            data_list.append((i[0], i[1], i[2], i[3], i[4]))
    if type == 3:
        data_header = courses_students_header
        for i in db_data:
            data_list.append((i[0], i[1], i[2], i[3], i[4], i[5]))
    if type == 4:
        data_header = course_outcomes_header
        for i in db_data:
            data_list.append((i[0], i[1], i[2]))
    if type == 5:
        data_header = program_outcomes_header
        for i in db_data:
            data_list.append((i[0], i[1]))
    try:
        listbox = MultiColumnListbox(mainarea)
    except:
        print("error on update_row_col")


def login_button():
    global email, password, current_page, loginWindow
    email = str(email_.get())
    password = str(password_.get())
    indexOfLogin = None
    current_page = 1
    try:
        indexOfLogin = data['email'].index[data['email'].str.contains(pat="^" + email + "$", regex=True)].values.min()
    except(Exception):
        pass

    if (indexOfLogin == None):
        tk.messagebox.showerror("Error", "There is no account corresponding to that e-mail.")
        email = None

    else:
        if (password == data['password'].iloc[indexOfLogin]):

            neededMail = str(data.email.iloc[indexOfLogin])
            roleCheckQuerry = "Select email from public.instructor"
            newData = pd.read_sql(roleCheckQuerry, düdük)
            isInstructor = newData['email'].str.contains(pat="^" + neededMail + "$", regex=True).any()

            if (isInstructor):
                loginWindow.destroy()

            else:
                tk.messagebox.showerror("Error", "You don't have permission")
                email = None
        else:
            tk.messagebox.showerror("Error", "Wrong Password")
            email = None


def list_courses_given_by_instructor(type):
    global current_page, current_view
    current_view = type
    masterSlaveQ1 = """select course.code, course.name, course.year_and_term, department.name, section.name
                                            from course
                                            join department on course.department_id = department.id
                                            join section on course.id = section.course_id
                                            join instructors_gives_sections on section.id = instructors_gives_sections.section_id
                                            where instructor_email = '{neededMail}'""".format(neededMail=email)
    masterSlaveD1 = pd.read_sql(masterSlaveQ1, düdük)
    current_page = 2
    update_row_col(masterSlaveD1.values.tolist(), 2)


def students_list(selected_row):
    global current_page, current_view
    # ilk master slave datası
    masterSlaveQ1 = """select student.student_id, "user".name, department.name, student.email, students_takes_sections.letter_grade, students_takes_sections.average
                            from student
                            join "user" on student.email = "user".email
                            join students_takes_sections on student.student_id = students_takes_sections.student_id
                            join section on students_takes_sections.section_id = section.id
                            join department on student.department_id = department.id
                            join instructors_gives_sections on section.id = instructors_gives_sections.section_id
                            join instructor on instructors_gives_sections.instructor_email = instructor.email
                            join course on section.course_id = course.id
                            where course.name='{course_name}' and course.year_and_term='{course_year_and_term}' and section.name='{section_name}' and instructor.email='{neededMail}'""".format(
        neededMail=email, section_name=selected_row[4], course_year_and_term=selected_row[2],
        course_name=selected_row[1])

    masterSlaveD1 = pd.read_sql(masterSlaveQ1, düdük)
    current_view = 1
    update_row_col(masterSlaveD1.values.tolist(), 3)
    current_page = 3



def list_course_outcome_by_given_by_instructor(selected_row):
    global current_page, last_selected_row, current_view
    masterSlaveQ1 = """select course_outcome.code, course_outcome.explanation, course_outcome.measured_average
                            from instructor
                            join instructors_gives_sections on instructor.email = instructors_gives_sections.instructor_email
                            join section on instructors_gives_sections.section_id = section.id
                            join course on section.course_id = course.id
                            join course_outcome on course.id = course_outcome.course_id
                            where course.year_and_term='{course_year_and_term}' and course.name='{course_name}' and instructor_email='{neededMail}'""".format(
        neededMail=email, course_name=selected_row[1], course_year_and_term=selected_row[2])
    masterSlaveD1 = pd.read_sql(masterSlaveQ1, düdük)
    current_page = 4
    current_view = 3
    last_selected_row = selected_row
    update_row_col(masterSlaveD1.values.tolist(), 4)


def list_program_outcome_by_given_co(selected_row):
    global current_page, last_selected_row, current_view

    masterSlaveQ1 = """select program_outcome.code, program_outcome.explanation
                            from instructor
                            join instructors_gives_sections on instructor.email = instructors_gives_sections.instructor_email
                            join section on instructors_gives_sections.section_id = section.id
                            join course on section.course_id = course.id
                            join course_outcome on course.id = course_outcome.course_id
                            join program_outcomes_provides_course_outcomes on course_outcome.id = program_outcomes_provides_course_outcomes.course_outcome_id
                            join program_outcome on program_outcomes_provides_course_outcomes.program_outcome_id = program_outcome.id
                            where course.year_and_term='{course_year_and_term}' and course.name='{course_name}' and course_outcome.code='{course_outcome_code}' and instructor_email='{neededMail}'""".format(
        neededMail=email, course_name=last_selected_row[1], course_year_and_term=last_selected_row[2],
        course_outcome_code=selected_row[0])
    masterSlaveD1 = pd.read_sql(masterSlaveQ1, düdük)
    update_row_col(masterSlaveD1.values.tolist(), 5)
    current_page = 5


def master_slave_3(msD, m1, mC, m2, mC2):
    # ekran size ayarları
    ms1RowNumber = msD.shape[0]
    ms1ColNumber = msD.shape[1]

    lbXPlaceConstant = int(msScreenWidth / ms1ColNumber)
    lbYPlaceConstant = int(msScreenHeight / 5)
    lbWidth = int(msScreenWidth / 29)
    lbHeight = int(msScreenHeight / 40)

    # buton için print fonksiyonu editlenecek
    # kartalmu@mef.edu.tr, email döndürür
    lArr = []

    # Master Slave stutent to student or student to course
    def print_table_to_screen1():
        global masterNewOld, masterSlaveD3
        for i in range(len(lArr)):
            clicked_items = lArr[i].curselection()
            if len(clicked_items) != 0:
                for item in clicked_items:
                    master, masterColumn = lArr[i].get(item), (msD.columns)[i]
                    break
                break

        if mC == 'email':
            if mC2 == 'code':
                if masterColumn == 'examname':
                    masterSlaveQ4 = """select  public.grading_tool.question_number, public.student_answers_grading_tool.grade
                                    from student
                                    join students_takes_sections on student.student_id = students_takes_sections.student_id
                                    join section on students_takes_sections.section_id = section.id
                                    join course on section.course_id = course.id
                                    join assessment on course.id = assessment.course_id
                                    join grading_tool on assessment.id = grading_tool.assessment_id
                                    join student_answers_grading_tool on grading_tool.id = student_answers_grading_tool.grading_tool_id
                                    where student_answers_grading_tool.student_id=student.student_id 
                                    AND student.email = '{smail}'
                                    AND course.code = '{cc}'
                                    AND assessment.name='{an}'""".format(cc=m2, smail=m1, an=master)
            else:
                if masterColumn == 'examname':
                    masterSlaveQ4 = """select  public.grading_tool.question_number, public.student_answers_grading_tool.grade
                                                from student
                                                join students_takes_sections on student.student_id = students_takes_sections.student_id
                                                join section on students_takes_sections.section_id = section.id
                                                join course on section.course_id = course.id
                                                join assessment on course.id = assessment.course_id
                                                join grading_tool on assessment.id = grading_tool.assessment_id
                                                join student_answers_grading_tool on grading_tool.id = student_answers_grading_tool.grading_tool_id
                                                where student_answers_grading_tool.student_id=student.student_id 
                                                AND student.email = '{smail}'
                                                AND course.name = '{cc}'
                                                AND assessment.name='{an}'""".format(cc=m2, smail=m1, an=master)

        else:
            if mC2 == 'code':
                if masterColumn == 'examname':
                    masterSlaveQ4 = """select  public.grading_tool.question_number, public.student_answers_grading_tool.grade
                                    from student
                                    join students_takes_sections on student.student_id = students_takes_sections.student_id
                                    join section on students_takes_sections.section_id = section.id
                                    join course on section.course_id = course.id
                                    join assessment on course.id = assessment.course_id
                                    join grading_tool on assessment.id = grading_tool.assessment_id
                                    join student_answers_grading_tool on grading_tool.id = student_answers_grading_tool.grading_tool_id
                                    where student_answers_grading_tool.student_id=student.student_id 
                                    AND student.student_id = '{smail}'
                                    AND course.code = '{cc}'
                                    AND assessment.name='{an}'""".format(cc=m2, smail=m1, an=master)
            else:
                if masterColumn == 'examname':
                    masterSlaveQ4 = """select  public.grading_tool.question_number, public.student_answers_grading_tool.grade
                                                from student
                                                join students_takes_sections on student.student_id = students_takes_sections.student_id
                                                join section on students_takes_sections.section_id = section.id
                                                join course on section.course_id = course.id
                                                join assessment on course.id = assessment.course_id
                                                join grading_tool on assessment.id = grading_tool.assessment_id
                                                join student_answers_grading_tool on grading_tool.id = student_answers_grading_tool.grading_tool_id
                                                where student_answers_grading_tool.student_id=student.student_id 
                                                AND student.student_id = '{smail}'
                                                AND course.name = '{cc}'
                                                AND assessment.name='{an}'""".format(cc=m2, smail=m1, an=master)

        masterSlaveD4 = pd.read_sql(masterSlaveQ4, düdük)

        clean_frame()
        button_next.destroy()

        master_slave_3(masterSlaveD4, m1, mC, m2, mC2)  # DEĞİŞ##################################

    for i in range(ms1ColNumber):
        l = tk.Listbox(mainarea, width=lbWidth, height=lbHeight, selectmode='single')
        for j in range(ms1RowNumber):
            l.insert(j, msD.iloc[j, i])
        # l.place(x=lbXPlaceConstant * (i), y=lbYPlaceConstant)
        l.grid(row=2, column=i, padx=(20, 20), pady=(10, 30))

        lab1 = tk.Label(mainarea, width=int(lbWidth / int(lbWidth / 13)), text=msD.columns[i], bg='white')
        lab1.config(font=("Helvetica", int(lbWidth)))

        lab1.grid(row=1, column=i, padx=(20, 20), pady=(100, 0))
        # lab1.place(x=lbXPlaceConstant * (i), y=lbYPlaceConstant, anchor='sw')

        lArr.append(l)

        # seçip yeni ekrana geçmek için gerekli value
    button_next_frame = tk.Frame(mainarea)
    button_next_frame.grid(row=0, column=0, pady=(30, 0))
    button_next = tk.Button(button_next_frame, text="Next", command=print_table_to_screen1)
    button_next.pack(anchor='center')


def master_slave_2(msD, m1, mC):
    # ekran size ayarları
    ms1RowNumber = msD.shape[0]
    ms1ColNumber = msD.shape[1]

    lbXPlaceConstant = int(msScreenWidth / ms1ColNumber)
    lbYPlaceConstant = int(msScreenHeight / 5)
    lbWidth = int(msScreenWidth / 29)
    lbHeight = int(msScreenHeight / 40)

    # buton için print fonksiyonu editlenecek
    # kartalmu@mef.edu.tr, email döndürür
    lArr = []

    # Master Slave stutent to student or student to course
    def print_table_to_screen1():
        global masterNewOld, masterSlaveD3
        for i in range(len(lArr)):
            clicked_items = lArr[i].curselection()
            if len(clicked_items) != 0:
                for item in clicked_items:
                    master, masterColumn = lArr[i].get(item), (msD.columns)[i]
                    break
                break

        if mC == 'email':
            if masterColumn == 'code':
                masterSlaveQ3 = """select assessment.name as ExamName, percentage from assessment,course where assessment.course_id = course.id AND
                                        course.code = '{coursecode}'""".format(coursecode=master, smail=m1)
                masterSlaveD3 = pd.read_sql(masterSlaveQ3, düdük)

                clean_frame()
                button_next.destroy()

                master_slave_3(masterSlaveD3, m1, mC, master, masterColumn)

            elif masterColumn == 'name':
                masterSlaveQ3 = """select assessment.name as ExamName, percentage from assessment,course where assessment.course_id = course.id AND
                                        course.name = '{coursename}'""".format(coursename=master, smail=m1)
                masterSlaveD3 = pd.read_sql(masterSlaveQ3, düdük)

                clean_frame()
                button_next.destroy()

                master_slave_3(masterSlaveD3, m1, mC, master, masterColumn)

            elif masterColumn == 'year_and_term':

                if (masterSlaveD3.size == 0 or masterSlaveD3.shape[1] == 4):
                    masterNewOld = master
                    masterSlaveQ3 = """select course.code,course.name, course.credit
                            from student, course,students_takes_sections,section  
                            where students_takes_sections.section_id = section.id 
                            AND student.student_id = students_takes_sections.student_id 
                            AND course.id = section.course_id 
                            AND student.email = '{smail}' 
                            AND course.year_and_term = '{master}'""".format(master=master, smail=m1)

                else:
                    masterSlaveQ3 = """select course.code,course.name
                            from student, course,students_takes_sections,section  
                            where students_takes_sections.section_id = section.id 
                            AND student.student_id = students_takes_sections.student_id 
                            AND course.id = section.course_id 
                            AND student.email = '{smail}' 
                            AND course.year_and_term = '{masterNewOld}'
                            AND course.credit = '{credit}'""".format(masterNewOld=master, smail=m1, credit=masterNewOld)

                masterSlaveD3 = pd.read_sql(masterSlaveQ3, düdük)

                clean_frame()
                button_next.destroy()

                master_slave_2(masterSlaveD3, m1, mC)

            elif masterColumn == 'credit':
                if (masterSlaveD3.size == 0 or masterSlaveD3.shape[1] == 4):
                    masterNewOld = master
                    masterSlaveQ3 = """select course.code,course.name, course.year_and_term
                            from student, course,students_takes_sections,section  
                            where students_takes_sections.section_id = section.id 
                            AND student.student_id = students_takes_sections.student_id 
                            AND course.id = section.course_id 
                            AND student.email = '{smail}' 
                            AND course.credit= '{master}'""".format(master=master, smail=m1)

                else:
                    masterSlaveQ3 = """select course.code,course.name
                            from student, course,students_takes_sections,section  
                            where students_takes_sections.section_id = section.id 
                            AND student.student_id = students_takes_sections.student_id 
                            AND course.id = section.course_id 
                            AND student.email = '{smail}' 
                            AND course.year_and_term = '{masterNewOld}'
                            AND course.credit = '{credit}'""".format(masterNewOld=masterNewOld, smail=m1, credit=master)

                masterSlaveD3 = pd.read_sql(masterSlaveQ3, düdük)

                clean_frame()
                button_next.destroy()

                master_slave_2(masterSlaveD3, m1, mC)

        elif mC == 'student_id':

            if masterColumn == 'code':
                masterSlaveQ3 = """select assessment.name as ExamName, percentage from assessment,course where assessment.course_id = course.id AND
                                        course.code = '{coursecode}'""".format(coursecode=master, smail=m1)
                masterSlaveD3 = pd.read_sql(masterSlaveQ3, düdük)

                clean_frame()
                button_next.destroy()

                master_slave_3(masterSlaveD3, m1, mC, master, masterColumn)

            elif masterColumn == 'name':
                masterSlaveQ3 = """select assessment.name as ExamName, percentage from assessment,course where assessment.course_id = course.id AND
                                        course.name = '{coursename}'""".format(coursename=master, smail=m1)
                masterSlaveD3 = pd.read_sql(masterSlaveQ3, düdük)

                clean_frame()
                button_next.destroy()

                master_slave_3(masterSlaveD3, m1, mC, master, masterColumn)

            elif masterColumn == 'year_and_term':

                if (masterSlaveD3.size == 0 or masterSlaveD3.shape[1] == 4):
                    masterNewOld = master
                    masterSlaveQ3 = """select course.code,course.name, course.credit
                            from student, course,students_takes_sections,section  
                            where students_takes_sections.section_id = section.id 
                            AND student.student_id = students_takes_sections.student_id 
                            AND course.id = section.course_id 
                            AND student.student_id = '{smail}' 
                            AND course.year_and_term = '{master}'""".format(master=master, smail=m1)

                else:
                    masterSlaveQ3 = """select course.code,course.name
                            from student, course,students_takes_sections,section  
                            where students_takes_sections.section_id = section.id 
                            AND student.student_id = students_takes_sections.student_id 
                            AND course.id = section.course_id 
                            AND student.student_id = '{smail}' 
                            AND course.year_and_term = '{masterNewOld}'
                            AND course.credit = '{credit}'""".format(masterNewOld=master, smail=m1, credit=masterNewOld)

                masterSlaveD3 = pd.read_sql(masterSlaveQ3, düdük)

                clean_frame()
                button_next.destroy()

                master_slave_2(masterSlaveD3, m1, mC)

            elif masterColumn == 'credit':
                if (masterSlaveD3.size == 0 or masterSlaveD3.shape[1] == 4):
                    masterNewOld = master
                    masterSlaveQ3 = """select course.code,course.name, course.year_and_term
                            from student, course,students_takes_sections,section  
                            where students_takes_sections.section_id = section.id 
                            AND student.student_id = students_takes_sections.student_id 
                            AND course.id = section.course_id 
                            AND student.student_id = '{smail}' 
                            AND course.credit= '{master}'""".format(master=master, smail=m1)

                else:
                    masterSlaveQ3 = """select course.code,course.name
                            from student, course,students_takes_sections,section  
                            where students_takes_sections.section_id = section.id 
                            AND student.student_id = students_takes_sections.student_id 
                            AND course.id = section.course_id 
                            AND student.student_id = '{smail}' 
                            AND course.year_and_term = '{masterNewOld}'
                            AND course.credit = '{credit}'""".format(masterNewOld=masterNewOld, smail=m1, credit=master)

                masterSlaveD3 = pd.read_sql(masterSlaveQ3, düdük)

                clean_frame()
                button_next.destroy()

                master_slave_2(masterSlaveD3, m1, mC)

    for i in range(ms1ColNumber):
        l = tk.Listbox(mainarea, width=lbWidth, height=lbHeight, selectmode='single')
        for j in range(ms1RowNumber):
            l.insert(j, msD.iloc[j, i])
        # l.place(x=lbXPlaceConstant * (i), y=lbYPlaceConstant)
        l.grid(row=2, column=i, padx=(20, 20), pady=(10, 30))

        lab1 = tk.Label(mainarea, width=int(lbWidth / int(lbWidth / 13)), text=msD.columns[i], bg='white')
        lab1.config(font=("Helvetica", int(lbWidth)))
        lab1.grid(row=1, column=i, padx=(20, 20), pady=(100, 0))
        # lab1.place(x=lbXPlaceConstant * (i), y=lbYPlaceConstant, anchor='sw')

        lArr.append(l)

        # seçip yeni ekrana geçmek için gerekli value
    button_next_frame = tk.Frame(mainarea)
    button_next_frame.grid(row=0, column=0, columnspan=4, pady=(30, 0))
    button_next = tk.Button(button_next_frame, text="Next", command=print_table_to_screen1)
    button_next.pack(anchor='center')


def master_slave(masterSlaveD1):
    # ekran size ayarları
    ms1RowNumber = masterSlaveD1.shape[0]
    ms1ColNumber = masterSlaveD1.shape[1]

    lbXPlaceConstant = int(msScreenWidth / ms1ColNumber)
    lbYPlaceConstant = int(msScreenHeight / 5)
    lbWidth = int(msScreenWidth / 29)
    lbHeight = int(msScreenHeight / 40)

    # buton için print fonksiyonu editlenecek
    # kartalmu@mef.edu.tr, email döndürür
    lArr = []

    # Master Slave stutent to student or student to course
    def print_table_to_screen():
        global master
        global masterColumn
        global masterSlaveD2
        global masterOld

        for i in range(len(lArr)):
            clicked_items = lArr[i].curselection()
            if len(clicked_items) != 0:
                for item in clicked_items:
                    master, masterColumn = lArr[i].get(item), (masterSlaveD1.columns)[i]
                    break
                break

        if masterColumn == 'student_id':
            master = master.strip()
            masterSlaveQ2 = """select course.code,course.name, course.year_and_term , course.credit
            from student, course,students_takes_sections,section 
            where students_takes_sections.section_id = section.id 
            AND student.student_id = students_takes_sections.student_id 
            AND course.id = section.course_id 
            AND student.student_id LIKE '{studentID}' 
            AND student.instructor_email ='{instructorEmail}'""".format(instructorEmail=email,
                                                                        studentID="%" + master + "%")
            masterSlaveD2 = pd.read_sql(masterSlaveQ2, düdük)

            # ekranı temizle
            clean_frame()
            button_next.destroy()

            master_slave_2(masterSlaveD2, master, masterColumn)

        elif masterColumn == 'email':

            master = master.strip()
            masterSlaveQ2 = """select course.code,course.name, course.year_and_term , course.credit
                        from student, course,students_takes_sections,section  
                        where students_takes_sections.section_id = section.id 
                        AND student.student_id = students_takes_sections.student_id 
                        AND course.id = section.course_id 
                        AND student.email = '{master}' 
                        AND student.instructor_email ='{instructorEmail}'""".format(instructorEmail=email,
                                                                                    master=master)
            masterSlaveD2 = pd.read_sql(masterSlaveQ2, düdük)

            # ekranı temizle
            clean_frame()
            button_next.destroy()

            master_slave_2(masterSlaveD2, master, masterColumn)

        elif masterColumn == 'is_major':

            master = master.strip()
            if (masterSlaveD2.size == 0 or masterSlaveD2.shape[1] == 4):
                masterOld = master
                masterSlaveQ2 = """select student_id,department_id,student.email from student 
                where student.instructor_email ='{neededMail}' 
                AND student.is_major = '{ismajor}'""".format(ismajor=master, neededMail=email)
            else:
                masterSlaveQ2 = """select student_id,student.email from student 
                                where student.instructor_email ='{neededMail}' 
                                AND student.is_major = '{ismajor}'
                                AND student.department_id = '{departmentID}'""".format(ismajor=master, neededMail=email,
                                                                                       departmentID=masterOld)
            masterSlaveD2 = pd.read_sql(masterSlaveQ2, düdük)

            # ekranı temizle
            clean_frame()
            button_next.destroy()

            # lbXPlaceConstant = int(msScreenWidth / ms1ColNumber-1)
            master_slave(masterSlaveD2)

        elif masterColumn == 'department_id':

            master = master.strip()
            if (masterSlaveD2.size == 0 or masterSlaveD2.shape[1] == 4):
                masterOld = master
                masterSlaveQ2 = """select student_id,is_major,student.email from student 
                where student.instructor_email ='{neededMail}' 
                AND student.department_id = '{ismajor}'""".format(ismajor=master, neededMail=email)
            else:
                masterSlaveQ2 = """select student_id,student.email from student 
                                                            where student.instructor_email ='{neededMail}' 
                                                            AND student.department_id = '{departmentID}'
                                                            AND student.is_major = '{ismajor}'""".format(
                    ismajor=masterOld, departmentID=master, neededMail=email)

            masterSlaveD2 = pd.read_sql(masterSlaveQ2, düdük)

            # ekranı temizle
            clean_frame()  ###place_slaves değil grid
            button_next.destroy()

            # lbXPlaceConstant = int(msScreenWidth / ms1ColNumber-1)
            master_slave(masterSlaveD2)

    # gelen dataya göre listboxları oluşturma
    for i in range(ms1ColNumber):
        l = tk.Listbox(mainarea, width=lbWidth, height=lbHeight, selectmode='single')
        for j in range(ms1RowNumber):
            l.insert(j, masterSlaveD1.iloc[j, i])

        l.grid(row=2, column=i, padx=(20, 20), pady=(10, 30))
        # l.place(x=lbXPlaceConstant * (i), y=lbYPlaceConstant)

        lab1 = tk.Label(mainarea, width=int(lbWidth / int(lbWidth / 13)), text=masterSlaveD1.columns[i], bg='white')
        lab1.config(font=("Helvetica", int(lbWidth)))
        lab1.grid(row=1, column=i, padx=(20, 20), pady=(100, 0))

        # lab1.place(x=lbXPlaceConstant * (i) , y=lbYPlaceConstant, anchor='sw')

        lArr.append(l)

    # seçip yeni ekrana geçmek için gerekli value
    button_next_frame = tk.Frame(mainarea)
    button_next_frame.grid(row=0, column=0, columnspan=4, pady=(30, 0))
    button_next = tk.Button(button_next_frame, text="Next", command=print_table_to_screen)
    button_next.pack(anchor='center')


def clean_frame():
    for i in mainarea.grid_slaves(): i.destroy()  ###place_slaves değil grid


def show_other_view():
    global lArr, masterNewOld, masterOld, masterSlaveD2, masterSlaveD3, master, masterColumn
    lArr, masterNewOld, masterOld, masterSlaveD2, masterSlaveD3, master, masterColumn = [], None, None, pd.DataFrame(), pd.DataFrame(), None, None
    clean_frame()
    masterSlaveQ1 = """select student_id,department_id,is_major,student.email from student where student.instructor_email ='{neededMail}'""".format(
        neededMail=email)
    masterSlaveD1 = pd.read_sql(masterSlaveQ1, düdük)

    mainarea.configure(bg='white')
    master_slave(masterSlaveD1)


loginWindow = tk.Tk()
screenWidth, screenHeight = 300, 325

loginWindow.geometry(("{}x{}+{}+{}".format(screenWidth, screenHeight, 550, 320)))
loginWindow.resizable(False, False)
loginWindow.title("Student Performance Analysis")
loginWindow.configure(bg='white')

# myCanvas = tk.Canvas(loginWindow)
# myCanvas.config(width=screenWidth, height=screenHeight, bg='white')

entryEmail = tk.StringVar()
email_ = tk.Entry(loginWindow, textvariable=entryEmail)
entryEmail.set("abc@email.com")
email_.place(x=screenWidth / 1.5, y=0.5 * screenHeight / 3, anchor='center')

entry_password = tk.StringVar()
password_ = tk.Entry(loginWindow, textvariable=entry_password, show="*")
entry_password.set("deneme123")
password_.place(x=screenWidth / 1.5, y=1 * screenHeight / 3, anchor='center')

button_N = tk.Button(loginWindow, text="Enter", height=int(screenHeight / 108), width=int(screenWidth / 23),
                     command=login_button)
button_N.place(x=screenWidth / 2, y=1.5 * screenHeight / 2.3, anchor='center')

lab = tk.Label(loginWindow, width=int(screenWidth / 25), text="E-Mail: ", bg='white')
lab.config(font=("Courier", int(screenWidth / 25)))
lab.place(x=screenWidth / 4, y=0.5 * screenHeight / 3, anchor='center')

lab2 = tk.Label(loginWindow, width=int(screenWidth / 25), text="Password: ", bg='white')
lab2.config(font=("Courier", int(screenWidth / 25)))
lab2.place(x=screenWidth / 4, y=1 * screenHeight / 3, anchor='center')

loginWindow.mainloop()

if email != None:
    root = tk.Tk()
    root.title("Multicolumn Treeview/Listbox")
    # sidebar
    sidebar = tk.Frame(root, width=200, bg='white', height=500, relief='sunken', borderwidth=2)
    sidebar.pack(fill='both', side='left', anchor='nw')
    sidebar_button_frame = tk.Frame(sidebar)
    sidebar_button_frame.grid(row=0, column=0, padx=30, pady=60)
    b = tk.Button(sidebar_button_frame, text='Academic Advisee List', command=lambda: show_other_view())
    b.grid(row=0, column=0, pady=(20, 20))

    c = tk.Button(sidebar_button_frame, text='Courses Given',
                  command=lambda: [clean_frame(), list_courses_given_by_instructor(1)])
    c.grid(row=1, column=0, pady=(20, 20))

    d = tk.Button(sidebar_button_frame, text='Course Outcomes',
                  command=lambda: [clean_frame(), list_courses_given_by_instructor(2)])
    d.grid(row=2, column=0, pady=(20, 20))

    # main content area
    mainarea = tk.Frame(root, bg='#CCC', width=500, height=500)
    mainarea.pack(expand=True, fill='both', side='right')

    # container.pack(fill='both', expand=True)
    listbox = MultiColumnListbox(mainarea)
    root.mainloop()

else:
    pass

try:
    düdük.close()
except Exception as e:
    print(e)