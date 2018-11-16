#!/usr/bin/env bash

genericPwd='r3dh4t1!'
pwdFile=/etc/origin/master/htpasswd

htpasswd -b $pwdFile andrew $genericPwd
htpasswd -b $pwdFile amy $genericPwd
htpasswd -b $pwdFile brian $genericPwd
htpasswd -b $pwdFile betty $genericPwd

#Admin User
htpasswd -b $pwdFile admin admin

#Adding user 'admin' as cluster admin in addition to marina
oc adm policy add-cluster-role-to-user cluster-admin admin
