--
-- PostgreSQL database dump
--

-- Dumped from database version 11.4
-- Dumped by pg_dump version 11.4

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

DROP DATABASE "spa analyzer";
--
-- Name: spa analyzer; Type: DATABASE; Schema: -; Owner: postgres
--

CREATE DATABASE "spa analyzer" WITH TEMPLATE = template0 ENCODING = 'UTF8' LC_COLLATE = 'Turkish_Turkey.1254' LC_CTYPE = 'Turkish_Turkey.1254';


ALTER DATABASE "spa analyzer" OWNER TO postgres;

\connect -reuse-previous=on "dbname='spa analyzer'"

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: role_enum; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.role_enum AS ENUM (
    '1',
    '2',
    '3',
    '4'
);


ALTER TYPE public.role_enum OWNER TO postgres;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: admin; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.admin (
    id integer NOT NULL,
    user_id integer NOT NULL
);


ALTER TABLE public.admin OWNER TO postgres;

--
-- Name: admin_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.admin_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.admin_id_seq OWNER TO postgres;

--
-- Name: admin_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.admin_id_seq OWNED BY public.admin.id;


--
-- Name: assessment; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.assessment (
    id integer NOT NULL,
    name character varying(50) NOT NULL,
    percentage double precision DEFAULT 0 NOT NULL,
    course_id integer NOT NULL
);


ALTER TABLE public.assessment OWNER TO postgres;

--
-- Name: course; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.course (
    id integer NOT NULL,
    code character varying(50) NOT NULL,
    year_and_term character varying(50) NOT NULL,
    department_id integer NOT NULL,
    name character varying(200) NOT NULL,
    credit integer NOT NULL,
    date_time character varying(250)
);


ALTER TABLE public.course OWNER TO postgres;

--
-- Name: course_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.course_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.course_id_seq OWNER TO postgres;

--
-- Name: course_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.course_id_seq OWNED BY public.course.id;


--
-- Name: course_outcome; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.course_outcome (
    id integer NOT NULL,
    explanation character varying(50) NOT NULL,
    code character varying(10) NOT NULL,
    survey_average double precision DEFAULT 0 NOT NULL,
    measured_average double precision DEFAULT 0 NOT NULL,
    course_id integer
);


ALTER TABLE public.course_outcome OWNER TO postgres;

--
-- Name: course_outcome_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.course_outcome_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.course_outcome_id_seq OWNER TO postgres;

--
-- Name: course_outcome_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.course_outcome_id_seq OWNED BY public.course_outcome.id;


--
-- Name: courses_given_by_instructor; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.courses_given_by_instructor (
    id integer NOT NULL,
    instructor_id integer NOT NULL,
    course_id integer NOT NULL,
    section character varying(50) DEFAULT 'section1'::character varying NOT NULL
);


ALTER TABLE public.courses_given_by_instructor OWNER TO postgres;

--
-- Name: courses_given_by_instructor_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.courses_given_by_instructor_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.courses_given_by_instructor_id_seq OWNER TO postgres;

--
-- Name: courses_given_by_instructor_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.courses_given_by_instructor_id_seq OWNED BY public.courses_given_by_instructor.id;


--
-- Name: courses_taken_by_students; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.courses_taken_by_students (
    id integer NOT NULL,
    lettergrade character varying(5) NOT NULL,
    average double precision DEFAULT 0 NOT NULL,
    course_id integer NOT NULL,
    student_id character varying(50) NOT NULL,
    section character varying(50) DEFAULT 'section1'::character varying NOT NULL
);


ALTER TABLE public.courses_taken_by_students OWNER TO postgres;

--
-- Name: courses_taken_by_students_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.courses_taken_by_students_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.courses_taken_by_students_id_seq OWNER TO postgres;

--
-- Name: courses_taken_by_students_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.courses_taken_by_students_id_seq OWNED BY public.courses_taken_by_students.id;


--
-- Name: department; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.department (
    id integer NOT NULL,
    name character varying(200) NOT NULL,
    faculty_id integer NOT NULL
);


ALTER TABLE public.department OWNER TO postgres;

--
-- Name: department_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.department_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.department_id_seq OWNER TO postgres;

