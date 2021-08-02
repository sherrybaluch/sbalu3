DROP TABLE IF EXISTS users CASCADE;                                         
CREATE TABLE users (                                                        
id SERIAL PRIMARY KEY,                                                      
first_name varchar(50),                                                     
last_name varchar(50),                                                      
email varchar(200) NOT NULL,                                                
password varchar(16) NOT NULL,                                              
created_at TIMESTAMP DEFAULT NOW(),                                         
updated_at TIMESTAMP);                                                      
                                                                            
DROP TABLE IF EXISTS status CASCADE;                                        
CREATE TABLE status (                                                       
id SERIAL PRIMARY KEY,                                                      
description varchar(255) NOT NULL,                                          
created_at TIMESTAMP DEFAULT NOW(),                                         
updated_at TIMESTAMP);                                                      
                                                                            
DROP TABLE IF EXISTS inventory CASCADE;                                     
CREATE TABLE inventory (                                                    
id SERIAL PRIMARY KEY,                                                      
status_id integer,                                                          
FOREIGN KEY (status_id)                                                     
REFERENCES status(id),                                                      
description varchar(255) NOT NULL,                                          
created_at TIMESTAMP DEFAULT NOW(),                                         
updated_at TIMESTAMP);                                                      
                                                                            
DROP TABLE IF EXISTS transactions CASCADE;                                  
CREATE TABLE transactions (                                                 
id SERIAL PRIMARY KEY,                                                      
user_id integer,                                                            
inventory_id integer,                                                       
checkout_time TIMESTAMP NOT NULL,                                           
scheduled_checkin_time TIMESTAMP,                                           
actual_checkin_time TIMESTAMP,                                              
created_at TIMESTAMP DEFAULT NOW (),                                        
updated_at TIMESTAMP,                                                       
FOREIGN KEY (user_id) REFERENCES users(id),                                 
FOREIGN KEY (inventory_id) REFERENCES inventory(id));                       
                                                                            
