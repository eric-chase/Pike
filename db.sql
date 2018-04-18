--
-- PostgreSQL database dump
--

SET statement_timeout = 0;
SET lock_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET client_min_messages = warning;

--
-- Name: nnc2117; Type: SCHEMA; Schema: -; Owner: nnc2117
--

CREATE SCHEMA nnc2117;


ALTER SCHEMA nnc2117 OWNER TO nnc2117;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: acts; Type: TABLE; Schema: nnc2117; Owner: nnc2117; Tablespace: 
--

CREATE TABLE nnc2117.acts (
    name character varying(50),
    act_id integer NOT NULL
);


ALTER TABLE nnc2117.acts OWNER TO nnc2117;

--
-- Name: albums; Type: TABLE; Schema: nnc2117; Owner: nnc2117; Tablespace: 
--

CREATE TABLE nnc2117.albums (
    record_label character varying(50),
    album_id integer NOT NULL,
    release_year integer,
    genre character varying(30),
    title character varying(50)
);


ALTER TABLE nnc2117.albums OWNER TO nnc2117;

--
-- Name: are_friends; Type: TABLE; Schema: nnc2117; Owner: nnc2117; Tablespace: 
--

CREATE TABLE nnc2117.are_friends (
    username1 character varying(20) NOT NULL,
    username2 character varying(20) NOT NULL
);


ALTER TABLE nnc2117.are_friends OWNER TO nnc2117;

--
-- Name: artists; Type: TABLE; Schema: nnc2117; Owner: nnc2117; Tablespace: 
--

CREATE TABLE nnc2117.artists (
    name character varying(50),
    artist_id integer NOT NULL
);


ALTER TABLE nnc2117.artists OWNER TO nnc2117;

--
-- Name: collections_owns; Type: TABLE; Schema: nnc2117; Owner: nnc2117; Tablespace: 
--

CREATE TABLE nnc2117.collections_owns (
    name character varying(30) NOT NULL,
    username character varying(20) NOT NULL
);


ALTER TABLE nnc2117.collections_owns OWNER TO nnc2117;

--
-- Name: contains; Type: TABLE; Schema: nnc2117; Owner: nnc2117; Tablespace: 
--

CREATE TABLE nnc2117.contains (
    name character varying(30) NOT NULL,
    username character varying(20) NOT NULL,
    song_id integer NOT NULL,
    act_id integer NOT NULL
);


ALTER TABLE nnc2117.contains OWNER TO nnc2117;

--
-- Name: likes; Type: TABLE; Schema: nnc2117; Owner: nnc2117; Tablespace: 
--

CREATE TABLE nnc2117.likes (
    username character varying(20) NOT NULL,
    song_id integer NOT NULL
);


ALTER TABLE nnc2117.likes OWNER TO nnc2117;

--
-- Name: part_of; Type: TABLE; Schema: nnc2117; Owner: nnc2117; Tablespace: 
--

CREATE TABLE nnc2117.part_of (
    album_id integer NOT NULL,
    song_id integer NOT NULL
);


ALTER TABLE nnc2117.part_of OWNER TO nnc2117;

--
-- Name: performs; Type: TABLE; Schema: nnc2117; Owner: nnc2117; Tablespace: 
--

CREATE TABLE nnc2117.performs (
    act_id integer NOT NULL,
    song_id integer NOT NULL,
    num_likes integer,
    num_views integer,
    link character varying(75)
);


ALTER TABLE nnc2117.performs OWNER TO nnc2117;

--
-- Name: plays_in; Type: TABLE; Schema: nnc2117; Owner: nnc2117; Tablespace: 
--

CREATE TABLE nnc2117.plays_in (
    act_id integer NOT NULL,
    artist_id integer NOT NULL
);


ALTER TABLE nnc2117.plays_in OWNER TO nnc2117;

--
-- Name: reviews; Type: TABLE; Schema: nnc2117; Owner: nnc2117; Tablespace: 
--