--
-- Name: department_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.department_id_seq OWNED BY public.department.id;


--
-- Name: departments_has_instructors; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.departments_has_instructors (
    id integer NOT NULL,
    department_id integer NOT NULL,
    instructor_id integer NOT NULL
);


ALTER TABLE public.departments_has_instructors OWNER TO postgres;

--
-- Name: departments_has_instructors_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.departments_has_instructors_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.departments_has_instructors_id_seq OWNER TO postgres;

--
-- Name: departments_has_instructors_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.departments_has_instructors_id_seq OWNED BY public.departments_has_instructors.id;


--
-- Name: faculty; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.faculty (
    id integer NOT NULL,
    name character varying(200) NOT NULL,
    university_name character varying(50) NOT NULL
);


ALTER TABLE public.faculty OWNER TO postgres;

--
-- Name: faculty_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.faculty_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.faculty_id_seq OWNER TO postgres;

--
-- Name: faculty_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.faculty_id_seq OWNED BY public.faculty.id;


--
-- Name: grading_tool; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.grading_tool (
    id integer NOT NULL,
    assessment_id integer NOT NULL,
    question_number integer NOT NULL,
    percentage double precision DEFAULT 0 NOT NULL
);


ALTER TABLE public.grading_tool OWNER TO postgres;

--
-- Name: grading_tool_covers_course_outcome; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.grading_tool_covers_course_outcome (
    id integer NOT NULL,
    grading_tool_id integer NOT NULL,
    course_outcome_id integer NOT NULL
);


ALTER TABLE public.grading_tool_covers_course_outcome OWNER TO postgres;

--
-- Name: instructor; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.instructor (
    id integer NOT NULL,
    role public.role_enum DEFAULT '1'::public.role_enum NOT NULL,
    user_id integer NOT NULL
);


ALTER TABLE public.instructor OWNER TO postgres;

--
-- Name: instructor_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.instructor_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.instructor_id_seq OWNER TO postgres;

--
-- Name: instructor_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.instructor_id_seq OWNED BY public.instructor.id;


--
-- Name: program_outcome; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.program_outcome (
    id integer NOT NULL,
    explanation character varying(50) NOT NULL,
    code character varying(10) NOT NULL,
    department_id integer NOT NULL
);


ALTER TABLE public.program_outcome OWNER TO postgres;

--
-- Name: program_outcome_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.program_outcome_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.program_outcome_id_seq OWNER TO postgres;

--
-- Name: program_outcome_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.program_outcome_id_seq OWNED BY public.program_outcome.id;


--
-- Name: program_outcomes_provides_course_outcomes; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.program_outcomes_provides_course_outcomes (
    id integer NOT NULL,
    course_outcome_id integer NOT NULL,
    program_outcome_id integer NOT NULL
);


ALTER TABLE public.program_outcomes_provides_course_outcomes OWNER TO postgres;

--
-- Name: program_outcomes_provides_course_outcomes_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.program_outcomes_provides_course_outcomes_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.program_outcomes_provides_course_outcomes_id_seq OWNER TO postgres;

--
-- Name: program_outcomes_provides_course_outcomes_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.program_outcomes_provides_course_outcomes_id_seq OWNED BY public.program_outcomes_provides_course_outcomes.id;


--
-- Name: questions_covers_course_outcome_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.questions_covers_course_outcome_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.questions_covers_course_outcome_id_seq OWNER TO postgres;

--
-- Name: questions_covers_course_outcome_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.questions_covers_course_outcome_id_seq OWNED BY public.grading_tool_covers_course_outcome.id;


--
-- Name: student; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.student (
    student_id character varying(50) NOT NULL,
    user_id integer NOT NULL,
    instructor_id integer NOT NULL,
    department_id integer NOT NULL,
    is_major boolean DEFAULT true
);


ALTER TABLE public.student OWNER TO postgres;

--
-- Name: student_answers_grading_tool; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.student_answers_grading_tool (
    id integer NOT NULL,
    student_id character varying,
    grading_tool_id integer,
    grade double precision DEFAULT 0 NOT NULL
);


