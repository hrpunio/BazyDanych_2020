
--1. Crearea tabelelor
create table categories(
   categoryid number(1) primary key,
   categoryname varchar2(15)
);

create table wines(
   wineid number(5) primary key,
   winename varchar2(40) not null unique,
   description varchar2(1000) not null,
   tastingnotes varchar2(300),
   abv number(4,2) check (abv between 0 and 21),
   year number(4) check (year between 2010 and 2020),
   price number(6,2) not null check (price > 0),
   bottlesize number(3,1),
   stock number(4) check (stock > 0),
   categoryid number(1) references categories(categoryid) on delete cascade
);


create table countries(
   countryid char(2) primary key,
   countryname varchar2(40)
);
create table regions(
   regionid number(2) primary key,
   regionname varchar2(40),
   countryid char(2) references countries(countryid)
);
create table producers(
   producerid number(4) primary key,
   producername varchar2(20) not null,
   description varchar2(300),
   regionid number(2) references regions(regionid)
);

alter table wines
add  producerid number(4) references producers(producerid);

create table members(
  memberid number(4) primary key,
  email varchar2(30) not null,
  password varchar2(20) not null,
  firstname varchar2(15),
  lastname varchar2(20),
  username varchar2(20) not null,
  phone char(10),
  bithdate date not null
);

alter table members
rename column bithdate to birthdate;

create table addresses(
  addressid number(4) primary key,
  streetaddress varchar2(120) not null,
  postalcode varchar2(7),
  regionid number(2) references regions(regionid),
  city varchar2(25) not null,
  memberid number(4) references members(memberid)
);

create table creditcards(
   cardid number(5) primary key,
   cardtype varchar2(20),
   pan char(16) not null,
   expirationdate date,
   cardholder varchar2(50) not null,
   memberid number(4) references members(memberid),
   constraint check_cardtype
   check (upper(cardtype) in ('AMERICAN EXPRESS','MASTERCARD','VISA','DISCOVER'))
);
create table orders(
    orderid number(4) primary key,
    orderdate date,
    shippingdate date,
    billingaddress number(4) references addresses(addressid),
    deliveryaddress number(4) references addresses(addressid),
    totalprice number(6,2) not null,
    totaldiscount number(6,2) not null,
    cardid number(5) references creditcards(cardid),
    memberid number(4) references members(memberid)
);
create table order_wine
(
   orderid number(4) references orders(orderid),
   wineid number(4) references wines(wineid),
   quantity number(2) not null,
   orderprice number(6,2),
   primary key(orderid,wineid)
);

create table plans(
   planid number(4) primary key,
   planname varchar2(20) not null,
   description varchar2(400),
   planprice number(6,2),
   dayofmonth char(2),
   nowines number
);

create table subscription
(
   subscriptionid number(4) primary key,
   startdate date,
   enddate date,
   billingaddress number(4) references addresses(addressid),
   deliveryaddress number(4) references addresses(addressid),
   cardid number(5) references creditcards(cardid),
   memberid number(4) references members(memberid),
   planid number(4) references plans(planid)
);
create table plan_wine(
   planwineid number(4) primary key,
   planid number(4) not null references plans(planid),
   wineid number(4) not null references wines(wineid),
   period date not null,
   constraint uni_plan_wine unique(planid,wineid,period)
);

create table discounts(
   discountid number(4) primary key,
   discountname varchar2(20),
   startdate date,
   enddate date,
   percentage number(3,1) 
);
create table wine_discount(
   wineid number(4) references wines(wineid),
   discountid number(4) references discounts(discountid),
   primary key(wineid,discountid)
);

--2. Populam cu date

--inseram in categories

insert into categories 
values (1,'Red');
insert into categories
values (2,'Rose');
insert into categories
values(3,'White');
--inseram in countries
insert into countries
values ('US','United States of America');
insert into countries
values ('AU','Australia');
insert into countries
values ('FR','France');
insert into countries
values ('CH','Switzerland');
insert into countries
values('AR','Argentina');
insert into countries
values ('NZ','New Zealand');

--inseram in regions
insert into regions 
values(1,'California','US');
insert into regions
values(2,'Central Otago','NZ');
insert into regions
values(3,'Oregon','US');
insert into regions
values(4,'Victoria','AU');
insert into regions
values(5,'Western Australia','AU');
insert into regions
values(6,'Alsace','FR');
insert into regions
values(7,'Bordeaux','FR');
insert into regions
values(8,'Burgundy','FR');