CREATE TABLE nnc2117.reviews (
    text character varying(100),
    date_time timestamp without time zone NOT NULL,
    rating integer,
    username character varying(20) NOT NULL,
    song_id integer NOT NULL,
    act_id integer NOT NULL
);


ALTER TABLE nnc2117.reviews OWNER TO nnc2117;

--
-- Name: songs; Type: TABLE; Schema: nnc2117; Owner: nnc2117; Tablespace: 
--

CREATE TABLE nnc2117.songs (
    song_id integer NOT NULL,
    length character varying(5),
    title character varying(50),
    genre character varying(30),
    CONSTRAINT songs_length_check CHECK (((length)::text ~~ '%:%'::text))
);


ALTER TABLE nnc2117.songs OWNER TO nnc2117;

--
-- Name: users; Type: TABLE; Schema: nnc2117; Owner: nnc2117; Tablespace: 
--

CREATE TABLE nnc2117.users (
    username character varying(20) NOT NULL,
    password character varying(20)
);


ALTER TABLE nnc2117.users OWNER TO nnc2117;

--
-- Data for Name: acts; Type: TABLE DATA; Schema: nnc2117; Owner: nnc2117
--

COPY nnc2117.acts (name, act_id) FROM stdin;
Green Day	1
Weezer	2
Nirvana	3
Foo Fighters	4
Pixies	5
Tame Impala	6
Muse	7
Neutral Milk Hotel	8
Michael Jackson	9
Elvis Presley	10
Prince	11
The Beatles	12
\.


--
-- Data for Name: albums; Type: TABLE DATA; Schema: nnc2117; Owner: nnc2117
--

COPY nnc2117.albums (record_label, album_id, release_year, genre, title) FROM stdin;
Reprise	1	1994	punk rock	Dookie
Reprise	2	2004	punk rock	American Idiot
DGC	3	1994	alternative rock	Blue Album
DGC	4	1996	alternative rock	Pinkerton
DGC	5	1991	grunge rock	Nevermind
DGC	6	1993	grunge rock	In Utero
Capitol	7	1997	alternative rock	The Colour and the Shape
4AD	8	1989	alternative rock	Doolittle
4AD	9	1988	alternative rock	Surfer Rosa
Modular	10	2015	psychedelic rock	Currents
Warner Bros.	11	2006	alternative rock	Black Holes and Revelations
Merge	12	1998	indie rock	In the Aeroplane Over the Sea
Epic	13	1982	pop	Thriller
RCA Victor	14	1961	pop	Blue Hawaii
Warner Bros.	15	1984	rock	Purple Rain
Apple	16	1970	rock	Hey Jude
Capitol	17	1967	rock	Sgt. Pepper’s Lonely Hearts Club Band
\.


--
-- Data for Name: are_friends; Type: TABLE DATA; Schema: nnc2117; Owner: nnc2117
--

COPY nnc2117.are_friends (username1, username2) FROM stdin;
e-chase	test-user1
e-chase	test-user2
e-chase	test-user3
e-chase	test-user4
e-chase	test-user5
e-chase	test-user6
e-chase	musiclover1989
e-chase	McLovinIt
e-chase	bump_dawg12
musiclover1989	McLovinIt
e-chase	nilesc
bob	e-chase
\.


--
-- Data for Name: artists; Type: TABLE DATA; Schema: nnc2117; Owner: nnc2117
--

