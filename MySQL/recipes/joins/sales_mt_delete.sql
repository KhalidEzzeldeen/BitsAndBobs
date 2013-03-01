# sales_mt_delete.sql

# This script illustrates how to use LEFT JOIN to identify mismatches
# between the parent (sales_region) and child (sales_volume) tables.
# These records represent unattached records in each table.  Then it
# uses similar DELETE statements to remove the unattached records.

# Note: Before running this script, you should make sure that the tables
# are loaded with their original rows.  Do this by running the script in
# the tables/sales.sql file.

# Show original tables

SELECT * FROM sales_region;
SELECT * FROM sales_volume;

# Identify those records that have no match

#@ _IDENTIFY_CHILDLESS_PARENTS_
SELECT sales_region.region_id AS 'unmatched region row IDs'
FROM sales_region LEFT JOIN sales_volume
  ON sales_region.region_id = sales_volume.region_id
WHERE sales_volume.region_id IS NULL;
#@ _IDENTIFY_CHILDLESS_PARENTS_

#@ _IDENTIFY_PARENTLESS_CHILDREN_
SELECT sales_volume.region_id AS 'unmatched volume row IDs'
FROM sales_volume LEFT JOIN sales_region
  ON sales_volume.region_id = sales_region.region_id
WHERE sales_region.region_id IS NULL;
#@ _IDENTIFY_PARENTLESS_CHILDREN_

# Delete those records that have no match

#@ _DELETE_CHILDLESS_PARENTS_
DELETE sales_region
FROM sales_region LEFT JOIN sales_volume
  ON sales_region.region_id = sales_volume.region_id
WHERE sales_volume.region_id IS NULL;
#@ _DELETE_CHILDLESS_PARENTS_

#@ _DELETE_PARENTLESS_CHILDREN_
DELETE sales_volume
FROM sales_volume LEFT JOIN sales_region
  ON sales_volume.region_id = sales_region.region_id
WHERE sales_region.region_id IS NULL;
#@ _DELETE_PARENTLESS_CHILDREN_

# Show resulting tables

SELECT * FROM sales_region;
SELECT * FROM sales_volume;