--inseram in producers
insert into producers
values(1,'Leeuwin Estate','Family owned, Leeuwin Estate, one of the five founding wineries of the now famous Margaret River district of Western Australia, is under the direction of two generations who work with a team of highly skilled winemakers to consistently produce wines ranking alongside the world’s finest.',5);
insert into producers
values(2,'Yarra Yering','Yarra Yering is one of the oldest and most beautiful vineyards in the Yarra
Valley consisting of 28 hectares of vines located at the foot of the Warramate Hills.',4);
insert into producers
values(3,'Chateau Montelena','Chateau Montelena is a Napa Valley winery most famous for winning the
white wine section of the historic "Judgment of Paris" wine competition.',1);
insert into producers
values(4,'Domaine Leflaive','Domaine Leflaive is a winery in Puligny-Montrachet, Côte de Beaune, Burgundy. 
The domaine is very highly regarded for its white wines, and its vineyard holdings include 5.1 hectares of Grand Cru vineyards.',8);
insert into producers
values(5,'Domaine Guy Amiot',null,8);
insert into producers
values(6,'Ridge Vineyards',null,1);
insert into producers
values(7,'Château Palmer','Château Palmer is a winery in Bordeaux, France. The wine produced here was classified as one
of fourteen Troisièmes Crus in the historic Bordeaux Wine Official Classification of 1855.',7);

--inseram in wines
--create sequence wines_seq
--start with 1
--increment by 1;

insert into wines
values(1,'Bienvenue Bâtard Montrachet','Bienvenues Bâtard Montrachet borders the Grand Cru 
vineyard Bâtard-Montrachet in the west and south and the Puligny-Montrachet Premier Cru 
Les Pucelles in the north.','Golden in colour, the bouquet is rich with a hint of butterscotch.
The palate is delicious, very rich and aristocratic, complex, multi dimensional
with layers of characterful fruit.',14,2010,900,75,100,3,4);

insert into wines
values(2,'Angels Flight','Full of juicy ripe strawberry and a hint of cream, perfect for those who prefer their wine with a touch of sweetness.',
'Bright aromas of strawberry and watermelon. The full, ripe fruit flavours are well balanced with a refreshing mouthfeel and a slight crisp, lingering finish.',
10,2018,20.4,75,65,2,2);

insert into wines
values(3,'Boulevard Blush','Plenty of strawberry fruit flavours in this classic blush style, with that signature sweetness.',
'Perfect for those who enjoy a sweeter rose, this has ripe, juicy flavours of watermelon and strawberry which lead to a long sweet finish.',
10,2014,19.99,75,34,2,2);

insert into wines
values(4,'Smoking Loon Old Vine','The grapes used to make this wine were sourced from multiple locations, most notably Lodi and Paso Robles.',
'Juicy aromas of plum, raspberry and mocha.',14,2017,12.99,75,21,1,2);



insert into wines
values(5,'Krondorf Shiraz','A robust Shiraz wine from the Barossa that is ready to enjoy now but will also develop for 4 - 5 years. Flavours of blackberry and spicy blackcurrant.',
'A nose of dark berries and spice.',14.5,2016,78.99,75,89,1,1);

insert into wines
values(6,'Cabernet Sauvignon Shiraz','A big ripe wine with aromas of cedar and spicy cassis.','The terroir delivers complexity involving the aroma and flavour of dusty earth and Eucalypt smoke. The aroma is complex and powerful, dominated by ripe blackberry and plum fruit.',
16,2013,44.99,65,55,1,2);

insert into wines
values(7,'Art Series Riesling','Energy and vitality is at the forefront on the palate, finger limes is the thread with subtleties of lemon sherbet.',
'A fragrant and delicate nose that features cut lime, lemon and apple, combining with Kaffir leaf, Thai basil and lemongrass',
13.5,2019,19.99,75,20,3,1);

insert into wines
values(8,'Puligny Montrachet','This vintage sits comfortably in the top ranks of vintages at this domaine, which has some of the greatest terroir in the world and whose results are always inspirational and frequently spectacular.',
'A wine of real finesse and elegance with notes of fine aniseed, clove and pears.',
13,2018,15.50,75,67,3,4);

insert into wines
values(9,'Chassagne-Montrachet','2018 is a "Grand" vintage: solar, powerful, generous... we wish we had more like this one in Burgundy!','Particularly high yields and alcoholic degrees (up to 15%/alc in some plots).',
15,2013,17,75,34,1,5);

-- inseram in plans
insert into plans
values(1,'The Explore','Built around a changing theme — such as a classic wine region, a specific grape variety, or the best wines of the season — 
this four-bottle selection offers a unique introduction to the world of wine, whether you want to grow your knowledge or just drink the good stuff.',
99,'04',4);
insert into plans
values(2,'The Blind','If you’re looking to refine your palate, expand your skills, or enjoy a fun way to drink great wine with friends, this club delivers
six bottles that are wrapped in black tissue paper and numbered for an authentic “blind tasting” experience.',
199,'12',6);
insert into plans
values(3,'The Grand Tour','We created The Grand Tour to bring the great work of the winemakers we love straight to your door. As a TGT member ($95/month + shipping), your monthly delivery will include four bottles
of hand-selected wine from the featured region or theme of that month.',95,'18',3);

insert into members
values(1,'tate@gmail.com','Tate@1234','Tate','Robinson','tate23','2025550104','2-JAN-1996');

insert into members
values(2,'america@gmail.com','America!23','America','Rogers','arogers','2025550129','14-JUN-1986');

insert into members
values(3,'rachel@gmail.com','!rach#2','Rachel','Williams','rachelwill','5807901036','26-SEP-1999');

insert into members
values(4,'dominic@yahoo.com','DomInIC3','Dominic','Clinton','dclinton','8483910069','10-NOV-1958');

insert into members
values(5,'levi@bitdefender.com','LewisC','Levi','Carter','cartlevi','5406367427','31-DEC-1989');

insert into members
values(6,'emily67@gmail.com','123Emily321','Emily','Gilmore','emilygilmore','5189269142','14-FEB-1955');

insert into members
values(7,'milescooper@gmail.com','Mileage@123','Miles','Cooper','milescooper','6312219320','22-MAY-1992');

insert into members
values(8,'curtisatt@gmail.com','Curtis22','Curtis','Attwood','curtisattwood','9106327426','13-SEP-1888');

insert into members
values(9,'tess28@gmail.com','tessalovespuppies','Theresa','Gearhart','tessagearhart','8435055048','28-JAN-2000');

insert into  addresses
values(1,'505 W Lambert Rd','0211000',1,'Brea',1);
insert into addresses
values(2,'487 E Middlefield Rd','9404300',1,'Mountain View',2);

insert into addresses
values(3,'2911 Elm Ave','90266',1,'Manhattan Beach',3);

insert into addresses
values(4,'29 Mildura Street','7216',4,'The Gardens',4);
insert into addresses
values(5,'86 Hebbard Street','3183',5,'St Kilda East',5);
insert into addresses
values(6,'118  rue Grande Fusterie','91800',7, 'BRUNOY',6);
insert into addresses
values(7,'30  rue des Soeurs','06160',8,'JUAN-LES-PINS',7);

insert into addresses
values(8,'31 Marshall Ave.','95123', 1, 'San Jose', 1);

insert into addresses
values(9,'97  rue des Coudriers','03000',6,'Moulins',9);

insert into addresses
values(10,'899  Armory Road','90001',1,'Los Angeles',2);

--subscriptions

insert into subscription
values(1,'3-NOV-2018','3-NOV-2021',1,1,1,1,1);

insert into subscription
values(2,'5-DEC-2019','6-DEC-2022',2,2,2,2,1);

insert into subscription
values(3,'28-AUG-2018','18-FEB-2021',3,3,3,3,2);

insert into subscription
values(4,'6-SEP-2019','6-SEP-2021',4,4,4,4,2);

insert into subscription
values(5,'18-NOV-2020','18-NOV-2021',5,5,5,5,3);

insert into subscription
values(6,'3-MAR-2020','3-MAR-2021',6,6,6,6,3);

insert into subscription
values(7,'16-MAY-2020','16-MAY-2021',7,7,7,7,3);


insert into creditcards
values(1,'Visa','4638413934278091','1-NOV-2023','Tate Robinson',1);

insert into creditcards
values(2,'Visa','4776733275746121','1-DEC-2023','America Rogers',2);

insert into creditcards
values(3,'Visa','4829266122034000','1-NOV-2023','Rachel Williams',3);

insert into creditcards
values(4,'American Express','3449849272194930','1-MAR-2028','Dominic Edward Clinton',4);

insert into creditcards
values(5,'American Express','3787543030379520','1-JUN-2028','Dona Carter',5);

insert into creditcards
values(6,'Mastercard','5142081410702854','1-FEB-2024','Emily Gilmore',6);

insert into creditcards
values(7,'Discover','6011321619825189','1-JUN-2021','Miles Cooper',7);

insert into creditcards
values(8, 'American Express','3775452613251110','1-FEB-2024','Angelina Cooper',7);

insert into orders
values(1,'3-NOV-2020','4-NOV-2020',1,1,65.39,0,1,1);
insert into orders
values(2,'5-DEC-2020','10-DEC-2020',1,1,720,180,1,1);

insert into orders
values(3,'14-JAN-2019','16-JAN-2016',2,2, 48.48,0,2,2);

insert into orders
values(4,'6-SEP-2020','6-SEP-2020',3,3,44.99,0,3,3);

insert into orders
values(5,'18-AUG-2020','23-AUG-2020',4,4,78.99,0,4,4);

insert into orders
values(6,'25-JUN-2020','1-AUG-2020',5,5,98.98,0,5,5);

insert into orders
values(7,'17-APR-2020','21-APR-2020',6,6,19.99,0,6,6);

insert into orders
values(8,'10-FEB-2020','12-FEB-2020',7,7,85.65,15.12,7,7);

insert into orders
values(9,'4-JAN-21','4-JAN-21',2,2,60.79,0,2,2);

insert into orders
values(10,'4-JAN-2021','5-JAN-2021',2,2,80.1,2.79,2,2);

insert into orders values(12,'5-JAN-2021','6-JAN-2021',3,3,333.88,17.57,3,3);

insert into orders 
values(13,'9-JAN-2021','10-JAN-2021',8,8,183.8,9.67,1,1);

insert into orders
values(14,'7-JAN-2021','7-JAN-2021',10,10,33.72,1.77,2,2);

insert into orders
values(15,'7-JAN-2021','7-JAN-2021',10,10,46.5,0,2,2);


insert into orders
values(16,'7-JAN-2021','7-JAN-2021',10,10,58.14,3.06,2,2);

insert into orders
values(17,'5-JAN-2021','6-JAN-2021',10,10,44.99,0,2,2);


insert into orders
values(18,'6-JAN-2021','6-JAN-2021',6,6,17 ,0,6,6);

insert into order_wine
values(18,9,1,17);

insert into order_wine
values(17,6,1,44.99);

insert into order_wine
values(16,2,3,19.38);


insert into order_wine
values(15,8,3,15.5);


insert into order_wine
values(14,8,1,14.73);
insert into order_wine
values(14,7,1,18.99);



insert into order_wine
values(13,7,1,18.99);
insert into order_wine
values(13,5,2,75.04);
insert into order_wine
values(13,8,1,14.73);


insert into order_wine
values(12,7,1,18.99);
insert into order_wine
values(12,5,4,75.04);
insert into order_wine
values(12,8,1,14.73);



insert into order_wine
values(10,7,1,20.99);
insert into order_wine 
values(10,8,1,16.28);
insert into order_wine
values(10,2,2,21.42);

insert into order_wine
values(9,2,2,20.4);
insert into order_wine
values(9,7,1,19.99);

--pentru orderid = 1
insert into order_wine
values(1,2,1,20.4);
insert into order_wine
values(1,6,1,44.99);
--pentru orderid = 2
insert into order_wine
values(2,1,1,720);
--pentru orderid = 3
insert into order_wine
values(3,4,1,12.99);
insert into order_wine
values(3,7,1,19.99);
insert into order_wine
values(3,8,1, 15.5);
--pentru orderid = 4
insert into order_wine
values(4,6,1,44.99);
--pentru orderid = 5
insert into order_wine
values(5,5,1,78.99);
--pentru orderid = 6
insert into order_wine
values(6,5,1,78.99);
insert into order_wine
values(6,3,1,19.99);
--pentru orderid = 7
insert into order_wine
values(7,3,1,19.99);
--pentru orderid = 8
insert into order_wine
values(8,7,3,16.99);
insert into order_wine
values(8,2,2,17.34);


insert into discounts
values(1,'Valentine Wine','7-FEB-2020','15-FEB-2020',15);
insert into discounts
values(2,'Christmas Time','1-DEC-2020','23-DEC-2020',20);
insert into discounts
values(3,'2020 Summer Sale','1-JUN-2020','7-JUN-2020',7);

insert into wine_discount
values(1,2);
insert into wine_discount
values(2,1);
insert into wine_discount
values(7,2);
insert into wine_discount
values(1,3);
insert into wine_discount
values(2,3);
insert into wine_discount
values(6,3);
insert into wine_discount
values(6,2);
insert into wine_discount
values(1,1);
insert into wine_discount
values(7,1);
insert into wine_discount
values(3,2);
insert into wine_discount
values(4,1);


insert into plan_wine
values(1,1,3,'1-DEC-2020');
insert into plan_wine
values(2,1,4,'1-DEC-2020');
insert into plan_wine
values(3,1,8,'1-DEC-2020');

insert into plan_wine
values(4,2,2,'1-DEC-2020');
insert into plan_wine
values(5,2,3,'1-DEC-2020');
insert into plan_wine
values(6,2,4,'1-DEC-2020');
insert into plan_wine
values(7,2,5,'1-DEC-2020');
insert into plan_wine
values(8,2,6,'1-DEC-2020');
insert into plan_wine
values(9,2,7,'1-DEC-2020');
insert into plan_wine
values(10,3,3,'1-DEC-2020');
insert into plan_wine
values(11,3,8,'1-DEC-2020');
insert into plan_wine
values(12,3,7,'1-DEC-2020');
insert into plan_wine
values(13,1,7,'1-DEC-2020');

