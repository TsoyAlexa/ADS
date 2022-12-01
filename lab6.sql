create table dealer
(
    id       integer primary key,
    name     varchar(255),
    location varchar(255),
    charge   float
);

INSERT INTO dealer (id, name, location, charge)
VALUES (101, 'Ерлан', 'Алматы', 0.15);
INSERT INTO dealer (id, name, location, charge)
VALUES (102, 'Жасмин', 'Караганда', 0.13);
INSERT INTO dealer (id, name, location, charge)
VALUES (105, 'Азамат', 'Нур-Султан', 0.11);
INSERT INTO dealer (id, name, location, charge)
VALUES (106, 'Канат', 'Караганда', 0.14);
INSERT INTO dealer (id, name, location, charge)
VALUES (107, 'Евгений', 'Атырау', 0.13);
INSERT INTO dealer (id, name, location, charge)
VALUES (103, 'Жулдыз', 'Актобе', 0.12);

create table client
(
    id        integer primary key,
    name      varchar(255),
    city      varchar(255),
    priority  integer,
    dealer_id integer references dealer (id)
);

INSERT INTO client (id, name, city, priority, dealer_id)
VALUES (802, 'Айша', 'Алматы', 100, 101);
INSERT INTO client (id, name, city, priority, dealer_id)
VALUES (807, 'Даулет', 'Алматы', 200, 101);
INSERT INTO client (id, name, city, priority, dealer_id)
VALUES (805, 'Али', 'Кокшетау', 200, 102);
INSERT INTO client (id, name, city, priority, dealer_id)
VALUES (808, 'Ильяс', 'Нур-Султан', 300, 102);
INSERT INTO client (id, name, city, priority, dealer_id)
VALUES (804, 'Алия', 'Караганда', 300, 106);
INSERT INTO client (id, name, city, priority, dealer_id)
VALUES (809, 'Саша', 'Шымкент', 100, 103);
INSERT INTO client (id, name, city, priority, dealer_id)
VALUES (803, 'Маша', 'Семей', 200, 107);
INSERT INTO client (id, name, city, priority, dealer_id)
VALUES (801, 'Максат', 'Нур-Султан', null, 105);

create table sell
(
    id        integer primary key,
    amount    float,
    date      timestamp,
    client_id integer references client (id),
    dealer_id integer references dealer (id)
);
INSERT INTO sell (id, amount, date, client_id, dealer_id) VALUES (201, 150.5, '2012-10-05 00:00:00.000000', 805, 102);
INSERT INTO sell (id, amount, date, client_id, dealer_id) VALUES (209, 270.65, '2012-09-10 00:00:00.000000', 801, 105);
INSERT INTO sell (id, amount, date, client_id, dealer_id) VALUES (202, 65.26, '2012-10-05 00:00:00.000000', 802, 101);
INSERT INTO sell (id, amount, date, client_id, dealer_id) VALUES (204, 110.5, '2012-08-17 00:00:00.000000', 809, 103);
INSERT INTO sell (id, amount, date, client_id, dealer_id) VALUES (207, 948.5, '2012-09-10 00:00:00.000000', 805, 102);
INSERT INTO sell (id, amount, date, client_id, dealer_id) VALUES (205, 2400.6, '2012-07-27 00:00:00.000000', 807, 101);
INSERT INTO sell (id, amount, date, client_id, dealer_id) VALUES (208, 5760, '2012-09-10 00:00:00.000000', 802, 101);
INSERT INTO sell (id, amount, date, client_id, dealer_id) VALUES (210, 1983.43, '2012-10-10 00:00:00.000000', 804, 106);
INSERT INTO sell (id, amount, date, client_id, dealer_id) VALUES (203, 2480.4, '2012-10-10 00:00:00.000000', 809, 103);
INSERT INTO sell (id, amount, date, client_id, dealer_id) VALUES (212, 250.45, '2012-06-27 00:00:00.000000', 808, 102);
INSERT INTO sell (id, amount, date, client_id, dealer_id) VALUES (211, 75.29, '2012-08-17 00:00:00.000000', 803, 107);
INSERT INTO sell (id, amount, date, client_id, dealer_id) VALUES (213, 3045.6, '2012-04-25 00:00:00.000000', 802, 101);

