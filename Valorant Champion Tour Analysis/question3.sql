--Q3. Who were the top-performing players in each role (Duelist, Initiator, Sentinel, Controller) based on statistics KDA? 

--Best player in each Role by using KDA in 2022
With topPlayerByRoleCTE as
(Select Player,Role,Max(KDA)as Highest_KDA
from players_stats_2022_1NF_view as ps22
JOIN Agent_Id as ai
on ps22.Agent=ai.Agents
Group by Role
Order by Role,Highest_KDA DESC)

Select tp.Role,tp.Player,tp.Highest_KDA,sct.Player,sct.Second_Highest_KDA
from 
(Select Player,Role,Max(KDA)as Second_Highest_KDA
from players_stats_2022_1NF_view as ps22
JOIN Agent_Id as ai
on ps22.Agent=ai.Agents
Where Player not in (Select Player from topPlayerByRoleCTE)
Group by Role
Order by Role,Second_Highest_KDA DESC) as sct
join topPlayerByRoleCTE as tp
using(Role)

--Best player in each Role by using KDA in 2023
With topPlayerByRoleCTE as
(Select Player,Role,Max(KDA)as Highest_KDA
from player_stats_2023_1NF_view as ps23
JOIN Agent_Id as ai
on ps23.Agent=ai.Agents
Group by Role
Order by Role,Highest_KDA DESC)

Select tp.Role,tp.Player,tp.Highest_KDA,sct.Player,sct.Second_Highest_KDA
from 
(Select Player,Role,Max(KDA)as Second_Highest_KDA
from player_stats_2023_1NF_view as ps23
JOIN Agent_Id as ai
on ps23.Agent=ai.Agents
Where Player not in (Select Player from topPlayerByRoleCTE)
Group by Role
Order by Role,Second_Highest_KDA DESC) as sct
join topPlayerByRoleCTE as tp
using(Role)