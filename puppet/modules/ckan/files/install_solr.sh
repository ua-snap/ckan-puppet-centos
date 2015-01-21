# Download + install Solr.
# These directions are more-or-less the same as are found here:
# https://github.com/ckan/ckan/wiki/How-To-Install-Apache-Solr-on-Red-Hat
cd /usr/src/;
/usr/bin/wget -q https://archive.apache.org/dist/lucene/solr/1.4.1/apache-solr-1.4.1.tgz;
tar -xvf apache-solr-1.4.1.tgz;
mkdir -p /data/solr;
cp -R apache-solr-1.4.1/example/solr/* /data/solr/;
cp apache-solr-1.4.1/dist/apache-solr-1.4.1.war /data/solr/solr.war;
chown -R tomcat:tomcat /data/solr;

# Fix RedHat compatibility issues
mkdir -p /usr/share/tomcat6/common/endorsed
cd /usr/share/tomcat6/common/endorsed/
ln -s /usr/share/java/xalan-j2.jar xalan-j2.jar

# Create "cores," we're only going to use one though.
mkdir -p /data/solr/cores
## this line may need to be managed by Puppet: cp /usr/src/apache-solr-1.4.1/example/multicore/solr.xml /data/solr
mkdir -p /data/solr/cores/ckan_default/conf
mkdir -p /var/lib/solr/data/ckan_default
cp /data/solr/conf/ /data/solr/cores/ckan_default/
echo "Making data dir..."
mkdir /data/solr/cores/ckan_default/data

# Copy CKAN schema file
cp /usr/lib/ckan/default/src/ckan/ckan/config/solr/schema.xml /data/solr/cores/ckan_default/conf/
chown -R tomcat:tomcat /data/solr/

echo "Finished installing Solr"
exit 0