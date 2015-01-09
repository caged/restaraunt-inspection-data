select count(*),
  law,
  rule
from violations
where law !~ '^99|98'
group by 2,3 order by 1 desc;
