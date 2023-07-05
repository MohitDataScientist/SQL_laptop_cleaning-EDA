-- Data Cleaning
USE laptop;

SELECT * FROM laptop;

-- 1. Create backup
--- creat table
CREATE TABLE laptop_backup LIKE laptop;
--- insert values
INSERT INTO laptop_backup 


-- 2. Check number of rows
SELECT * FROM laptop; 

-- 3. Create index column 
ALTER TABLE laptop
ADD column `index` INT AUTO_INCREMENT PRIMARY KEY AFTER `Unnamed: 0` ;

SELECT * FROM laptop;

-- 4. Delete unwanted columns
ALTER TABLE laptop DROP COLUMN `Unnamed: 0`;

SELECT * FROM laptop;

-- 5. Check memory consumption
SELECT DATA_LENGTH/1024 FROM INFORMATION_SCHEMA.TABLES
WHERE TABLE_SCHEMA = 'laptop'
AND TABLE_NAME = 'laptop';

-- 6. Drop null values
DELETE FROM laptop
WHERE `index` IN (SELECT * FROM (SELECT `index` FROM laptop
WHERE Company IS NULL AND TypeName IS NULL AND Inches IS NULL
AND ScreenResolution IS NULL AND Cpu IS NULL AND Ram IS NULL
AND Memory IS NULL AND Gpu IS NULL AND OpSys IS NULL AND
WEIGHT IS NULL AND Price IS NULL)t);

SELECT COUNT(*) FROM laptop;

-- 7. Drop duplicates
select * from laptop where `index` not in 
(select min(`index`) from laptop 
group by `index`, Company, TypeName, Inches, ScreenResolution, Cpu, Ram, Memory, Gpu, OpSys, Weight, Price);

-- 8. Change column data types
--- Inches column 
select * from laptop where Inches = '?';
DELETE from laptop
where `index` = 480;

ALTER TABLE laptop modify Inches decimal(10,1);

--- Ram column 
UPDATE laptop l1
SET Ram = (
    SELECT REPLACE(Ram, 'GB', '') 
    FROM (SELECT * FROM laptop) AS l2 
    WHERE l2.index = l1.index
);
ALTER TABLE laptop
MODIFY Ram INT;

--- Weight column
update laptop l1
set Weight = (select replace(Weight, 'kg', '') 
              from (select * from laptop) as l2
              where l2.index = l1.index
);

select * from laptop
where weight = '?';

delete from laptop
where `index` = 196 ;

--- Price column 
update laptop t1
set price = (select round(price) 
            from (select * from laptop) t2
            where t2.index = t1.index);

alter table laptop
modify price int;

--- 
update laptop t1
set OpSys = (
SELECT
CASE 
    WHEN OpSys LIKE '%mac%' THEN 'macos'
    WHEN OpSys LIKE 'windows%' THEN 'windows'
    WHEN OpSys LIKE '%linux%' THEN 'linux'
    WHEN OpSys = 'No OS' THEN 'N/A'
    ELSE 'other'
END AS 'os_brand'
FROM (select * from laptop) t2
where t2.index = t1.index
);

--- Gpu column
ALTER TABLE laptop
ADD COLUMN gpu_brand VARCHAR(255) AFTER Gpu,
ADD COLUMN gpu_name VARCHAR(255) AFTER gpu_brand;

update laptop t1
set gpu_brand = (select substring_index(Gpu, ' ', 1) 
           from (select * from laptop) t2
           where t2.index = t1.index);

update laptop t1
set gpu_name = (select replace(Gpu, gpu_brand, '') 
               from (select * from laptop) t2
               where t2.index = t1.index);

alter table laptop drop column Gpu;

select * from laptop;

--- Cpu column 
alter table laptop
add column cpu_brand varchar(255) after Cpu,
add column cpu_name varchar(255) after cpu_brand,
add column cpu_speed decimal(10,1) after cpu_name;

update laptop t1
set cpu_brand = (select substring_index(Cpu, ' ', 1) 
                 from (select * from laptop) t2
                 where t2.index = t1.index
                );

update laptop t1
set cpu_speed = (select replace(substring_index(Cpu, ' ', -1), 'GHz', '') 
                 from (select * from laptop) t2
                 where t2.index = t1.index
                 );
                 
update laptop t1
set cpu_name = (select replace(replace(Cpu, cpu_brand, ' '),
                substring_index(replace(Cpu, cpu_brand, ' '), ' ', -1), '')
                from (select * from laptop) t2
                where t2.index = t1.index);
                
alter table laptop drop column Cpu;

--- Screen resolution
Alter Table laptop
Add Column resolution_width int after ScreenResolution,
Add Column resolution_height int after resolution_width;

update laptop t1
set resolution_width = (select substring_index(substring_index(ScreenResolution, " ", -1), 'x', 1) 
                        from (select * from laptop) t2
                        where t2.index = t1.index);
update laptop t1
set resolution_height = (select substring_index(substring_index(ScreenResolution, " ", -1), 'x', -1) 
                        from (select * from laptop) t2
                        where t2.index = t1.index);
                        
Alter Table laptop
Add Column is_touchscreen int after resolution_height;

update laptop
set is_touchscreen = ScreenResolution like '%Touch%';

ALTER TABLE LAPTOP
DROP COLUMN ScreenResolution;

--- Cpu_name column
update laptop
set cpu_name = substring_index(trim(cpu_Name), " ", 2);

--- Memory Column
alter table laptop
add column memory_type varchar(255) after Memory,
add column primary_storage int after memory_type,
add column secondary_storage int after primary_storage;

update laptop
set memory_type = 
CASE
    when Memory like '%SSD%' and Memory like '%HDD%' then 'Hybrid'
    when Memory like '%SSD%' then 'SSD'
    when Memory like '%HDD%' then 'HDD'
    when Memory like '%Flash%' then 'Flash Storage'
    when Memory like '%Hybrid%' then 'Hybrid'
    when Memory like '%Flash%' and Memory like '%HDD%' then 'Hybrid'
    else Null
END ;

update laptop
set primary_storage = REGEXP_SUBSTR(substring_index(Memory, "+",1), '[0-9]+');

update laptop
set secondary_storage = case when Memory like '%+%'
then REGEXP_SUBSTR(trim(substring_index(Memory, "+",-1)), '[0-9]+') else 0 end;

update laptop
set primary_storage = CASE
   WHEN primary_storage like 1 then 1024
   WHEN primary_storage like 2 then 2*1024
   else primary_storage
END;

update laptop
set secondary_storage = CASE
   WHEN secondary_storage like 1 then 1024
   WHEN secondary_storage like 2 then 2*1024
   else secondary_storage
END;

alter table laptop
drop column Memory;

select DATA_LENGTH/1024 AS 'Kb' from information_schema.TABLES
where TABLE_SCHEMA = 'laptop' and TABLE_NAME = 'laptop';

select * from laptop;

--- Data cleaning ends here 