--
-- PostgreSQL database dump
--

-- Dumped from database version 12.2 (Ubuntu 12.2-4)
-- Dumped by pg_dump version 12.2 (Ubuntu 12.2-4)

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

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: chat; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.chat (
    id integer NOT NULL,
    message text,
    sender smallint,
    receiver smallint,
    sent_date timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    atch text,
    ref smallint,
    identifier character varying(255)
);


ALTER TABLE public.chat OWNER TO postgres;

--
-- Name: chat_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.chat_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.chat_id_seq OWNER TO postgres;

--
-- Name: chat_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.chat_id_seq OWNED BY public.chat.id;


--
-- Name: conversationlist; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.conversationlist (
    id integer NOT NULL,
    identifier character varying(255),
    sender smallint,
    receiver smallint,
    last_message character varying(255),
    sent_date timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.conversationlist OWNER TO postgres;

--
-- Name: conversationlist_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.conversationlist_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.conversationlist_id_seq OWNER TO postgres;

--
-- Name: conversationlist_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.conversationlist_id_seq OWNED BY public.conversationlist.id;


--
-- Name: login; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.login (
    id integer NOT NULL,
    email character varying(255) NOT NULL,
    name character varying(255),
    hash character varying(255)
);


ALTER TABLE public.login OWNER TO postgres;

--
-- Name: login_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.login_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.login_id_seq OWNER TO postgres;

--
-- Name: login_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.login_id_seq OWNED BY public.login.id;


--
-- Name: posts; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.posts (
    id integer NOT NULL,
    post character varying(255),
    post_date timestamp without time zone,
    user_id character varying(100),
    atch character varying(255)
);


ALTER TABLE public.posts OWNER TO postgres;

--
-- Name: posts_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.posts_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.posts_id_seq OWNER TO postgres;

--
-- Name: posts_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.posts_id_seq OWNED BY public.posts.id;


--
-- Name: students; Type: TABLE; Schema: public; Owner: me
--

CREATE TABLE public.students (
    id integer NOT NULL,
    student_name character varying(128) NOT NULL,
    student_age integer NOT NULL,
    student_class character varying(128) NOT NULL,
    parent_contact character varying(128) NOT NULL,
    admission_date character varying(128) NOT NULL
);


ALTER TABLE public.students OWNER TO me;

--
-- Name: students_id_seq; Type: SEQUENCE; Schema: public; Owner: me
--

CREATE SEQUENCE public.students_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.students_id_seq OWNER TO me;

--
-- Name: students_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: me
--

ALTER SEQUENCE public.students_id_seq OWNED BY public.students.id;


--
-- Name: users; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.users (
    id integer NOT NULL,
    username character varying(255),
    completename character varying(255),
    email character varying(255),
    tcbatch smallint,
    origin character varying(255),
    dob date,
    profile_picture character varying(255),
    cover_picture character varying(255),
    about character varying(255)
);


ALTER TABLE public.users OWNER TO postgres;

--
-- Name: users_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.users_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.users_id_seq OWNER TO postgres;

--
-- Name: users_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.users_id_seq OWNED BY public.users.id;


--
-- Name: chat id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.chat ALTER COLUMN id SET DEFAULT nextval('public.chat_id_seq'::regclass);


--
-- Name: conversationlist id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.conversationlist ALTER COLUMN id SET DEFAULT nextval('public.conversationlist_id_seq'::regclass);


--
-- Name: login id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.login ALTER COLUMN id SET DEFAULT nextval('public.login_id_seq'::regclass);


--
-- Name: posts id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.posts ALTER COLUMN id SET DEFAULT nextval('public.posts_id_seq'::regclass);


--
-- Name: students id; Type: DEFAULT; Schema: public; Owner: me
--

ALTER TABLE ONLY public.students ALTER COLUMN id SET DEFAULT nextval('public.students_id_seq'::regclass);


--
-- Name: users id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users ALTER COLUMN id SET DEFAULT nextval('public.users_id_seq'::regclass);


--
-- Data for Name: chat; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.chat (id, message, sender, receiver, sent_date, atch, ref, identifier) FROM stdin;
1	hello	1	3	2020-05-25 02:51:37.447842	\N	\N	u1u3
2	How are you?	3	1	2020-05-25 02:52:16.750826	\N	\N	u1u3
3	Are you still there?	3	1	2020-05-25 02:52:44.041263	\N	\N	u1u3
4	Yeah, it is suck here. I wanna walk outta here.	1	3	2020-05-25 02:53:39.78629	\N	\N	u1u3
5	Have you got my mail?	9	2	2020-05-25 02:57:50.436263	\N	\N	u2u9
6	What do you say if I m inviting you for coffee this afternoon?	5	2	2020-05-25 03:07:50.832316	\N	\N	u2u6
7	What do you say if I m inviting you for coffee this afternoon?	9	3	2020-05-25 04:20:08.431895	\N	\N	u3u9
8	hello	3	8	2020-05-25 13:23:30.437047	\N	\N	u3u8
9	where have you been?	3	8	2020-05-25 13:25:18.349105	\N	\N	u3u8
10	is it okay?	3	8	2020-05-25 13:27:15.853708	\N	\N	u3u8
11	try it	3	8	2020-05-25 13:29:33.326663	\N	\N	u3u8
12	try it	3	8	2020-05-25 13:29:41.242477	\N	\N	u3u8
13	take it out	3	7	2020-05-25 13:30:58.001879	\N	\N	u3u7
14	okay	3	9	2020-05-25 13:32:18.669546	\N	\N	u3u9
15	hei	3	1	2020-05-25 13:33:41.565265	\N	\N	u1u3
16	well	3	7	2020-05-25 13:34:30.353496	\N	\N	u3u7
17	are you fine with this?	3	1	2020-05-25 13:34:47.275101	\N	\N	u1u3
18	I am not sure this is what i am thingking about	3	1	2020-05-25 13:35:15.269763	\N	\N	u1u3
19	don't know	3	7	2020-05-25 13:37:04.261953	\N	\N	u3u7
20	try this! you gotta love it	3	9	2020-05-25 13:44:14.529069	\N	\N	u3u9
21	are you sure?	7	3	2020-05-25 13:50:22.411744	\N	\N	u3u7
\.


--
-- Data for Name: conversationlist; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.conversationlist (id, identifier, sender, receiver, last_message, sent_date) FROM stdin;
1	u1u3	1	3	Yeah, it is suck here. I wanna walk outta here.	2020-05-25 02:53:39.78629
3	u3u9	1	3	Yeah, it is suck here. I wanna walk outta here.	2020-05-25 12:37:17.920364
\.


--
-- Data for Name: login; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.login (id, email, name, hash) FROM stdin;
1	caesar@mail.com	caesar	$2a$10$NvZ355O.QuFkggkX4bAdbeAN4kYefZ1ityaRRP6seHNDIc/OEUyO6
2	jason@mail.com	jason	$2a$10$fgSBJQkwjBuqMk14CdIAgeM.zMlmvyW7O7P00s/m9QyXr1uqXM5Ie
3	sally@mail.com	sally	$2a$10$PQ5w2qjYdgcmJeES1zuIF.JXoTzHYZ5srt47i8Tv4lKm/rTAf6GFO
4	carlos@mail.com	123	$2a$10$MjHoj3n4RCaHp7OV7FdlJ.ew.v1sJKfEgFT1n.RQ55ok5ng/dU6Fm
5	rex@mail.com	rex	$2a$10$c2Syi0mTSpNwoV.yW.qfduF2y5CgXu2Yqpu5SJ/SddptsNFBNzxQe
6	tony@mail.com	tony	$2a$10$4JtuGcTTB0oXjTVKp2HHueUt4AaHR5LHElJanqeo1a6QzIXp0ylCG
7	jeff@mail.com	jeff	$2a$10$pduOKxLkMdTExQdV0XMgmOgfHxX1ERlE03NRIK2SIujppXDLhnOVS
8	brian@mail.com	brian	$2a$10$CCbgG.LIRazXdUH3ZREpTODgtMGvfpDKjsIqhWGx4o4aIjBVpPYl6
9	rose@mail.com	rose	$2a$10$PezAJUs25mDiGHVtBSJTLewIkJDlQIHsCpZW5zQfk/0i.T2PwzZve
10	prick@mail.com	prick	$2a$10$CkyGy1gpFhGlGpa.74OaxeL.dZrlwww.9d1ubN8kT4vH6WRp0pwg2
\.


--
-- Data for Name: posts; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.posts (id, post, post_date, user_id, atch) FROM stdin;
23	hello	2020-05-20 02:32:01.055	a	\N
24	how are you?	2020-05-20 02:32:08.179	a	\N
25		2020-05-20 02:38:05.192	a	landing_page1.png
26		2020-05-20 02:48:00.352	a	pattern.png
27	I am so tired	2020-05-20 02:53:04.453	a	\N
28	i don't know what to do	2020-05-20 14:34:14.153	a	\N
29		2020-05-20 14:46:07.284	a	avatar.jpg
30		2020-05-20 14:47:47.672	a	Crocus_Wallpaper_by_Roy_Tanck.jpg
31	what is your name?	2020-05-20 19:50:47.279	\N	\N
32	what is your name?	2020-05-20 19:50:58.448	\N	Fairground_at_Night_by_martin.jpg
\.


--
-- Data for Name: students; Type: TABLE DATA; Schema: public; Owner: me
--

COPY public.students (id, student_name, student_age, student_class, parent_contact, admission_date) FROM stdin;
1	1	2	3	4	5
\.


--
-- Data for Name: users; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.users (id, username, completename, email, tcbatch, origin, dob, profile_picture, cover_picture, about) FROM stdin;
2	jason	\N	jason@mail.com	12	Malang	\N	2_avatar.jpg	\N	\N
4	eddy	\N	carlos@mail.com	123	Palangkaraya	\N	4_avatar.jpg	\N	\N
5	john	\N	rex@mail.com	87	Sumedang	\N	5_avatar.jpg	\N	\N
6	tony	\N	tony@mail.com	3	Gorontalo	\N	6_avatar.jpg	\N	\N
7	jeff	\N	jeff@mail.com	123	Ujung Pandang	\N	7_avatar.jpg	\N	\N
8	brian	\N	brian@mail.com	9	Maluku	\N	8_avatar.jpg	\N	\N
9	rose	\N	rose@mail.com	9	Bandung	\N	9_avatar.jpg	\N	\N
10	carlos	\N	prick@mail.com	5	Kebumen	\N	10_avatar.jpg	\N	\N
1	caesar	John doe	caesar@mail.com	7	Melbourne	1998-10-13	1_avatar.jpg	\N	it's alright
3	sally	Sally Sandra	sally@mail.com	4	Jakarta	2020-12-31	3_avatar.jpg	\N	Once upon a time...
\.


--
-- Name: chat_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.chat_id_seq', 21, true);


--
-- Name: conversationlist_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.conversationlist_id_seq', 2, true);


--
-- Name: login_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.login_id_seq', 10, true);


--
-- Name: posts_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.posts_id_seq', 32, true);


--
-- Name: students_id_seq; Type: SEQUENCE SET; Schema: public; Owner: me
--

SELECT pg_catalog.setval('public.students_id_seq', 1, true);


--
-- Name: users_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.users_id_seq', 10, true);


--
-- Name: login login_email_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.login
    ADD CONSTRAINT login_email_key UNIQUE (email);


--
-- Name: students students_pkey; Type: CONSTRAINT; Schema: public; Owner: me
--

ALTER TABLE ONLY public.students
    ADD CONSTRAINT students_pkey PRIMARY KEY (id);


--
-- Name: users users_email_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_email_key UNIQUE (email);


--
-- Name: users users_username_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_username_key UNIQUE (username);


--
-- PostgreSQL database dump complete
--