INSERT INTO users (first_name, last_name, email, password) VALUES ('John', '
Smith', 'johnsmith@email.com', 'pass1234');                                 
                                                                            
INSERT INTO users (first_name, last_name, email, password) VALUES ('Jane', '
Smith', 'janesmith@email.com', 'pass1234');                                 
                                                                            
INSERT INTO users (first_name, last_name, email, password) VALUES ('Tom', 'S
mith', 'tomsmith@email.com', 'pass1234');                                   
                                                                            
INSERT INTO users (first_name, last_name, email, password) VALUES ('Ann', 'S
mith', 'annsmith@email.com', 'pass1234');                                   
                                                                            
INSERT INTO users (first_name, last_name, email, password) VALUES ('Dawn', '
Smith', 'dawnsmith@email.com', 'pass1234');                                 
                                                                            
INSERT INTO status (description) VALUES ('Available');                      
                                                                            
INSERT INTO status (description) VALUES ('Checked Out');                    
                                                                            
INSERT INTO status (description) VALUES ('Overdue');                        
                                                                            
INSERT INTO status (description) VALUES ('Unavailable');                    
                                                                            
INSERT INTO status (description) VALUES ('Under Repair');                   
                                                                            
INSERT INTO inventory (description) VALUES ('Laptop1');                     
                                                                            
INSERT INTO inventory (description) VALUES ('Laptop2');                     
                                                                            
INSERT INTO inventory (description) VALUES ('Webcam1');                     
                                                                            
INSERT INTO inventory (description) VALUES ('TV1');                         
                                                                            
INSERT INTO inventory (description) VALUES ('Microphone1');                 
                                                                            
INSERT INTO transactions (user_id,inventory_id,checkout_time,scheduled_checkin_time)                                                                    
VALUES (1,1,TIMESTAMP '2010-01-01 12:00:00',TIMESTAMP '2011-06-01 12:00:00');                                                                           
                                                                            
INSERT INTO transactions (user_id,inventory_id,checkout_time,scheduled_checkin_time)                                                                    
VALUES (1,2,'2020-01-01 12:00:00','2021-01-01 12:00:00');                   
                                                                            
INSERT INTO transactions (user_id,inventory_id,checkout_time,scheduled_checkin_time)                                                                    
VALUES (2,3, '2021-01-01 12:00:00','2021-06-30 12:00:00');                  
                                                                            
ALTER TABLE users ADD COLUMN signed_agreement boolean DEFAULT false;        
                                                                            
UPDATE inventory                                                            
SET status_id = 2, updated_at = NOW()::TIMESTAMP                            
WHERE id >= 1 and id <= 3;                                                  
                                                                            
SELECT i.description, t.scheduled_checkin_time                              
FROM inventory i INNER JOIN transactions t                                  
ON i.id=t.inventory_id                                                      
WHERE status_id = 2                                                         
ORDER BY t.scheduled_checkin_time DESC;                                     
                                                                            
SELECT i.description                                                        
FROM inventory i INNER JOIN transactions t                                  
ON i.id=t.inventory_id                                                      
WHERE scheduled_checkin_time > '2019-05-31 00:00:00';                       
                                                                            
SELECT COUNT(*)                                                             
FROM inventory i INNER JOIN transactions t                                  
ON i.id=t.inventory_id                                                      
WHERE status_id = 2 and user_id = 1;                                        
                                      
                              
-- FUNCTION FOR CHECKOUT

CREATE OR REPLACE FUNCTION checkout(user_id_v integer, inven_id_v integer, checkout_time_v timestamp, scheduled_checkin_time_v timestamp)
RETURNS boolean AS $$
DECLARE
  completed_ok boolean := false;

BEGIN

  
  

  -- create transaction record
  INSERT INTO transactions (user_id,inventory_id,checkout_time,scheduled_checkin_time)                                                                    
  VALUES (user_id_v,inven_id_v,checkout_time_v,scheduled_checkin_time_v);

  -- update inventory to checked out status
  UPDATE inventory                                                            
  SET status_id = 2, updated_at = NOW()::TIMESTAMP                            
  WHERE id = inven_id_v;

  completed_ok := true;
  
  RETURN completed_ok;
END;
$$ LANGUAGE plpgsql;




/* Function for checkin */

CREATE OR REPLACE FUNCTION checkin(inven_id_v integer, actual_checkin_time_v timestamp)
RETURNS boolean AS $$
DECLARE
  completed_ok boolean := false;
  transaction_id integer;

BEGIN

  --RETURN true;

  RAISE INFO 'Attempting checkin of item %.', inven_id_v;

  /* find the record for the checked out item. Match id and is not checked in (has no checkin_time). */
  SELECT id INTO transaction_id
  FROM transactions
  WHERE inventory_id = inven_id_v AND actual_checkin_time IS NULL;
  
  
  IF transaction_id IS NULL THEN
    RAISE INFO 'Item % NOT checked out. Cannot checkin.', inven_id_v;
    RETURN false;
  END IF;

  /* update the record to show the actual checkin time. */
  UPDATE transactions
  SET updated_at = NOW()::TIMESTAMP, actual_checkin_time = actual_checkin_time_v
  WHERE id = transaction_id;

  /* update inventory item to show checked-in. */
  UPDATE inventory                                                            
  SET status_id = 1, updated_at = NOW()::TIMESTAMP                            
  WHERE id = inven_id_v;

  completed_ok := true;

  RAISE INFO 'Item % checked in', inven_id_v;
  
  RETURN completed_ok;
END;
$$ LANGUAGE plpgsql;


-- Delete all previous transactions from prior exercises
TRUNCATE TABLE transactions;

-- Create 20 transactions

SELECT checkout(1,3,'2020-06-10 12:00:00','2020-06-30 12:00:00');
SELECT checkin(3,'2020-06-20 12:00:00');

SELECT checkout(2,1,'2020-06-10 12:00:00','2020-06-30 12:00:00');
SELECT checkin(1,'2020-06-12 12:00:00');

SELECT checkout(3,2,'2020-01-01 12:00:00','2020-01-10 12:00:00');
SELECT checkin(2,'2020-02-01 12:00:00');

SELECT checkout(4,4,'2020-01-01 12:00:00','2020-01-30 12:00:00');
SELECT checkin(4,'2020-02-01 12:00:00');

SELECT checkout(5,1,'2020-07-01 12:00:00','2020-07-30 12:00:00');
SELECT checkin(1,'2020-08-01 12:00:00');

SELECT checkout(1,2,'2020-03-01 12:00:00','2020-03-30 12:00:00');
SELECT checkin(2,'2020-03-10 12:00:00');

SELECT checkout(2,3,'2020-03-01 12:00:00','2020-03-30 12:00:00');
SELECT checkin(3,'2020-03-10 12:00:00');

SELECT checkout(1,4,'2020-04-10 12:00:00','2020-04-30 12:00:00');
SELECT checkin(4,'2020-04-20 12:00:00');

SELECT checkout(2,5,'2020-05-10 12:00:00','2020-05-30 12:00:00');
SELECT checkin(5,'2020-05-12 12:00:00');

SELECT checkout(3,4,'2020-05-01 12:00:00','2020-05-10 12:00:00');
SELECT checkin(4,'2020-05-05 12:00:00');

SELECT checkout(4,5,'2020-07-01 12:00:00','2020-07-30 12:00:00');
SELECT checkin(5,'2020-07-05 12:00:00');

SELECT checkout(5,3,'2020-08-01 12:00:00','2020-08-30 12:00:00');
SELECT checkin(3,'2020-08-15 12:00:00');

SELECT checkout(4,2,'2020-09-01 12:00:00','2020-09-30 12:00:00');
SELECT checkin(2,'2020-09-10 12:00:00');

SELECT checkout(2,5,'2020-10-01 12:00:00','2020-10-30 12:00:00');
SELECT checkin(5,'2020-10-10 12:00:00');

SELECT checkout(1,3,'2020-11-10 12:00:00','2020-11-30 12:00:00');
SELECT checkin(3,'2020-11-20 12:00:00');

SELECT checkout(2,1,'2021-06-05 12:00:00','2021-06-30 12:00:00');
SELECT checkin(1,'2021-06-10 12:00:00');

SELECT checkout(3,2,'2018-01-01 12:00:00','2018-01-10 12:00:00');
SELECT checkin(2,'2021-02-01 12:00:00');

SELECT checkout(4,4,'2018-01-01 12:00:00','2018-01-30 12:00:00');
SELECT checkin(4,'2018-02-01 12:00:00');

SELECT checkout(5,1,'2018-04-01 12:00:00','2018-04-30 12:00:00');
SELECT checkin(1,'2021-04-05 12:00:00');

SELECT checkout(1,2,'2018-03-01 12:00:00','2018-03-30 12:00:00');
SELECT checkin(2,'2018-03-10 12:00:00');

SELECT checkout(1,2,'2021-03-01 12:00:00','2021-03-30 12:00:00');

CREATE VIEW late_checkins AS
SELECT t.user_id, i.description, COUNT(*)
FROM transactions t INNER JOIN inventory i
ON i.id = t.inventory_id
WHERE t.actual_checkin_time > t.scheduled_checkin_time
GROUP BY t.user_id, i.description
ORDER BY t.user_id, i.description;

SELECT * FROM late_checkins;
