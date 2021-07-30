-- Question 1
select convert(varchar, datepart(mm, u.created_at)) + '-' + convert(varchar, datepart(yyyy, u.created_at)) as created_month_year, -- create a column with the month and year the patient joined
count(distinct u2.user_id) as total_users, -- create column for count of unique users per month
count(distinct u.user_id) as count_users_completed_exercise_first_month, -- create column for count of unique users that completed an exercise in their first month
convert(float, count(distinct u.user_id)) / convert(float, count(distinct u2.user_id)) * 100.0 as pct_users_completed_exercise_first_month -- create column for percentage of users that did an exercise in their first month

from exercises e
inner join users u
on e.user_id = u.user_id -- join exercises (e) and users (u) on user_id

inner join users u2
on datepart(mm, u2.created_at) = datepart(mm, u.created_at) and
   datepart(yyyy, u2.created_at) = datepart(yyyy, u.created_at) -- join exercises (e) and users (u2) on month and year created
  
where datepart(mm, u.created_at) = datepart(mm, exercise_completion_date) and
datepart(yyyy, u.created_at) = datepart(yyyy, exercise_completion_date) -- where patients completed an exercise in their first month
group by convert(varchar, datepart(mm, u.created_at)) + '-' + convert(varchar, datepart(yyyy, u.created_at)) -- group by month and year user joined

----------------------------------------------------

-- Question 2

select ex.exercise_count, count(*) as exercise_amount_frequency -- gets frequency of users that performed x amount of exercises
from
(
select count(e.exercise_id) as exercise_count  -- create exercise_count column
from users u 
left join exercises e -- includes 0 exercises done 
on e.user_id = u.user_id -- join on user_id
group by u.user_id -- group by user_id
) ex
group by ex.exercise_count -- groups by number of exercises performed 

----------------------------------------------------

-- Question 3

select top 5 -- get 5 highest mean phq9 scores by organization
pr.organization_name, -- show name
pr.organization_id, -- show id
convert(float, avg(ph.score)) as mean_organization_score -- show mean phq9 score of organization

from Providers pr 
inner join Phq9 ph
on ph.provider_id = pr.provider_id -- join Providers and Phq9 on provider_id

group by pr.organization_name, pr.organization_id -- group by name and id of organization
order by mean_organization_score desc -- order in descending order of mean organization score