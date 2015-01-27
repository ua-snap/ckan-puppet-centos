# Postgres 9.2 Repo
class ckan::pgdg92repo {
        yumrepo { 'PGDG92':
                name            => "PGDG92",
                descr           => "PostgreSQL 9.2",
                baseurl         => 'http://yum.postgresql.org/9.2/redhat/rhel-$releasever-$basearch',
                gpgcheck        => 0,
                enabled         => 1
        }
        file { "/etc/pki/rpm-gpg/RPM-GPG-KEY-PGDG-92":
                owner   => 'root',
                group   => 'root',
                mode    => 0444,
                source  => 'puppet:///modules/ckan/RPM-GPG-KEY-PGDG-92'
        }
}
