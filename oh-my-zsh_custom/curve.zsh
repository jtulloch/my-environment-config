export PROJECT_BASE_PATH='/home/joel/public_html'
export SHAREDPATH='/home/joel/Super-Shared'
JOEL_PSQL_ARGS='-h10.131.25.250'

if [ -f $HOME/.curverc ]; then
    source $HOME/.curverc
fi

if [ "${DATA_DUMP_DIR}" = "" ]; then
    DATA_DUMP_DIR=~/data_dumps
fi

if [ "${SHAREDPATH}" = "" ]; then
    SHAREDPATH=/home/shared
fi

SHAREDFOLDER=${SHAREDPATH}
fpath=(${SHAREDFOLDER}/.fun $fpath)
autoload -U compinit
compinit -i

# THIS DOESN'T WORK RIGHT NOW, AS THERE ARE THINGS THAT BREAK MY PROMPT, ETC.
#
# source ${SHAREDPATH}/.zshrc

###### ALIASES #####
alias root='cd ~/public_html/$CURVEPROJECT'
alias gotoHeroPath='root && cd'

alias contr='gotoHeroPath app/controllers'
alias model='gotoHeroPath app/models'
alias widget='gotoHeroPath public/javascripts/curve/'
alias jsc='gotoHeroPath public/javascripts/'
alias proc='gotoHeroPath app/installers/storedProcedures/'

alias gitcommit='${SHAREDPATH}/scripts/gitcommit.rb'

alias vi='/usr/bin/vim'

alias tdb='psql -U test_$(getCurrentDatabaseName) -v schema=test_curvehero ${JOEL_PSQL_ARGS} test_$(getCurrentDatabaseName)'
alias db='psql -U $(getCurrentDatabaseName) ${JOEL_PSQL_ARGS} -v schema=${CURVEPROJECT} $(getCurrentDatabaseName)'

alias createTestUser='createuser ${JOEL_PSQL_ARGS} -s test_$(getCurrentDatabaseName)'
alias createTestDatabase='createdb ${JOEL_PSQL_ARGS} test_$(getCurrentDatabaseName)'
alias createTestSchema='psql ${JOEL_PSQL_ARGS} -U test_$(getCurrentDatabaseName) test_$(getCurrentDatabaseName) -c "CREATE SCHEMA test_curvehero;"'

alias generateTestDatabase='createTestUser && createTestDatabase && createTestSchema'

alias loadtestdata='root && cleandb app/installers/data/default_test_data.sql && cd -'
alias loadustestdata='root && dropdb ${JOEL_PSQL_ARGS} $(getCurrentDatabaseName) && createdb ${JOEL_PSQL_ARGS} -O $(getCurrentDatabaseName) $(getCurrentDatabaseName) && psql ${JOEL_PSQL_ARGS} $(getCurrentDatabaseName) -f app/installers/data/us_multi_claim.sql && cd -'
alias dumptestdata='root && db -c "ALTER SCHEMA ${CURVEPROJECT} RENAME TO test_curvehero" && pg_dump ${JOEL_PSQL_ARGS} -O $(getCurrentDatabaseName) > app/installers/data/default_test_data.sql && cd -'

alias setadmin='db -f ${SHAREDPATH}/scripts/setAdminUser.sql'

alias taillog='cleanlog && tail -f ~/public_html/*/log/*.log'
alias cleanlog='echo -n > ~/public_html/*/log/*.log'

alias migrateTest='root && ./script/migrateTest all install'
alias migrate='root && ./script/migrateAll all install'
alias clearbilling='db -f ~/clearbilling.sql'

alias cleandb='cleandatabase'
alias dumpdb='dumpdatabase'

alias riptheheartoutofmyfuckingdatabasebecauseidontneeditanymore='dropdb -h ${CURVE_POSTGRES_SERVER} $(getCurrentDatabaseName)'
alias cdb='createdb -h ${CURVE_POSTGRES_SERVER} -O $(getCurrentDatabaseName) $(getCurrentDatabaseName)'
alias cdbuser='createuser -h ${CURVE_POSTGRES_SERVER} $(getCurrentDatabaseName)'

alias ssh_adminosaur='ssh_to Adminosaur'

###### FUNCTIONS #####
#
#
# FROM SHARED STUFF
#
ssh_to() {
        ssh $(/usr/local/server_deployment/scripts/get_instance_url.php -n $1)
}

getCurrentDatabaseName() {
    php ${SHAREDPATH}/scripts/getCurrentDatabaseName.php
}

getCurrentHeroName() {
    php ${SHAREDPATH}/scripts/getCurrentHeroName.php
}

getCurrentBranch() {
    git branch 2> /dev/null | grep --color=never -e '\* ' | sed 's/^..\(.*\)/\1/'
}

