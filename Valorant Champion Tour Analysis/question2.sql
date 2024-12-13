--Q2. What was the most effective tactic (meta) for each of the two tournaments (map picking, agents’ pool, etc)?

--1 Percentage of map pick
SELECT Map as map_2022, round((1.0*total/(Select sum(Total) from map_pick_stats_2022 ))*100,2) as map_pick_percentage_2022, p23.Map as map_2023, p23.map_pick_percentage_2023
from map_pick_stats_2022
Full jOIN 
(SELECT Map, round((1.0*total/(Select sum(Total) from map_pick_stats_2023 ))*100,2) as map_pick_percentage_2023 
from map_pick_stats_2023
Order by  map_pick_percentage_2023  DESC) as p23
USING(Map)
Order by  map_pick_percentage_2022  DESC

--2 percentage of map ban
SELECT Map as map_2022, round((1.0*total/(Select sum(Total) from map_banned_2022 ))*100,2) as map_ban_percentage_2022, b23.Map as map_2023, b23.map_ban_percentage_2023
from map_banned_2022
Full jOIN 
(SELECT Map, round((1.0*total/(Select sum(Total) from map_pick_stats_2023 ))*100,2) as map_ban_percentage_2023 
from map_banned_2023
Order by  map_ban_percentage_2023  DESC) as b23
USING(Map)
--where map_2022 != "-"
Order by  map_ban_percentage_2022  DESC

--3 agents' pool different
drop table Agent_Id
Create Table Agent_Id(
ID Int,
Agents Text,
Role Text)

Insert into Agent_Id
VALUES
(1, "brimstone", "Controller"),
(2, "viper", "Controller"),
(3, "omen", "Controller"),
(4, "killjoy", "Sentinel"),
(5, "cypher", "Sentinel"),
(6, "sova", "Initiator"),
(7, "sage", "Sentinel"),
(8, "phoenix", "Duelist"),
(9, "jett", "Duelist"),
(10, "reyna", "Duelist"),
(11, "raze", "Duelist"),
(12, "breach", "Initiator"),
(13, "skye", "Initiator"),
(14, "yoru", "Duelist"),
(15, "astra", "Controller"),
(16, "kay/o", "Initiator"),
(17, "chamber", "Sentinel"),
(18, "neon", "Duelist"),
(19, "fade", "Initiator"),
(20, "harbor", "Controller"),
(21, "gekko", "Initiator"),
(22, "deadlock", "Sentinel"),
(23, "iso", "Duelist"),
(24, "vyse", "Controller"),
(25, "clove", "Initiator")

--Agent percentage pick of 2022
Drop view agents_perccetage_pick_2022_view
Create view agents_perccetage_pick_2022_view as
With Agent_pick_2022 as (
Select o2.Map,o2.Agents,o1.Role,Count(o2.Agents) as Usage_count
from overview_2022 as o2
JOIN Agent_Id  as o1 
on o1.Agents=o2.Agents
Where Side="both" and Map!="All Maps" and o2.Agents Not like "%,%"
Group by o2.Map,o2.Agents
)
Select Agent_pick_2022.*, round((1.0* Usage_count/(select sum(Usage_count) from Agent_pick_2022 Group by Role ,Map)*100),2) as percentage_pick
from Agent_Id
join Agent_pick_2022 USING(Agents)
Order by Map,Role,percentage_pick Desc

--Agent percentage pick 2023
Drop view agents_perccetage_pick_2023_view
Create view agents_perccetage_pick_2023_view as
With Agent_pick_2023 as (
Select o3.Map,o3.Agents,o1.Role,Count(o3.Agents) as Usage_count
from overview_2023 as o3
JOIN Agent_Id  as o1 
on o1.Agents=o3.Agents
Where Side="both" and Map!="All Maps" and o3.Agents Not like "%,%"
Group by o3.Map,o3.Agents
)
Select Agent_pick_2023.*, round((1.0* Usage_count/(select sum(Usage_count) from Agent_pick_2023 Group by Role ,Map)*100),2) as percentage_pick
from Agent_Id
join Agent_pick_2023 USING(Agents)
Order by Map,Role,percentage_pick Desc

--Comparison between two VCR
Select * from
(Select Map as Map_2022,Agents as Agents_2022,Role,max(percentage_pick) as Percent_pick_by_role_2022
from agents_perccetage_pick_2022_view
group by Map_2022,Role) as pp22
join 
(Select Map as Map_2023,Agents as Agent_2023,Role,max(percentage_pick) as Percent_pick_by_role_2023
from agents_perccetage_pick_2023_view
group by Map_2023,Role) as pp23
on pp22.Map_2022 = pp23.Map_2023 and pp22.Role = pp23.Role