ALTER TABLE public.student_answers_grading_tool OWNER TO postgres;

--
-- Name: student_answers_question_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.student_answers_question_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.student_answers_question_id_seq OWNER TO postgres;

--
-- Name: student_answers_question_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.student_answers_question_id_seq OWNED BY public.student_answers_grading_tool.id;


--
-- Name: student_gets_measured_grade_course_outcome; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.student_gets_measured_grade_course_outcome (
    id integer NOT NULL,
    course_outcome_id integer,
    student_id character varying,
    grade double precision DEFAULT 0 NOT NULL
);


ALTER TABLE public.student_gets_measured_grade_course_outcome OWNER TO postgres;

--
-- Name: student_gets_measured_grade_course_outcome_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.student_gets_measured_grade_course_outcome_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.student_gets_measured_grade_course_outcome_id_seq OWNER TO postgres;

--
-- Name: student_gets_measured_grade_course_outcome_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.student_gets_measured_grade_course_outcome_id_seq OWNED BY public.student_gets_measured_grade_course_outcome.id;


--
-- Name: student_gets_measured_grade_program_outcome; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.student_gets_measured_grade_program_outcome (
    id integer NOT NULL,
    program_outcome_id integer,
    student_id character varying,
    grade double precision DEFAULT 0 NOT NULL
);


ALTER TABLE public.student_gets_measured_grade_program_outcome OWNER TO postgres;

--
-- Name: student_gets_measured_grade_program_outcome_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.student_gets_measured_grade_program_outcome_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.student_gets_measured_grade_program_outcome_id_seq OWNER TO postgres;

--
-- Name: student_gets_measured_grade_program_outcome_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.student_gets_measured_grade_program_outcome_id_seq OWNED BY public.student_gets_measured_grade_program_outcome.id;


--
-- Name: university; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.university (
    name character varying(200) NOT NULL,
    bank_account character varying(200),
    address character varying(200) NOT NULL,
    phone_number character varying(20) NOT NULL
);


ALTER TABLE public.university OWNER TO postgres;

--
-- Name: user; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."user" (
    id integer NOT NULL,
    email_address character varying(200) NOT NULL,
    name character varying(200) NOT NULL,
    password character varying(50) NOT NULL
);


ALTER TABLE public."user" OWNER TO postgres;

--
-- Name: user_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.user_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.user_id_seq OWNER TO postgres;

--
-- Name: user_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.user_id_seq OWNED BY public."user".id;


--
-- Name: admin id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.admin ALTER COLUMN id SET DEFAULT nextval('public.admin_id_seq'::regclass);


--
-- Name: course id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.course ALTER COLUMN id SET DEFAULT nextval('public.course_id_seq'::regclass);


--
-- Name: course_outcome id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.course_outcome ALTER COLUMN id SET DEFAULT nextval('public.course_outcome_id_seq'::regclass);


--
-- Name: courses_given_by_instructor id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.courses_given_by_instructor ALTER COLUMN id SET DEFAULT nextval('public.courses_given_by_instructor_id_seq'::regclass);


--
-- Name: courses_taken_by_students id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.courses_taken_by_students ALTER COLUMN id SET DEFAULT nextval('public.courses_taken_by_students_id_seq'::regclass);


--
-- Name: department id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.department ALTER COLUMN id SET DEFAULT nextval('public.department_id_seq'::regclass);


--
-- Name: departments_has_instructors id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.departments_has_instructors ALTER COLUMN id SET DEFAULT nextval('public.departments_has_instructors_id_seq'::regclass);


--
-- Name: faculty id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.faculty ALTER COLUMN id SET DEFAULT nextval('public.faculty_id_seq'::regclass);


--
-- Name: grading_tool_covers_course_outcome id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.grading_tool_covers_course_outcome ALTER COLUMN id SET DEFAULT nextval('public.questions_covers_course_outcome_id_seq'::regclass);


--
-- Name: instructor id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.instructor ALTER COLUMN id SET DEFAULT nextval('public.instructor_id_seq'::regclass);


--
-- Name: program_outcome id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.program_outcome ALTER COLUMN id SET DEFAULT nextval('public.program_outcome_id_seq'::regclass);


