CREATE DATABASE orders;
go

USE orders;
go

DROP TABLE review;
DROP TABLE shipment;
DROP TABLE productinventory;
DROP TABLE warehouse;
DROP TABLE orderproduct;
DROP TABLE incart;
DROP TABLE product;
DROP TABLE category;
DROP TABLE ordersummary;
DROP TABLE paymentmethod;
DROP TABLE customer;


CREATE TABLE customer (
    customerId          INT IDENTITY,
    firstName           VARCHAR(40),
    lastName            VARCHAR(40),
    email               VARCHAR(50),
    phonenum            VARCHAR(20),
    address             VARCHAR(50),
    city                VARCHAR(40),
    state               VARCHAR(20),
    postalCode          VARCHAR(20),
    country             VARCHAR(40),
    userid              VARCHAR(20),
    password            VARCHAR(30),
    PRIMARY KEY (customerId)
);

CREATE TABLE paymentmethod (
    paymentMethodId     INT IDENTITY,
    paymentType         VARCHAR(20),
    paymentNumber       VARCHAR(30),
    paymentExpiryDate   DATE,
    customerId          INT,
    PRIMARY KEY (paymentMethodId),
    FOREIGN KEY (customerId) REFERENCES customer(customerid)
        ON UPDATE CASCADE ON DELETE CASCADE 
);

CREATE TABLE ordersummary (
    orderId             INT IDENTITY,
    orderDate           DATETIME,
    totalAmount         DECIMAL(10,2),
    shiptoAddress       VARCHAR(50),
    shiptoCity          VARCHAR(40),
    shiptoState         VARCHAR(20),
    shiptoPostalCode    VARCHAR(20),
    shiptoCountry       VARCHAR(40),
    customerId          INT,
    PRIMARY KEY (orderId),
    FOREIGN KEY (customerId) REFERENCES customer(customerid)
        ON UPDATE CASCADE ON DELETE CASCADE 
);

CREATE TABLE category (
    categoryId          INT IDENTITY,
    categoryName        VARCHAR(50),    
    PRIMARY KEY (categoryId)
);

CREATE TABLE product (
    productId           INT IDENTITY,
    productName         VARCHAR(60),
    productPrice        DECIMAL(10,2),
    productImageURL     VARCHAR(100),
    productImage        VARBINARY(MAX),
    productDesc         VARCHAR(1000),
    categoryId          INT,
    PRIMARY KEY (productId),
    FOREIGN KEY (categoryId) REFERENCES category(categoryId)
);

CREATE TABLE orderproduct (
    orderId             INT,
    productId           INT,
    quantity            INT,
    price               DECIMAL(10,2),  
    PRIMARY KEY (orderId, productId),
    FOREIGN KEY (orderId) REFERENCES ordersummary(orderId)
        ON UPDATE CASCADE ON DELETE NO ACTION,
    FOREIGN KEY (productId) REFERENCES product(productId)
        ON UPDATE CASCADE ON DELETE NO ACTION
);

CREATE TABLE incart (
    orderId             INT,
    productId           INT,
    quantity            INT,
    price               DECIMAL(10,2),  
    PRIMARY KEY (orderId, productId),
    FOREIGN KEY (orderId) REFERENCES ordersummary(orderId)
        ON UPDATE CASCADE ON DELETE NO ACTION,
    FOREIGN KEY (productId) REFERENCES product(productId)
        ON UPDATE CASCADE ON DELETE NO ACTION
);

CREATE TABLE warehouse (
    warehouseId         INT IDENTITY,
    warehouseName       VARCHAR(30),    
    PRIMARY KEY (warehouseId)
);

CREATE TABLE shipment (
    shipmentId          INT IDENTITY,
    shipmentDate        DATETIME,   
    shipmentDesc        VARCHAR(100),   
    warehouseId         INT, 
    PRIMARY KEY (shipmentId),
    FOREIGN KEY (warehouseId) REFERENCES warehouse(warehouseId)
        ON UPDATE CASCADE ON DELETE NO ACTION
);