COPY nnc2117.artists (name, artist_id) FROM stdin;
Billie Joe Armstrong	1
Mike Dirnt	2
Tre Cool	3
Rivers Cuomo	4
Brian Bell	5
Patrick Wilson	6
Scott Shriner	7
Matt Sharp	8
Kurt Cobain	9
Dave Grohl	10
Krist Novoselic	11
Taylor Hawkins	12
Pat Smear	13
Nate Mendel	14
Chris Shiflett	15
Black Francis	16
Joey Santiago	17
David Lovering	18
Kevin Parker	19
Jay Watson	20
Dominic Simper	21
Cam Avery	22
Matt Bellamy	23
Chris Wolstenholme	24
Dominic Howard	25
Jeff Mangum	26
Julian Koster	27
Jeremy Barnes	28
Scott Spillane	29
Michael Jackson	30
Elvis Presley	31
Prince	32
John Lennon	33
Paul McCartney	34
George Harrison	35
Ringo Starr	36
\.


--
-- Data for Name: collections_owns; Type: TABLE DATA; Schema: nnc2117; Owner: nnc2117
--

COPY nnc2117.collections_owns (name, username) FROM stdin;
Eric’s Playlist	e-chase
My First Playlist	test-user1
My First Playlist	test-user2
My First Playlist	test-user3
My First Playlist	test-user4
My First Playlist	test-user5
My First Playlist	test-user6
My Rock Playlist	musiclover1989
Rock N’ Roll	McLovinIt
Bedtime Tunes	bump_dawg12
classics	nilesc
hits	nilesc
tunes	nilesc
Howdy	billie-bob
My Music	bob
rock	bob
\.


--
-- Data for Name: contains; Type: TABLE DATA; Schema: nnc2117; Owner: nnc2117
--

COPY nnc2117.contains (name, username, song_id, act_id) FROM stdin;
Eric’s Playlist	e-chase	1	1
Eric’s Playlist	e-chase	2	1
Eric’s Playlist	e-chase	3	1
Eric’s Playlist	e-chase	4	2
Eric’s Playlist	e-chase	5	2
Eric’s Playlist	e-chase	6	2
Eric’s Playlist	e-chase	7	2
Eric’s Playlist	e-chase	8	3
Eric’s Playlist	e-chase	9	3
Rock N’ Roll	McLovinIt	1	1
hits	nilesc	3	1
classics	nilesc	3	1
Howdy	billie-bob	2	1
Howdy	billie-bob	13	6
Eric’s Playlist	e-chase	13	6
My Music	bob	10	4
\.


--
-- Data for Name: likes; Type: TABLE DATA; Schema: nnc2117; Owner: nnc2117
--

COPY nnc2117.likes (username, song_id) FROM stdin;
e-chase	1
e-chase	2
e-chase	3
e-chase	4
e-chase	5
e-chase	6
e-chase	7
e-chase	8
e-chase	9
e-chase	10
e-chase	11
e-chase	12
e-chase	13
e-chase	14
e-chase	15
e-chase	16
test-user1	1
test-user1	2
test-user1	3
test-user2	1
test-user2	2
test-user2	3
\.


--
-- Data for Name: part_of; Type: TABLE DATA; Schema: nnc2117; Owner: nnc2117
--

COPY nnc2117.part_of (album_id, song_id) FROM stdin;
1	1
1	2
2	3
3	4
3	5
3	6
4	7
5	8
6	9
7	10
8	11
9	12
10	13
10	14
11	15
11	16
12	17
12	18
13	19
14	20
15	21
16	22
17	23
\.


--
-- Data for Name: performs; Type: TABLE DATA; Schema: nnc2117; Owner: nnc2117
--