--
-- Name: program_outcomes_provides_course_outcomes id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.program_outcomes_provides_course_outcomes ALTER COLUMN id SET DEFAULT nextval('public.program_outcomes_provides_course_outcomes_id_seq'::regclass);


--
-- Name: student_answers_grading_tool id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.student_answers_grading_tool ALTER COLUMN id SET DEFAULT nextval('public.student_answers_question_id_seq'::regclass);


--
-- Name: student_gets_measured_grade_course_outcome id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.student_gets_measured_grade_course_outcome ALTER COLUMN id SET DEFAULT nextval('public.student_gets_measured_grade_course_outcome_id_seq'::regclass);


--
-- Name: student_gets_measured_grade_program_outcome id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.student_gets_measured_grade_program_outcome ALTER COLUMN id SET DEFAULT nextval('public.student_gets_measured_grade_program_outcome_id_seq'::regclass);


--
-- Name: user id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."user" ALTER COLUMN id SET DEFAULT nextval('public.user_id_seq'::regclass);


--
-- Data for Name: admin; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.admin (id, user_id) VALUES (3, 20);


--
-- Data for Name: assessment; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- Data for Name: course; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.course (id, code, year_and_term, department_id, name, credit, date_time) VALUES (5, 'COMP205', '2019-2020-01', 5, 'Systems Programming', 6, NULL);
INSERT INTO public.course (id, code, year_and_term, department_id, name, credit, date_time) VALUES (6, 'COMP205', '2018-2019-01', 5, 'Systems Programming', 6, NULL);
INSERT INTO public.course (id, code, year_and_term, department_id, name, credit, date_time) VALUES (7, 'COMP204', '2018-2019-02', 5, 'Programming Studio', 6, NULL);
INSERT INTO public.course (id, code, year_and_term, department_id, name, credit, date_time) VALUES (8, 'COMP110', '2017-2018-02', 5, 'Object-Oriented Programming (JAVA)', 6, NULL);
INSERT INTO public.course (id, code, year_and_term, department_id, name, credit, date_time) VALUES (9, 'COMP110', '2017-2018-02', 6, 'Object-Oriented Programming (JAVA)', 6, NULL);
INSERT INTO public.course (id, code, year_and_term, department_id, name, credit, date_time) VALUES (10, 'EE204', '2018-2019-02', 5, 'Signals and Systems', 6, NULL);
INSERT INTO public.course (id, code, year_and_term, department_id, name, credit, date_time) VALUES (11, 'EE204', '2018-2019-02', 6, 'Signals and Systems', 6, NULL);


--
-- Data for Name: course_outcome; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- Data for Name: courses_given_by_instructor; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- Data for Name: courses_taken_by_students; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- Data for Name: department; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.department (id, name, faculty_id) VALUES (5, 'Computer Engineering', 5);
INSERT INTO public.department (id, name, faculty_id) VALUES (7, 'Computer Engineering', 6);
INSERT INTO public.department (id, name, faculty_id) VALUES (6, 'Electrical and Electronics Engineering', 5);
INSERT INTO public.department (id, name, faculty_id) VALUES (8, 'Electrical and Electronics Engineering', 6);


--
-- Data for Name: departments_has_instructors; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.departments_has_instructors (id, department_id, instructor_id) VALUES (3, 5, 5);
INSERT INTO public.departments_has_instructors (id, department_id, instructor_id) VALUES (4, 5, 6);
INSERT INTO public.departments_has_instructors (id, department_id, instructor_id) VALUES (5, 5, 7);


--
-- Data for Name: faculty; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.faculty (id, name, university_name) VALUES (5, 'Faculty of Engineering', 'MEF University');
INSERT INTO public.faculty (id, name, university_name) VALUES (6, 'Faculty of Engineering', 'Koç University');


--
-- Data for Name: grading_tool; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- Data for Name: grading_tool_covers_course_outcome; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- Data for Name: instructor; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.instructor (id, role, user_id) VALUES (5, '1', 15);
INSERT INTO public.instructor (id, role, user_id) VALUES (6, '2', 16);
INSERT INTO public.instructor (id, role, user_id) VALUES (7, '1', 17);
INSERT INTO public.instructor (id, role, user_id) VALUES (8, '4', 18);
INSERT INTO public.instructor (id, role, user_id) VALUES (9, '3', 19);
INSERT INTO public.instructor (id, role, user_id) VALUES (10, '1', 21);


