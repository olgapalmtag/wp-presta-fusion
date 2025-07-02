#!/bin/bash
adduser --disabled-password --gecos "" ${end_user_username}
echo "${end_user_username}:${end_user_password}" | chpasswd

adduser --disabled-password --gecos "" ${developer_username}
echo "${developer_username}:${developer_password}" | chpasswd

adduser --disabled-password --gecos "" ${ops_username}
echo "${ops_username}:${ops_password}" | chpasswd

adduser --disabled-password --gecos "" ${sre_username}
echo "${sre_username}:${sre_password}" | chpasswd

adduser --disabled-password --gecos "" ${instructor_username}
echo "${instructor_username}:${instructor_password}" | chpasswd

apt update && apt install -y nginx
systemctl enable nginx && systemctl start nginx

