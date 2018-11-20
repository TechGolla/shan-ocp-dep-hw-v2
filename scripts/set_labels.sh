#!/usr/bin/env bash

oc login -u system:admin

oc adm groups new alphacorp andrew amy
oc adm groups new betacorp brian betty
oc adm groups new common chris cody

oc label group alphacorp client=alpha
oc label group betacorp client=beta
oc label group common client=common
 
