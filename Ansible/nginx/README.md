nginx
=========

This role is intended for installing the Nginx service, setting up basic site pages, and launching the service.

Requirements
------------

none

Role Variables
--------------

vars/main.yml:
  * nginx_path - this variable specifies the path where the Nginx service configs are located;
  * http_port - this variable specifies the number of sites to be created and the ports on which they will work.

Dependencies
------------

none

Example Playbook
----------------

Including an example of how to use your role (for instance, with variables passed in as parameters) is always nice for users too:

    - hosts: servers
      roles:
        - { role: nginx_init, become: true }


License
-------

BSD

Author Information
------------------

Anton Kurbatov
deyckstra@gmail.com