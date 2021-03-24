echo `date`
zgrep 'resource-in' 22* > resource-in-temp.log
grep -E 'v1/companies-office/financial-service-providers-register|/v1/radio-spectrum-management/DownloadLicences|v1/trading-standards/mvtr|/v3/insolvency/SearchService|/v3/iponz/trademark-information|/v3/nzbn/entities/|/v4/nzbn/entities/|/v1/iponz/patent-information|/v3/iponz/TradeMark|/v1/iponz/Patent' resource-in-temp.log > resource-in.log
rm -rf resource-in-temp.log
zgrep 'resource-out' 22* > resource-out.log
grep -v ') = NaN' resource-out.log > resource-out-without-nan.log
rm -rf resource-out.log
awk '{print $11" "$4" "$14}' resource-in.log > resource-in-filter.log
rm -rf resource-in.log
awk '{print $11" "$NF}' resource-out-without-nan.log > resource-out-filter.log
rm -rf resource-out-without-nan.log
sed -i "s/urn:uuid://g" resource-in-filter.log
sed -i "s/\[//g" resource-in-filter.log
sed -i "s/urn:uuid://g" resource-out-filter.log
sed -i "s/,//g" resource-in-filter.log
sed -i "s/,//g" resource-out-filter.log
sort -k 1 resource-in-filter.log > resource-in-filter-sorted.log
rm -rf resource-in-filter.log
sort -k 1 resource-out-filter.log > resource-out-filter-sorted.log
rm -rf resource-out-filter.log
join -1 1 -2 1 -o 1.1 1.2 1.3 2.2 resource-in-filter-sorted.log resource-out-filter-sorted.log > joined_filter.csv
rm -rf resource-in-filter-sorted.log resource-out-filter-sorted.log
awk '{ if ($3 ~ /^\/v3\/nzbn/) $3="nzbnv3_entities_with_slash"; print}'  joined_filter.csv > joined_filter_1.csv
rm -rf joined_filter.csv
awk '{ if ($3 ~ /^\/v4\/nzbn/) $3="nzbnv4_entities_with_slash"; print}'  joined_filter_1.csv > joined_filter_2.csv
rm -rf joined_filter_1.csv
awk '{ if ($3 ~ /^\/v1\/iponz\/Patent/) $3="patent"; print}'  joined_filter_2.csv > joined_filter_3.csv
rm -rf joined_filter_2.csv
awk '{ if ($3 ~ /^\/v1\/iponz\/patent-information/) $3="patent-information"; print}'  joined_filter_3.csv > joined_filter_4.csv
rm -rf joined_filter_3.csv
awk '{ if ($3 ~ /^\/v3\/iponz\/TradeMark/) $3="tradeMark"; print}'  joined_filter_4.csv > joined_filter_5.csv
rm -rf joined_filter_4.csv
awk '{ if ($3 ~ /^\/v3\/insolvency\/SearchService/) $3="SearchService"; print}'  joined_filter_5.csv > joined_filter_6.csv
rm -rf joined_filter_5.csv
awk '{ if ($3 ~ /^\/v1\/trading-standards\/mvtr/) $3="mvtr"; print}'  joined_filter_6.csv > joined_filter_7.csv
rm -rf joined_filter_6.csv
awk '{ if ($3 ~ /^\/v1\/radio-spectrum-management\/DownloadLicences/) $3="DownloadLicences"; print}'  joined_filter_7.csv > joined_filter_8.csv
rm -rf joined_filter_7.csv
awk '{ if ($3 ~ /^\/v1\/companies-office\/financial-service-providers-register-private/) $3="fspr-private"; print}'  joined_filter_8.csv > joined_filter_9.csv
rm -rf joined_filter_8.csv
awk '{ if ($3 ~ /^\/v1\/companies-office\/financial-service-providers-register/) $3="fspr"; print}'  joined_filter_9.csv > joined_filter_10.csv
rm -rf joined_filter_9.csv
awk '{ if ($3 ~ /^\/v3\/iponz\/trademark-information/) $3="trademark-information"; print}'  joined_filter_10.csv > joined_filter_11.csv
rm -rf joined_filter_10.csv
awk '{print $2","$3","$4}' joined_filter_11.csv > joined_filter_wc.csv
rm -rf joined_filter_11.csv
echo `date`