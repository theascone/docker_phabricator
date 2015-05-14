# docker_phabricator

Dockerize Phabricator

## About

This image provides the following:
- Lighttpd based Phabricator installation
- SSH + HTTP/HTTPS access to repositories
- Aphlict server for instant notifications

## Creation

\* highlights mandatory options

### Links (--link)

`mysql` \*
Mysql container

### Environment (-e)

`MYSQL_USER` \*
Name of the Mysql user  
`MYSQL_PASS` \*
Password of the Mysql user  

### Volumes (-v)

`/var/config`
[preamble.php](https://secure.phabricator.com/book/phabricator/article/configuring_preamble/),
[config.conf.php](https://secure.phabricator.com/book/phabricator/article/advanced_configuration/#creating-a-configuration)  
`/var/repo`
All repositories  
`/var/storage`
Large file storage

### Ports (-p)

`22`
SSH  
`80`
Lighttpd  
`22280`
[Aphlict](https://secure.phabricator.com/book/phabricator/article/notifications/)

### Hostname (-h) \*

Lighttpd is configured to only respond to the supplied hostname e.g. [phabricator.example.com](#))

### Example

    docker create --name phabricator -h [hostname] --link [mysql_container]:mysql -e MYSQL_USER=[user] -e MYSQL_PASS=[password] -v [/path/to/config/dir]:/var/config -v [/path/to/repo/dir]:/var/repo -v [/path/to/storage/dir]:/var/storage -p 80:80 -p 22:22 -p 22280:22280 theascone/docker_phabricator:latest

## Usage

### Phabricator

[Phabricator documentation](https://secure.phabricator.com/book/phabricator/)

### SSH

SSH user is `vcs`
