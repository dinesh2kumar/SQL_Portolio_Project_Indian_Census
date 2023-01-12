select * from Portfolio_Project_1.dbo.Data1;

select * from Portfolio_Project_1.dbo.Data2;

--- Numbers of Rows in our Dataset

select count(*) from Portfolio_Project_1..Data1;
select count(*) from Portfolio_Project_1..Data2;

--- Dataset for Maharastra and Uttarpradesh

select * from Portfolio_Project_1.dbo.Data1 where State in ('Maharashtra','Uttar Pradesh');

-- Population of India

select SUM(Population) from Portfolio_Project_1..Data2;

-- Average Function

select AVG(Growth)*100 Avg_Growth from Portfolio_Project_1..Data1;

-- Average Growth by State

select state,avg(Growth)*100 Avg_Growth from Portfolio_Project_1..Data1 group by State;


-- Average Sex Ration

select state,round(avg(Sex_Ratio),0) Avg_Sex_Growth from Portfolio_Project_1..Data1 group by State;

-- Average Literacy Rate by Descending Order

select state,round(avg(Literacy),0) Avg_Literacy from Portfolio_Project_1..Data1 group by State  order by Avg_Literacy desc;

-- Literacy rate more than 90

select state,round(avg(Literacy),0) Avg_Literacy 
from Portfolio_Project_1..Data1 
group by State
having round(avg(Literacy),0) >90
order by Avg_Literacy desc;


-- Top 3 State Showing Highest growth Ratio

select top 3 state,avg(Growth)*100 Avg_Growth from Portfolio_Project_1..Data1 
group by State
order by Avg_Growth desc;

--- Bottom 3 State for Sex Ratio


select top 3 state,round(avg(Sex_Ratio),0) Avg_Sex_Growth from Portfolio_Project_1..Data1 where Sex_Ratio is not null group by State 
order by Avg_Sex_Growth asc;

-- Removing Null Values 

delete Data1 from  Portfolio_Project_1.dbo.Data1
where Growth IS NULL;
delete Data1 from  Portfolio_Project_1.dbo.Data1
where Growth IS NULL;

--- Bottom 3 State for Sex Ratio


select Top 3 state,round(avg(Sex_Ratio),0) Avg_Sex_Growth from Portfolio_Project_1..Data1  group by State 
order by Avg_Sex_Growth asc;

--- Top and Bottom 3 State in Literacy Rate

	drop table if exists topstate
	create table topstate
	(
	state nvarchar(255),
	topstate float)

	insert into topstate 
	select state,round(avg(Literacy),0) Avg_Literacy_Growth from Portfolio_Project_1..Data1  group by State 
order by Avg_Literacy_Growth asc;

select top 3 * from  topstate order by topstate desc;

drop table if exists bottomstate
	create table bottomstate
	(
	state nvarchar(255),
	bottomstate float)

	insert into bottomstate 
	select state,round(avg(Literacy),0) Avg_Literacy_Growth from Portfolio_Project_1..Data1  group by State 
order by Avg_Literacy_Growth asc;


select top 3 * from  topstate order by topstate asc;


-- Union operator
select * from (
select top 3 * from  topstate order by topstate desc) a
union
select * from (
select top 3 * from  topstate order by topstate asc)b;


-- State Starting with letter A


select distinct State from Portfolio_Project_1.dbo.Data1 where lower(State) like 'a%' or LOWER(state) like 'b%';

--- State Starting with letter M and End with Letter A


select distinct State from Portfolio_Project_1.dbo.Data1 where lower(State) like 'M%' and LOWER(state) like '%a';

-- Joining Function

select a.District,a.State,a.Sex_Ratio,b.Population from Portfolio_Project_1..Data1 a inner join Portfolio_Project_1..Data2  b on a.District=b.District

-- Deriving Male and Female assumption on M and F are data present in Population
--

select a.District,a.State,a.Sex_Ratio,b.Population,
round(((b.Population/a.Sex_Ratio)/2)*1000,0) Male, (b.Population - round((((b.Population/a.Sex_Ratio)/2)*1000),0)) Female
 from
Portfolio_Project_1..Data1 a 
inner join
Portfolio_Project_1..Data2  b 
on
a.District=b.District order by Male desc;

--- Checking State Male and female
select d.state,sum(d.Male) Total_Male, sum(d.female) Total_Female from(
select c.District,c.State,c.Sex_Ratio,c.Population,
round(((c.Population/c.Sex_Ratio)/2)*1000,0) Male, (c.Population - round((((c.Population/c.Sex_Ratio)/2)*1000),0)) Female
 from (
select a.District,a.State,a.Sex_Ratio,b.Population from Portfolio_Project_1..Data1 a inner join Portfolio_Project_1..Data2  b on a.District=b.District	)c)d group by d.State


--- Calculating total literate people
--  Total Literate People / Population = Literacy Rate
-- Total Literate Population =  Literacy * Population
select d.State,sum(d.Literacy_Population) Total_Literate_People,sum(d.Illiteracy_Population) Total_Illiterate_People from(

select c.District, c.State, c.Literacy, c.Population, round((c.Literacy*c.Population)/100,0) Literacy_Population,c.Population-round((c.Literacy*c.Population)/100,0) Illiteracy_Population  from
(
select a.District , a.State , a.Literacy,b.Population from Portfolio_Project_1..Data1 a inner join Portfolio_Project_1..Data2 b on a.District = b.District
)c)d group by d.State;


--- Previous census Population
select sum(e.Previous_Population) Previous_Populaiton,sum(e.Current_Population) Current_Population from
(select d.State,sum(d.Previous_Year_Census) Previous_Population,sum(d.Current_Year_Census) Current_Population from
(select c.District,c.state,round(c.Population/(1+c.Growth),0) Previous_Year_Census, c.Population Current_Year_Census from
(
select a.District,a.State, a.Growth Growth, b.Population from Portfolio_Project_1..Data1 a inner join Portfolio_Project_1..Data2 b on a.District = b.District)c)d group by d.State)e

Select avg(growth) Growth from Portfolio_Project_1..Data1
select avg(a.growth)Growth,sum(b.Population) Population from Portfolio_Project_1..Data1 a inner join Portfolio_Project_1..Data2 b on a.District = b.District

--- END OF ANALYSIS----