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
-- Name: uuid-ossp; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS "uuid-ossp" WITH SCHEMA public;


--
-- Name: EXTENSION "uuid-ossp"; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION "uuid-ossp" IS 'generate universally unique identifiers (UUIDs)';


SET search_path = public, pg_catalog;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: accounts; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE accounts (
    id integer NOT NULL,
    email character varying(255) NOT NULL,
    crypted_password character varying(255),
    salt character varying(255),
    name character varying(255) DEFAULT ''::character varying NOT NULL,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    remember_me_token character varying(255),
    remember_me_token_expires_at timestamp without time zone,
    reset_password_token character varying(255),
    reset_password_token_expires_at timestamp without time zone,
    reset_password_email_sent_at timestamp without time zone,
    password_set boolean DEFAULT true,
    last_login_at timestamp without time zone,
    last_logout_at timestamp without time zone,
    last_activity_at timestamp without time zone,
    last_login_from_ip_address character varying(255),
    type character varying(255)
);


--
-- Name: accounts_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE accounts_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: accounts_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE accounts_id_seq OWNED BY accounts.id;


--
-- Name: api_keys; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE api_keys (
    id integer NOT NULL,
    token character varying(255) NOT NULL,
    type character varying(255) NOT NULL,
    room_id integer,
    user_id integer
);


--
-- Name: api_keys_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE api_keys_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: api_keys_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE api_keys_id_seq OWNED BY api_keys.id;


--
-- Name: identities; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE identities (
    id integer NOT NULL,
    user_id integer NOT NULL,
    provider character varying(255) NOT NULL,
    uid character varying(255) NOT NULL,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    name character varying(255),
    email character varying(255),
    nickname character varying(255),
    first_name character varying(255),
    last_name character varying(255),
    avatar character varying(255),
    access_token character varying(255),
    secret_token character varying(255),
    description text,
    location character varying(255),
    urls json
);


--
-- Name: identities_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE identities_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: identities_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE identities_id_seq OWNED BY identities.id;


--
-- Name: invitations; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE invitations (
    id integer NOT NULL,
    token character varying(255),
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    room_id integer,
    email character varying(255)
);


--
-- Name: invitations_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE invitations_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: invitations_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE invitations_id_seq OWNED BY invitations.id;


--
-- Name: messages; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE messages (
    id integer NOT NULL,
    room_id integer,
    parent_id integer,
    author_id integer,
    body text,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    attachment_file_name character varying(255),
    attachment_content_type character varying(255),
    attachment_file_size integer,
    attachment_updated_at timestamp without time zone,
    parameters json,
    type character varying(255),
    edited_at timestamp without time zone
);


--
-- Name: messages_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE messages_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: messages_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE messages_id_seq OWNED BY messages.id;


--
-- Name: organization_memberships; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE organization_memberships (
    id integer NOT NULL,
    user_id integer,
    organization_id integer
);


--
-- Name: organization_memberships_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE organization_memberships_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: organization_memberships_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE organization_memberships_id_seq OWNED BY organization_memberships.id;


