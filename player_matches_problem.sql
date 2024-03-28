# Question:
-- Write a SQL query to find the winner in each group
/* winner in each group is the player who scored the max. total poinnts within the group, in case of tie, 
the lowest player_id wins */

-- script to create the table 

create table players
(player_id int,
group_id int);

insert into players values (15,1);
insert into players values (25,1);
insert into players values (30,1);
insert into players values (45,1);
insert into players values (10,2);
insert into players values (35,2);
insert into players values (50,2);
insert into players values (20,3);
insert into players values (40,3);

create table matches
(
match_id int,
first_player int,
second_player int,
first_score int,
second_score int);

insert into matches values (1,15,45,3,0);
insert into matches values (2,30,25,1,2);
insert into matches values (3,30,15,2,0);
insert into matches values (4,40,20,5,2);
insert into matches values (5,35,50,1,1);


-- select the created tables (matches & players) 
SELECT * FROM `leetcode_sql-ab`.matches;
SELECT * FROM `leetcode_sql-ab`.players;


-- extracting player_id and score from matches table and summing it up..

with cte as(
	select player, sum(score) as total_score
	from (
		select first_player as player, first_score as score from matches
		UNION ALL
		select second_player as player, second_score as score from matches ) sq
	group by player order by player
),

        -- inner joining above created table with the players table 
           
    pGroup as( 
	select *
	from cte c
	join players p ON c.player = p.player_id ),

		-- filtering players based on max score, and lower player_id (in case of a tie).. 

    top_players as(
    select *, 
    row_number() over(partition by group_id order by total_score desc, player asc) as rn from pGroup)
    
select player, total_score, group_id
from top_players where rn = 1


