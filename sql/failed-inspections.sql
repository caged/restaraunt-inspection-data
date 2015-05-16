with
reinspections as (
  select *
  from inspections
  where
    type = 'FoodSvcFailRE'
),
failing_inspections as (
  select *
  from inspections
  where
    rest_id in (select rest_id from reinspections) and
    pkey not in (select pkey from reinspections) and
    (score between 1 and 69 or pkey = 5591) -- Fujin scored 0, so manually target it
  order by date asc
)

select * from reinspections
union select * from failing_inspections
order by name, date asc
