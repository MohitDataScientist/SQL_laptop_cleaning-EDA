USE laptop;


--- EDA
SELECT * FROM laptop.laptop;

--- Head, Tail, Sample
-- Head
select * from laptop limit 5;
-- Tail
select * from laptop order by `index` desc limit 5;
-- Sample
select * from laptop order by rand() limit 5;

SELECT COUNT(Price) OVER(),
MIN(Price) OVER(),
MAX(Price) OVER(),
AVG(Price) OVER(),
STD(Price) OVER(),
PERCENTILE_CONT(0.25) WITHIN GROUP(ORDER BY Price) OVER() AS 'Q1',
PERCENTILE_CONT(0.5) WITHIN GROUP(ORDER BY Price) OVER() AS 'Median',
PERCENTILE_CONT(0.75) WITHIN GROUP(ORDER BY Price) OVER() AS 'Q3'
FROM laptop
ORDER BY `index` LIMIT 1;


-- Check for missing values
select count(*) from laptop
where price is Null;

-- Horizontal / Vertical Histogram in sql

SELECT price,
  CASE
    WHEN price BETWEEN 0 AND 25000 THEN '0-25K'
    WHEN price BETWEEN 25001 AND 50000 THEN '25K-50K'
    WHEN price BETWEEN 50001 AND 75000 THEN '50K-75K'
    WHEN price BETWEEN 75001 AND 100000 THEN '75K-100K'
    ELSE '>100K'
  END AS price_range
FROM laptop;


select bucket, REPEAT('*',(count(*)/5)) as 'Frequency' from (select price,
CASE
   WHEN price BETWEEN 0 and 25000 then '0-25k'
   WHEN price BETWEEN 25001 and 50000 then '25k-50k'
   WHEN price BETWEEN 50001 and 75000 then '50k-75k'
   WHEN price BETWEEN 75001 and 100000 then '75k-100k'
   WHEN price > 100000 then '>100k'
END as 'bucket'   
from laptop) t
group by t.bucket;

select company, count(*) from laptop
group by company;

--- Categorical vs Categorical
-- Contingency Table

select Company, Count(*) as 'Total_Laptop',
    SUM(CASE WHEN is_touchscreen = 1 then 1 else 0 END) as 'TouchScreen_Yes',
    SUM(CASE WHEN is_touchscreen = 1 then 0 else 1 END) as 'TouchScreen_NO'
from laptop
group by company;


select Company, count(*) as 'Total_Laptop',
SUM(CASE WHEN gpu_brand = 'AMD' then 1 else 0 end) as 'AMD',
SUM(CASE WHEN gpu_brand = 'Nvidia' then 1 else 0 end) as 'Nvidia',
SUM(CASE WHEN gpu_brand = 'Intel' then 1 else 0 end) as 'Intel',
SUM(CASE WHEN gpu_brand = 'ARM' then 1 else 0 end) as 'ARM'
from laptop
group by company;


-- ONE HOT ENCODING

select gpu_brand from laptop
group by gpu_brand;

select gpu_brand,
CASE WHEN gpu_brand = 'AMD' then 1 else 0 end as 'AMD',
CASE WHEN gpu_brand = 'Nvidia' then 1 else 0 end as 'Nvidia',
CASE WHEN gpu_brand = 'Intel' then 1 else 0 end as 'Intel',
CASE WHEN gpu_brand = 'ARM' then 1 else 0 end as 'ARM'

from laptop;

SELECT price,
  CASE
    WHEN price BETWEEN 0 AND 25000 THEN '0-25K'
    WHEN price BETWEEN 25001 AND 50000 THEN '25K-50K'
    WHEN price BETWEEN 50001 AND 75000 THEN '50K-75K'
    WHEN price BETWEEN 75001 AND 100000 THEN '75K-100K'
    ELSE '>100K'
  END AS price_range
FROM laptop;











