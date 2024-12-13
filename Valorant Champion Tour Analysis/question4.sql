--Q4. Who is the best player in Valorant and CSGO based on their performance for each country?

--CSGo
Drop view csgoKDA_view
Create view csgoKDA_view as
Select name,nationality,team, max(average_KDA) as csgo_max_average_KDA
from
(Select name,nationality,team,AVG(rating) as average_KDA
from major_stats
group by name
order by nationality,average_KDA desc
)
group by nationality

--CSGo vs VCT 2022
Select *,round(vct_max_KDA_2022 - csgo_max_average_KDA,2) as KDA_difference_between_VCT_CSGo from
(Select Player,Country,Team,max(KDA) as vct_max_KDA_2022
from players_stats_2022
group by Country
order by vct_max_KDA_2022 Desc) as vct22
join csgoKDA_view as csg
on csg.nationality = vct22.Country

order by KDA_difference_between_VCT_CSGo;

--CSGgo vs VCT 2023
Select *, round(vct_max_KDA_2023 - csgo_max_average_KDA,2) as KDA_difference_between_VCT_CSGo from
(Select Player,Country,Team,max(KDA) as vct_max_KDA_2023
from player_stats_2023
group by Country
order by vct_max_KDA_2023 Desc) as vct23
join csgoKDA_view as csg
on csg.nationality = vct23.Country
order by KDA_difference_between_VCT_CSGo;

--VCT 2022 vs VCT 2023
Select vct22.Country,vct22.Player as player_2022,vct22.Team as team_2022,vct22.max_KDA as KDA_2022, vct23.Player as player_2023,vct23.Team as team_2023,vct23.max_KDA as KDA_2023,
round(vct23.max_KDA - vct22.max_KDA,2) as KDA_difference_between_VCT23_VCT22 from
(Select Player,Country,Team,max(KDA) as max_KDA
from players_stats_2022
group by Country
order by max_KDA Desc) as vct22
join 
(Select Player,Country,Team,max(KDA) as max_KDA
from player_stats_2023
group by Country
order by max_KDA Desc) as vct23
using(Country)
order by KDA_difference_between_VCT23_VCT22;

