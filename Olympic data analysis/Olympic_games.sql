--select top (100) * 
--from [olympic_games].[dbo].[athletes_event_results]

select [ID] 
,[Name] as 'Competitor Name'
, CASE WHEN SEX='M' THEN 'Male' ELSE 'Female' END AS Sex
,[Age]
,CASE WHEN[Age]<18 THEN 'Under 18'
      WHEN [Age] between 18 and 25 then '18-25'
	  WHEN [Age] between 25 and 30 then '25-30'
	  WHEN [Age] >30 then 'Over 30'
END AS [Age Grouping]
, [Height]
,[Weight]
,[NOC] as 'Nation Code'
,LEFT(Games, CHARINDEX(' ',Games)-1) AS 'Year'
,RIGHT(Games, CHARINDEX(' ',REVERSE(Games))-1) AS 'Season'
,[Games]
,[Sport]
,[Event]
,CASE WHEN Medal='NA' THEN 'Not Registered' ELSE Medal END AS Medal
from [olympic_games].[dbo].[athletes_event_results]
WHERE RIGHT(Games, CHARINDEX(' ',REVERSE(Games))-1) ='Summer'