#!/bin/sh

#   This script was written to enumerate existing firefox user preferences normally modified using the
#   about:config interface. It is important to note that changing preferences while firefox is running
#   is not possible, therefore this script will purposely error out. However, if the specified setting
#   is already present (even if firefox is running), the script will complete normally. 

#   $4 (required) user preference key (e.g. network.negotiate-auth.allow-insecure-ntlm-v1)
#   $5 (required) user preference key value (e.g. true, false, 512, sharepoint.company.com)
#   $6 (optional) indicates if the value is a string (e.g. string)

#   Author:     Andrew Thomson
#   Date:       04-29-2015

declare -a ARRAY_USERS
declare -a ARRAY_PROFILES

exec 2> /dev/null

#   if the required parameters are missing then exit
if [[ -z $4 ]] || [[ -z $5 ]]; then 
    echo "ERROR: Missing parameters."
    exit $LINENO
fi

#   display parameters
echo "KEY: ${4}"
echo "VALUE: ${5}"

#   create array of users
ARRAY_USERS=(`/usr/bin/dscl . list /Users | /usr/bin/grep -v '^_'`)

#   remove users from array without a firefox profile
for INDEX in $(seq 0 $((${#ARRAY_USERS[@]}-1))); do
    if [ ! -f "/Users/${ARRAY_USERS[INDEX]}/Library/Application Support/Firefox/profiles.ini" ]; then
        unset ARRAY_USERS[$INDEX]
    fi
done

#   display count users with firefox profile
echo "USERS: ${#ARRAY_USERS[@]}"  

#   eunmerate profiles for each user
for INDEX in $(seq 0 $((${#ARRAY_USERS[@]}-1))); do
    ARRAY_PROFILES=(`/usr/bin/grep -i path= "/Users/${ARRAY_USERS[INDEX]}/Library/Application Support/Firefox/profiles.ini" | /usr/bin/cut -d= -f2`)
    echo "PROFILES: ${#ARRAY_PROFILES[@]}"

    #   enumerate each preference file 
    for JNDEX in $(seq 0 $((${#ARRAY_PROFILES[@]}-1))); do

        #   find line within file with specified key
        LINE_NO=`/usr/bin/grep --text --line-number ${4} "/Users/${ARRAY_USERS[INDEX]}/Library/Application Support/Firefox/${ARRAY_PROFILES[JNDEX]}/prefs.js" | /usr/bin/cut -d: -f1`
        if [[ -n $LINE_NO ]]; then

            #   if key found display on which line
            echo "LINE: $LINE_NO"

            #   find current value associated with specified key                                                                                                              last_two_chars;first_space;quotes
            VALUE=`/usr/bin/sed -n ${LINE_NO}p "/Users/${ARRAY_USERS[INDEX]}/Library/Application Support/Firefox/${ARRAY_PROFILES[JNDEX]}/prefs.js" | /usr/bin/cut -d, -f2 | /usr/bin/sed 's/..$//;s/ //;s/\"//g'`
            echo "VAL1: ${5} VAL2: ${VALUE}"
            if [[ ${5} == ${VALUE} ]]; then
                echo "Specifed KEY and VALUE are already set for: \"${ARRAY_USERS[INDEX]}\""
                continue
            else
                #   before editing make sure firefox is not running.
                if /usr/bin/pgrep -i firefox; then echo "ERROR: Unable to modify config while Firefox is running."; exit $LINENO; fi

                #   backup file then delete the line that contains the specified key
                TIME_CODE=`/bin/date "+%Y%m%d%H%M%S"`
                if /usr/bin/sed -i.${TIME_CODE} ${LINE_NO}d "/Users/${ARRAY_USERS[INDEX]}/Library/Application Support/Firefox/${ARRAY_PROFILES[JNDEX]}/prefs.js"; then
                    echo "DELETED: ${LINE_NO}"

                    #   add setting to end of preference file   
                    echo "Modifying  entry . . ."
                    if [[ -n ${6} ]]; then
                        #   add value as string
                        echo "STRING: true"
                        if /bin/echo user_pref\(\"${4}\", \"${5}\"\)\; >> "/Users/${ARRAY_USERS[INDEX]}/Library/Application Support/Firefox/${ARRAY_PROFILES[JNDEX]}/prefs.js"; then
                            echo "ADDED: true"
                        else
                            PROFILE=`${ARRAY_PROFILES[JNDEX]} | /usr/bin/cut -d/ -f2`
                            echo "ERROR: Unable to modify profile: \"${PROFILE}\""
                            continue
                        fi
                    else
                        #   add value NOT as string
                        echo "STRING: false"
                        if /bin/echo user_pref\(\"${4}\", ${5}\)\; >> "/Users/${ARRAY_USERS[INDEX]}/Library/Application Support/Firefox/${ARRAY_PROFILES[JNDEX]}/prefs.js"; then
                            echo "ADDED: true"
                        else
                            PROFILE=`${ARRAY_PROFILES[JNDEX]} | /usr/bin/cut -d/ -f2`
                            echo "ERROR: Unable to modify profile: \"${PROFILE}\""
                            continue
                        fi
                    fi
                else
                    PROFILE=`${ARRAY_PROFILES[JNDEX]} | /usr/bin/cut -d/ -f2`
                    echo "ERROR: Unable to modify profile: \"${PROFILE}\""
                    continue
                fi
            fi
        else 
            #   before editing make sure firefox is not running.
            if /usr/bin/pgrep -i firefox; then echo "ERROR: Unable to modify config while Firefox is running."; exit $LINENO; fi

            #   backup preference file
            TIME_CODE=`/bin/date "+%Y%m%d%H%M%S"`
            if /bin/cp -p "/Users/${ARRAY_USERS[INDEX]}/Library/Application Support/Firefox/${ARRAY_PROFILES[JNDEX]}/prefs.js" "/Users/${ARRAY_USERS[INDEX]}/Library/Application Support/Firefox/${ARRAY_PROFILES[JNDEX]}/prefs.js.${TIME_CODE}"; then
                echo "BACKUP: true"
            else
                echo "ERROR: Unable backup preference file."
                continue
            fi

            #   add setting to end of preference file   
            echo "Adding entry . . ."
            if [[ -n ${6} ]]; then
                #   add value as string
                echo "STRING: true"
                if /bin/echo user_pref\(\"${4}\", \"${5}\"\)\; >> "/Users/${ARRAY_USERS[INDEX]}/Library/Application Support/Firefox/${ARRAY_PROFILES[JNDEX]}/prefs.js"; then
                    echo "ADDED: true"
                else
                    PROFILE=`${ARRAY_PROFILES[JNDEX]} | /usr/bin/cut -d/ -f2`
                    echo "ERROR: Unable to modify profile: \"${PROFILE}\""
                    continue
                fi
            else
                #   add value NOT as string
                echo "STRING: false"
                if /bin/echo user_pref\(\"${4}\", ${5}\)\; >> "/Users/${ARRAY_USERS[INDEX]}/Library/Application Support/Firefox/${ARRAY_PROFILES[JNDEX]}/prefs.js"; then
                    echo "ADDED: true"
                else
                    PROFILE=`${ARRAY_PROFILES[JNDEX]} | /usr/bin/cut -d/ -f2`
                    echo "ERROR: Unable to modify profile: \"${PROFILE}\""
                    continue
                fi
            fi
        fi
    done    
done