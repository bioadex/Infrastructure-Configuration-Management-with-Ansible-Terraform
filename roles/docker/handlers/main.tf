
---
- name: restart docker
  systemd:
    name: "{{ docker_service_name }}"
    state: restarted
  become: yes
  tags:
    - docker
    - service

- name: reset ssh connection
  meta: reset_connection
