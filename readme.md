A poorly documented collection of tools and scripts to export Portland, OR. restaurant inspection data from the [Civic Apps API](http://api.civicapps.org/#restaurant-inspections), import it into postgres, and export relevant CSV data.

**Requirements**
* [csv2psql](https://github.com/drh-stanford/csv2psql)
* [jq](http://stedolan.github.io/jq/)
* [postgres](http://www.postgresql.org/)


**General usage**

``` bash
script/sync       # fetches all inspections for 2014 from the civic apps api
script/tocsv      # converts raw inspection and violation data to csv files
script/psqlimport # imports data to postgres database named 'portland'
script/process    # performs a variety of task on the raw data (overlappoing point jittering, postgis Geom from lat/lon, etc.) and exports relevant csv files to the out/ directory
```