cleandatabase() {
    local FILE_NAME=$1
    local SQL_DUMP_FILE

    if [ $# -eq 0 ]; then
        BRANCHED_DUMP_NAME=$(getCurrentDatabaseName)_dump.sql

        if [ -f ${DATA_DUMP_DIR}/${BRANCHED_DUMP_NAME} ]; then
            SQL_DUMP_FILE=${DATA_DUMP_DIR}/${BRANCHED_DUMP_NAME}
        else
            SQL_DUMP_FILE=${DATA_DUMP_DIR}/${CURVEPROJECT}_dump.sql
        fi
    else
        if [ -f ${DATA_DUMP_DIR}/${FILE_NAME} ]; then
            SQL_DUMP_FILE=${DATA_DUMP_DIR}/${FILE_NAME}
        elif [ -f ${CURVESPACE}/${CURVEPROJECT}/${FILE_NAME} ]; then
            SQL_DUMP_FILE=${CURVESPACE}/${CURVEPROJECT}/${FILE_NAME}        
        elif [ -f ~/client_data/${FILE_NAME} ]; then
            SQL_DUMP_FILE=~/client_data/${FILE_NAME}
        else
            return
        fi
    fi

    riptheheartoutofmyfuckingdatabasebecauseidontneeditanymore
    cdb

    CURRENT_DATABASE=$(getCurrentDatabaseName)

    echo "Cleaning database ${CURRENT_DATABASE} with [${SQL_DUMP_FILE}]."

    psql -h ${CURVE_POSTGRES_SERVER} -U ${CURRENT_DATABASE} -f ${SQL_DUMP_FILE} ${CURRENT_DATABASE}
    echo "Renaming schema..."
    NAME=`cat ${SQL_DUMP_FILE} |ack-grep -i "CREATE SCHEMA"|grep -v public`
    RENAME_SCHEMA=`echo ${NAME} |sed 's/CREATE SCHEMA //g' |sed 's/;//g'`
    echo "Found name [${RENAME_SCHEMA}]"
    HERONAME=$(getCurrentHeroName)

    if [ "${RENAME_SCHEMA}" != "${HERONAME}" ]; then
        echo "Renaming schema from [${RENAME_SCHEMA}] to [${HERONAME}]..."
        db -c "ALTER SCHEMA ${RENAME_SCHEMA} RENAME TO ${HERONAME}"
    fi
}

dumpdatabase() {
    local DUMP_FILE_NAME

    if [ $# -eq 0 ]; then
        DUMP_FILE_NAME=$(getCurrentDatabaseName)_dump.sql
    else
        DUMP_FILE_NAME=$1
    fi

    if [ ! -d $DATA_DUMP_DIR ]; then
        mkdir $DATA_DUMP_DIR
    fi

    pg_dump -h ${CURVE_POSTGRES_SERVER} -U $(getCurrentDatabaseName) -f ${DATA_DUMP_DIR}/${DUMP_FILE_NAME} $(getCurrentDatabaseName)
}

runtest() {
    local testCommand
    local testArg
    testCommand='./script/test'
    testArg=()

    if [ -z $1 ]; then
        echo "No file specified"
    else
        secondLastArg=''
        lastArg=''
        for arg in $@
        do
            testArg+="${secondLastArg}"
            secondLastArg="${lastArg}"
            lastArg="${arg}"
        done

        testPath='test/'
        case ${secondLastArg} in
        "-f"*)
            testPath+='functional'

            if [ "${lastArg}" != "all" ]; then
                testPath+="/controllers/"
            fi
        ;;
        "-m"*)
            testPath+='unit'

            if [ "${lastArg}" != "all" ]; then
                testPath+="/app/models/"
            fi
        ;;
        "-u"*)
            testPath+='unit/us/'
        ;;
        "-l"*)
            testPath+='unit/app/lib/'
        ;;
        "-ak"*)
            testPath+='unit/akelos/'
        ;;
        esac

        if [ "${lastArg}" != "all" ]; then
            testPath+="${lastArg}"
        fi

        testArg+=${testPath}

        echo ${testCommand}
        echo ${testArg}
        cd ${CURVESPACE}/${CURVEPROJECT} && ${testCommand} ${testArg}
    fi
}

proj () {
    if [ -z $1 ]; then
        selectProject
    else
        export CURVEPROJECT=$1
        root
    fi
}

selectProject() {
    CURVEPROJECTS=()
    PROJCOUNT=1

#This is to make the for loop parse by new lines instead of whitespace
IFS_BAK=$IFS
IFS="
"

    echo "0) None"

    for PROJ in `listHeroes.sh`
    do
        CURVEPROJECTS+=($PROJ)
        echo "${PROJCOUNT}) ${PROJ}"
        PROJCOUNT=$(( $PROJCOUNT + 1 ))
    done
IFS=$IFS_BAK
IFS_BAK=

    read ANSWER;
    if [ "${ANSWER}" = "" ]; then
        CURVEPROJECT=""
        export CURVEPROJECT
        cd
    elif [ "${ANSWER}" != "0" ]; then
        proj ${CURVEPROJECTS[$ANSWER]%% *}
    else
        CURVEPROJECT=""
        export CURVEPROJECT
        cd
    fi
}

#######################################################

clearProject() {
    export CURVEPROJECT=''
}

proj
