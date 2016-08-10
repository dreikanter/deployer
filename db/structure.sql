CREATE TABLE "schema_migrations" ("version" varchar NOT NULL PRIMARY KEY);
CREATE TABLE "ar_internal_metadata" ("key" varchar NOT NULL PRIMARY KEY, "value" varchar, "created_at" datetime NOT NULL, "updated_at" datetime NOT NULL);
CREATE TABLE "delayed_jobs" ("id" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, "priority" integer DEFAULT 0 NOT NULL, "attempts" integer DEFAULT 0 NOT NULL, "handler" text NOT NULL, "last_error" text, "run_at" datetime, "locked_at" datetime, "failed_at" datetime, "locked_by" varchar, "queue" varchar, "created_at" datetime, "updated_at" datetime);
CREATE INDEX "delayed_jobs_priority" ON "delayed_jobs" ("priority", "run_at");
CREATE TABLE "deployment_keys" ("id" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, "encrypted_private" varchar NOT NULL, "public" varchar NOT NULL, "iv" varchar NOT NULL, "name" varchar DEFAULT '' NOT NULL, "cipher_algorithm" varchar NOT NULL, "created_at" datetime NOT NULL, "updated_at" datetime NOT NULL);
INSERT INTO schema_migrations (version) VALUES ('20160808195155'), ('20160810123230');


