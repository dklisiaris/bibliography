--
-- PostgreSQL database dump
--

SET statement_timeout = 0;
SET lock_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;

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


SET search_path = public, pg_catalog;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: authors; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE authors (
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
    tsearch_vector tsvector
);


--
-- Name: authors_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE authors_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: authors_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE authors_id_seq OWNED BY authors.id;


--
-- Name: awards; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE awards (
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

CREATE SEQUENCE awards_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: awards_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE awards_id_seq OWNED BY awards.id;


--
-- Name: books; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE books (
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
    tsearch_vector tsvector
);


--
-- Name: books_categories; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE books_categories (
    book_id integer,
    category_id integer
);


--
-- Name: books_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE books_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: books_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE books_id_seq OWNED BY books.id;


--
-- Name: bookshelves; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE bookshelves (
    id integer NOT NULL,
    book_id integer,
    shelf_id integer,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: bookshelves_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE bookshelves_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: bookshelves_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE bookshelves_id_seq OWNED BY bookshelves.id;


--
-- Name: categories; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE categories (
    id integer NOT NULL,
    name character varying,
    ddc character varying,
    slug character varying,
    biblionet_id integer,
    parent_id integer,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    impressions_count integer DEFAULT 0,
    featured boolean DEFAULT false
);


--
-- Name: categories_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE categories_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: categories_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE categories_id_seq OWNED BY categories.id;


--
-- Name: contributions; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE contributions (
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

CREATE SEQUENCE contributions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: contributions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE contributions_id_seq OWNED BY contributions.id;


--
-- Name: follows; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE follows (
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

CREATE SEQUENCE follows_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: follows_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE follows_id_seq OWNED BY follows.id;


--
-- Name: impressions; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE impressions (
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
    updated_at timestamp without time zone
);


--
-- Name: impressions_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE impressions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: impressions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE impressions_id_seq OWNED BY impressions.id;


--
-- Name: pg_search_documents; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE pg_search_documents (
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

CREATE SEQUENCE pg_search_documents_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: pg_search_documents_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE pg_search_documents_id_seq OWNED BY pg_search_documents.id;


--
-- Name: places; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE places (
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

CREATE SEQUENCE places_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: places_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE places_id_seq OWNED BY places.id;


--
-- Name: prizes; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE prizes (
    id integer NOT NULL,
    name character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: prizes_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE prizes_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: prizes_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE prizes_id_seq OWNED BY prizes.id;


--
-- Name: profiles; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE profiles (
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
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: profiles_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE profiles_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: profiles_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE profiles_id_seq OWNED BY profiles.id;


--
-- Name: publishers; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE publishers (
    id integer NOT NULL,
    name character varying,
    owner character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    biblionet_id integer,
    impressions_count integer DEFAULT 0,
    slug character varying
);


--
-- Name: publishers_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE publishers_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: publishers_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE publishers_id_seq OWNED BY publishers.id;


--
-- Name: royce_connector; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE royce_connector (
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

CREATE SEQUENCE royce_connector_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: royce_connector_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE royce_connector_id_seq OWNED BY royce_connector.id;


--
-- Name: royce_role; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE royce_role (
    id integer NOT NULL,
    name character varying NOT NULL,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: royce_role_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE royce_role_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: royce_role_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE royce_role_id_seq OWNED BY royce_role.id;


--
-- Name: schema_migrations; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE schema_migrations (
    version character varying NOT NULL
);


--
-- Name: shelves; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE shelves (
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

CREATE SEQUENCE shelves_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: shelves_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE shelves_id_seq OWNED BY shelves.id;


--
-- Name: users; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE users (
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
    api_key character varying
);


--
-- Name: users_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE users_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: users_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE users_id_seq OWNED BY users.id;


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY authors ALTER COLUMN id SET DEFAULT nextval('authors_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY awards ALTER COLUMN id SET DEFAULT nextval('awards_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY books ALTER COLUMN id SET DEFAULT nextval('books_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY bookshelves ALTER COLUMN id SET DEFAULT nextval('bookshelves_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY categories ALTER COLUMN id SET DEFAULT nextval('categories_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY contributions ALTER COLUMN id SET DEFAULT nextval('contributions_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY follows ALTER COLUMN id SET DEFAULT nextval('follows_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY impressions ALTER COLUMN id SET DEFAULT nextval('impressions_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY pg_search_documents ALTER COLUMN id SET DEFAULT nextval('pg_search_documents_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY places ALTER COLUMN id SET DEFAULT nextval('places_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY prizes ALTER COLUMN id SET DEFAULT nextval('prizes_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY profiles ALTER COLUMN id SET DEFAULT nextval('profiles_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY publishers ALTER COLUMN id SET DEFAULT nextval('publishers_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY royce_connector ALTER COLUMN id SET DEFAULT nextval('royce_connector_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY royce_role ALTER COLUMN id SET DEFAULT nextval('royce_role_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY shelves ALTER COLUMN id SET DEFAULT nextval('shelves_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY users ALTER COLUMN id SET DEFAULT nextval('users_id_seq'::regclass);


--
-- Name: authors_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY authors
    ADD CONSTRAINT authors_pkey PRIMARY KEY (id);


--
-- Name: awards_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY awards
    ADD CONSTRAINT awards_pkey PRIMARY KEY (id);


--
-- Name: books_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY books
    ADD CONSTRAINT books_pkey PRIMARY KEY (id);


--
-- Name: bookshelves_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY bookshelves
    ADD CONSTRAINT bookshelves_pkey PRIMARY KEY (id);


--
-- Name: categories_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY categories
    ADD CONSTRAINT categories_pkey PRIMARY KEY (id);


--
-- Name: contributions_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY contributions
    ADD CONSTRAINT contributions_pkey PRIMARY KEY (id);


--
-- Name: follows_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY follows
    ADD CONSTRAINT follows_pkey PRIMARY KEY (id);


--
-- Name: impressions_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY impressions
    ADD CONSTRAINT impressions_pkey PRIMARY KEY (id);


--
-- Name: pg_search_documents_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY pg_search_documents
    ADD CONSTRAINT pg_search_documents_pkey PRIMARY KEY (id);


--
-- Name: places_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY places
    ADD CONSTRAINT places_pkey PRIMARY KEY (id);


--
-- Name: prizes_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY prizes
    ADD CONSTRAINT prizes_pkey PRIMARY KEY (id);


--
-- Name: profiles_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY profiles
    ADD CONSTRAINT profiles_pkey PRIMARY KEY (id);


--
-- Name: publishers_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY publishers
    ADD CONSTRAINT publishers_pkey PRIMARY KEY (id);


--
-- Name: royce_connector_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY royce_connector
    ADD CONSTRAINT royce_connector_pkey PRIMARY KEY (id);


--
-- Name: royce_role_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY royce_role
    ADD CONSTRAINT royce_role_pkey PRIMARY KEY (id);


--
-- Name: shelves_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY shelves
    ADD CONSTRAINT shelves_pkey PRIMARY KEY (id);


--
-- Name: users_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: authors_tsearch_idx; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX authors_tsearch_idx ON authors USING gin (tsearch_vector);


--
-- Name: books_tsearch_idx; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX books_tsearch_idx ON books USING gin (tsearch_vector);


--
-- Name: controlleraction_ip_index; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX controlleraction_ip_index ON impressions USING btree (controller_name, action_name, ip_address);


--
-- Name: controlleraction_request_index; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX controlleraction_request_index ON impressions USING btree (controller_name, action_name, request_hash);


--
-- Name: controlleraction_session_index; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX controlleraction_session_index ON impressions USING btree (controller_name, action_name, session_hash);


--
-- Name: fk_followables; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX fk_followables ON follows USING btree (followable_id, followable_type);


--
-- Name: fk_follows; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX fk_follows ON follows USING btree (follower_id, follower_type);


--
-- Name: impressionable_type_message_index; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX impressionable_type_message_index ON impressions USING btree (impressionable_type, message, impressionable_id);


--
-- Name: index_authors_on_biblionet_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX index_authors_on_biblionet_id ON authors USING btree (biblionet_id);


--
-- Name: index_authors_on_slug; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX index_authors_on_slug ON authors USING btree (slug);


--
-- Name: index_awards_on_awardable_id_and_awardable_type; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_awards_on_awardable_id_and_awardable_type ON awards USING btree (awardable_id, awardable_type);


--
-- Name: index_awards_on_prize_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_awards_on_prize_id ON awards USING btree (prize_id);


--
-- Name: index_books_categories_on_book_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_books_categories_on_book_id ON books_categories USING btree (book_id);


--
-- Name: index_books_categories_on_category_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_books_categories_on_category_id ON books_categories USING btree (category_id);


--
-- Name: index_books_on_isbn; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX index_books_on_isbn ON books USING btree (isbn);


--
-- Name: index_books_on_isbn13; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX index_books_on_isbn13 ON books USING btree (isbn13);


--
-- Name: index_books_on_ismn; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX index_books_on_ismn ON books USING btree (ismn);


--
-- Name: index_books_on_publisher_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_books_on_publisher_id ON books USING btree (publisher_id);


--
-- Name: index_books_on_slug; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX index_books_on_slug ON books USING btree (slug);


--
-- Name: index_bookshelves_on_book_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_bookshelves_on_book_id ON bookshelves USING btree (book_id);


--
-- Name: index_bookshelves_on_book_id_and_shelf_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX index_bookshelves_on_book_id_and_shelf_id ON bookshelves USING btree (book_id, shelf_id);


--
-- Name: index_bookshelves_on_shelf_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_bookshelves_on_shelf_id ON bookshelves USING btree (shelf_id);


--
-- Name: index_categories_on_parent_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_categories_on_parent_id ON categories USING btree (parent_id);


--
-- Name: index_categories_on_slug; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX index_categories_on_slug ON categories USING btree (slug);


--
-- Name: index_contributions_on_author_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_contributions_on_author_id ON contributions USING btree (author_id);


--
-- Name: index_contributions_on_book_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_contributions_on_book_id ON contributions USING btree (book_id);


--
-- Name: index_impressions_on_user_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_impressions_on_user_id ON impressions USING btree (user_id);


--
-- Name: index_pg_search_documents_on_searchable_type_and_searchable_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_pg_search_documents_on_searchable_type_and_searchable_id ON pg_search_documents USING btree (searchable_type, searchable_id);


--
-- Name: index_places_on_placeable_id_and_placeable_type; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_places_on_placeable_id_and_placeable_type ON places USING btree (placeable_id, placeable_type);


--
-- Name: index_prizes_on_name; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX index_prizes_on_name ON prizes USING btree (name);


--
-- Name: index_profiles_on_user_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_profiles_on_user_id ON profiles USING btree (user_id);


--
-- Name: index_profiles_on_username; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX index_profiles_on_username ON profiles USING btree (username);


--
-- Name: index_publishers_on_slug; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX index_publishers_on_slug ON publishers USING btree (slug);


--
-- Name: index_royce_connector_on_role_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_royce_connector_on_role_id ON royce_connector USING btree (role_id);


--
-- Name: index_royce_connector_on_roleable_id_and_roleable_type; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_royce_connector_on_roleable_id_and_roleable_type ON royce_connector USING btree (roleable_id, roleable_type);


--
-- Name: index_royce_role_on_name; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_royce_role_on_name ON royce_role USING btree (name);


--
-- Name: index_shelves_on_user_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_shelves_on_user_id ON shelves USING btree (user_id);


--
-- Name: index_users_on_email; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX index_users_on_email ON users USING btree (email);


--
-- Name: index_users_on_reset_password_token; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX index_users_on_reset_password_token ON users USING btree (reset_password_token);


--
-- Name: poly_ip_index; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX poly_ip_index ON impressions USING btree (impressionable_type, impressionable_id, ip_address);


--
-- Name: poly_request_index; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX poly_request_index ON impressions USING btree (impressionable_type, impressionable_id, request_hash);


--
-- Name: poly_session_index; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX poly_session_index ON impressions USING btree (impressionable_type, impressionable_id, session_hash);


--
-- Name: unique_schema_migrations; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX unique_schema_migrations ON schema_migrations USING btree (version);


--
-- Name: fk_rails_237c584e0e; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY bookshelves
    ADD CONSTRAINT fk_rails_237c584e0e FOREIGN KEY (shelf_id) REFERENCES shelves(id);


--
-- Name: fk_rails_426cc1dbb3; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY books_categories
    ADD CONSTRAINT fk_rails_426cc1dbb3 FOREIGN KEY (category_id) REFERENCES categories(id);


--
-- Name: fk_rails_4b64804a3a; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY books_categories
    ADD CONSTRAINT fk_rails_4b64804a3a FOREIGN KEY (book_id) REFERENCES books(id);


--
-- Name: fk_rails_51d9e3825a; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY awards
    ADD CONSTRAINT fk_rails_51d9e3825a FOREIGN KEY (prize_id) REFERENCES prizes(id);


--
-- Name: fk_rails_6b65d5b892; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY shelves
    ADD CONSTRAINT fk_rails_6b65d5b892 FOREIGN KEY (user_id) REFERENCES users(id);


--
-- Name: fk_rails_9a6539777c; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY bookshelves
    ADD CONSTRAINT fk_rails_9a6539777c FOREIGN KEY (book_id) REFERENCES books(id);


--
-- Name: fk_rails_ab8ec95b90; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY contributions
    ADD CONSTRAINT fk_rails_ab8ec95b90 FOREIGN KEY (book_id) REFERENCES books(id);


--
-- Name: fk_rails_c4e3b9f561; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY contributions
    ADD CONSTRAINT fk_rails_c4e3b9f561 FOREIGN KEY (author_id) REFERENCES authors(id);


--
-- Name: fk_rails_d7ae2b039e; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY books
    ADD CONSTRAINT fk_rails_d7ae2b039e FOREIGN KEY (publisher_id) REFERENCES publishers(id);


--
-- Name: fk_rails_e424190865; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY profiles
    ADD CONSTRAINT fk_rails_e424190865 FOREIGN KEY (user_id) REFERENCES users(id);


--
-- PostgreSQL database dump complete
--

SET search_path TO "$user",public;

INSERT INTO schema_migrations (version) VALUES ('20141224113610');

INSERT INTO schema_migrations (version) VALUES ('20141224164302');

INSERT INTO schema_migrations (version) VALUES ('20141224215914');

INSERT INTO schema_migrations (version) VALUES ('20141227180024');

INSERT INTO schema_migrations (version) VALUES ('20141228192751');

INSERT INTO schema_migrations (version) VALUES ('20141228221925');

INSERT INTO schema_migrations (version) VALUES ('20141228234255');

INSERT INTO schema_migrations (version) VALUES ('20141230215655');

INSERT INTO schema_migrations (version) VALUES ('20141230230720');

INSERT INTO schema_migrations (version) VALUES ('20141231014554');

INSERT INTO schema_migrations (version) VALUES ('20141231122037');

INSERT INTO schema_migrations (version) VALUES ('20141231145234');

INSERT INTO schema_migrations (version) VALUES ('20141231181733');

INSERT INTO schema_migrations (version) VALUES ('20141231214257');

INSERT INTO schema_migrations (version) VALUES ('20150101180825');

INSERT INTO schema_migrations (version) VALUES ('20150102131342');

INSERT INTO schema_migrations (version) VALUES ('20150111185403');

INSERT INTO schema_migrations (version) VALUES ('20150112185335');

INSERT INTO schema_migrations (version) VALUES ('20150113124906');

INSERT INTO schema_migrations (version) VALUES ('20150412132653');

INSERT INTO schema_migrations (version) VALUES ('20150412142244');

INSERT INTO schema_migrations (version) VALUES ('20150419134946');

INSERT INTO schema_migrations (version) VALUES ('20150506191222');

INSERT INTO schema_migrations (version) VALUES ('20150506191354');

INSERT INTO schema_migrations (version) VALUES ('20150506191553');

INSERT INTO schema_migrations (version) VALUES ('20150506191847');

INSERT INTO schema_migrations (version) VALUES ('20150513220715');

INSERT INTO schema_migrations (version) VALUES ('20150515100817');

INSERT INTO schema_migrations (version) VALUES ('20150515120907');

INSERT INTO schema_migrations (version) VALUES ('20150515122457');

INSERT INTO schema_migrations (version) VALUES ('20150517205441');

INSERT INTO schema_migrations (version) VALUES ('20150521121122');

INSERT INTO schema_migrations (version) VALUES ('20150521131600');

INSERT INTO schema_migrations (version) VALUES ('20150523102340');

INSERT INTO schema_migrations (version) VALUES ('20150527100323');

INSERT INTO schema_migrations (version) VALUES ('20150527100411');

INSERT INTO schema_migrations (version) VALUES ('20150527100420');

INSERT INTO schema_migrations (version) VALUES ('20150527110154');

INSERT INTO schema_migrations (version) VALUES ('20150615182412');

INSERT INTO schema_migrations (version) VALUES ('20150616120331');

INSERT INTO schema_migrations (version) VALUES ('20150616125149');

INSERT INTO schema_migrations (version) VALUES ('20150616134352');

INSERT INTO schema_migrations (version) VALUES ('20150617190157');

