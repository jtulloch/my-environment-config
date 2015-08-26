export PROJECT_BASE_PATH='/home/joel/public_html'
export SHAREDPATH='/home/joel/other_projects/Super-Shared'
JOEL_PSQL_ARGS='-h${CURVE_POSTGRES_SERVER} -Upostgres'

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
alias setErrorAll="root && sed -i config/config.php -e \"s/ini_get('error_reporting')/E_ALL/g\""

alias contr='gotoHeroPath app/controllers'
alias model='gotoHeroPath app/models'
alias widget='gotoHeroPath public/javascripts/curve/'
alias jsc='gotoHeroPath public/javascripts/'
alias proc='gotoHeroPath app/installers/storedProcedures/'

alias resetjs='root && cp app/views/main/TEMPLATE-_devcustom.tpl app/views/main/_devcustom.tpl'

alias gitcommit='${SHAREDPATH}/scripts/gitcommit.rb'

alias vi='vim'

alias tdb='psql -v schema=test_joel_hero -h${CURVE_POSTGRES_SERVER} $(getCurrentDatabaseName)'
alias db='psql -h${CURVE_POSTGRES_SERVER} -v schema=${CURVEPROJECT} $(getCurrentDatabaseName)'

alias createTestUser='createuser ${JOEL_PSQL_ARGS} -s test_$(getCurrentDatabaseName)'
alias createTestDatabase='createdb -h${CURVE_POSTGRES_SERVER} -U test_$(getCurrentDatabaseName) test_$(getCurrentDatabaseName)'
alias dropTestDatabase='dropdb -h${CURVE_POSTGRES_SERVER} -U test_$(getCurrentDatabaseName) test_$(getCurrentDatabaseName)'
alias createTestSchema='psql -h${CURVE_POSTGRES_SERVER} test_$(getCurrentDatabaseName) -c "CREATE SCHEMA test_curvehero;"'

alias generateTestDatabase='createTestUser && createTestDatabase && createTestSchema'

alias loadtestdata='root && cleandb app/installers/data/default_test_data.sql && cd -'
alias loadustestdata='root && cleandb app/installers/data/us_multi_claim.sql && cd -'
alias loadfinancialtestdata='root && cleandb app/installers/data/finance_test_data.sql && cd -'

alias dumpfinancialtestdata='root && db -c "ALTER SCHEMA ${CURVEPROJECT} RENAME TO test_curvehero" && pg_dump -h${CURVE_POSTGRES_SERVER} -O -x -n test_curvehero $(getCurrentDatabaseName) > app/installers/data/finance_test_data.sql && cd -'
alias dumpustestdata='root && db -c "ALTER SCHEMA ${CURVEPROJECT} RENAME TO test_curvehero" && pg_dump -h${CURVE_POSTGRES_SERVER} -O -x -n test_curvehero $(getCurrentDatabaseName) > app/installers/data/us_multi_claim.sql && cd -'
alias dumptestdata='root && db -c "ALTER SCHEMA ${CURVEPROJECT} RENAME TO test_curvehero" && pg_dump -h${CURVE_POSTGRES_SERVER} -O -x -n test_curvehero $(getCurrentDatabaseName) > app/installers/data/default_test_data.sql && cd -'

alias setadmin='db -f ${SHAREDPATH}/scripts/setAdminUser.sql'

alias taillog='cleanlog && root && tail -f log/*.log'
alias cleanlog='echo -n > ~/public_html/*/log/*.log'

alias migrateTest='root && ./script/migrateTest all install'
alias migrate='root && ./script/migrateAll'
alias clearbilling='db -f ~/scripts/clearbilling.sql'
alias clearLogTables='db -f ~/scripts/clean_log_tables.psql && db -c "clean_log_tables()"'

alias cleandb='cleandatabase'
alias dumpdb='dumpdatabase'

##### REGRESSION TESTS #####
alias cleardb="psql ${JOEL_PSQL_ARGS} -U $(getCurrentDatabaseName) -v schema=test_$(getCurrentDatabaseName) $(getCurrentDatabaseName) -c \"set search_path to test_$(getCurrentDatabaseName); update test_database_name set name = 'XXX'\"";

alias riptheheartoutofmyfuckingdatabasebecauseidontneeditanymore='dropdb ${JOEL_PSQL_ARGS} $(getCurrentDatabaseName)'
alias cdb='createdb ${JOEL_PSQL_ARGS} $(getCurrentDatabaseName)'
alias cdbuser='createuser ${JOEL_PSQL_ARGS} $(getCurrentDatabaseName)'

