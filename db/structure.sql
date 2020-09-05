--
-- PostgreSQL database dump
--

-- Dumped from database version 10.8
-- Dumped by pg_dump version 10.8

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
-- Name: plpgsql; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;


--
-- Name: EXTENSION plpgsql; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';


--
-- Name: fuzzystrmatch; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS fuzzystrmatch WITH SCHEMA public;


--
-- Name: EXTENSION fuzzystrmatch; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION fuzzystrmatch IS 'determine similarities and distance between strings';


--
-- Name: hstore; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS hstore WITH SCHEMA public;


--
-- Name: EXTENSION hstore; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION hstore IS 'data type for storing sets of (key, value) pairs';


--
-- Name: pg_trgm; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS pg_trgm WITH SCHEMA public;


--
-- Name: EXTENSION pg_trgm; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION pg_trgm IS 'text similarity measurement and index searching based on trigrams';


--
-- Name: unaccent; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS unaccent WITH SCHEMA public;


--
-- Name: EXTENSION unaccent; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION unaccent IS 'text search dictionary that removes accents';


SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: activities; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.activities (
    id integer NOT NULL,
    trackable_id integer,
    trackable_type character varying,
    owner_id integer,
    owner_type character varying,
    key character varying,
    parameters text,
    recipient_id integer,
    recipient_type character varying,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: activities_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.activities_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: activities_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.activities_id_seq OWNED BY public.activities.id;


--
-- Name: ar_internal_metadata; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.ar_internal_metadata (
    key character varying NOT NULL,
    value character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: authors; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.authors (
    id integer NOT NULL,
    firstname character varying,
    lastname character varying,
    extra_info character varying,
    biography text,
    image character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    biblionet_id integer,
    impressions_count integer DEFAULT 0,
    slug character varying,
    tsearch_vector tsvector,
    contributions_count integer DEFAULT 0,
    uploaded_avatar character varying,
    masterpiece_id integer
);


--
-- Name: authors_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.authors_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: authors_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.authors_id_seq OWNED BY public.authors.id;


--
-- Name: awards; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.awards (
    id integer NOT NULL,
    prize_id integer,
    year integer,
    awardable_id integer,
    awardable_type character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: awards_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.awards_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: awards_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.awards_id_seq OWNED BY public.awards.id;


--
-- Name: books; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.books (
    id integer NOT NULL,
    title character varying,
    subtitle character varying,
    description text,
    image character varying,
    isbn character varying,
    isbn13 character varying,
    ismn character varying,
    issn character varying,
    series_name character varying,
    pages integer,
    publication_year integer,
    publication_place character varying,
    price numeric(6,2),
    price_updated_at date,
    size character varying,
    cover_type integer DEFAULT 0,
    availability integer DEFAULT 0,
    format integer DEFAULT 0,
    original_language integer,
    original_title character varying,
    publisher_id integer,
    extra character varying,
    biblionet_id integer,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    collective_work boolean DEFAULT false,
    series_volume integer,
    publication_version integer,
    impressions_count integer DEFAULT 0,
    slug character varying,
    language integer,
    tsearch_vector tsvector,
    series_id integer,
    liked_by_count_cache integer DEFAULT 0,
    disliked_by_count_cache integer DEFAULT 0,
    bookshelves_count integer DEFAULT 0,
    views_count integer DEFAULT 0,
    uploaded_cover character varying,
    main_writer_id integer
);


--
-- Name: books_categories; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.books_categories (
    book_id integer,
    category_id integer
);


--
-- Name: books_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.books_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: books_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.books_id_seq OWNED BY public.books.id;


--
-- Name: bookshelves; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.bookshelves (
    id integer NOT NULL,
    book_id integer,
    shelf_id integer,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: bookshelves_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.bookshelves_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: bookshelves_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.bookshelves_id_seq OWNED BY public.bookshelves.id;


--
-- Name: categories; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.categories (
    id integer NOT NULL,
    name character varying,
    ddc character varying,
    slug character varying,
    biblionet_id integer,
    parent_id integer,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    impressions_count integer DEFAULT 0,
    featured boolean DEFAULT false,
    tsearch_vector tsvector
);


--
-- Name: categories_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.categories_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: categories_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.categories_id_seq OWNED BY public.categories.id;


--
-- Name: comments; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.comments (
    id integer NOT NULL,
    commentable_id integer,
    commentable_type character varying,
    title character varying,
    body text,
    subject character varying,
    user_id integer NOT NULL,
    parent_id integer,
    lft integer,
    rgt integer,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: comments_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.comments_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: comments_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.comments_id_seq OWNED BY public.comments.id;


--
-- Name: contributions; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.contributions (
    id integer NOT NULL,
    job integer,
    book_id integer,
    author_id integer,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: contributions_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.contributions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: contributions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.contributions_id_seq OWNED BY public.contributions.id;


--
-- Name: daily_suggestions; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.daily_suggestions (
    id integer NOT NULL,
    book_id integer,
    suggested_at timestamp without time zone,
    suggested_count integer DEFAULT 0
);


--
-- Name: daily_suggestions_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.daily_suggestions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: daily_suggestions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.daily_suggestions_id_seq OWNED BY public.daily_suggestions.id;


--
-- Name: follows; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.follows (
    id integer NOT NULL,
    followable_id integer NOT NULL,
    followable_type character varying NOT NULL,
    follower_id integer NOT NULL,
    follower_type character varying NOT NULL,
    blocked boolean DEFAULT false NOT NULL,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: follows_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.follows_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: follows_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.follows_id_seq OWNED BY public.follows.id;


--
-- Name: impressions; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.impressions (
    id integer NOT NULL,
    impressionable_type character varying,
    impressionable_id integer,
    user_id integer,
    controller_name character varying,
    action_name character varying,
    view_name character varying,
    request_hash character varying,
    ip_address character varying,
    session_hash character varying,
    message text,
    referrer text,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    params text
);


--
-- Name: impressions_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.impressions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: impressions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.impressions_id_seq OWNED BY public.impressions.id;


--
-- Name: pg_search_documents; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.pg_search_documents (
    id integer NOT NULL,
    content text,
    searchable_id integer,
    searchable_type character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: pg_search_documents_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.pg_search_documents_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: pg_search_documents_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.pg_search_documents_id_seq OWNED BY public.pg_search_documents.id;


--
-- Name: places; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.places (
    id integer NOT NULL,
    name character varying,
    role character varying,
    address character varying,
    telephone character varying,
    fax character varying,
    email character varying,
    website character varying,
    latitude numeric(10,6),
    longitude numeric(10,6),
    placeable_id integer,
    placeable_type character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: places_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.places_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: places_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.places_id_seq OWNED BY public.places.id;


--
-- Name: prizes; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.prizes (
    id integer NOT NULL,
    name character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: prizes_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.prizes_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: prizes_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.prizes_id_seq OWNED BY public.prizes.id;


--
-- Name: profiles; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.profiles (
    id integer NOT NULL,
    username character varying,
    name character varying,
    avatar character varying,
    cover character varying,
    about_me text,
    about_library text,
    account_type integer DEFAULT 0,
    privacy integer DEFAULT 0,
    language integer DEFAULT 0,
    allow_comments boolean DEFAULT true,
    allow_friends boolean DEFAULT true,
    email_privacy integer DEFAULT 0,
    discoverable_by_email boolean DEFAULT true,
    receive_newsletters boolean DEFAULT true,
    user_id integer,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    social public.hstore,
    gender integer,
    city character varying,
    birthday timestamp without time zone
);


--
-- Name: profiles_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.profiles_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: profiles_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.profiles_id_seq OWNED BY public.profiles.id;


--
-- Name: publishers; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.publishers (
    id integer NOT NULL,
    name character varying,
    owner character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    biblionet_id integer,
    impressions_count integer DEFAULT 0,
    slug character varying,
    tsearch_vector tsvector,
    books_count integer DEFAULT 0
);


--
-- Name: publishers_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.publishers_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: publishers_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.publishers_id_seq OWNED BY public.publishers.id;


--
-- Name: ratings; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.ratings (
    id integer NOT NULL,
    user_id integer NOT NULL,
    rateable_id integer NOT NULL,
    rateable_type character varying NOT NULL,
    rate integer NOT NULL,
    bookmark boolean DEFAULT false
);


--
-- Name: ratings_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.ratings_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: ratings_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.ratings_id_seq OWNED BY public.ratings.id;


--
-- Name: royce_connector; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.royce_connector (
    id integer NOT NULL,
    roleable_id integer NOT NULL,
    roleable_type character varying NOT NULL,
    role_id integer NOT NULL,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: royce_connector_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.royce_connector_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: royce_connector_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.royce_connector_id_seq OWNED BY public.royce_connector.id;


--
-- Name: royce_role; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.royce_role (
    id integer NOT NULL,
    name character varying NOT NULL,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: royce_role_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.royce_role_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: royce_role_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.royce_role_id_seq OWNED BY public.royce_role.id;


--
-- Name: schema_migrations; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.schema_migrations (
    version character varying NOT NULL
);


--
-- Name: series; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.series (
    id integer NOT NULL,
    name character varying,
    books_count integer DEFAULT 0,
    tsearch_vector tsvector,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: series_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.series_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: series_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.series_id_seq OWNED BY public.series.id;


--
-- Name: shelves; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.shelves (
    id integer NOT NULL,
    name character varying,
    privacy integer DEFAULT 0,
    built_in boolean DEFAULT false,
    default_name integer DEFAULT 0,
    active boolean DEFAULT true,
    user_id integer,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: shelves_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.shelves_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: shelves_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.shelves_id_seq OWNED BY public.shelves.id;


--
-- Name: users; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.users (
    id integer NOT NULL,
    email character varying DEFAULT ''::character varying NOT NULL,
    encrypted_password character varying DEFAULT ''::character varying NOT NULL,
    reset_password_token character varying,
    reset_password_sent_at timestamp without time zone,
    remember_created_at timestamp without time zone,
    sign_in_count integer DEFAULT 0 NOT NULL,
    current_sign_in_at timestamp without time zone,
    last_sign_in_at timestamp without time zone,
    current_sign_in_ip character varying,
    last_sign_in_ip character varying,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    api_key character varying,
    provider character varying,
    uid character varying
);


--
-- Name: users_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.users_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: users_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.users_id_seq OWNED BY public.users.id;


--
-- Name: activities id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.activities ALTER COLUMN id SET DEFAULT nextval('public.activities_id_seq'::regclass);


--
-- Name: authors id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.authors ALTER COLUMN id SET DEFAULT nextval('public.authors_id_seq'::regclass);


--
-- Name: awards id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.awards ALTER COLUMN id SET DEFAULT nextval('public.awards_id_seq'::regclass);


--
-- Name: books id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.books ALTER COLUMN id SET DEFAULT nextval('public.books_id_seq'::regclass);


--
-- Name: bookshelves id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.bookshelves ALTER COLUMN id SET DEFAULT nextval('public.bookshelves_id_seq'::regclass);


--
-- Name: categories id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.categories ALTER COLUMN id SET DEFAULT nextval('public.categories_id_seq'::regclass);


--
-- Name: comments id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.comments ALTER COLUMN id SET DEFAULT nextval('public.comments_id_seq'::regclass);


--
-- Name: contributions id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.contributions ALTER COLUMN id SET DEFAULT nextval('public.contributions_id_seq'::regclass);


--
-- Name: daily_suggestions id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.daily_suggestions ALTER COLUMN id SET DEFAULT nextval('public.daily_suggestions_id_seq'::regclass);


--
-- Name: follows id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.follows ALTER COLUMN id SET DEFAULT nextval('public.follows_id_seq'::regclass);


--
-- Name: impressions id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.impressions ALTER COLUMN id SET DEFAULT nextval('public.impressions_id_seq'::regclass);


--
-- Name: pg_search_documents id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.pg_search_documents ALTER COLUMN id SET DEFAULT nextval('public.pg_search_documents_id_seq'::regclass);


--
-- Name: places id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.places ALTER COLUMN id SET DEFAULT nextval('public.places_id_seq'::regclass);


--
-- Name: prizes id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.prizes ALTER COLUMN id SET DEFAULT nextval('public.prizes_id_seq'::regclass);


--
-- Name: profiles id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.profiles ALTER COLUMN id SET DEFAULT nextval('public.profiles_id_seq'::regclass);


--
-- Name: publishers id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.publishers ALTER COLUMN id SET DEFAULT nextval('public.publishers_id_seq'::regclass);


--
-- Name: ratings id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.ratings ALTER COLUMN id SET DEFAULT nextval('public.ratings_id_seq'::regclass);


--
-- Name: royce_connector id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.royce_connector ALTER COLUMN id SET DEFAULT nextval('public.royce_connector_id_seq'::regclass);


--
-- Name: royce_role id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.royce_role ALTER COLUMN id SET DEFAULT nextval('public.royce_role_id_seq'::regclass);


--
-- Name: series id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.series ALTER COLUMN id SET DEFAULT nextval('public.series_id_seq'::regclass);


--
-- Name: shelves id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.shelves ALTER COLUMN id SET DEFAULT nextval('public.shelves_id_seq'::regclass);


--
-- Name: users id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.users ALTER COLUMN id SET DEFAULT nextval('public.users_id_seq'::regclass);


--
-- Name: activities activities_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.activities
    ADD CONSTRAINT activities_pkey PRIMARY KEY (id);


--
-- Name: ar_internal_metadata ar_internal_metadata_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.ar_internal_metadata
    ADD CONSTRAINT ar_internal_metadata_pkey PRIMARY KEY (key);


--
-- Name: authors authors_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.authors
    ADD CONSTRAINT authors_pkey PRIMARY KEY (id);


--
-- Name: awards awards_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.awards
    ADD CONSTRAINT awards_pkey PRIMARY KEY (id);


--
-- Name: books books_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.books
    ADD CONSTRAINT books_pkey PRIMARY KEY (id);


--
-- Name: bookshelves bookshelves_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.bookshelves
    ADD CONSTRAINT bookshelves_pkey PRIMARY KEY (id);


--
-- Name: categories categories_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.categories
    ADD CONSTRAINT categories_pkey PRIMARY KEY (id);


--
-- Name: comments comments_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.comments
    ADD CONSTRAINT comments_pkey PRIMARY KEY (id);


--
-- Name: contributions contributions_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.contributions
    ADD CONSTRAINT contributions_pkey PRIMARY KEY (id);


--
-- Name: daily_suggestions daily_suggestions_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.daily_suggestions
    ADD CONSTRAINT daily_suggestions_pkey PRIMARY KEY (id);


--
-- Name: follows follows_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.follows
    ADD CONSTRAINT follows_pkey PRIMARY KEY (id);


--
-- Name: impressions impressions_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.impressions
    ADD CONSTRAINT impressions_pkey PRIMARY KEY (id);


--
-- Name: pg_search_documents pg_search_documents_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.pg_search_documents
    ADD CONSTRAINT pg_search_documents_pkey PRIMARY KEY (id);


--
-- Name: places places_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.places
    ADD CONSTRAINT places_pkey PRIMARY KEY (id);


--
-- Name: prizes prizes_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.prizes
    ADD CONSTRAINT prizes_pkey PRIMARY KEY (id);


--
-- Name: profiles profiles_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.profiles
    ADD CONSTRAINT profiles_pkey PRIMARY KEY (id);


--
-- Name: publishers publishers_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.publishers
    ADD CONSTRAINT publishers_pkey PRIMARY KEY (id);


--
-- Name: ratings ratings_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.ratings
    ADD CONSTRAINT ratings_pkey PRIMARY KEY (id);


--
-- Name: royce_connector royce_connector_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.royce_connector
    ADD CONSTRAINT royce_connector_pkey PRIMARY KEY (id);


--
-- Name: royce_role royce_role_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.royce_role
    ADD CONSTRAINT royce_role_pkey PRIMARY KEY (id);


--
-- Name: series series_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.series
    ADD CONSTRAINT series_pkey PRIMARY KEY (id);


--
-- Name: shelves shelves_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.shelves
    ADD CONSTRAINT shelves_pkey PRIMARY KEY (id);


--
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: authors_tsearch_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX authors_tsearch_idx ON public.authors USING gin (tsearch_vector);


--
-- Name: books_tsearch_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX books_tsearch_idx ON public.books USING gin (tsearch_vector);


--
-- Name: categories_tsearch_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX categories_tsearch_idx ON public.categories USING gin (tsearch_vector);


--
-- Name: controlleraction_ip_index; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX controlleraction_ip_index ON public.impressions USING btree (controller_name, action_name, ip_address);


--
-- Name: controlleraction_request_index; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX controlleraction_request_index ON public.impressions USING btree (controller_name, action_name, request_hash);


--
-- Name: controlleraction_session_index; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX controlleraction_session_index ON public.impressions USING btree (controller_name, action_name, session_hash);


--
-- Name: fk_followables; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX fk_followables ON public.follows USING btree (followable_id, followable_type);


--
-- Name: fk_follows; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX fk_follows ON public.follows USING btree (follower_id, follower_type);


--
-- Name: fk_rateables; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX fk_rateables ON public.ratings USING btree (rateable_id, rateable_type);


--
-- Name: impressionable_type_message_index; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX impressionable_type_message_index ON public.impressions USING btree (impressionable_type, message, impressionable_id);


--
-- Name: index_activities_on_owner_id_and_owner_type; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_activities_on_owner_id_and_owner_type ON public.activities USING btree (owner_id, owner_type);


--
-- Name: index_activities_on_recipient_id_and_recipient_type; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_activities_on_recipient_id_and_recipient_type ON public.activities USING btree (recipient_id, recipient_type);


--
-- Name: index_activities_on_trackable_id_and_trackable_type; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_activities_on_trackable_id_and_trackable_type ON public.activities USING btree (trackable_id, trackable_type);


--
-- Name: index_authors_on_biblionet_id; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_authors_on_biblionet_id ON public.authors USING btree (biblionet_id);


--
-- Name: index_authors_on_masterpiece_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_authors_on_masterpiece_id ON public.authors USING btree (masterpiece_id);


--
-- Name: index_authors_on_slug; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_authors_on_slug ON public.authors USING btree (slug);


--
-- Name: index_awards_on_awardable_id_and_awardable_type; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_awards_on_awardable_id_and_awardable_type ON public.awards USING btree (awardable_id, awardable_type);


--
-- Name: index_awards_on_prize_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_awards_on_prize_id ON public.awards USING btree (prize_id);


--
-- Name: index_books_categories_on_book_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_books_categories_on_book_id ON public.books_categories USING btree (book_id);


--
-- Name: index_books_categories_on_category_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_books_categories_on_category_id ON public.books_categories USING btree (category_id);


--
-- Name: index_books_on_isbn; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_books_on_isbn ON public.books USING btree (isbn);


--
-- Name: index_books_on_isbn13; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_books_on_isbn13 ON public.books USING btree (isbn13);


--
-- Name: index_books_on_ismn; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_books_on_ismn ON public.books USING btree (ismn);


--
-- Name: index_books_on_main_writer_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_books_on_main_writer_id ON public.books USING btree (main_writer_id);


--
-- Name: index_books_on_publisher_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_books_on_publisher_id ON public.books USING btree (publisher_id);


--
-- Name: index_books_on_series_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_books_on_series_id ON public.books USING btree (series_id);


--
-- Name: index_books_on_slug; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_books_on_slug ON public.books USING btree (slug);


--
-- Name: index_bookshelves_on_book_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_bookshelves_on_book_id ON public.bookshelves USING btree (book_id);


--
-- Name: index_bookshelves_on_book_id_and_shelf_id; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_bookshelves_on_book_id_and_shelf_id ON public.bookshelves USING btree (book_id, shelf_id);


--
-- Name: index_bookshelves_on_shelf_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_bookshelves_on_shelf_id ON public.bookshelves USING btree (shelf_id);


--
-- Name: index_categories_on_parent_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_categories_on_parent_id ON public.categories USING btree (parent_id);


--
-- Name: index_categories_on_slug; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_categories_on_slug ON public.categories USING btree (slug);


--
-- Name: index_comments_on_commentable_id_and_commentable_type; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_comments_on_commentable_id_and_commentable_type ON public.comments USING btree (commentable_id, commentable_type);


--
-- Name: index_comments_on_user_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_comments_on_user_id ON public.comments USING btree (user_id);


--
-- Name: index_contributions_on_author_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_contributions_on_author_id ON public.contributions USING btree (author_id);


--
-- Name: index_contributions_on_book_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_contributions_on_book_id ON public.contributions USING btree (book_id);


--
-- Name: index_daily_suggestions_on_book_id; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_daily_suggestions_on_book_id ON public.daily_suggestions USING btree (book_id);


--
-- Name: index_impressions_on_user_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_impressions_on_user_id ON public.impressions USING btree (user_id);


--
-- Name: index_pg_search_documents_on_searchable_type_and_searchable_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_pg_search_documents_on_searchable_type_and_searchable_id ON public.pg_search_documents USING btree (searchable_type, searchable_id);


--
-- Name: index_places_on_placeable_id_and_placeable_type; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_places_on_placeable_id_and_placeable_type ON public.places USING btree (placeable_id, placeable_type);


--
-- Name: index_prizes_on_name; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_prizes_on_name ON public.prizes USING btree (name);


--
-- Name: index_profiles_on_user_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_profiles_on_user_id ON public.profiles USING btree (user_id);


--
-- Name: index_profiles_on_username; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_profiles_on_username ON public.profiles USING btree (username);


--
-- Name: index_publishers_on_slug; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_publishers_on_slug ON public.publishers USING btree (slug);


--
-- Name: index_ratings_on_user_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_ratings_on_user_id ON public.ratings USING btree (user_id);


--
-- Name: index_royce_connector_on_role_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_royce_connector_on_role_id ON public.royce_connector USING btree (role_id);


--
-- Name: index_royce_connector_on_roleable_id_and_roleable_type; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_royce_connector_on_roleable_id_and_roleable_type ON public.royce_connector USING btree (roleable_id, roleable_type);


--
-- Name: index_royce_role_on_name; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_royce_role_on_name ON public.royce_role USING btree (name);


--
-- Name: index_shelves_on_user_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_shelves_on_user_id ON public.shelves USING btree (user_id);


--
-- Name: index_users_on_email; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_users_on_email ON public.users USING btree (email);


--
-- Name: index_users_on_reset_password_token; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_users_on_reset_password_token ON public.users USING btree (reset_password_token);


--
-- Name: poly_ip_index; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX poly_ip_index ON public.impressions USING btree (impressionable_type, impressionable_id, ip_address);


--
-- Name: poly_params_request_index; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX poly_params_request_index ON public.impressions USING btree (impressionable_type, impressionable_id, params);


--
-- Name: poly_request_index; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX poly_request_index ON public.impressions USING btree (impressionable_type, impressionable_id, request_hash);


--
-- Name: poly_session_index; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX poly_session_index ON public.impressions USING btree (impressionable_type, impressionable_id, session_hash);


--
-- Name: publishers_tsearch_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX publishers_tsearch_idx ON public.publishers USING gin (tsearch_vector);


--
-- Name: unique_schema_migrations; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX unique_schema_migrations ON public.schema_migrations USING btree (version);


--
-- Name: books fk_rails_1c0d164eeb; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.books
    ADD CONSTRAINT fk_rails_1c0d164eeb FOREIGN KEY (series_id) REFERENCES public.series(id);


--
-- Name: bookshelves fk_rails_237c584e0e; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.bookshelves
    ADD CONSTRAINT fk_rails_237c584e0e FOREIGN KEY (shelf_id) REFERENCES public.shelves(id);


--
-- Name: books_categories fk_rails_426cc1dbb3; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.books_categories
    ADD CONSTRAINT fk_rails_426cc1dbb3 FOREIGN KEY (category_id) REFERENCES public.categories(id);


--
-- Name: books_categories fk_rails_4b64804a3a; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.books_categories
    ADD CONSTRAINT fk_rails_4b64804a3a FOREIGN KEY (book_id) REFERENCES public.books(id);


--
-- Name: awards fk_rails_51d9e3825a; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.awards
    ADD CONSTRAINT fk_rails_51d9e3825a FOREIGN KEY (prize_id) REFERENCES public.prizes(id);


--
-- Name: shelves fk_rails_6b65d5b892; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.shelves
    ADD CONSTRAINT fk_rails_6b65d5b892 FOREIGN KEY (user_id) REFERENCES public.users(id);


--
-- Name: bookshelves fk_rails_9a6539777c; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.bookshelves
    ADD CONSTRAINT fk_rails_9a6539777c FOREIGN KEY (book_id) REFERENCES public.books(id);


--
-- Name: contributions fk_rails_ab8ec95b90; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.contributions
    ADD CONSTRAINT fk_rails_ab8ec95b90 FOREIGN KEY (book_id) REFERENCES public.books(id);


--
-- Name: contributions fk_rails_c4e3b9f561; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.contributions
    ADD CONSTRAINT fk_rails_c4e3b9f561 FOREIGN KEY (author_id) REFERENCES public.authors(id);


--
-- Name: books fk_rails_d7ae2b039e; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.books
    ADD CONSTRAINT fk_rails_d7ae2b039e FOREIGN KEY (publisher_id) REFERENCES public.publishers(id);


--
-- Name: profiles fk_rails_e424190865; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.profiles
    ADD CONSTRAINT fk_rails_e424190865 FOREIGN KEY (user_id) REFERENCES public.users(id);


--
-- PostgreSQL database dump complete
--

SET search_path TO "$user", public;

INSERT INTO "schema_migrations" (version) VALUES
('20141224113610'),
('20141224164302'),
('20141224215914'),
('20141227180024'),
('20141228192751'),
('20141228221925'),
('20141228234255'),
('20141230215655'),
('20141230230720'),
('20141231014554'),
('20141231122037'),
('20141231145234'),
('20141231181733'),
('20141231214257'),
('20150101180825'),
('20150102131342'),
('20150111185403'),
('20150112185335'),
('20150113124906'),
('20150412132653'),
('20150412142244'),
('20150419134946'),
('20150506191222'),
('20150506191354'),
('20150506191553'),
('20150506191847'),
('20150513220715'),
('20150515100817'),
('20150515120907'),
('20150515122457'),
('20150517205441'),
('20150521121122'),
('20150521131600'),
('20150523102340'),
('20150527100323'),
('20150527100411'),
('20150527100420'),
('20150527110154'),
('20150615182412'),
('20150616120331'),
('20150616125149'),
('20150616134352'),
('20150617190157'),
('20150618174541'),
('20150619193344'),
('20151003140444'),
('20160521142614'),
('20160521200629'),
('20161229202559'),
('20161229202920'),
('20161229221829'),
('20161230145401'),
('20170331095631'),
('20170412202745'),
('20170412203337'),
('20170419124824'),
('20170419141515'),
('20170419145719'),
('20170903183316'),
('20170903214213'),
('20170906120011'),
('20170912082754'),
('20170912092805'),
('20170918120936'),
('20200905162806');