CREATE TABLE productinventory ( 
    productId           INT,
    warehouseId         INT,
    quantity            INT,
    price               DECIMAL(10,2),  
    PRIMARY KEY (productId, warehouseId),   
    FOREIGN KEY (productId) REFERENCES product(productId)
        ON UPDATE CASCADE ON DELETE NO ACTION,
    FOREIGN KEY (warehouseId) REFERENCES warehouse(warehouseId)
        ON UPDATE CASCADE ON DELETE NO ACTION
);

CREATE TABLE review (
    reviewId            INT IDENTITY,
    reviewRating        INT,
    reviewDate          DATETIME,   
    customerId          INT,
    productId           INT,
    reviewComment       VARCHAR(1000),          
    PRIMARY KEY (reviewId),
    FOREIGN KEY (customerId) REFERENCES customer(customerId)
        ON UPDATE CASCADE ON DELETE CASCADE,
    FOREIGN KEY (productId) REFERENCES product(productId)
        ON UPDATE CASCADE ON DELETE CASCADE
);
INSERT INTO category(categoryName) VALUES ('Action & Adventure');
INSERT INTO category(categoryName) VALUES ('Horror');
INSERT INTO category(categoryName) VALUES ('Romance');
INSERT INTO category(categoryName) VALUES ('Crime & Mystery');
INSERT INTO category(categoryName) VALUES ('Fantasy');

