# See app_lxc/systemd/Dockerfile for the base image
FROM ldap_sysd
MAINTAINER Jeff McCune <jeff@puppetlabs.com>

EXPOSE 389

# start ldap directly:
CMD ["/usr/sbin/slapd", "-u", "ldap", "-h", "ldapi:/// ldap:///", "-d", "0"]
