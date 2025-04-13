-- In this SQL file, write (and comment!) the schema of your database, including the CREATE TABLE, CREATE INDEX, CREATE VIEW, etc. statements that compose it

-- "fatwas" table contains all fatwas from islamweb englisgh version where each fatwa has an id, a subject, a title,
-- a date at which it was added, the question and its answer
CREATE TABLE "fatwas"(
    "id" INTEGER,
    "subject" TEXT NOT NULL CHECK("subject" IN ('Siyaam (Fasting)', 'Fiqh of Transactions and Inheritance', 'Islamic Creed',
    'Women and Family', 'Foods, Drinks, Clothes and Adornment' ,"Religions, Sects and Da'wah (Call to Islam)",
    'Medical Issues, Media, Culture and Means of Entertainment', 'Jinaayaat (Criminology) and Islamic Judicial System',
    "Etiquettes, Morals, Thikr and Du'aa'", 'Noble Hadeeth', 'Tahaarah (Ritual Purity)', 'Seerah (Biography of the Prophet)',
    'Islamic Politics and International Affairs', 'Merits and Virtues', 'Salah (Prayer)', 'Zakaah (Obligatory Charity)',
    'Miscellaneous', 'The Noble Quran', 'Funeral: Prayer and Rulings', "Hajj and 'Umrah", 'OTHER ISSUES')),
    "title" TEXT NOT NULL,
    "date" NUMERIC NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "question" TEXT UNIQUE NOT NULL,
    "answer" TEXT NOT NULL,
    PRIMARY KEY("id")
);

-- "questions" table contains all question not yet answered where each question has an id, a subject, a title,
-- the question and answer field to be filled latter
CREATE TABLE "questions"(
    "id" INTEGER,
    "subject" TEXT NOT NULL CHECK("subject" IN ('Siyaam (Fasting)', 'Fiqh of Transactions and Inheritance', 'Islamic Creed',
    'Women and Family', 'Foods, Drinks, Clothes and Adornment' ,"Religions, Sects and Da'wah (Call to Islam)",
    'Medical Issues, Media, Culture and Means of Entertainment', 'Jinaayaat (Criminology) and Islamic Judicial System',
    "Etiquettes, Morals, Thikr and Du'aa'", 'Noble Hadeeth', 'Tahaarah (Ritual Purity)', 'Seerah (Biography of the Prophet)',
    'Islamic Politics and International Affairs', 'Merits and Virtues', 'Salah (Prayer)', 'Zakaah (Obligatory Charity)',
    'Miscellaneous', 'The Noble Quran', 'Funeral: Prayer and Rulings', "Hajj and 'Umrah", 'OTHER ISSUES')),
    "title" TEXT NOT NULL,
    "question" TEXT UNIQUE NOT NULL,
    "answer" TEXT DEFAULT NULL,
    PRIMARY KEY("id")
);

-- "comments" table contains comments on all fatwas where each comment has an id,
-- the fatwa_id on which the comment was added and the comment itself
CREATE TABLE "comments"(
    "id" INTEGER,
    "fatwa_id" INTEGER,
    "comment" TEXT NOT NULL,
    PRIMARY KEY("id"),
    FOREIGN KEY("fatwa_id") REFERENCES "fatwas"("id")
);

-- "ratings" table contains ratings on all fatwas where each rating has an id,
-- the fatwa_id on which the rating was added and the rating itself ranging from 1 to 5
CREATE TABLE "ratings"(
    "id" INTEGER,
    "fatwa_id" INTEGER,
    "rating" INTEGER NOT NULL CHECK(1 <= "rating" AND "rating" <= 5),
    PRIMARY KEY("id"),
    FOREIGN KEY("fatwa_id") REFERENCES "fatwas"("id")
);

-- "iftaa" trigger upon answering a question in "questions" table the fatwaa is then moved to
-- "fatwas" table and the question is deleted from "questions" table
CREATE TRIGGER "iftaa"
AFTER UPDATE OF "answer"  ON "questions"
FOR EACH ROW
BEGIN
INSERT INTO "fatwas"("subject", "title", "question", "answer")
VALUES(OLD."subject", OLD."title", OLD."question", NEW."answer");
DELETE FROM "questions" WHERE "id" = OLD."id";
END;

-- "q&a" index speeds up the searching for questions with thier answers
CREATE INDEX "q&a"
ON "fatwas"("question", "answer");