INSERT product(productName, categoryId, productDesc, productPrice) VALUES ('Tokyo Ghoul, Vol. 5', 2, 'Ghouls live among us, the same as normal people in every way—except their craving for human flesh.
Ken Kaneki is an ordinary college student until a violent encounter turns him into the first half-human half-ghoul hybrid. Trapped between two worlds, he must survive Ghoul turf wars, learn more about Ghoul society and master his new powers.
Kaneki, Nishio and Touka struggle to work together to rescue their human friend Kimi while Ghoul Investigator deaths skyrocket in wards 9 through 12. It all leads to an increase in CCG agents and an increased risk for Ghouls. As reinforcements are called in on both sides, the stakes are suddenly higher than ever.', 19.99);
UPDATE Product SET productImageURL = 'img/tg5.avif' WHERE productName = 'Tokyo Ghoul, Vol. 5';

INSERT INTO product (productName, categoryId, productDesc, productPrice)
VALUES (
    'Tokyo Ghoul, Vol. 8',
    2,
    'Kaneki is struggling to maintain control as his Kagune continues to evolve. Investigators tighten their net around the ghouls during rising conflict within the 11th Ward.',
    17.99
);
UPDATE Product SET productImageURL = 'img/tg8.avif' WHERE productName = 'Tokyo Ghoul, Vol. 8';


INSERT INTO product (productName, categoryId, productDesc, productPrice)
VALUES (
    'Tokyo Ghoul, Vol. 6',
    2,
    'Kaneki faces increasingly dangerous struggles as tensions rise between ghouls and investigators, forcing him deeper into conflict as he searches for identity and survival.',
    17.99
);
UPDATE Product SET productImageURL = 'img/tg6.avif' WHERE productName = 'Tokyo Ghoul, Vol. 6';

INSERT INTO product (productName, categoryId, productDesc, productPrice)
VALUES (
    'Tokyo Ghoul, Vol. 10',
    2,
    'Chaos erupts as the CCG intensifies its campaigns and Kaneki confronts new threats, testing the fragile alliances between ghouls and investigators.',
    17.99
);
UPDATE Product SET productImageURL = 'img/tg10.avif' WHERE productName = 'Tokyo Ghoul, Vol. 10';

INSERT INTO product (productName, categoryId, productDesc, productPrice)
VALUES (
    'Tokyo Ghoul, Vol. 9',
    2,
    'As tensions escalate across Tokyo, Kaneki and the ghouls face mounting pressure from investigators, leading to dangerous confrontations and shifting alliances.',
    17.99
);
UPDATE Product SET productImageURL = 'img/tg9.avif' WHERE productName = 'Tokyo Ghoul, Vol. 9';

INSERT INTO product (productName, categoryId, productDesc, productPrice)
VALUES (
    'Tokyo Ghoul, Vol. 11',
    2,
    'The battle between ghouls and investigators reaches new intensity as Kaneki faces unsettling revelations, forcing him to confront the truth behind his existence.',
    17.99
);

UPDATE Product
SET productImageURL = 'img/tg11.avif'
WHERE productName = 'Tokyo Ghoul, Vol. 11';

INSERT INTO product (productName, categoryId, productDesc, productPrice)
VALUES (
    'Tokyo Ghoul:re, Vol. 1',
    2,
    'Haise Sasaki leads the Quinx Squad under the CCG, balancing his role as mentor while grappling with buried memories that threaten to resurface.',
    17.99
);

UPDATE Product
SET productImageURL = 'img/tgre1.avif'
WHERE productName = 'Tokyo Ghoul:re, Vol. 1';

INSERT INTO product (productName, categoryId, productDesc, productPrice)
VALUES (
    'Tokyo Ghoul, Vol. 14',
    2,
    'As the CCG clashes with Aogiri Tree in escalating violence, Kaneki is forced toward a final confrontation that will reshape the fate of both humans and ghouls.',
    17.99
);

UPDATE Product
SET productImageURL = 'img/tg14.avif'
WHERE productName = 'Tokyo Ghoul, Vol. 14';


INSERT INTO product (productName, categoryId, productDesc, productPrice)
VALUES (
    'Tokyo Ghoul:re, Vol. 10',
    2,
    'The CCG’s campaign intensifies as secrets surrounding the ghouls deepen, pushing Haise and the members of the Quinx Squad toward devastating revelations.',
    17.99
);

UPDATE Product
SET productImageURL = 'img/tgre10.avif'
WHERE productName = 'Tokyo Ghoul:re, Vol. 10';

INSERT INTO product (productName, categoryId, productDesc, productPrice)
VALUES (
    'Tokyo Ghoul:re, Vol. 9',
    2,
    'As the conflict escalates, Haise and the Quinx Squad are pushed to their limits while the mystery surrounding the ghouls deepens across Tokyo.',
    17.99
);

UPDATE Product
SET productImageURL = 'img/tgre9.avif'
WHERE productName = 'Tokyo Ghoul:re, Vol. 9';


INSERT INTO product (productName, categoryId, productDesc, productPrice)
VALUES (
    'Bleach (3-in-1 Edition), Vol. 1',
    1,
    'Ichigo Kurosaki becomes a Substitute Soul Reaper after gaining powers from Rukia, pulling him into battles against Hollows and the mysteries of the spirit world.',
    19.99
);

UPDATE Product
SET productImageURL = 'img/bleach3in1v1.avif'
WHERE productName = 'Bleach (3-in-1 Edition), Vol. 1';


INSERT INTO product (productName, categoryId, productDesc, productPrice)
VALUES (
    'Bleach: Can’t Fear Your Own World, Vol. 1',
    1,
    'Following the aftermath of the Thousand-Year Blood War, Shuhei Hisagi is drawn into a conspiracy threatening Soul Society as new shadows rise from the chaos.',
    19.99
);

UPDATE Product
SET productImageURL = 'img/bleachcfyow1.avif'
WHERE productName = 'Bleach: Can’t Fear Your Own World, Vol. 1';

INSERT INTO product (productName, categoryId, productDesc, productPrice)
VALUES (
    'Bleach, Vol. 71',
    1,
    'As the final battles of the Thousand-Year Blood War intensify, Ichigo and his allies face overwhelming threats while hidden truths about Yhwach’s power come to light.',
    12.99
);

UPDATE Product
SET productImageURL = 'img/bleach71.avif'
WHERE productName = 'Bleach, Vol. 71';

INSERT INTO product (productName, categoryId, productDesc, productPrice)
VALUES (
    'Bleach, Vol. 74',
    1,
    'The final confrontation of the Thousand-Year Blood War erupts as Ichigo faces Yhwach in a desperate battle to decide the fate of Soul Society once and for all.',
    12.99
);

UPDATE Product
SET productImageURL = 'img/bleach74.avif'
WHERE productName = 'Bleach, Vol. 74';

INSERT INTO product (productName, categoryId, productDesc, productPrice)
VALUES (
    'Bleach, Vol. 24: Immanent God Blues',
    1,
    'As the Arrancar threat escalates, Ichigo pushes deeper into conflict while grappling with the unstable power of his Hollow within.',
    12.99
);

UPDATE Product
SET productImageURL = 'img/bleach24.avif'
WHERE productName = 'Bleach, Vol. 24: Immanent God Blues';

INSERT INTO product (productName, categoryId, productDesc, productPrice)
VALUES (
    'Bleach, Vol. 34: King of the Kill',
    1,
    'Ichigo’s battle against Grimmjow reaches its brutal climax as both fighters unleash everything they have in a desperate struggle for dominance.',
    12.99
);

UPDATE Product
SET productImageURL = 'img/bleach34.avif'
WHERE productName = 'Bleach, Vol. 34: King of the Kill';

INSERT INTO product (productName, categoryId, productDesc, productPrice)
VALUES (
    'Bleach, Vol. 57: Out of Bloom',
    1,
    'The sudden invasion of the Wandenreich plunges Soul Society into chaos as the Quincy unleash overwhelming power, forcing Ichigo into a desperate race to return.',
    12.99
);

UPDATE Product
SET productImageURL = 'img/bleach57.avif'
WHERE productName = 'Bleach, Vol. 57: Out of Bloom';

INSERT INTO product (productName, categoryId, productDesc, productPrice)
VALUES (
    'JoJo''s Bizarre Adventure Part 7: Steel Ball Run, Vol. 4',
    1,
    'Johnny and Gyro push deeper into the Steel Ball Run race as new Stand users close in, forcing them into brutal confrontations across the deadly American landscape.',
    26.99
);

UPDATE Product
SET productImageURL = 'img/sbr4.avif'
WHERE productName = 'JoJo''s Bizarre Adventure Part 7: Steel Ball Run, Vol. 4';

INSERT INTO product (productName, categoryId, productDesc, productPrice)
VALUES (
    'JoJo''s Bizarre Adventure Part 7: Steel Ball Run, Vol. 1',
    1,
    'The Steel Ball Run race begins as Johnny Joestar, a former jockey, crosses paths with the mysterious Gyro Zeppeli and the deadly power of the Spin.',
    26.99
);

UPDATE Product
SET productImageURL = 'img/sbr1.avif'
WHERE productName = 'JoJo''s Bizarre Adventure Part 7: Steel Ball Run, Vol. 1';

INSERT INTO product (productName, categoryId, productDesc, productPrice)
VALUES (
    'JoJo''s Bizarre Adventure Part 7: Steel Ball Run, Vol. 3',
    1,
    'Johnny and Gyro continue their advance in the Steel Ball Run race, facing lethal Stand abilities as rival racers close in across the treacherous terrain.',
    26.99
);

UPDATE Product
SET productImageURL = 'img/sbr3.avif'
WHERE productName = 'JoJo''s Bizarre Adventure Part 7: Steel Ball Run, Vol. 3';

INSERT INTO product (productName, categoryId, productDesc, productPrice)
VALUES (
    'JoJo''s Bizarre Adventure Part 2: Battle Tendency, Vol. 3',
    1,
    'Joseph Joestar clashes with the Pillar Men as their terrifying powers escalate, pushing him into deadly battles that demand every trick he can muster.',
    12.99
);

UPDATE Product
SET productImageURL = 'img/bt3.avif'
WHERE productName = 'JoJo''s Bizarre Adventure Part 2: Battle Tendency, Vol. 3';

INSERT INTO product (productName, categoryId, productDesc, productPrice)
VALUES (
    'JoJo''s Bizarre Adventure Part 2: Battle Tendency, Vol. 1',
    1,
    'Joseph Joestar is dragged into a new war against the ancient Pillar Men, beginning a chaotic clash of wits, ridiculous tactics, and escalating supernatural power.',
    12.99
);

UPDATE Product
SET productImageURL = 'img/bt1.avif'
WHERE productName = 'JoJo''s Bizarre Adventure Part 2: Battle Tendency, Vol. 1';

INSERT INTO product (productName, categoryId, productDesc, productPrice)
VALUES (
    'JoJo''s Bizarre Adventure Part 1: Phantom Blood, Vol. 3',
    1,
    'Jonathan Joestar faces Dio’s monstrous rise as their final confrontation erupts, pushing the limits of Hamon and sealing the tragic fate of the Joestar bloodline’s beginning.',
    12.99
);

UPDATE Product
SET productImageURL = 'img/pb3.avif'
WHERE productName = 'JoJo''s Bizarre Adventure Part 1: Phantom Blood, Vol. 3';

INSERT INTO product (productName, categoryId, productDesc, productPrice)
VALUES (
    'JoJo''s Bizarre Adventure Part 4: Diamond Is Unbreakable, Vol. 6',
    1,
    'Josuke and the gang close in on new Stand threats in Morioh as the escalating mystery draws them toward deadly confrontations hidden within the quiet town.',
    19.99
);

UPDATE Product
SET productImageURL = 'img/diu6.avif'
WHERE productName = 'JoJo''s Bizarre Adventure Part 4: Diamond Is Unbreakable, Vol. 6';

INSERT INTO product (productName, categoryId, productDesc, productPrice)
VALUES (
    'Dandadan, Vol. 14',
    1,
    'As Momo, Okarun, and their chaotic crew confront escalating supernatural threats, new enemies emerge and the stakes rise in their battle to protect those they care about.',
    14.99
);

UPDATE Product
SET productImageURL = 'img/dandadan14.avif'
WHERE productName = 'Dandadan, Vol. 14';

INSERT INTO product (productName, categoryId, productDesc, productPrice)
VALUES (
    'Jujutsu Kaisen, Vol. 23',
    1,
    'The chaos of the Culling Game intensifies as sorcerers clash with overwhelming curses, forcing Yuji and his allies into brutal battles that push them past their limits.',
    12.99
);

UPDATE Product
SET productImageURL = 'img/jjk23.avif'
WHERE productName = 'Jujutsu Kaisen, Vol. 23';

INSERT INTO product (productName, categoryId, productDesc, productPrice)
VALUES (
    'Chainsaw Man, Vol. 18',
    1,
    'As new devils and shifting alliances shake the fragile balance of the world, Denji is dragged deeper into chaos, forced to confront enemies who know exactly how to break him.',
    12.99
);

UPDATE Product
SET productImageURL = 'img/csm18.avif'
WHERE productName = 'Chainsaw Man, Vol. 18';




INSERT INTO customer (firstName, lastName, email, phonenum, address, city, state, postalCode, country, userid, password) VALUES ('Some', 'Body', 'once@told.com', '204-111-2222', '103 AnyWhere Street', 'Kelowna', 'BC', 'V1X 3Y7', 'Canada', 'zalad' , 'USER304!');
INSERT INTO customer (firstName, lastName, email, phonenum, address, city, state, postalCode, country, userid, password) VALUES ('Zander', 'Holoboff', 'zander@gmail.com', '204-111-2222', '103 AnyWhere Street', 'Winnipeg', 'MB', 'R3X 45T', 'Canada', 'admin304' , 'ADMIN304!');

INSERT INTO customer (firstName, lastName, email, phonenum, address, city, state, postalCode, country, userid, password) VALUES ('Arnold', 'Anderson', 'a.anderson@gmail.com', '204-111-2222', '103 AnyWhere Street', 'Winnipeg', 'MB', 'R3X 45T', 'Canada', 'arnold' , '304Arnold!');
INSERT INTO customer (firstName, lastName, email, phonenum, address, city, state, postalCode, country, userid, password) VALUES ('Bobby', 'Brown', 'bobby.brown@hotmail.ca', '572-342-8911', '222 Bush Avenue', 'Boston', 'MA', '22222', 'United States', 'bobby' , '304Bobby!');
INSERT INTO customer (firstName, lastName, email, phonenum, address, city, state, postalCode, country, userid, password) VALUES ('Candace', 'Cole', 'cole@charity.org', '333-444-5555', '333 Central Crescent', 'Chicago', 'IL', '33333', 'United States', 'candace' , '304Candace!');
INSERT INTO customer (firstName, lastName, email, phonenum, address, city, state, postalCode, country, userid, password) VALUES ('Darren', 'Doe', 'oe@doe.com', '250-807-2222', '444 Dover Lane', 'Kelowna', 'BC', 'V1V 2X9', 'Canada', 'darren' , '304Darren!');
INSERT INTO customer (firstName, lastName, email, phonenum, address, city, state, postalCode, country, userid, password) VALUES ('Elizabeth', 'Elliott', 'engel@uiowa.edu', '555-666-7777', '555 Everwood Street', 'Iowa City', 'IA', '52241', 'United States', 'beth' , '304Beth!');

-- Order 1 can be shipped as have enough inventory
DECLARE @orderId int
INSERT INTO ordersummary (customerId, orderDate, totalAmount) VALUES (1, '2019-10-15 10:25:55', 91.70)
SELECT @orderId = @@IDENTITY
INSERT INTO orderproduct (orderId, productId, quantity, price) VALUES (@orderId, 1, 1, 18)
INSERT INTO orderproduct (orderId, productId, quantity, price) VALUES (@orderId, 2, 2, 21.35)
INSERT INTO orderproduct (orderId, productId, quantity, price) VALUES (@orderId, 3, 1, 31);

INSERT INTO ordersummary (customerId, orderDate, totalAmount) VALUES (2, '2019-10-16 18:00:00', 106.75)
SELECT @orderId = @@IDENTITY
INSERT INTO orderproduct (orderId, productId, quantity, price) VALUES (@orderId, 1, 5, 21.35);

-- Order 3 cannot be shipped as do not have enough inventory for item 7
INSERT INTO ordersummary (customerId, orderDate, totalAmount) VALUES (3, '2019-10-15 3:30:22', 140)
SELECT @orderId = @@IDENTITY
INSERT INTO orderproduct (orderId, productId, quantity, price) VALUES (@orderId, 2, 2, 25)
INSERT INTO orderproduct (orderId, productId, quantity, price) VALUES (@orderId, 4, 3, 30);

INSERT INTO ordersummary (customerId, orderDate, totalAmount) VALUES (2, '2019-10-17 05:45:11', 327.85)
SELECT @orderId = @@IDENTITY
INSERT INTO orderproduct (orderId, productId, quantity, price) VALUES (@orderId, 3, 4, 10)
INSERT INTO orderproduct (orderId, productId, quantity, price) VALUES (@orderId, 2, 3, 40)
INSERT INTO orderproduct (orderId, productId, quantity, price) VALUES (@orderId, 1, 3, 23.25)
INSERT INTO orderproduct (orderId, productId, quantity, price) VALUES (@orderId, 2, 2, 21.05)
INSERT INTO orderproduct (orderId, productId, quantity, price) VALUES (@orderId, 4, 4, 14);

INSERT INTO ordersummary (customerId, orderDate, totalAmount) VALUES (5, '2019-10-15 10:25:55', 277.40)
SELECT @orderId = @@IDENTITY
INSERT INTO orderproduct (orderId, productId, quantity, price) VALUES (@orderId, 5, 4, 21.35)
INSERT INTO orderproduct (orderId, productId, quantity, price) VALUES (@orderId, 4, 2, 81)
INSERT INTO orderproduct (orderId, productId, quantity, price) VALUES (@orderId, 6, 3, 10);

-- give every product without an image No_Image_Available
UPDATE Product SET productImageURL = 'img/No_Image_Available.jpg' WHERE productImageURL is NULL