CREATE DATABASE hotel_booking_analysis;
USE hotel_booking_analysis;
SELECT * FROM reservations;
SELECT * FROM guests;
SELECT * FROM rooms;
SELECT * FROM properties;

# How many bookings are Confirmed, Cancelled, Checked-out, and No-show?
SELECT 
booking_status,
COUNT(*) AS total_bookings
FROM reservations
GROUP BY booking_status
ORDER BY total_bookings DESC;

#Find the total number of bookings for each month.
SELECT
YEAR(booking_date) AS booking_year,
MONTH(booking_date) AS booking_month,
COUNT(*) AS total_bookings
FROM reservations
GROUP BY YEAR(booking_date), MONTH(booking_date)
ORDER BY booking_year, booking_month;

#Total Revenue by Property
SELECT
p.property_name,
SUM(r.booking_value) AS total_revenue
FROM reservations r
JOIN properties p
ON r.property_id = p.property_id
WHERE r.booking_status = 'Checked Out'
GROUP BY p.property_name
ORDER BY total_revenue DESC;

#Cancellation Rate
SELECT
    COUNT(*) AS total_bookings,
    SUM(CASE WHEN booking_status = 'Cancelled' THEN 1 ELSE 0 END) AS cancelled_bookings,
    ROUND(
        SUM(CASE WHEN booking_status = 'Cancelled' THEN 1 ELSE 0 END) * 100.0
        / COUNT(*), 2
    ) AS cancellation_rate
FROM reservations;

#Revenue by Room Type
SELECT
    rm.room_type,
    SUM(r.booking_value) AS total_revenue
FROM reservations r
JOIN rooms rm
    ON r.room_id = rm.room_id
WHERE r.booking_status = 'Checked Out'
GROUP BY rm.room_type
ORDER BY total_revenue DESC;

#Top 5 Guests by Booking Amount
SELECT
    g.guest_id,
    g.guest_name,
    SUM(r.booking_value) AS total_revenue
FROM reservations r
JOIN guests g
    ON r.guest_id = g.guest_id
WHERE r.booking_status = 'Checked Out'
GROUP BY g.guest_id, g.guest_name
ORDER BY total_revenue DESC
LIMIT 5;

#Bookings by Booking Channel
select
booking_channel,
count(*) as total_bookings
from reservations
group by booking_channel
order by total_bookings desc;

#Cancellation Rate by Property
select
    p.property_name,
    count(*) as total_bookings,
    sum(case when r.booking_status = 'Cancelled' then 1 else 0 end) as cancelled_bookings,
    round(
        sum(case when r.booking_status = 'Cancelled' then 1 else 0 end) * 100.0
        / count(*), 2
    ) as cancellation_rate
from reservations r
join properties p
    on r.property_id = p.property_id
group by p.property_name
order by cancellation_rate desc;

# Average Length of Stay by Room Type
select
rm.room_type,
round(avg(r.nights_booked), 2) as avg_nights
from reservations r
join rooms rm
on r.room_id = rm.room_id
where r.booking_status = 'Checked Out'
group by rm.room_type
order by avg_nights desc;

# Payment Status Distribution
select
payment_status,
count(*) as total_bookings
from reservations
group by payment_status
order by total_bookings desc;

# Top 5 Guest Cities by Booking Count
select
g.home_city,
count(r.reservation_id) as total_bookings
from reservations r
join guests g
on r.guest_id = g.guest_id
group by g.home_city
order by total_bookings desc
limit 5;

# Identify the Most Common Cancellation Reasons
select
cancellation_reason,
count(*) as total_cancellations
from reservations
where booking_status = 'Cancelled'
group by cancellation_reason
order by total_cancellations desc;

# Average Booking Lead Time by Status
select
booking_status,
round(avg(lead_time_days), 2) as avg_lead_time,
count(*) as total_bookings
from reservations
group by booking_status
order by avg_lead_time desc;

# Monthly Realized Revenue
select
year(check_in_date) as booking_year,
month(check_in_date) as booking_month,
sum(booking_value) as total_revenue
from reservations
where booking_status = 'Checked Out'
group by year(check_in_date), month(check_in_date)
order by booking_year, booking_month;

# Revenue by Guest Type
select
g.guest_type,
count(r.reservation_id) as total_bookings,
sum(r.booking_value) as total_revenue,
round(avg(r.booking_value), 2) as avg_booking_value
from reservations r
join guests g
    on r.guest_id = g.guest_id
where r.booking_status = 'Checked Out'
group by g.guest_type
order by total_revenue desc;