--
-- Data for Name: program_outcome; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.program_outcome (id, explanation, code, department_id) VALUES (6, 'asdad', 'asdas', 5);


--
-- Data for Name: program_outcomes_provides_course_outcomes; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- Data for Name: student; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.student (student_id, user_id, instructor_id, department_id, is_major) VALUES ('041701005', 13, 5, 5, true);
INSERT INTO public.student (student_id, user_id, instructor_id, department_id, is_major) VALUES ('041701008', 11, 5, 5, true);
INSERT INTO public.student (student_id, user_id, instructor_id, department_id, is_major) VALUES ('041701014', 10, 5, 5, true);
INSERT INTO public.student (student_id, user_id, instructor_id, department_id, is_major) VALUES ('041701022', 12, 5, 5, true);
INSERT INTO public.student (student_id, user_id, instructor_id, department_id, is_major) VALUES ('041701076', 14, 6, 5, true);
INSERT INTO public.student (student_id, user_id, instructor_id, department_id, is_major) VALUES ('041702023', 14, 10, 6, true);


--
-- Data for Name: student_answers_grading_tool; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- Data for Name: student_gets_measured_grade_course_outcome; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- Data for Name: student_gets_measured_grade_program_outcome; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- Data for Name: university; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.university (name, bank_account, address, phone_number) VALUES ('Koç University', 'Yapı Kredi Bankası Koç Üniversitesi Şb. TR63 0006 7010 0000 0000 428868', 'Rumelifeneri, Sarıyer Rumeli Feneri Yolu, 34450 Sarıyer/İstanbul', '(0212) 338 10 00');
INSERT INTO public.university (name, bank_account, address, phone_number) VALUES ('MEF University', 'Yapı Kredi Bankası Maslak Şubesi MEF Üniversitesi Hesap No: 688 - 51743829 IBAN: TR78 0006 7010 0000 0051 7438 29', 'Huzur, Maslak Ayazağa Cd. No:4, 34396 Sarıyer/İstanbul', '(0212) 395 36 00');


--
-- Data for Name: user; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public."user" (id, email_address, name, password) VALUES (20, 'alp.gokcek1@gmail.com', 'Alp Gökçek', 'deneme123');
INSERT INTO public."user" (id, email_address, name, password) VALUES (17, 'bekmezcii@mef.edu.tr', 'İlker Bekmezci', 'deneme123');
INSERT INTO public."user" (id, email_address, name, password) VALUES (15, 'berk.gokberk@mef.edu.tr', 'Berk Gökberk', 'deneme123');
INSERT INTO public."user" (id, email_address, name, password) VALUES (14, 'doganer@mef.edu.tr', 'Erdal Sidal Doğan', 'deneme123');
INSERT INTO public."user" (id, email_address, name, password) VALUES (13, 'erdoganberf@mef.edu.tr', 'Berfin Elif Erdoğan', 'deneme123');
INSERT INTO public."user" (id, email_address, name, password) VALUES (10, 'gokcekal@mef.edu.tr', 'Alp Gökçek', 'deneme123');
INSERT INTO public."user" (id, email_address, name, password) VALUES (11, 'kartalmu@mef.edu.tr', 'Muhammed Rahmetullah Kartal', 'deneme123');
INSERT INTO public."user" (id, email_address, name, password) VALUES (21, 'kirbizs@mef.edu.tr', 'Serap Kırbız', 'deneme123');
INSERT INTO public."user" (id, email_address, name, password) VALUES (19, 'mehmetfevzi.unal@mef.edu.tr', 'Mehmet Fevzi Ünal', 'deneme123');
INSERT INTO public."user" (id, email_address, name, password) VALUES (18, 'muhammed.sahin@mef.edu.tr', 'Muhammed Şahin', 'deneme123');
INSERT INTO public."user" (id, email_address, name, password) VALUES (16, 'muhittin.gokmen@mef.edu.tr', 'Muhittin Gökmen', 'deneme123');
INSERT INTO public."user" (id, email_address, name, password) VALUES (12, 'subasie@mef.edu.tr', 'Ezgi Subaşı', 'deneme123');


