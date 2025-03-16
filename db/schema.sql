CREATE TABLE "schema_migrations" (
  "version" varchar NOT NULL PRIMARY KEY
);

CREATE TABLE "ar_internal_metadata" (
  "key" varchar NOT NULL PRIMARY KEY,
  "value" varchar,
  "created_at" datetime(6) NOT NULL,
  "updated_at" datetime(6) NOT NULL
);

CREATE TABLE "contributors" (
  "id" integer PRIMARY KEY AUTOINCREMENT,
  "created_at" timestamp NOT NULL,
  "updated_at" timestamp NOT NULL
);

CREATE TABLE "contributor_logins" (
  "id" integer PRIMARY KEY AUTOINCREMENT,
  "contributor_id" integer NOT NULL,
  "login" varchar NOT NULL
);

CREATE INDEX "index_contributor_logins_on_login"
  ON "contributor_logins" ("login");

CREATE TABLE "contributor_names" (
  "id" integer PRIMARY KEY AUTOINCREMENT,
  "contributor_id" integer NOT NULL,
  "name" varchar NOT NULL
);

CREATE INDEX "index_contributor_names_on_name"
  ON "contributor_names" ("name");

CREATE TABLE "contributor_emails" (
  "id" integer PRIMARY KEY AUTOINCREMENT,
  "contributor_id" integer NOT NULL,
  "email" varchar NOT NULL
);

CREATE INDEX "index_contributor_emails_on_email"
  ON "contributor_emails" ("email");

CREATE TABLE "commits" (
  "id" integer PRIMARY KEY AUTOINCREMENT,
  "sha" text UNIQUE NOT NULL,
  "time" timestamp NOT NULL,
  "name" text NOT NULL,
  "email" text NOT NULL,
  "message" text NOT NULL,
  "contributor_id" integer NOT NULL,
  "created_at" timestamp NOT NULL,
  "updated_at" timestamp NOT NULL
);
