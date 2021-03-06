define rsync::manager::schedule (
                                  $ensure        = 'present',
                                  $schedule_name = $name,
                                  $user          = 'root',
                                  $group         = 'root',
                                  $schedule_mode = '0640',
                                  $hour          = '*',
                                  $minute        = '*',
                                  $month         = '*',
                                  $monthday      = '*',
                                  $weekday       = '*',
                                  $mail_to       = undef,
                                  $host_id       = undef,
                                  $logdir        = '/var/log/rsyncman',
                                  $pre_script    = undef,
                                  $post_script   = undef,
                                  $timeout       = '3600',
                                ) {
  include ::rsync::manager

  cron { $schedule_name:
    ensure   => $ensure,
    command  => "/usr/bin/rsyncman -c /etc/rsyncman/${schedule_name}.conf\n",
    user     => $user,
    hour     => $hour,
    minute   => $minute,
    month    => $month,
    monthday => $monthday,
    weekday  => $weekday,
    require  => Concat["/etc/rsyncman/${schedule_name}.conf"],
  }

  concat { "/etc/rsyncman/${schedule_name}.conf":
    ensure => $ensure,
    owner  => $user,
    group  => $group,
    mode   => $schedule_mode,
  }

  concat::fragment{ "/etc/rsyncman/${schedule_name}.conf global config":
    target  => "/etc/rsyncman/${schedule_name}.conf",
    order   => 'a00',
    content => template("${module_name}/rsyncman/base.erb")
  }

}
