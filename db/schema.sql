CREATE TABLE "schema_migrations" ("version" varchar NOT NULL PRIMARY KEY);

CREATE TABLE "ar_internal_metadata" ("key" varchar NOT NULL PRIMARY KEY, "value" varchar, "created_at" datetime(6) NOT NULL, "updated_at" datetime(6) NOT NULL);

CREATE TABLE contributors (
  id bigserial PRIMARY KEY,
  created_at timestamp NOT NULL,
  updated_at timestamp NOT NULL
);

CREATE TABLE "contributor_logins" (
  "id" bigserial PRIMARY KEY,
  "contributor_id" bigint NOT NULL,
  "login" varchar NOT NULL
);
CREATE INDEX "index_contributor_logins_on_login" ON "contributor_logins" ("login");

CREATE TABLE "contributor_names" (
  "id" bigserial PRIMARY KEY,
  "contributor_id" bigint NOT NULL,
  "name" varchar NOT NULL
);

CREATE TABLE "contributor_emails" (
  "id" bigserial PRIMARY KEY,
  "contributor_id" bigint NOT NULL,
  "email" varchar NOT NULL
);
CREATE INDEX "index_contributor_emails_on_email" ON "contributor_emails" ("email");

CREATE TABLE commits (
  id bigserial PRIMARY KEY,
  sha text,
  date timestamp,
  author text,
  email text,
  message text,
  contributor_id bigint REFERENCES contributors(id),
  created_at timestamp NOT NULL,
  updated_at timestamp NOT NULL
);