--
-- Name: admin_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.admin_id_seq', 1, false);


--
-- Name: course_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.course_id_seq', 1, false);


--
-- Name: course_outcome_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.course_outcome_id_seq', 1, true);


--
-- Name: courses_given_by_instructor_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.courses_given_by_instructor_id_seq', 1, false);


--
-- Name: courses_taken_by_students_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.courses_taken_by_students_id_seq', 1, false);


--
-- Name: department_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.department_id_seq', 1, false);


--
-- Name: departments_has_instructors_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.departments_has_instructors_id_seq', 1, false);


--
-- Name: faculty_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.faculty_id_seq', 1, false);


--
-- Name: instructor_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.instructor_id_seq', 1, false);


--
-- Name: program_outcome_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.program_outcome_id_seq', 6, true);


--
-- Name: program_outcomes_provides_course_outcomes_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.program_outcomes_provides_course_outcomes_id_seq', 1, false);


--
-- Name: questions_covers_course_outcome_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.questions_covers_course_outcome_id_seq', 1, false);


--
-- Name: student_answers_question_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.student_answers_question_id_seq', 1, false);


--
-- Name: student_gets_measured_grade_course_outcome_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.student_gets_measured_grade_course_outcome_id_seq', 1, false);


--
-- Name: student_gets_measured_grade_program_outcome_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.student_gets_measured_grade_program_outcome_id_seq', 1, false);


--
-- Name: user_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.user_id_seq', 1, false);


--
-- Name: student UNIQUE KEYS; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.student
    ADD CONSTRAINT "UNIQUE KEYS" UNIQUE (user_id, student_id);


--
-- Name: admin admin_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.admin
    ADD CONSTRAINT admin_pkey PRIMARY KEY (id);


--
-- Name: course code_year_and_term; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.course
    ADD CONSTRAINT code_year_and_term UNIQUE (code, year_and_term, department_id);


--
-- Name: courses_taken_by_students course_id_student_id; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.courses_taken_by_students
    ADD CONSTRAINT course_id_student_id UNIQUE (course_id, student_id);


--
-- Name: program_outcomes_provides_course_outcomes course_outcome_id_program_outcome_id; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.program_outcomes_provides_course_outcomes
    ADD CONSTRAINT course_outcome_id_program_outcome_id UNIQUE (course_outcome_id, program_outcome_id);


--
-- Name: course_outcome course_outcome_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.course_outcome
    ADD CONSTRAINT course_outcome_pkey PRIMARY KEY (id);


--
-- Name: course course_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.course
    ADD CONSTRAINT course_pkey PRIMARY KEY (id);


--
-- Name: courses_given_by_instructor courses_given_by_instructor_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.courses_given_by_instructor
    ADD CONSTRAINT courses_given_by_instructor_pkey PRIMARY KEY (id);


--
-- Name: courses_taken_by_students courses_taken_by_students_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.courses_taken_by_students
    ADD CONSTRAINT courses_taken_by_students_pkey PRIMARY KEY (id);


--
-- Name: departments_has_instructors department_id_instructor_id; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.departments_has_instructors
    ADD CONSTRAINT department_id_instructor_id UNIQUE (department_id, instructor_id);


--
-- Name: department department_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.department
    ADD CONSTRAINT department_pkey PRIMARY KEY (id);


--
-- Name: departments_has_instructors departments_has_instructors_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.departments_has_instructors
    ADD CONSTRAINT departments_has_instructors_pkey PRIMARY KEY (id);


--
-- Name: grading_tool exam_id_question_number; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.grading_tool
    ADD CONSTRAINT exam_id_question_number UNIQUE (assessment_id, question_number);


--
-- Name: assessment exam_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.assessment
    ADD CONSTRAINT exam_pkey PRIMARY KEY (id);


--
-- Name: faculty faculty_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.faculty
    ADD CONSTRAINT faculty_pkey PRIMARY KEY (id);