--1
--a combine each row of dealer table with each row of client table
select *
from dealer d
         join client c on d.id = c.dealer_id;

--b find all dealers along with client name, city, grade, sell number, date, and amount
select d.name, c.name, c.city, c.priority, s.id, s.date, s.amount
from dealer d
         join client c on d.id = c.dealer_id
         join sell s on d.id = s.dealer_id and c.id = s.client_id;

--c find the dealer and client who belongs to same city
select *
from dealer d
         join client c on d.id = c.dealer_id
where d.location = c.city;

--d find sell id, amount, client name, city those sells where sell amount exists between 100 and 500
select s.id, s.amount, c.name, c.city
from client c
         join sell s on c.id = s.client_id
where s.amount between 100 and 500;

--e find dealers who works either for one or more client or not yet join under any of the clients
select *
from dealer d
         full outer join client c on d.id = c.dealer_id;

--f find the dealers and the clients he service, return client name, city, dealer name, commission.
select c.name, c.city, d.name, d.charge
from dealer d
         join client c on d.id = c.dealer_id;

--g find client name, client city, dealer, commission those dealers who received a commission from the sell more than 12%
select c.name, c.city, d.name, d.charge
from dealer d
         join client c on d.id = c.dealer_id
where d.charge > 0.12;

--h make a report with client name, city, sell id, sell date, sell amount, dealer name and commission to find that either
-- any of the existing clients haven’t made a purchase(sell) or made one or more purchase(sell) by their dealer or by own.
select c.name, c.city, s.id, s.date, s.amount, d.name, d.charge
from dealer d
         join client c on d.id = c.dealer_id
         join sell s on c.id = s.client_id;

--i find dealers who either work for one or more clients. The client may have made,either one or more purchases,
-- or purchase amount above 2000 and must have a grade, or he may not have made any purchase to the associated dealer.
-- Print client name, client grade, dealer name, sell id, sell amount
select c.name, c.priority, d.name, s.id, s.amount
from dealer d
         join client c on d.id = c.dealer_id
         join sell s on c.id = s.client_id
where c.priority is not null
  and s.amount > 2000;

--2
--a count the number of unique clients, compute average and total purchase amount of client orders by each date.
create view a as
select date, count(distinct client_id) as "number", avg(amount) as "average", sum(amount) as "total"
from sell
group by date;
select * from a;

--b find top 5 dates with the greatest total sell amount
create view b as
select distinct date, amount
from sell
order by amount desc
limit 5;
select * from b;

--c count the number of sales, compute average and total amount of all sales of each dealer
create view c as
select dealer, count(amount) as "number", avg(amount) as "average", sum(amount) as "total"
from sell s
         join dealer on s.dealer_id = dealer.id
group by dealer;
select * from c;

--d compute how much all dealers earned from charge(total sell amount * charge) in each location
create view d as
select dealer, sum(amount * dealer.charge) as "earned"
from sell s
         join dealer on s.dealer_id = dealer_id
group by dealer;
select * from d;

--e compute number of sales, average and total amount of all sales dealers made in each location
create view e as
select location, count(amount) as "number", avg(amount) as "average", sum(amount) as "total"
from dealer
         join sell s on dealer.id = s.dealer_id
group by location;
select * from e;

--f compute number of sales, average and total amount of expenses in each city clients made.
create view f as
select city,
       count(amount)                as "number",
       avg(amount * (d.charge + 1)) as "average",
       sum(amount * (d.charge + 1)) as "total"
from client c
         join dealer d on c.dealer_id = d.id
         join sell s on c.id = s.client_id
group by city;
select * from f;

--g find cities where total expenses more than total amount of sales in locations
create view g as
select c.city, sum(amount * (d.charge + 1)) as cities, sum(amount) as locations
from client c
         join sell s on c.id = s.client_id
         join dealer d on s.dealer_id = d.id and c.city = d.location
group by city;
select * from g;