COPY nnc2117.performs (act_id, song_id, num_likes, num_views, link) FROM stdin;
4	10	7	28	https://embed.vevo.com?isrc=USRW40500008
1	2	4	74	https://embed.vevo.com?isrc=USREV0100011
8	18	1	2	https://www.youtube.com/embed/TudLjZ_4VhU
3	9	0	4	https://embed.vevo.com?isrc=USUV70902889
1	3	2	23	https://embed.vevo.com?isrc=USREV0400205
2	7	1	1	https://embed.vevo.com?isrc=USIV20400078
5	11	0	1	https://www.youtube.com/embed/_hCEd8YLKWI
5	12	0	1	https://www.youtube.com/embed/49FB9hhoO6c
7	15	4	22	https://embed.vevo.com?isrc=GB1300600690
6	13	9	35	https://www.youtube.com/embed/eoU7_qCgUAI
12	22	0	1	https://embed.vevo.com?isrc=GBUV71501362
11	21	0	1	https://www.youtube.com/embed/g6IlECn56oo
6	14	2	12	//ok.ru/videoembed/23439806879
1	1	4	69	https://embed.vevo.com?isrc=USREV0100010
2	4	0	0	https://embed.vevo.com?isrc=USIV20400100
2	5	0	0	https://embed.vevo.com?isrc=USIV20200407
2	6	0	0	https://embed.vevo.com?isrc=USIV20400115
7	16	1	8	https://player.vimeo.com/video/96764539
8	17	0	0	https://www.youtube.com/embed/hD6_QXwKesU
9	19	0	0	https://embed.vevo.com?isrc=USSM20800257
10	20	0	0	https://embed.vevo.com?isrc=USRV81200151
12	23	0	1	https://embed.vevo.com?isrc=GBUV71501383
3	8	4	12	https://embed.vevo.com?isrc=USIV20500045
\.


--
-- Data for Name: plays_in; Type: TABLE DATA; Schema: nnc2117; Owner: nnc2117
--

COPY nnc2117.plays_in (act_id, artist_id) FROM stdin;
1	1
1	2
1	3
2	4
2	5
2	6
2	7
2	8
3	9
3	10
3	11
4	10
4	12
4	13
4	14
4	15
5	16
5	17
5	18
6	19
6	20
6	21
6	22
7	23
7	24
7	25
8	26
8	27
8	28
8	29
9	30
10	31
11	32
12	33
12	34
12	35
12	36
\.


--
-- Data for Name: reviews; Type: TABLE DATA; Schema: nnc2117; Owner: nnc2117
--

COPY nnc2117.reviews (text, date_time, rating, username, song_id, act_id) FROM stdin;
Great song!	2018-02-17 20:17:36	10	test-user1	1	1
Love this song.	2018-02-17 20:18:42	10	test-user2	1	1
These guys are great!	2018-02-17 20:19:09	10	test-user3	2	1
Woohoo!	2018-02-17 20:21:50	10	McLovinIt	1	1
Something about this song makes me feel sleepy...	2018-02-17 20:22:25	8	McLovinIt	14	6
What can I say? A classic.	2018-02-17 20:22:25	9	musiclover1989	8	3
The lead singer’s voice is great!	2018-02-17 20:24:45	8	bump_dawg12	16	7
Dave Grohl, you sly dog.	2018-02-17 20:26:50	9	bump_dawg12	10	4
A great song by a great band.	2018-02-17 20:28:25	10	test-user4	3	1
Mike’s bass line is awesome!	2018-02-17 20:29:05	10	test-user1	3	1
This song makes me want to actually register for Pike.	2018-03-16 22:14:00	10	anon	1	1
To this day, Green Day is my favorite band of all time and Basket Case remains a 90's classic.	2018-03-16 22:46:09	10	e-chase	1	1
This song has a very interesting sound to it.	2018-03-16 23:01:44	7	anon	18	8
This site sure has a lot of Green Day. Not that I'm complaining about it. This song rocks!	2018-03-17 00:06:56	10	anon	2	1
There's something so groovy about this song.	2018-03-17 00:11:43	9	anon	13	6
That opening guitar riff hits like BAM!	2018-03-17 00:16:32	9	anon	15	7
I'm not here for the music.	2018-03-20 00:28:16	10	billie-bob	14	6
Trevor the Gorilla makes this song.	2018-03-20 00:33:22	9	billie-bob	13	6
I like the high level of energy running through this song.	2018-03-23 21:06:01	9	e-chase	15	7
I'll go ahead and agree that this song is a rock classic.	2018-03-28 18:10:01	9	anon	8	3
I like this song!	2018-03-28 18:50:00	9	anon	2	1
cool stuff	2018-03-28 18:58:42	3	anon	2	1
\.


