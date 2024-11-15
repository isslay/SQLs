CREATE USER 'readonly_user'@'%' IDENTIFIED BY 'dev_readonly';
GRANT Usage ON *.* TO 'readonly_user'@'%';
