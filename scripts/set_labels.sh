#!/usr/bin/env bash

oc login -u system:admin

oc adm groups new alphacorp andrew amy
oc adm groups new betacorp brian betty

oc label group alphacorp client=alpha
oc label group betacorp client=beta 
