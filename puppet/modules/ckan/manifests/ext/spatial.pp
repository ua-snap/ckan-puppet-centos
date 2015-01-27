# == Class: ckan::ext::spatial
#
# Installs the "spatial" extension, which allows for the association of datasets
# with geographic locations, and for searches across datasets to be restricted
# to a particular geographical area. Additionally, it provides some support for
# previewing geographical datasets.
#
# At a minimum, you should enable the "spatial_metadata" and "spatial_query"
# plugins. See the plugin documentation for full details:
#
#   http://docs.ckan.org/projects/ckanext-spatial/en/latest/
#
class ckan::ext::spatial {

  package { [
    'postgis2_93',
    'postgis2_93-docs',
    'postgis2_93-devel',
    'postgis2_93-debuginfo',
    'postgis2_93-utils',
    'postgis2_93-client'
    ]:
  }
  -> ckan::ext { 'spatial': }

  $sql_functions = '/usr/pgsql-9.3/share/contrib/postgis-2.1/postgis.sql'
  $sql_tables = '/usr/pgsql-9.3/share/contrib/postgis-2.1/spatial_ref_sys.sql'

  postgresql_psql { 'create postgis functions':
    command => "\\i $sql_functions",
    db      => 'ckan_default',
    require => Ckan::Ext['spatial'],
  }
  -> postgresql_psql { 'create spatial tables':
    command => "\\i $sql_tables",
    db      => 'ckan_default',
  }
  -> postgresql_psql { 'set spatial_ref_sys owner':
    command => 'ALTER TABLE spatial_ref_sys OWNER TO ckan',
    db      => 'ckan_default',
  }
  -> postgresql_psql { 'set geometry_columns owner':
    command => 'ALTER TABLE geometry_columns OWNER TO ckan',
    db      => 'ckan_default',
  }

  # Need libxml2 at version 2.9 for the spatial harvesters
  file { '/tmp/install_libxml2-2.9.sh':
    source => 'puppet:///modules/ckan/install_libxml2-2.9.sh',
  } ~> exec {'/tmp/install_libxml2-2.9.sh':
    command => '/bin/bash /tmp/install_libxml2-2.9.sh',
    refreshonly => true
  }

}