--
-- Data for Name: songs; Type: TABLE DATA; Schema: nnc2117; Owner: nnc2117
--

COPY nnc2117.songs (song_id, length, title, genre) FROM stdin;
17	3:22	In The Aeroplane Over the Sea	indie rock
18	4:26	Two-Headed Boy	indie rock
19	5:57	Thriller	pop
20	2:57	Can’t Help Falling in Love	pop
21	4:35	Purple Rain	rock
22	7:02	Hey Jude	rock
23	5:12	A Day in the Life	rock
1	3:01	Basket Case	punk rock
2	2:58	When I Come Around	punk rock
3	3:52	Holiday	punk rock
4	4:18	Say It Ain’t So	alternative rock
5	2:39	Buddy Holly	alternative rock
6	5:05	Undone – The Sweater Song	alternative rock
7	4:03	El Scorcho	alternative rock
8	5:01	Smells Like Teen Spirit	grunge rock
9	2:29	Dumb	grunge rock
10	4:10	Everlong	alternative rock
11	2:56	Monkey Gone to Heaven	alternative rock
12	3:51	Where Is My Mind?	alternative rock
13	3:36	The Less I Know the Better	psychedelic rock
14	4:15	The Moment	psychedelic rock
15	3:32	Supermassive Black Hole	alternative rock
16	4:03	Starlight	alternative rock
\.


--
-- Data for Name: users; Type: TABLE DATA; Schema: nnc2117; Owner: nnc2117
--

COPY nnc2117.users (username, password) FROM stdin;
test-user1	admin
test-user2	admin
test-user3	admin
test-user4	admin
test-user5	admin
test-user6	admin
musiclover1989	music4life
McLovinIt	bigmacboy
bump_dawg12	148276
e-chase	testing
nilesc	hunter2
anon	anon
niles	MyTestPassword
billie-bob	bill
jim83	jimmy
rachel	10101
bob	bob
\.


--
-- Name: acts_pkey; Type: CONSTRAINT; Schema: nnc2117; Owner: nnc2117; Tablespace: 
--

ALTER TABLE ONLY nnc2117.acts
    ADD CONSTRAINT acts_pkey PRIMARY KEY (act_id);


--
-- Name: albums_pkey; Type: CONSTRAINT; Schema: nnc2117; Owner: nnc2117; Tablespace: 
--

ALTER TABLE ONLY nnc2117.albums
    ADD CONSTRAINT albums_pkey PRIMARY KEY (album_id);


--
-- Name: are_friends_pkey; Type: CONSTRAINT; Schema: nnc2117; Owner: nnc2117; Tablespace: 
--

ALTER TABLE ONLY nnc2117.are_friends
    ADD CONSTRAINT are_friends_pkey PRIMARY KEY (username1, username2);


--
-- Name: artists_pkey; Type: CONSTRAINT; Schema: nnc2117; Owner: nnc2117; Tablespace: 
--

ALTER TABLE ONLY nnc2117.artists
    ADD CONSTRAINT artists_pkey PRIMARY KEY (artist_id);


--
-- Name: collections_owns_pkey; Type: CONSTRAINT; Schema: nnc2117; Owner: nnc2117; Tablespace: 
--

ALTER TABLE ONLY nnc2117.collections_owns
    ADD CONSTRAINT collections_owns_pkey PRIMARY KEY (username, name);


--
-- Name: contains_pkey; Type: CONSTRAINT; Schema: nnc2117; Owner: nnc2117; Tablespace: 
--

ALTER TABLE ONLY nnc2117.contains
    ADD CONSTRAINT contains_pkey PRIMARY KEY (name, username, song_id, act_id);