# Average Daily Rate (ADR) by Property
select
p.property_name,
round(avg(r.adr), 2) as avg_adr
from reservations r
join properties p
on r.property_id = p.property_id
where r.booking_status = 'Checked Out'
group by p.property_name
order by avg_adr desc;

# Weekday vs Weekend Bookings
select
    case
        when dayofweek(check_in_date) in (1, 7) then 'Weekend'
        else 'Weekday'
    end as day_type,
    count(*) as total_bookings
from reservations
group by day_type;

# Repeat Guests
select
g.guest_id,
g.guest_name,
count(r.reservation_id) as total_bookings
from guests g
join reservations r
on g.guest_id = r.guest_id
group by g.guest_id, g.guest_name
having count(r.reservation_id) > 1
order by total_bookings desc;

# Loyalty Member Revenue
select
g.loyalty_member,
count(r.reservation_id) as total_bookings,
sum(r.booking_value) as total_revenue
from reservations r
join guests g
    on r.guest_id = g.guest_id
where r.booking_status = 'Checked Out'
group by g.loyalty_member;

# Property Performance Analysis
select
    p.property_name,
    count(r.reservation_id) as total_bookings,
    sum(case when r.booking_status = 'Checked Out' then 1 else 0 end) as completed_stays,
    sum(case when r.booking_status = 'Cancelled' then 1 else 0 end) as cancellations,
    sum(case when r.booking_status = 'Checked Out' then r.booking_value else 0 end) as realized_revenue
from properties p
join reservations r
    on p.property_id = r.property_id
group by p.property_name
order by realized_revenue desc;

#  Revenue by Booking Channel
select booking_channel, sum(booking_value) as revenue
from reservations
where booking_status = 'Checked Out'
group by booking_channel;

# Bookings by Guest Type
select g.guest_type, count(*) as total_bookings
from reservations r
join guests g on r.guest_id = g.guest_id
group by g.guest_type;

# Cancellation Rate by Deposit Type
select deposit_type,
round(avg(booking_status = 'Cancelled') * 100, 2) as cancellation_rate
from reservations
group by deposit_type;

# Average Stay Duration by Property
select p.property_name, avg(r.nights_booked) as avg_nights
from reservations r
join properties p on r.property_id = p.property_id
group by p.property_name;

# Pending Payments by Property
select p.property_name, count(*) as pending_payments
from reservations r
join properties p on r.property_id = p.property_id
where r.payment_status = 'Pending'
group by p.property_name;

# Payment Status by Booking Status
select booking_status, payment_status, count(*) as total
from reservations
group by booking_status, payment_status;

# Average Room Rate by Booking Channel
select booking_channel, round(avg(adr),2) as avg_adr
from reservations
where booking_status = 'Checked Out'
group by booking_channel
order by avg_adr desc;

# Revenue by Guest City
select g.home_city, sum(r.booking_value) as revenue
from reservations r
join guests g on r.guest_id = g.guest_id
where r.booking_status = 'Checked Out'
group by g.home_city
order by revenue desc
limit 5;

# Top 5 Room Types by Booking Count
select rm.room_type, count(*) as bookings
from reservations r
join rooms rm on r.room_id = rm.room_id
group by rm.room_type
order by bookings desc
limit 5;

# Revenue by Property Type
select p.property_type, sum(r.booking_value) as revenue
from reservations r
join properties p on r.property_id = p.property_id
where r.booking_status = 'Checked Out'
group by p.property_type
order by revenue desc;

# Top 5 Guests by Number of Completed Stays
select guest_id, count(*) as completed_stays
from reservations
where booking_status = 'Checked Out'
group by guest_id
order by completed_stays desc
limit 5;

# Average Booking Value by Property
select p.property_name, round(avg(r.booking_value),2) as avg_booking_value
from reservations r
join properties p on r.property_id = p.property_id
group by p.property_name;

# Monthly Cancellation Count
select monthname(booking_date) as month, count(*) as cancellations
from reservations
where booking_status = 'Cancelled'
group by month(booking_date), monthname(booking_date)
order by month(booking_date);

# Guests with No Completed Stays
select g.guest_id, g.guest_name
from guests g
left join reservations r
on g.guest_id = r.guest_id
and r.booking_status = 'Checked Out'
where r.reservation_id is null;

# Top 5 Guests by Revenue 
with guest_revenue as (
    select guest_id, sum(booking_value) as revenue
    from reservations
    where booking_status = 'Checked Out'
    group by guest_id
)
select * from guest_revenue
order by revenue desc
limit 5;

# Guests Who Booked Above Average Booking Value
select guest_id, booking_value
from reservations
where booking_value > (select avg(booking_value) from reservations);