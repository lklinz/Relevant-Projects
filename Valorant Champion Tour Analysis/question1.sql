--Q1. What changes in team members have each team made over one year? 
--Q1. How was the performance and roles of players after changes ?

--Teams Out
drop view teamOut_view
Create view teamOut_view as
Select DISTINCT p22.Team as team_22,p23.Team as team_23 from players_stats_2022 as p22
full join player_stats_2023 as p23
using (Team)
where p23.Team is null
Order by p23.Team
--Out: Leviatán,OpTic Gaming,100 Thieves,XSET,FURIA Esports,XERXIA,BOOM Esports

--Teams In
drop view teamIn_view
Create view teamIn_view as
Select DISTINCT p22.Team as team_22,p23.Team as team_23 from players_stats_2022 as p22
full join player_stats_2023 as p23
using (Team)
where p22.Team is null
Order by p23.Team;
--In: Bilibili Gaming,Evil Geniuses,FUT Esports,Giants,NRG,Natus Vincere,T1

--Changes made by team
drop view changes_in_players
create view changes_in_players as
Select p22.Player as player_22,p22.Team as team_22,p23.Player as player_23,p23.Team as team_23
from players_stats_2022 as p22
full join player_stats_2023 as p23
using(Player)
where team_23 is not null or team_22 not in (select team_22 from teamOut_view) or team_22 is NULL
Order by team_23,team_22

--Players who entered in 2023 VCT
Drop view newPlayer23_view
Create view newPlayer23_view as
select player_23,team_23,"New" as status
from changes_in_players
where team_22 is NULL and team_23 not in (select team_23 from teamIn_view)

--A.Players got completely replaced

--A.1.Teams' overall performance
With playersKDACTE as
(--compare the performance of replaced players and new players
Select c.player_22,c.team_22,p22.Country,p22.KDA as KDA_2022,"Replaced" as status,n.player_23,n.team_23,p23.Country,p23.KDA as KDA_2023,n.status from changes_in_players as c
join newPlayer23_view as n
	on n.team_23 = c.team_22
join players_stats_2022 as p22
	on c.player_22 = p22.player
join player_stats_2023 as p23
	on n.player_23 = p23.Player
where c.team_23 is Null
order by c.team_22,status)
Select *,round(average_KDA_2023 - average_KDA_2022,2) as increase
from
(Select distinct team_22,round(avg(KDA_2022),3) as average_KDA_2022
from playersKDACTE
Group by team_22) as oldKDA
full JOIN
(Select distinct team_23,round(avg(KDA_2023),3) as average_KDA_2023
from playersKDACTE
Group by team_23) as newKDA
on oldKDA.team_22 = newKDA.team_23
order by increase DESC

--A.2.roles changed between replaced and new players
--A.2.1.Overall changed
Select team,status,role,Count(Role) as number_of_roles
from
(Select n.player_23 AS players,n.team_23 as team,p23.Country,n.status,ai.Role 
from newPlayer23_view as n
join player_stats_2023_1NF_view as p23
	on n.player_23 = p23.Player
join Agent_Id as ai
	on p23.Agent = ai.Agents
UNION 
Select c.player_22,c.team_22,p22.Country,"Replaced" as status,ai.Role
from changes_in_players as c
join players_stats_2022_1NF_view as p22
	on c.player_22 = p22.player
join Agent_Id as ai
	on p22.Agent = ai.Agents
where c.team_23 is Null
order by team,status)
--where team = "LOUD"
group by team,status,role
order by team,number_of_roles Desc

--A.2.2.Teams actually saw changes in players' roles
Select DISTINCT * from
(Select n.player_23,n.team_23 as team,p23.Country,n.status,ai.Role 
from newPlayer23_view as n
join player_stats_2023_1NF_view as p23
	on n.player_23 = p23.Player
join Agent_Id as ai
	on p23.Agent = ai.Agents)
Full join  
(Select c.player_22,c.team_22 as team,p22.Country,"Replaced" as status,ai.Role
from changes_in_players as c
join players_stats_2022_1NF_view as p22
	on c.player_22 = p22.player
join Agent_Id as ai
	on p22.Agent = ai.Agents
where c.team_23 is Null)
Using(team,Role)
where player_22 is null or player_23 is null
order by team

--B.Players moved to other teams

--B.1.The overall performance of the players in 2 tournaments
With KDADifferenceCTE as
(--compare their performance between two tournament
Select DISTINCT c.player_22 as players,p22.Country,c.team_22 as old_team ,p22.KDA as KDA_2022,c.team_23 as new_team,p23.KDA as KDA_2023,p23.KDA-p22.KDA as KDA_difference
from changes_in_players as c
join players_stats_2022_1NF_view as p22
	on c.player_22 = p22.player
join player_stats_2023_1NF_view as p23
	on c.player_23 = p23.player
where team_22 != team_23
order by KDA_difference desc)
Select players,old_team,new_team,max(KDA_difference) as KDA_difference
from KDADifferenceCTE
UNION
Select players,old_team,new_team,min(KDA_difference) as KDA_difference
from KDADifferenceCTE

--B.2.compare role changes
--B.2.1.Overall Role changes
Select distinct Player,Country,Team,Status,Roles
from
(Select c.player_22 as Player,p22.Country,c.team_22 as Team,"Old Team" as Status,p22.Agent as Agents,Role as Roles
from changes_in_players as c
join players_stats_2022_1NF_view as p22
	on c.player_22 = p22.player
join Agent_Id as ai
	on p22.Agent = ai.Agents
where team_22 != team_23 
Union
Select c.player_23,p23.Country,c.team_23,"New Team" ,p23.Agent, Role
from changes_in_players as c
join player_stats_2023_1NF_view as p23
	on c.player_23 = p23.player
join Agent_Id as ai
	on p23.Agent = ai.Agents
where team_22 != team_23 )
order by Player,Status

--B.2.2.Players actual changed their role
Select distinct *
from 
(Select c.player_22 as Player,p22.Country,c.team_22 as Team,"Old Team" as Status,p22.Agent as Agents,Role
from changes_in_players as c
join players_stats_2022_1NF_view as p22
	on c.player_22 = p22.player
join Agent_Id as ai
	on p22.Agent = ai.Agents
where team_22 != team_23) as role2022
full join
(Select c.player_23 as Player,c.team_23,"New Team" ,p23.Agent, Role
from changes_in_players as c
join player_stats_2023_1NF_view as p23
	on c.player_23 = p23.player
join Agent_Id as ai
	on p23.Agent = ai.Agents
where team_22 != team_23) as role2023
using(player,role)
where Agent is Null or Agents is null
order by Team,Player,Status
