# Transmission Notes

Two components, `transmission-daemon` which is the server and `transmission-remote` which communicates with the daemon.

Activate daemon by running command `transmission-daemon`, configs are in `.config/transmission-daemon/settings.json`. Web interface available on localhost:9091

`transmission-remote` is used to interact with the daemon through cli.

* Add torrents with `transmission-remote -a "link to torrent file, or magnet link"`
* List active torrents with `tranmission-remote -l`
* Remove torrents with `transmission-remote -t <ID> -r`. Can use comma seperated IDs or 'all'. Get IDs from listing active torrents
