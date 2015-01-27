# EPEL Repo, in common-server class, should be installed on all servers
class ckan::epelrepo {
        yumrepo { "epel":
                name            => 'EPEL',
                descr           => 'EPEL',
                mirrorlist      => 'https://mirrors.fedoraproject.org/metalink?repo=epel-6&arch=$basearch',
                enabled         => 1,
                gpgcheck        => 1,
                gpgkey          => 'file:///etc/pki/rpm-gpg/RPM-GPG-KEY-EPEL-6',
                require         => File["/etc/pki/rpm-gpg/RPM-GPG-KEY-EPEL-6"]

        }
        file { "/etc/pki/rpm-gpg/RPM-GPG-KEY-EPEL-6":
                owner   => 'root',
                group   => 'root',
                mode    => 0444,
                source  => 'puppet:///modules/ckan/RPM-GPG-KEY-EPEL-6'
        }

}
