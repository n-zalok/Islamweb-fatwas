-- In this SQL file, write (and comment!) the typical SQL queries users will run on your database

-- selecting q&a for a fatwa
SELECT "question", "answer" FROM "fatwas"
WHERE "id" = 508291;

-- selecting fatwas for a specific subject
SELECT "question", "answer" FROM "fatwas"
WHERE "subject" = 'Siyaam (Fasting)';

-- asking a question
INSERT INTO "questions"("subject", "title", "question")
VALUES('Islamic Creed', 'title', 'question');

-- answering a question
UPDATE "questions" SET "answer" = 'answer' WHERE "question" = 'question';

-- commenting on a fatwaa
INSERT INTO "comments"("fatwa_id", "comment")
VALUES(508291, 'comment');

-- viewing comments on a fatwaa
SELECT "id", "comment" FROM "comments"
WHERE "fatwa_id" = 508291;

-- rating a fatwaa
INSERT INTO "ratings"("fatwa_id", "rating")
VALUES(508291, 4);

-- viewing average rating of a fatwaa
SELECT ROUND(AVG("rating"), 2) AS 'average rating' FROM "ratings"
GROUP BY "fatwa_id"
HAVING "fatwa_id" = 508291;
