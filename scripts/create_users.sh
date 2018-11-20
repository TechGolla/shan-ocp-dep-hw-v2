#!/usr/bin/env bash

genericPwd='r3dh4t1!'
pwdFile=/etc/origin/master/htpasswd

htpasswd -b $pwdFile andrew $genericPwd
htpasswd -b $pwdFile amy $genericPwd
htpasswd -b $pwdFile brian $genericPwd
htpasswd -b $pwdFile betty $genericPwd
htpasswd -b $pwdFile chris $genericPwd
htpasswd -b $pwdFile cody $genericPwd
htpasswd -b $pwdFile marina $genericPwd

#Admin User
echo "Adding User admin"
htpasswd -b $pwdFile admin admin

#Adding user 'admin' as cluster admin
echo "Adding user 'admin' as cluster admin"
oc adm policy add-cluster-role-to-user cluster-admin admin
