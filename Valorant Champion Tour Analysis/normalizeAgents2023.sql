
UPDATE player_stats_2023 as p
Set PlayerID=i.ID
from all_player_ids as i
Where p. player=i.Player;

Create table player_stats_2023_1NF(
Player text,
ID INT,
Agent text);

Insert into player_stats_2023_1NF
VALUES
("Derke",3,"Raze"),("Derke",3,"Jett"),
("ZmjjKK",4,"Jett"),("ZmjjKK",4,"Raze"),("ZmjjKK",4,"Chamber"),
("Laz",6,"Chamber"),("Laz",6, "Viper"),
("Alfajer",7,"Killjoy"),("Alfajer",7,"Cypher"),("Alfajer",7,"Chamber"),
("Keznit",8,"Raze"),("Keznit",8,"Jett"),
("Jinggg",9,"Raze"),("Jinggg",9,"Phoenix"),
("Ardiis",10,"Jett"),("Ardiis",10,"Chamber"),("Ardiis",10,"Killjoy"),
("BuZz",11,"Raze"),("BuZz",11,"Jett"),
("Zyppan",13,"Raze"),("Zyppan",13,"KAY/O"),("Zyppan",13,"Breach"),
("Dep",16,"Neon"),("Dep",16,"Killjoy"),
("Smoggy",18,"Breach"),("Smoggy",18,"Jett"),("Smoggy",18,"KAY/O"),
("Less",19,"Killjoy"),("Less",19,"Viper"),
("Jamppi",21,"Jett"),("Jamppi",21,"Chamber"),("Jamppi",21,"Breach"),
("F0rsakeN",22,"Killjoy"),("F0rsakeN",22,"Harbor"),("F0rsakeN",22,"Skye"),
("Aspas",23,"Raze"),("Aspas",23,"Jett"),
("NagZ",24,"Viper"),	
("SUYGETSU",26,"Viper"),("SUYGETSU",26,"Killjoy"),("SUYGETSU",26,"Cypher"),
("MaKo",27,"Omen"),("MaKo",27,"Brimstone"),
("Victor",28,"Raze"),("Victor",28,"Killjoy"),("Victor",28,"KAY/O"),
("Saadhak",32,"Breach"),("Saadhak",32,"Viper"),("Saadhak",32,"KAY/O"),
("Crashies",35,"Skye"),("Crashies",35,"Sova"),
("Shao",37,"Skye"),("Shao",37,"Fade"),("Shao",37,"Sova"),
("D4v41",39,"Skye"),("D4v41",39,"Viper"),("D4v41",39,"Killjoy"),
("Rb",41,"Killjoy"),("Rb",41,"Yoru"),
("TENNN",43,"Raze"),
("SugarZ3ro",45,"Brimstone"),("SugarZ3ro",45,"Astra"),
("Melser",47,"Harbor"),("Melser",47,"Astra"),("Melser",47,"Omen"),
("Boaster",52,"Astra"),("Boaster",52,"Omen"),("Boaster",52,"Brimstone"),
("CHICHOO",57,"Viper"),("CHICHOO",57,"Killjoy"),("CHICHOO",57,"Cypher"),
("Haodong",58,"Omen"),("Haodong",58,"Brimstone"),("Haodong",58,"Astra"),
("Zest",60,"Viper"),("Zest",60,"Sova"),
("Stax",62,"Skye"),	("Stax",62,"Fade"),("Stax",62,"Breach"),
("Soulcas",66,"Skye"),("Soulcas",66,"Astra"),
("Nobody",70,"Skye"),("Nobody",70,"Sova"),("Nobody",70,"Fade"),
("FNS",72,"Viper"),("FNS",72,"Killjoy"),
("Mindfreak",73,"Astra"),("Mindfreak",73,"Viper"),("Mindfreak",73,"Brimstone"),
("Klaus",75,"Skye"),
("ANGE1",76,"Brimstone"),("ANGE1",76,"Omen"),("ANGE1",76, "Sova"),
("Crow",81,"Skye"),("Crow",81,"Breach"),
("Whz",82,"Raze"),("Whz",82,"Jett"),
("Demon1",83,"Jett"),("Demon1",83,"Astra"),("Demon1",83,"Chamber"),
("AAAAY",84,"Skye"),("AAAAY",84,"Gekko"),
("Sayaplayer",85,"Jett"),("Sayaplayer",85,"Raze"),
("Jawgemo",86,"Raze"),("Jawgemo",86,"Omen"),("Jawgemo",86,"Astra"),
("Fit1nho",87,"Raze"),("Fit1nho",87,"Jett"),
("Sayf",88,"Raze"),("Sayf",88,"Breach"),("Sayf",88,"Jett"),
("CNed",89,"Jett"),("CNed",89,"Neon"),("CNed",89,"Sage"),
("Cauanzin",90,"Skye"),("Cauanzin",90,"Fade"),("Cauanzin",90,"Sova"),
("Cloud",91,"Skye"),("Cloud",91,"Sova"),
("Munchkin",92,"Killjoy"),("Munchkin",92,"Skye"),("Munchkin",92,"Breach"),
("NAts",93,"Viper"),("NAts",93,"Killjoy"),
("Something",94,"Jett"),("Something",94,"Reyna"),("Something",94,"Breach"),
("MrFaliN",95,"Killjoy"),("MrFaliN",95,"Breach"),("MrFaliN",95,"Fade"),
("Lysoar",96,"Killjoy"),("Lysoar",96,"Viper"),
("Yosemite",97,"Viper"),("Yosemite",97,"Killjoy"),
("Yuicaw",98,"Jett"),("Yuicaw",98,"Raze"),
("Leo",99,"Sova"),("Leo",99,"Skye"),("Leo",99,"Fade"),
("Hoody",100,"Omen"),("Hoody",100,"Viper"),("Hoody",100,"Skye"),
("ATA KAPTAN",101,"Brimstone"),("ATA KAPTAN",101,"Omen"),
("C0M",102,"Sova"),("C0M",102,"Viper"),
("Ethan",103,"Skye"),("Ethan",103,"KAY/O"),("Ethan",103,"Yoru"),
("QRaxs",104,"KAY/O"),("QRaxs",104,"Gekko"),
("Mojj",105,"Viper"),("Mojj",105,"Killjoy"),
("Qw1",106,"Jett"),("Qw1",106,"Raze"),
("Knight",107,"Cypher"),("Knight",107,"Omen"),("Knight",107,"Breach"),
("Biank",108,"Sova"),("Biank",108,"Skye"),("Biank",108,"Fade"),
("Boostio",109,"Killjoy"),("Boostio",109,"Brimstone"),("Boostio",109,"Chamber"),
("Xeta",110,"Viper"),("Xeta",110,"Sova"),
("Nukkye",111,"Cypher"),("Nukkye",111,"Killjoy"),
("Daveeys",112,"Killjoy"),("Daveeys",112,"Chamber"),
("Ban",113,"Harbor"),("Ban",113, "Omen"),
("Rhyme",114,"Breach"),("Rhyme",114,"Omen"),("Rhyme",114,"Brimstone"),
("S0m",115,"Brimstone"),("S0m",115, "Omen"),("S0m",115,"Harbor"),
("Chronicle",116,"Breach"),("Chronicle",116,"Viper"),("Chronicle",116,"KAY/O"),
("Tuyz",117,"Omen"),("Tuyz",117,"Astra"),("Tuyz",117,"Harbor"),
("Redgar",118,"Astra"),("Redgar",118,"Sova"),("Redgar",118,"Omen"),
("BerLIN",119,"Omen"),("BerLIN",119,"Harbor"),("BerLIN",119,"Raze"),
("Carpe",120,"Gekko"),("Carpe",120,"Skye"),("Carpe",120,"Killjoy"),
("Rin",121,"Omen"),	("Rin",121,"Killjoy"),("Rin",121,"Brimstone"),
("TZH",122,"Astra"),("TZH",122,"Viper"),("TZH",122,"Harbor")

Update player_stats_2023_1NF
Set Agent = lower(Agent)

Drop view player_stats_2023_1NF_view
Create VIEW player_stats_2023_1NF_view as
Select p2.player,p2.Country,p2.team,p1nf_2.Agent,p2.Maps,p2.K,p2.D,p2.A,p2.KD,p2.KDA,p2."ACS/Map",p2."D/Map",p2."A/Map"
from player_stats_2023 as p2
join player_stats_2023_1NF as p1nf_2
on PlayerID=ID