--
-- Name: likes_pkey; Type: CONSTRAINT; Schema: nnc2117; Owner: nnc2117; Tablespace: 
--

ALTER TABLE ONLY nnc2117.likes
    ADD CONSTRAINT likes_pkey PRIMARY KEY (username, song_id);


--
-- Name: part_of_pkey; Type: CONSTRAINT; Schema: nnc2117; Owner: nnc2117; Tablespace: 
--

ALTER TABLE ONLY nnc2117.part_of
    ADD CONSTRAINT part_of_pkey PRIMARY KEY (album_id, song_id);


--
-- Name: performs_pkey; Type: CONSTRAINT; Schema: nnc2117; Owner: nnc2117; Tablespace: 
--

ALTER TABLE ONLY nnc2117.performs
    ADD CONSTRAINT performs_pkey PRIMARY KEY (act_id, song_id);


--
-- Name: plays_in_pkey; Type: CONSTRAINT; Schema: nnc2117; Owner: nnc2117; Tablespace: 
--

ALTER TABLE ONLY nnc2117.plays_in
    ADD CONSTRAINT plays_in_pkey PRIMARY KEY (act_id, artist_id);


--
-- Name: reviews_pkey; Type: CONSTRAINT; Schema: nnc2117; Owner: nnc2117; Tablespace: 
--

ALTER TABLE ONLY nnc2117.reviews
    ADD CONSTRAINT reviews_pkey PRIMARY KEY (username, song_id, act_id, date_time);


--
-- Name: songs_pkey; Type: CONSTRAINT; Schema: nnc2117; Owner: nnc2117; Tablespace: 
--

ALTER TABLE ONLY nnc2117.songs
    ADD CONSTRAINT songs_pkey PRIMARY KEY (song_id);


--
-- Name: users_pkey; Type: CONSTRAINT; Schema: nnc2117; Owner: nnc2117; Tablespace: 
--

ALTER TABLE ONLY nnc2117.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (username);


--
-- Name: are_friends_username1_fkey; Type: FK CONSTRAINT; Schema: nnc2117; Owner: nnc2117
--

ALTER TABLE ONLY nnc2117.are_friends
    ADD CONSTRAINT are_friends_username1_fkey FOREIGN KEY (username1) REFERENCES nnc2117.users(username) ON DELETE CASCADE;


--
-- Name: are_friends_username2_fkey; Type: FK CONSTRAINT; Schema: nnc2117; Owner: nnc2117
--

ALTER TABLE ONLY nnc2117.are_friends
    ADD CONSTRAINT are_friends_username2_fkey FOREIGN KEY (username2) REFERENCES nnc2117.users(username) ON DELETE CASCADE;


--
-- Name: collections_owns_username_fkey; Type: FK CONSTRAINT; Schema: nnc2117; Owner: nnc2117
--

ALTER TABLE ONLY nnc2117.collections_owns
    ADD CONSTRAINT collections_owns_username_fkey FOREIGN KEY (username) REFERENCES nnc2117.users(username) ON DELETE CASCADE;


--
-- Name: contains_act_id_fkey; Type: FK CONSTRAINT; Schema: nnc2117; Owner: nnc2117
--

ALTER TABLE ONLY nnc2117.contains
    ADD CONSTRAINT contains_act_id_fkey FOREIGN KEY (act_id, song_id) REFERENCES nnc2117.performs(act_id, song_id) ON DELETE CASCADE;


--
-- Name: contains_username_fkey; Type: FK CONSTRAINT; Schema: nnc2117; Owner: nnc2117
--

ALTER TABLE ONLY nnc2117.contains
    ADD CONSTRAINT contains_username_fkey FOREIGN KEY (username, name) REFERENCES nnc2117.collections_owns(username, name) ON DELETE CASCADE;


--
-- Name: likes_song_id_fkey; Type: FK CONSTRAINT; Schema: nnc2117; Owner: nnc2117
--

