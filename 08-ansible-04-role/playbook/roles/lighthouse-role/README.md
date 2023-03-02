lighthouse-role
=========

Installing and configuring lighthouse, starting services.

Requirements
------------

Git and nginx packages is required.

Role Variables
--------------

- lighthouse_default_dir - the default directory for installing lighthouse, now it should be the same as the default directory for sites in nginx.

Tags
----
- lighthouse

Example Playbook
----------------

Including an example of how to use your role (for instance, with variables passed in as parameters) is always nice for users too:

    - hosts: servers
      vars:
         - lighthouse_default_dir: "/usr/share/nginx/html/"
      roles:
         - lighthouse-role

License
-------

MIT

Author Information
------------------

Somov Alexey