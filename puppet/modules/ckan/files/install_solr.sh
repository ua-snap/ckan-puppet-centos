# Fetch the proper version of Solr (CKAN needs 1.4.1), untar and create required directories.
wget -q https://archive.apache.org/dist/lucene/solr/1.4.1/apache-solr-1.4.1.tgz;
tar -zxvf apache-solr-1.4.1.tgz -C /usr/src
mkdir -p /usr/share/solr/core0/conf
cp /usr/src/apache-solr-1.4.1/dist/apache-solr-1.4.1.war /usr/share/solr/

# First copy the baseline required files for Solr...
cp -R /usr/src/apache-solr-1.4.1/example/solr/conf/* /usr/share/solr/core0/conf/

# Now overwrite with defaults for multi-core setup...
cp -R /usr/src/apache-solr-1.4.1/example/multicore/core0/* /usr/share/solr/core0/
cp /usr/src/apache-solr-1.4.1/example/multicore/solr.xml /usr/share/solr/

# Finally, copy the CKAN schema file over.
cp /usr/lib/ckan/default/src/ckan/ckan/config/solr/schema.xml /usr/share/solr/core0/conf/schema.xml

# Fix permissions...
chown -R tomcat:tomcat /usr/share/solr/