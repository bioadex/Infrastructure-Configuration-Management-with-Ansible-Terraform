---
# Installs and configures Docker with security best practices

- name: Update system packages
  yum:
    name: '*'
    state: latest
    update_cache: yes
  become: yes
  tags:
    - docker
    - system

- name: Install Docker
  yum:
    name: "{{ docker_package }}"
    state: present
  become: yes
  tags:
    - docker
    - install

- name: Ensure Docker service is started and enabled
  systemd:
    name: "{{ docker_service_name }}"
    state: started
    enabled: yes
  become: yes
  tags:
    - docker
    - service

- name: Add users to docker group
  user:
    name: "{{ item }}"
    groups: docker
    append: yes
  become: yes
  loop: "{{ docker_users }}"
  notify: reset ssh connection
  tags:
    - docker
    - users

- name: Create Docker daemon configuration directory
  file:
    path: /etc/docker
    state: directory
    mode: '0755'
  become: yes
  tags:
    - docker
    - config

- name: Configure Docker daemon with security settings
  copy:
    content: |
      {
        "log-driver": "json-file",
        "log-opts": {
          "max-size": "{{ docker_log_max_size }}",
          "max-file": "{{ docker_log_max_files }}"
        },
        "live-restore": true,
        "userland-proxy": false,
        "no-new-privileges": true
      }
    dest: /etc/docker/daemon.json
    mode: '0644'
  become: yes
  notify: restart docker
  tags:
    - docker
    - config
    - security