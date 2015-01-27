# ELGIS Repo, only installed on servers processing GIS related data
class ckan::elgisrepo {
        yumrepo { 'ELGIS':
                name            => "ELGIS",
                descr           => "ELGIS",
                baseurl         => 'http://elgis.argeo.org/repos/6/elgis/$basearch',
                gpgcheck        => 0,
                enabled         => 1
        }
        file { "/etc/pki/rpm-gpg/RPM-GPG-KEY-ELGIS":
                owner   => 'root',
                group   => 'root',
                mode    => 0444,
                source  => 'puppet:///modules/ckan/RPM-GPG-KEY-ELGIS'
        }
}