--
-- Name: preferences; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE preferences (
    id integer NOT NULL,
    user_id integer NOT NULL,
    audio_volume integer DEFAULT 100,
    audio_notification character varying(255) DEFAULT 'mentions'::character varying,
    desktop_notification character varying(255) DEFAULT 'mentions'::character varying,
    email_notification boolean DEFAULT true,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: preferences_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE preferences_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: preferences_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE preferences_id_seq OWNED BY preferences.id;


--
-- Name: profiles; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE profiles (
    id integer NOT NULL,
    account_id integer,
    name character varying(255),
    email character varying(255),
    location character varying(255),
    company character varying(255),
    website character varying(255),
    avatar_file_name character varying(255),
    avatar_content_type character varying(255),
    avatar_file_size integer,
    avatar_updated_at timestamp without time zone,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    description text,
    avatar_provider_id integer
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
-- Name: repositories; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE repositories (
    id integer NOT NULL,
    room_id integer,
    name character varying(255),
    type character varying(255),
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    hook_id integer,
    events character varying(255)[] DEFAULT '{}'::character varying[]
);


--
-- Name: repositories_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE repositories_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: repositories_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE repositories_id_seq OWNED BY repositories.id;


--
-- Name: roles; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE roles (
    id integer NOT NULL,
    name character varying(255)
);


--
-- Name: roles_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE roles_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: roles_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE roles_id_seq OWNED BY roles.id;


--
-- Name: room_memberships; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE room_memberships (
    id integer NOT NULL,
    user_id integer NOT NULL,
    room_id integer NOT NULL,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    room_hidden boolean DEFAULT false NOT NULL
);


--
-- Name: room_memberships_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE room_memberships_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: room_memberships_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE room_memberships_id_seq OWNED BY room_memberships.id;


--
-- Name: rooms; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE rooms (
    id integer NOT NULL,
    name character varying(255),
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    slug character varying(255) NOT NULL,
    owner_id integer,
    access character varying(255),
    access_policy character varying(255)
);


--
-- Name: rooms_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE rooms_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: rooms_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE rooms_id_seq OWNED BY rooms.id;


--
-- Name: schema_migrations; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE schema_migrations (
    version character varying(255) NOT NULL
);


--
-- Name: taggings; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE taggings (
    id integer NOT NULL,
    message_id integer NOT NULL,
    tag_id integer NOT NULL
);


--
-- Name: taggings_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE taggings_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: taggings_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE taggings_id_seq OWNED BY taggings.id;


--
-- Name: tags; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE tags (
    id integer NOT NULL,
    name character varying(255) NOT NULL,
    type character varying(255) NOT NULL
);


--
-- Name: tags_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE tags_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: tags_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE tags_id_seq OWNED BY tags.id;


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY accounts ALTER COLUMN id SET DEFAULT nextval('accounts_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY api_keys ALTER COLUMN id SET DEFAULT nextval('api_keys_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY identities ALTER COLUMN id SET DEFAULT nextval('identities_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY invitations ALTER COLUMN id SET DEFAULT nextval('invitations_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY messages ALTER COLUMN id SET DEFAULT nextval('messages_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY organization_memberships ALTER COLUMN id SET DEFAULT nextval('organization_memberships_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY preferences ALTER COLUMN id SET DEFAULT nextval('preferences_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY profiles ALTER COLUMN id SET DEFAULT nextval('profiles_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY repositories ALTER COLUMN id SET DEFAULT nextval('repositories_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY roles ALTER COLUMN id SET DEFAULT nextval('roles_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY room_memberships ALTER COLUMN id SET DEFAULT nextval('room_memberships_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY rooms ALTER COLUMN id SET DEFAULT nextval('rooms_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY taggings ALTER COLUMN id SET DEFAULT nextval('taggings_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY tags ALTER COLUMN id SET DEFAULT nextval('tags_id_seq'::regclass);


--
-- Name: api_keys_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY api_keys
    ADD CONSTRAINT api_keys_pkey PRIMARY KEY (id);


--
-- Name: authentications_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY identities
    ADD CONSTRAINT authentications_pkey PRIMARY KEY (id);


--
-- Name: invitations_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY invitations
    ADD CONSTRAINT invitations_pkey PRIMARY KEY (id);


--
-- Name: messages_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY messages
    ADD CONSTRAINT messages_pkey PRIMARY KEY (id);


--
-- Name: organization_memberships_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY organization_memberships
    ADD CONSTRAINT organization_memberships_pkey PRIMARY KEY (id);


--
-- Name: preferences_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY preferences
    ADD CONSTRAINT preferences_pkey PRIMARY KEY (id);


--
-- Name: profiles_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY profiles
    ADD CONSTRAINT profiles_pkey PRIMARY KEY (id);


--
-- Name: repositories_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY repositories
    ADD CONSTRAINT repositories_pkey PRIMARY KEY (id);


--
-- Name: roles_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY roles
    ADD CONSTRAINT roles_pkey PRIMARY KEY (id);


--
-- Name: rooms_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY rooms
    ADD CONSTRAINT rooms_pkey PRIMARY KEY (id);


--
-- Name: rooms_users_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY room_memberships
    ADD CONSTRAINT rooms_users_pkey PRIMARY KEY (id);


--
-- Name: taggings_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY taggings
    ADD CONSTRAINT taggings_pkey PRIMARY KEY (id);


--
-- Name: tags_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY tags
    ADD CONSTRAINT tags_pkey PRIMARY KEY (id);


--
-- Name: users_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY accounts
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: index_accounts_on_email; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX index_accounts_on_email ON accounts USING btree (email);


--
-- Name: index_accounts_on_last_logout_at_and_last_activity_at; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_accounts_on_last_logout_at_and_last_activity_at ON accounts USING btree (last_logout_at, last_activity_at);


--
-- Name: index_accounts_on_name; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX index_accounts_on_name ON accounts USING btree (name);


--
-- Name: index_accounts_on_remember_me_token; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_accounts_on_remember_me_token ON accounts USING btree (remember_me_token);


--
-- Name: index_accounts_on_reset_password_token; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_accounts_on_reset_password_token ON accounts USING btree (reset_password_token);


--
-- Name: index_api_keys_on_room_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_api_keys_on_room_id ON api_keys USING btree (room_id);


--
-- Name: index_api_keys_on_token; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX index_api_keys_on_token ON api_keys USING btree (token);


--
-- Name: index_api_keys_on_user_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_api_keys_on_user_id ON api_keys USING btree (user_id);


--
-- Name: index_identities_on_uid_and_provider; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX index_identities_on_uid_and_provider ON identities USING btree (uid, provider);


--
-- Name: index_identities_on_user_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_identities_on_user_id ON identities USING btree (user_id);


--
-- Name: index_identities_on_user_id_and_provider_and_uid; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_identities_on_user_id_and_provider_and_uid ON identities USING btree (user_id, provider, uid);


--
-- Name: index_invitations_on_room_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_invitations_on_room_id ON invitations USING btree (room_id);


--
-- Name: index_invitations_on_token; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX index_invitations_on_token ON invitations USING btree (token);


--
-- Name: index_messages_on_author_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_messages_on_author_id ON messages USING btree (author_id);


--
-- Name: index_messages_on_created_at; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_messages_on_created_at ON messages USING btree (created_at);


--
-- Name: index_messages_on_parent_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_messages_on_parent_id ON messages USING btree (parent_id);


--
-- Name: index_messages_on_room_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_messages_on_room_id ON messages USING btree (room_id);


--
-- Name: index_organization_memberships_on_organization_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_organization_memberships_on_organization_id ON organization_memberships USING btree (organization_id);


--
-- Name: index_organization_memberships_on_user_id_and_organization_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX index_organization_memberships_on_user_id_and_organization_id ON organization_memberships USING btree (user_id, organization_id);


--
-- Name: index_preferences_on_user_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_preferences_on_user_id ON preferences USING btree (user_id);


--
-- Name: index_profiles_on_account_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX index_profiles_on_account_id ON profiles USING btree (account_id);


--
-- Name: index_profiles_on_avatar_provider_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_profiles_on_avatar_provider_id ON profiles USING btree (avatar_provider_id);


--
-- Name: index_repositories_on_room_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX index_repositories_on_room_id ON repositories USING btree (room_id);


--
-- Name: index_roles_on_name; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX index_roles_on_name ON roles USING btree (name);


--
-- Name: index_room_memberships_on_user_id_and_room_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX index_room_memberships_on_user_id_and_room_id ON room_memberships USING btree (user_id, room_id);


--
-- Name: index_taggings_on_message_id_and_tag_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX index_taggings_on_message_id_and_tag_id ON taggings USING btree (message_id, tag_id);


--
-- Name: index_taggings_on_tag_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_taggings_on_tag_id ON taggings USING btree (tag_id);


--
-- Name: index_tags_on_name; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX index_tags_on_name ON tags USING btree (name);


--
-- Name: unique_schema_migrations; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX unique_schema_migrations ON schema_migrations USING btree (version);


--
-- PostgreSQL database dump complete
--

SET search_path TO "$user",public;

INSERT INTO schema_migrations (version) VALUES ('20131015135109');

INSERT INTO schema_migrations (version) VALUES ('20131015135110');

INSERT INTO schema_migrations (version) VALUES ('20131015135111');

INSERT INTO schema_migrations (version) VALUES ('20131015135112');

INSERT INTO schema_migrations (version) VALUES ('20131016083700');

INSERT INTO schema_migrations (version) VALUES ('20131016100720');

INSERT INTO schema_migrations (version) VALUES ('20131016115905');

INSERT INTO schema_migrations (version) VALUES ('20131017103042');

INSERT INTO schema_migrations (version) VALUES ('20131017111107');

INSERT INTO schema_migrations (version) VALUES ('20131017112316');

INSERT INTO schema_migrations (version) VALUES ('20131017120101');

INSERT INTO schema_migrations (version) VALUES ('20131017132420');

INSERT INTO schema_migrations (version) VALUES ('20131021112221');

INSERT INTO schema_migrations (version) VALUES ('20131021112604');

INSERT INTO schema_migrations (version) VALUES ('20131021122845');

INSERT INTO schema_migrations (version) VALUES ('20131022110438');

INSERT INTO schema_migrations (version) VALUES ('20131022134750');

INSERT INTO schema_migrations (version) VALUES ('20131023094403');

INSERT INTO schema_migrations (version) VALUES ('20131023094451');

INSERT INTO schema_migrations (version) VALUES ('20131024084035');

INSERT INTO schema_migrations (version) VALUES ('20131025084334');

INSERT INTO schema_migrations (version) VALUES ('20131029102921');

INSERT INTO schema_migrations (version) VALUES ('20131030094039');

INSERT INTO schema_migrations (version) VALUES ('20131031101910');

INSERT INTO schema_migrations (version) VALUES ('20131105091519');

INSERT INTO schema_migrations (version) VALUES ('20131105102339');

INSERT INTO schema_migrations (version) VALUES ('20131106093032');

INSERT INTO schema_migrations (version) VALUES ('20131107094500');

INSERT INTO schema_migrations (version) VALUES ('20131107094623');

INSERT INTO schema_migrations (version) VALUES ('20131108103018');

INSERT INTO schema_migrations (version) VALUES ('20131108114525');

INSERT INTO schema_migrations (version) VALUES ('20131113092231');

INSERT INTO schema_migrations (version) VALUES ('20131113092356');

INSERT INTO schema_migrations (version) VALUES ('20131122110659');

INSERT INTO schema_migrations (version) VALUES ('20131122114859');

INSERT INTO schema_migrations (version) VALUES ('20131122130326');

INSERT INTO schema_migrations (version) VALUES ('20131122144201');

INSERT INTO schema_migrations (version) VALUES ('20131202105032');

INSERT INTO schema_migrations (version) VALUES ('20131209123531');

INSERT INTO schema_migrations (version) VALUES ('20131210104536');

INSERT INTO schema_migrations (version) VALUES ('20131216134446');

INSERT INTO schema_migrations (version) VALUES ('20131217130042');

INSERT INTO schema_migrations (version) VALUES ('20131218145551');

INSERT INTO schema_migrations (version) VALUES ('20131218150714');

INSERT INTO schema_migrations (version) VALUES ('20131218152323');

INSERT INTO schema_migrations (version) VALUES ('20131219104625');

INSERT INTO schema_migrations (version) VALUES ('20140108112645');

INSERT INTO schema_migrations (version) VALUES ('20140108112836');

INSERT INTO schema_migrations (version) VALUES ('20140113081450');

INSERT INTO schema_migrations (version) VALUES ('20140116103126');

INSERT INTO schema_migrations (version) VALUES ('20140117094716');

INSERT INTO schema_migrations (version) VALUES ('20140120085013');

INSERT INTO schema_migrations (version) VALUES ('20140122121758');

INSERT INTO schema_migrations (version) VALUES ('20140124101516');

INSERT INTO schema_migrations (version) VALUES ('20140128094202');

INSERT INTO schema_migrations (version) VALUES ('20140128105342');

INSERT INTO schema_migrations (version) VALUES ('20140129102603');

INSERT INTO schema_migrations (version) VALUES ('20140129125620');

INSERT INTO schema_migrations (version) VALUES ('20140129141740');

INSERT INTO schema_migrations (version) VALUES ('20140205103955');

INSERT INTO schema_migrations (version) VALUES ('20140206114637');

INSERT INTO schema_migrations (version) VALUES ('20140206134855');

INSERT INTO schema_migrations (version) VALUES ('20140210094758');

INSERT INTO schema_migrations (version) VALUES ('20140217105038');

INSERT INTO schema_migrations (version) VALUES ('20140218103026');

INSERT INTO schema_migrations (version) VALUES ('20140218104103');

INSERT INTO schema_migrations (version) VALUES ('20140219143835');

INSERT INTO schema_migrations (version) VALUES ('20140224113705');

INSERT INTO schema_migrations (version) VALUES ('20140303080049');

INSERT INTO schema_migrations (version) VALUES ('20140303090002');

INSERT INTO schema_migrations (version) VALUES ('20140305135943');

INSERT INTO schema_migrations (version) VALUES ('20140306085544');

INSERT INTO schema_migrations (version) VALUES ('20140429124626');