--
-- Name: courses_given_by_instructor instructor_id_course_id; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.courses_given_by_instructor
    ADD CONSTRAINT instructor_id_course_id UNIQUE (instructor_id, course_id);


--
-- Name: instructor instructor_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.instructor
    ADD CONSTRAINT instructor_pkey PRIMARY KEY (id);


--
-- Name: department name_faculty_id; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.department
    ADD CONSTRAINT name_faculty_id UNIQUE (name, faculty_id);


--
-- Name: program_outcome program_outcome_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.program_outcome
    ADD CONSTRAINT program_outcome_pkey PRIMARY KEY (id);


--
-- Name: program_outcomes_provides_course_outcomes program_outcomes_provides_course_outcomes_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.program_outcomes_provides_course_outcomes
    ADD CONSTRAINT program_outcomes_provides_course_outcomes_pkey PRIMARY KEY (id);


--
-- Name: grading_tool_covers_course_outcome question_id_course_outcome_id; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.grading_tool_covers_course_outcome
    ADD CONSTRAINT question_id_course_outcome_id UNIQUE (grading_tool_id, course_outcome_id);


--
-- Name: grading_tool question_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.grading_tool
    ADD CONSTRAINT question_pkey PRIMARY KEY (id);


--
-- Name: grading_tool_covers_course_outcome questions_covers_course_outcome_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.grading_tool_covers_course_outcome
    ADD CONSTRAINT questions_covers_course_outcome_pkey PRIMARY KEY (id);


--
-- Name: student_answers_grading_tool student_answers_question_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.student_answers_grading_tool
    ADD CONSTRAINT student_answers_question_pk PRIMARY KEY (id);


--
-- Name: student_gets_measured_grade_course_outcome student_gets_measured_grade_course_outcome_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.student_gets_measured_grade_course_outcome
    ADD CONSTRAINT student_gets_measured_grade_course_outcome_pk PRIMARY KEY (id);


--
-- Name: student_gets_measured_grade_program_outcome student_gets_measured_grade_program_outcome_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.student_gets_measured_grade_program_outcome
    ADD CONSTRAINT student_gets_measured_grade_program_outcome_pk PRIMARY KEY (id);


--
-- Name: student student_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.student
    ADD CONSTRAINT student_pkey PRIMARY KEY (student_id);


--
-- Name: university university_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.university
    ADD CONSTRAINT university_pkey PRIMARY KEY (name);


--
-- Name: user user_id; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."user"
    ADD CONSTRAINT user_id UNIQUE (id);


--
-- Name: user user_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."user"
    ADD CONSTRAINT user_pkey PRIMARY KEY (email_address, id);


--
-- Name: admin admin_user_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.admin
    ADD CONSTRAINT admin_user_fk FOREIGN KEY (user_id) REFERENCES public."user"(id);


--
-- Name: course course_department_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.course
    ADD CONSTRAINT course_department_fk FOREIGN KEY (department_id) REFERENCES public.department(id);


--
-- Name: assessment course_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.assessment
    ADD CONSTRAINT course_fk FOREIGN KEY (course_id) REFERENCES public.course(id);


--
-- Name: courses_taken_by_students course_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.courses_taken_by_students
    ADD CONSTRAINT course_id FOREIGN KEY (course_id) REFERENCES public.course(id);


--
-- Name: courses_given_by_instructor course_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.courses_given_by_instructor
    ADD CONSTRAINT course_id_fk FOREIGN KEY (course_id) REFERENCES public.course(id);


--
-- Name: course_outcome course_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.course_outcome
    ADD CONSTRAINT course_id_fk FOREIGN KEY (course_id) REFERENCES public.course(id);


--
-- Name: grading_tool_covers_course_outcome course_outcome_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.grading_tool_covers_course_outcome
    ADD CONSTRAINT course_outcome_fk FOREIGN KEY (course_outcome_id) REFERENCES public.course_outcome(id);


--
-- Name: program_outcomes_provides_course_outcomes course_outcome_fk1; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.program_outcomes_provides_course_outcomes
    ADD CONSTRAINT course_outcome_fk1 FOREIGN KEY (course_outcome_id) REFERENCES public.course_outcome(id);


