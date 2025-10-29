-- Keep a log of any SQL queries you execute as you solve the mystery.
-- Getting to know database
.schema

-- Getting to know more about crime_scene report
SELECT id, description
FROM crime_scene_reports
WHERE year = 2024
AND month = 7
AND day = 28
AND street = 'Humphrey Street';
-- THREE interview took place at same day, moreover exact time was 10:15 am of crime. Each interview mentioned something about bakery.

-- Let's take look at interviews first
SELECT id, name, transcript
FROM interviews
WHERE year = 2024
AND month = 7
AND day = 28
AND transcript LIKE '%bakery%';
-- Ruth (161) says he saw theft get into car and drove away from bakery parking lot within 10 min
-- Eugene (162) says that she recognized the theif, he was same person that she saw withdrawing money from ATM on LEGGETT street that morning
-- Raymond (163) overheard theif on phone, theif called, to a helper for less than a minute who was plannig to buy earliest flight ticket out of FIFTYVILLE tommorow, the purchase would be made by helper

-- Lets look at bakery's security log for license plate of car that left after 10: 15
SELECT id, hour, minute, activity, license_plate
FROM bakery_security_logs
WHERE year = 2024
AND month = 7
AND day = 28
AND hour = 10
AND minute < 26
AND activity = 'exit';
-- Potential car no.
-- 5P2BI95
-- 94KL13X
-- 6P58WS2
-- 4328GD8
-- G412CB7
-- L93JTIZ
-- 322W7JE
-- 0NTHK55

-- FINDING activities of these car no.s, if they entered after 9 then maybe they posses some threat not before
SELECT *
FROM people
WHERE license_plate
IN ('6P58WS2', '0NTHK55', '322W7JE', 'L93JTIZ', '4328GD8', '94KL13X', '5P2BI95');
--+--------+---------+----------------+-----------------+---------------+
--|   id   |  name   |  phone_number  | passport_number | license_plate |
--+--------+---------+----------------+-----------------+---------------+
--| 221103 | Vanessa | (725) 555-4692 | 2963008352      | 5P2BI95       |
--| 243696 | Barry   | (301) 555-4174 | 7526138472      | 6P58WS2       |
--| 396669 | Iman    | (829) 555-5269 | 7049073643      | L93JTIZ       |
--| 467400 | Luca    | (389) 555-5198 | 8496433585      | 4328GD8       |
--| 514354 | Diana   | (770) 555-1861 | 3592750733      | 322W7JE       |
--| 560886 | Kelsey  | (499) 555-9472 | 8294398571      | 0NTHK55       |
--| 686048 | Bruce   | (367) 555-5533 | 5773159633      | 94KL13X       |
--+--------+---------+----------------+-----------------+---------------+

-- Now looking for the call the call in question by interviewe(163)
SELECT id, caller, receiver, duration
FROM phone_calls
WHERE year = 2024
AND month = 7
AND day = 28
AND duration < 61;
--+--------+---------+----------------+-----------------+---------------+
--|   id   |  name   |  phone_number  | passport_number | license_plate |
--+--------+---------+----------------+-----------------+---------------+
--| 221103 | Vanessa | (725) 555-4692 | 2963008352      | 5P2BI95       | Not on call
--| 243696 | Barry   | (301) 555-4174 | 7526138472      | 6P58WS2       | Not on call
--| 396669 | Iman    | (829) 555-5269 | 7049073643      | L93JTIZ       | Not on all
--| 467400 | Luca    | (389) 555-5198 | 8496433585      | 4328GD8       | On call as receiver with (609) 555-5876
--| 514354 | Diana   | (770) 555-1861 | 3592750733      | 322W7JE       | On call as caller with (725) 555-3243
--| 560886 | Kelsey  | (499) 555-9472 | 8294398571      | 0NTHK55       | On call as caller with (892) 555-8872
--| 686048 | Bruce   | (367) 555-5533 | 5773159633      | 94KL13X       | On call as caller with (375) 555-8161
--+--------+---------+----------------+-----------------+---------------+

-- FINDING out the people with whom they were at call with
SELECT *
FROM people
WHERE phone_number
IN ('(996) 555-8899', '(676) 555-6554', '(725) 555-3243', '(892) 555-8872', '(375) 555-8161');
-- People in question
--+--------+--------+----------------+-----------------+---------------+
--|   id   |  name  |  phone_number  | passport_number | license_plate |
--+--------+--------+----------------+-----------------+---------------+
--| 250277 | James  | (676) 555-6554 | 2438825627      | Q13SVG6       |
--| 251693 | Larry  | (892) 555-8872 | 2312901747      | O268ZZ0       |
--| 567218 | Jack   | (996) 555-8899 | 9029462229      | 52R0Y8U       |
--| 847116 | Philip | (725) 555-3243 | 3391710505      | GW362R6       |
--| 864400 | Robin  | (375) 555-8161 | NULL            | 4V16VO0       |
--+--------+--------+----------------+-----------------+---------------+

-- lets see the transaction history as described and look for similarities, caller has to be their, so preferably account is of caller but can be of helper either
SELECT name
FROM people
WHERE id
IN (
    SELECT person_id
    FROM bank_accounts
    WHERE account_number
    IN (
        SELECT account_number
        FROM atm_transactions
        WHERE year = 2024
        AND month = 7
        AND day = 28
        AND atm_location = 'Leggett Street'
        AND transaction_type = 'withdraw'
    )
);
-- Diana or Bruce, one of them is thief.

-- Search for first flight out of city on 29th
SELECT id
FROM flights
WHERE origin_airport_id
IN (
    SELECT id
    FROM airports
    WHERE city = 'Fiftyville'
)
AND year = 2024
AND month = 7
AND day = 29
ORDER BY hour, minute
LIMIT 1;

-- See if Diana, Bruce are in this flight
SELECT passport_number
FROM passengers
WHERE passport_number
IN ('3592750733', '5773159633')
AND flight_id
IN (
    SELECT id
    FROM flights
    WHERE origin_airport_id
    IN (
        SELECT id
        FROM airports
        WHERE city = 'Fiftyville'
    )
    AND year = 2024
    AND month = 7
    AND day = 29
    ORDER BY hour, minute
    LIMIT 1
);
-- Bruce is in the flight
-- Bruce is theif so Robin is accomplice

-- For city
SELECT city
FROM airports
WHERE id IN (
    SELECT destination_airport_id
    FROM flights
    WHERE id IN (
                SELECT id
                FROM flights
                WHERE origin_airport_id
                IN (
                    SELECT id
                    FROM airports
                    WHERE city = 'Fiftyville'
                )
                AND year = 2024
                AND month = 7
                AND day = 29
                ORDER BY hour, minute
                LIMIT 1
            )
    );
-- New york city