alias ssh_adminosaur='ssh_to Adminosaur'
alias get_url='/usr/local/server_deployment/scripts/get_instance_url.php -n'

alias testrun='runtest -t all && ./script/test_functional -t 4 && ./script/jstest-quick'

alias t='tmuxinator'

alias fix-file='/usr/local/code_sniffer/php-cs-fixer.phar fix'

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

getClientData() {
    echo "dumpClient.sh $1 ca blah"
}

loadlogtables() {
    local FILE_NAME=$1
    local SQL_DUMP_FILE

    if [ -f $FILE_NAME ]; then 
        SQL_DUMP_FILE=$FILE_NAME
    elif [ -f ~/client_data/$FILE_NAME ]; then
        SQL_DUMP_FILE=~/client_data/$FILE_NAME
    else
        return
    fi

    HERONAME=$(getCurrentHeroName)
    CURRENT_DATABASE=$(getCurrentDatabaseName)

    cat $SQL_DUMP_FILE | sed "s/\(SET search_path =\) [a-z]*,/\1 ${HERONAME},/g" | psql -X -q -a -1 -v ON_ERROR_STOP=1 --pset pager=off -h $CURVE_POSTGRES_SERVER -U $CURRENT_DATABASE -d $CURRENT_DATABASE
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
        if [ -f ${FILE_NAME} ]; then
            SQL_DUMP_FILE=${FILE_NAME}
        elif [ -f ${DATA_DUMP_DIR}/${FILE_NAME} ]; then
            SQL_DUMP_FILE=${DATA_DUMP_DIR}/${FILE_NAME}
        elif [ -f ${CURVESPACE}/${CURVEPROJECT}/${FILE_NAME} ]; then
            SQL_DUMP_FILE=${CURVESPACE}/${CURVEPROJECT}/${FILE_NAME}        
        elif [ -f ~/client_data/${FILE_NAME} ]; then
            SQL_DUMP_FILE=~/client_data/${FILE_NAME}
        else
            return
        fi
    fi

    # riptheheartoutofmyfuckingdatabasebecauseidontneeditanymore
    # cdb

    CURRENT_DATABASE=$(getCurrentDatabaseName)

    echo "Cleaning database ${CURRENT_DATABASE} with [${SQL_DUMP_FILE}]."

    psql -h ${CURVE_POSTGRES_SERVER} -U ${CURRENT_DATABASE} -f ${SQL_DUMP_FILE} ${CURRENT_DATABASE}
    echo "Renaming schema..."
    NAME=`cat ${SQL_DUMP_FILE} |ack-grep -i "CREATE SCHEMA"|grep -v public`
    RENAME_SCHEMA=`echo ${NAME} |sed 's/CREATE SCHEMA //g' |sed 's/;//g'`
    echo "Found name [${RENAME_SCHEMA}]"
    HERONAME=$(getCurrentHeroName)

    if [ "${RENAME_SCHEMA}" != "${HERONAME}" ]; then
        db -c "DROP SCHEMA ${HERONAME} CASCADE"
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

    pg_dump -h ${CURVE_POSTGRES_SERVER} -O -x -U $(getCurrentDatabaseName) -n $(getCurrentDatabaseName) -f ${DATA_DUMP_DIR}/${DUMP_FILE_NAME} $(getCurrentDatabaseName)
}

runtest() {
    cd ${CURVESPACE}/${CURVEPROJECT}

    script/runtest.sh "$@"
}

proj () {
    if [ -z $1 ]; then
        selectProject
    else
        export CURVEPROJECT=$1
        root
    fi
}

tproj() {
    NO_ARGS=0
    E_OPTERROR=85

    local PROJECT
    local LAYOUT

    argument_error() {
        echo "Usage: `basename $0` options (-p < project > -l < layout >)"
    }

    if [ $# -eq "$NO_ARGS" ]; then
        argument_error
    fi

    while getopts ":p:l:" Option
    do
        case $Option in
            p) PROJECT="${OPTARG}";;
            l) LAYOUT="${OPTARG}" ;;
            *) argument_error ;;
        esac
    done

    shift $(($OPTIND - 1))

    tmatt $PROJECT $LAYOUT
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