--
-- Name: student_gets_measured_grade_course_outcome course_outcome_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.student_gets_measured_grade_course_outcome
    ADD CONSTRAINT course_outcome_id_fk FOREIGN KEY (course_outcome_id) REFERENCES public.course_outcome(id);


--
-- Name: departments_has_instructors department_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.departments_has_instructors
    ADD CONSTRAINT department_fk FOREIGN KEY (department_id) REFERENCES public.department(id);


--
-- Name: student department_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.student
    ADD CONSTRAINT department_id FOREIGN KEY (department_id) REFERENCES public.department(id);


--
-- Name: program_outcome department_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.program_outcome
    ADD CONSTRAINT department_id_fk FOREIGN KEY (department_id) REFERENCES public.department(id);


--
-- Name: grading_tool exam_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.grading_tool
    ADD CONSTRAINT exam_fk FOREIGN KEY (assessment_id) REFERENCES public.assessment(id);


--
-- Name: department faculty_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.department
    ADD CONSTRAINT faculty_id_fk FOREIGN KEY (faculty_id) REFERENCES public.faculty(id);


--
-- Name: student_answers_grading_tool grading_tool_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.student_answers_grading_tool
    ADD CONSTRAINT grading_tool_id_fk FOREIGN KEY (grading_tool_id) REFERENCES public.grading_tool(id);


--
-- Name: departments_has_instructors instructor_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.departments_has_instructors
    ADD CONSTRAINT instructor_id FOREIGN KEY (instructor_id) REFERENCES public.instructor(id);


--
-- Name: courses_given_by_instructor instructor_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.courses_given_by_instructor
    ADD CONSTRAINT instructor_id_fk FOREIGN KEY (instructor_id) REFERENCES public.instructor(id);


--
-- Name: instructor instructor_user_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.instructor
    ADD CONSTRAINT instructor_user_fk FOREIGN KEY (user_id) REFERENCES public."user"(id);


--
-- Name: program_outcomes_provides_course_outcomes program_outcome_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.program_outcomes_provides_course_outcomes
    ADD CONSTRAINT program_outcome_fk FOREIGN KEY (program_outcome_id) REFERENCES public.program_outcome(id);


--
-- Name: student_gets_measured_grade_program_outcome program_outcome_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.student_gets_measured_grade_program_outcome
    ADD CONSTRAINT program_outcome_id_fk FOREIGN KEY (program_outcome_id) REFERENCES public.program_outcome(id);


--
-- Name: grading_tool_covers_course_outcome question_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.grading_tool_covers_course_outcome
    ADD CONSTRAINT question_fk FOREIGN KEY (grading_tool_id) REFERENCES public.grading_tool(id);


--
-- Name: courses_taken_by_students student_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.courses_taken_by_students
    ADD CONSTRAINT student_id FOREIGN KEY (student_id) REFERENCES public.student(student_id);


--
-- Name: student_answers_grading_tool student_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.student_answers_grading_tool
    ADD CONSTRAINT student_id_fk FOREIGN KEY (student_id) REFERENCES public.student(student_id);


--
-- Name: student_gets_measured_grade_course_outcome student_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.student_gets_measured_grade_course_outcome
    ADD CONSTRAINT student_id_fk FOREIGN KEY (student_id) REFERENCES public.student(student_id);


--
-- Name: student_gets_measured_grade_program_outcome student_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.student_gets_measured_grade_program_outcome
    ADD CONSTRAINT student_id_fk FOREIGN KEY (student_id) REFERENCES public.student(student_id);


--
-- Name: student student_instructor_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.student
    ADD CONSTRAINT student_instructor_id_fk FOREIGN KEY (instructor_id) REFERENCES public.instructor(id);


--
-- Name: student student_user_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.student
    ADD CONSTRAINT student_user_id_fk FOREIGN KEY (user_id) REFERENCES public."user"(id);


--
-- Name: faculty univeristy_name_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.faculty
    ADD CONSTRAINT univeristy_name_fk FOREIGN KEY (university_name) REFERENCES public.university(name);


--
-- PostgreSQL database dump complete
--

