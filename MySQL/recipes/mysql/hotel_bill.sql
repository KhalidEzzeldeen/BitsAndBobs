# hotel_bill.sql

SET @daily_room_charge = 100.00;
SET @num_of_nights = 3;
SET @tax_percent = 8;
SET @total_room_charge = @daily_room_charge * @num_of_nights;
SET @tax = (@total_room_charge * @tax_percent) / 100;
SET @total = @total_room_charge + @tax;
SELECT @total;
