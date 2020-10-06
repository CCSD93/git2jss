#!/bin/bash

    echo "OS version 10.9 or above"
    security authorizationdb write system.preferences allow
    security authorizationdb write system.preferences.timemachine allow
#    security authorizationdb write system.preferences.network allow
    security authorizationdb write system.preferences.energysaver allow
    security authorizationdb write system.preferences.printing allow
    security authorizationdb write system.preferences.datetime allow
#    security authorizationdb write system.services.systemconfiguration.network allow