ALTER TABLE ONLY nnc2117.likes
    ADD CONSTRAINT likes_song_id_fkey FOREIGN KEY (song_id) REFERENCES nnc2117.songs(song_id) ON DELETE CASCADE;


--
-- Name: likes_username_fkey; Type: FK CONSTRAINT; Schema: nnc2117; Owner: nnc2117
--

ALTER TABLE ONLY nnc2117.likes
    ADD CONSTRAINT likes_username_fkey FOREIGN KEY (username) REFERENCES nnc2117.users(username) ON DELETE CASCADE;


--
-- Name: part_of_album_id_fkey; Type: FK CONSTRAINT; Schema: nnc2117; Owner: nnc2117
--

ALTER TABLE ONLY nnc2117.part_of
    ADD CONSTRAINT part_of_album_id_fkey FOREIGN KEY (album_id) REFERENCES nnc2117.albums(album_id) ON DELETE CASCADE;


--
-- Name: part_of_song_id_fkey; Type: FK CONSTRAINT; Schema: nnc2117; Owner: nnc2117
--

ALTER TABLE ONLY nnc2117.part_of
    ADD CONSTRAINT part_of_song_id_fkey FOREIGN KEY (song_id) REFERENCES nnc2117.songs(song_id) ON DELETE CASCADE;


--
-- Name: performs_act_id_fkey; Type: FK CONSTRAINT; Schema: nnc2117; Owner: nnc2117
--

ALTER TABLE ONLY nnc2117.performs
    ADD CONSTRAINT performs_act_id_fkey FOREIGN KEY (act_id) REFERENCES nnc2117.acts(act_id) ON DELETE CASCADE;


--
-- Name: performs_song_id_fkey; Type: FK CONSTRAINT; Schema: nnc2117; Owner: nnc2117
--

ALTER TABLE ONLY nnc2117.performs
    ADD CONSTRAINT performs_song_id_fkey FOREIGN KEY (song_id) REFERENCES nnc2117.songs(song_id) ON DELETE CASCADE;


--
-- Name: plays_in_act_id_fkey; Type: FK CONSTRAINT; Schema: nnc2117; Owner: nnc2117
--

ALTER TABLE ONLY nnc2117.plays_in
    ADD CONSTRAINT plays_in_act_id_fkey FOREIGN KEY (act_id) REFERENCES nnc2117.acts(act_id) ON DELETE CASCADE;


--
-- Name: plays_in_artist_id_fkey; Type: FK CONSTRAINT; Schema: nnc2117; Owner: nnc2117
--

ALTER TABLE ONLY nnc2117.plays_in
    ADD CONSTRAINT plays_in_artist_id_fkey FOREIGN KEY (artist_id) REFERENCES nnc2117.artists(artist_id) ON DELETE CASCADE;


--
-- Name: reviews_act_id_fkey; Type: FK CONSTRAINT; Schema: nnc2117; Owner: nnc2117
--

ALTER TABLE ONLY nnc2117.reviews
    ADD CONSTRAINT reviews_act_id_fkey FOREIGN KEY (act_id, song_id) REFERENCES nnc2117.performs(act_id, song_id) ON DELETE CASCADE;


--
-- Name: reviews_username_fkey; Type: FK CONSTRAINT; Schema: nnc2117; Owner: nnc2117
--

ALTER TABLE ONLY nnc2117.reviews
    ADD CONSTRAINT reviews_username_fkey FOREIGN KEY (username) REFERENCES nnc2117.users(username) ON DELETE CASCADE;


--
-- Name: SCHEMA nnc2117; Type: ACL; Schema: -; Owner: nnc2117
--

REVOKE ALL ON SCHEMA nnc2117 FROM PUBLIC;
REVOKE ALL ON SCHEMA nnc2117 FROM nnc2117;
GRANT ALL ON SCHEMA nnc2117 TO nnc2117;


--
-- PostgreSQL database dump complete
--

