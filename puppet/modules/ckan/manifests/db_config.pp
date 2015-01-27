# configuration supporting database for ckan
# details: http://docs.ckan.org/en/ckan-2.0/install-from-package.html
class ckan::db_config {

  # === configure postgresql ===
  # create the database
  # also create the user/password to access the db
  # user gets all privs by default
  postgresql::server::role {'ckan':
    password_hash => 'pass',
  }
  postgresql::server::db {'ckan_default':
    user     => 'ckan',
    owner    => 'ckan',
    password => 'pass',
    require  => Postgresql::Server::Role ['ckan'],
  }

  #############################################################
  # May or may not need this in the future
  # create a seperate db for the datastore extension
  postgresql::server::db { 'datastore_default' :
    user     => 'ckan',
    owner    => 'ckan',
    password => 'pass',
    require  => Postgresql::Server::Role ['ckan'],
  }

  # create a ro user for datastore extension
  postgresql::server::role {'datastore' :
    password_hash => 'pass',
  }

  # grant privs for datastore user
  postgresql::server::database_grant { 'datastore_default' :
    privilege => 'CONNECT',
    db        => 'datastore_default',
    role      => 'datastore',
    require   => [Postgresql::Server::Role['datastore'],
                  Postgresql::Server::Db['datastore_default']],
  }

  #postgresql::server::database_grant { 'SCHEMA' :
  #  privilege => 'USAGE, SELECT',
  #  db        => 'SCHEMA',
  #  role      => 'datastore',
  #  require   => Postgresql::Server::Role['datastore'],
  #}

}
