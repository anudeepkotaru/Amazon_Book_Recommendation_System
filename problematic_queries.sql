-- Query 2

SELECT B.title, U.profile_name, R.review_summary, S.top_country, S.books_sold
FROM Books B
JOIN Authors A ON B.book_id = A.book_id
JOIN Publishers P ON B.book_id = P.book_id
JOIN Reviews R ON B.book_id = R.book_id
JOIN Users U ON R.user_id = U.user_id
JOIN Sales S ON P.publisher_id = S.publisher_id;

-- Query 2 Solution

WITH BookDetails AS (
    SELECT B.book_id, B.title, P.publisher_id
    FROM Books B
    JOIN Publishers P ON B.book_id = P.book_id
)
SELECT BD.title, U.profile_name, R.review_summary, S.top_country, S.books_sold
FROM BookDetails BD
JOIN Reviews R ON BD.book_id = R.book_id
JOIN Users U ON R.user_id = U.user_id
JOIN Sales S ON BD.publisher_id = S.publisher_id;

-- Query 3

SELECT B.title, P.publisher, SUM(S.books_sold) as Total_Sales, AVG(R.review_score) as Average_Review_Score
FROM Books B
JOIN Publishers P ON B.book_id = P.book_id
JOIN Sales S ON P.publisher_id = S.publisher_id
JOIN Reviews R ON B.book_id = R.book_id
GROUP BY B.title, P.publisher;

-- Query 3 Solution

CREATE TEMP TABLE TempSalesData AS
SELECT publisher_id, SUM(books_sold) AS Total_Sales
FROM Sales
GROUP BY publisher_id;

CREATE TEMP TABLE TempReviewData AS
SELECT book_id, AVG(review_score) AS Average_Review_Score
FROM Reviews
GROUP BY book_id;

SELECT B.title, P.publisher, TSD.Total_Sales, TRD.Average_Review_Score
FROM Books B
JOIN Publishers P ON B.book_id = P.book_id
JOIN TempSalesData TSD ON P.publisher_id = TSD.publisher_id
JOIN TempReviewData TRD ON B.book_id = TRD.book_id
GROUP BY B.title, P.publisher, TSD.Total_Sales, TRD.Average_Review_Score;

DROP TABLE TempSalesData;
DROP TABLE TempReviewData;