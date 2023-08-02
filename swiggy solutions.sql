USE swiggy;

-- 1. HOW MANY RESTAURANTS HAVE A RATING GREATER THAN 4.5?
SELECT 
    COUNT(DISTINCT restaurant_name) AS `NumberOfRestaurantsRating > 4.5`
FROM
    swiggy
WHERE
    rating > 4.5;

-- 2. WHICH IS THE TOP 1 CITY WITH THE HIGHEST NUMBER OF RESTAURANTS?
WITH cte1 AS (
    SELECT
        DISTINCT city,
        COUNT(DISTINCT restaurant_name) AS rest_count,
        DENSE_RANK() 
        OVER (ORDER BY COUNT(DISTINCT restaurant_name) DESC) AS ranking
    FROM
        swiggy
    GROUP BY
        city
)
SELECT
    city,
    rest_count
FROM
    cte1
WHERE
    ranking = 1;


-- 3. HOW MANY RESTAURANTS HAVE THE WORD "PIZZA" IN THEIR NAME?
SELECT 
    COUNT(DISTINCT restaurant_name) AS no_rest_w_name_pizza
FROM
    swiggy
WHERE
    restaurant_name LIKE '%PIZZA%';
SELECT DISTINCT
    restaurant_name
FROM
    swiggy
WHERE
    restaurant_name LIKE '%PIZZA%';

-- 4. WHAT IS THE MOST COMMON CUISINE AMONG THE RESTAURANTS IN THE DATASET?
WITH cte1 AS (
    SELECT
        cuisine,
        COUNT(cuisine) AS numberofcuisines,
        DENSE_RANK() OVER (ORDER BY COUNT(cuisine) DESC) AS ranking
    FROM
        swiggy
    GROUP BY
        cuisine
)
SELECT
    cuisine,
    numberofcuisines
FROM
    cte1
WHERE
    ranking = 1;


-- 5. WHAT IS THE AVERAGE RATING OF RESTAURANTS IN EACH CITY?
SELECT DISTINCT
    city,
    ROUND(AVG(rating) OVER (PARTITION BY city), 2) AS average_rating
FROM
    swiggy;


-- 6. WHAT IS THE HIGHEST PRICE OF ITEM UNDER THE 'RECOMMENDED' MENU CATEGORY FOR EACH RESTAURANT?
SELECT DISTINCT
    restaurant_name,
    menu_category,
    MAX(price) OVER (PARTITION BY restaurant_name) AS highest_price
FROM
    swiggy
WHERE
    menu_category = 'Recommended';

-- 7. FIND THE TOP 5 MOST EXPENSIVE RESTAURANTS THAT OFFER CUISINE OTHER THAN INDIAN CUISINE.
SELECT DISTINCT
    restaurant_name, cuisine, cost_per_person
FROM
    swiggy
WHERE
    cuisine NOT LIKE '%Indian%'
ORDER BY cost_per_person DESC
LIMIT 5;

-- 8. FIND THE RESTAURANTS THAT HAVE AN COST WHICH IS HIGHER THAN THE TOTAL AVERAGE COST OF ALL RESTAURANTS TOGETHER.
SELECT DISTINCT
    restaurant_name, cost_per_person
FROM
    swiggy
WHERE
    cost_per_person > (SELECT 
            AVG(cost_per_person)
        FROM
            swiggy);

-- 9. RETRIEVE THE DETAILS OF RESTAURANTS THAT HAVE THE SAME NAME BUT ARE LOCATED IN DIFFERENT CITIES.
SELECT DISTINCT
    s1.restaurant_name
FROM
    swiggy s1
        JOIN
    swiggy s2 ON s1.restaurant_name = s2.restaurant_name
        AND s1.city <> s2.city;

-- 10. WHICH RESTAURANT OFFERS THE MOST NUMBER OF ITEMS IN THE 'MAIN COURSE' CATEGORY?
SELECT DISTINCT
    restaurant_name,
    menu_category,
    COUNT(item) AS number_of_items
FROM
    swiggy
WHERE
    menu_category LIKE '%main%%course%'
GROUP BY restaurant_name , menu_category
ORDER BY number_of_items DESC
LIMIT 1;

-- 11.LIST THE NAMES OF RESTAURANTS THAT ARE 100% VEGEATARIAN IN ALPHABETICAL ORDER OF RESTAURANT NAME.
SELECT DISTINCT
    restaurant_name, veg_or_nonveg
FROM
    swiggy
WHERE
    veg_or_nonveg LIKE 'veg%'
ORDER BY restaurant_name;

-- 12. WHICH IS THE RESTAURANT PROVIDING THE LOWEST AVERAGE PRICE FOR ALL ITEMS?
SELECT DISTINCT
    restaurant_name, ROUND(AVG(price), 2) AS average_price
FROM
    swiggy
GROUP BY restaurant_name
ORDER BY average_price
LIMIT 1;

-- 13. WHICH TOP 5 RESTAURANT OFFERS HIGHEST NUMBER OF CATEGORIES?
SELECT 
    restaurant_name,
    COUNT(DISTINCT menu_category) AS numberofcategories
FROM
    swiggy
GROUP BY restaurant_name
ORDER BY numberofcategories DESC
LIMIT 5;

-- 14. WHICH RESTAURANT PROVIDES THE HIGHEST PERCENTAGE OF NON-VEGEATARIAN FOOD?
SELECT DISTINCT
    restaurant_name,
    ROUND(COUNT(CASE
                WHEN veg_or_nonveg LIKE '%non%' THEN 1
            END) * 100 / COUNT(*),
            2) AS nonvegpercentage
FROM
    swiggy
GROUP BY restaurant_name
ORDER BY nonvegpercentage DESC
LIMIT 1;
