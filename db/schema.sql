CREATE TABLE "schema_migrations" ("version" varchar NOT NULL PRIMARY KEY);

CREATE TABLE "ar_internal_metadata" ("key" varchar NOT NULL PRIMARY KEY, "value" varchar, "created_at" datetime(6) NOT NULL, "updated_at" datetime(6) NOT NULL);
