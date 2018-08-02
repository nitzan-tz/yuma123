#!/bin/bash

test_data()
{
    #TODO
    declare -a schema_load_fail=("${!2}")
    declare -a data_file_load_fail=("${!3}")

    for index in ${!schema_load_fail[*]}
    do
        #printf "%4d: %s\n" $index ${schema_load_fail[$index]}
        if [ ${schema_load_fail[$index]} == "0" ] ; then
            MODULE_ARGS=${MODULE_ARGS}" --module="${1}/mod$(($index+1)).yang
        fi
    done

    for index in ${!data_file_load_fail[*]}
    do
        if [ ${data_file_load_fail[$index]} == "0" ] ; then
            EXPECTED="OK"
        else
            EXPECTED="FAIL"
        fi
        DATA_FILE=${1}/data$(($index+1)).xml
        echo "Testing EXPECTED=$EXPECTED $DATA_FILE ..." >&2
        echo '<?xml version="1.0" encoding="UTF-8"?>' >test-cfg.xml
        echo '<config xmlns="urn:ietf:params:xml:ns:netconf:base:1.0">' >>test-cfg.xml
        cat ${DATA_FILE} >> test-cfg.xml
        echo '</config>' >> test-cfg.xml
        /usr/sbin/netconfd --validate-config-only --startup-error=stop --modpath=${1}/ ${MODULE_ARGS} --startup=test-cfg.xml 1>&2
        RES=$?

        echo "RES="$RES >&2
        if [ "$RES" != "0" ] ; then
            if [ "$EXPECTED" == "OK" ] ; then
                echo "FAIL: ${DATA_FILE}" >&2
                FAIL=$(($FAIL+1))
                echo -n ",1"

            else
                echo "OK:   ${DATA_FILE}" >&2
                OK=$(($OK+1))
                echo -n ",0"

            fi
        else
            if [ "$EXPECTED" != "OK" ] ; then
                echo "FAIL: ${DATA_FILE}" >&2
                FAIL=$(($FAIL+1))
                echo -n ",1"
            else
                echo "OK:   ${DATA_FILE}" >&2
                OK=$(($OK+1))
                echo -n ",0"
            fi
        fi
    done
    echo "OKs=$OK" >&2
    echo "FAILs=$FAIL" >&2
    return $FAIL
}
test_schema()
{
    declare -a schema_load_fail=("${!2}")
    declare -a data_file_load_fail=("${!3}")

    FAIL=0
    OK=0

    for index in ${!schema_load_fail[*]}
    do
        #printf "%4d: %s\n" $index ${schema_load_fail[$index]}
        if [ ${schema_load_fail[$index]} == "0" ] ; then
            EXPECTED="OK"
        else
            EXPECTED="FAIL"
        fi
        MODULE=${1}/mod$(($index+1)).yang
        echo "Testing EXPECTED=$EXPECTED $MODULE ..." >&2


        if [ "$RUN_WITH_PYANG" != "" ] ; then
            pyang --path ${1}/ ${1}/mod$(($index+1)).yang  1>&2
            RES=$?
        elif [ "$RUN_WITH_YANGDUMP" != "" ] ; then
            yangdump --modpath=${1}/ ${1}/mod$(($index+1)).yang  1>&2
            RES=$?
        elif [ "$RUN_WITH_YANGLINT" != "" ] ; then
            yanglint --path=${1}/ ${1}/mod$(($index+1)).yang  1>&2
            RES=$?
        elif [ "$RUN_WITH_CONFD" != "" ] ; then
            killall -KILL confd || true
            source $RUN_WITH_CONFD/confdrc
            confdc -c ${1}/mod$(($index+1)).yang --yangpath ${1}/ -o mod$(($index+1)).fxs  1>&2
            RES=$?
        else
            /usr/sbin/netconfd --validate-config-only --startup-error=stop --no-startup --modpath=${1}/ --module=${1}/mod$(($index+1)).yang  1>&2
            RES=$?
        fi

        echo "RES="$RES >&2
        if [ "$RES" != "0" ] ; then
            if [ "$EXPECTED" == "OK" ] ; then
                echo "FAIL: ${MODULE}" >&2
                FAIL=$(($FAIL+1))
                echo -n ",1"

            else
                echo "OK:   ${MODULE}" >&2
                OK=$(($OK+1))
                echo -n ",0"

            fi
        else
            if [ "$EXPECTED" != "OK" ] ; then
                echo "FAIL: ${MODULE}" >&2
                FAIL=$(($FAIL+1))
                echo -n ",1"
            else
                echo "OK:   ${MODULE}" >&2
                OK=$(($OK+1))
                echo -n ",0"
            fi
        fi
    done
    echo "OKs=$OK" >&2
    echo "FAILs=$FAIL" >&2
    return $FAIL
}


TOTAL_FAILS=0
TOTAL_OKS=0

tests_base_dir=$1
tests_spec_file=$2

while read -r TEST_DIR_STR TEST_SCHEMA_LOAD_FAIL_STR TEST_DATA_FILE_FAIL_STR
do
    echo -n "$TEST_DIR_STR"
    test_dir=${tests_base_dir}"/"${TEST_DIR_STR}
    test_schema_load_fail=(${TEST_SCHEMA_LOAD_FAIL_STR//,/ })
    test_data_file_load_fail=(${TEST_DATA_FILE_FAIL_STR//,/ })
    if [ "$3" == "data" ] ; then
        test_data $test_dir test_schema_load_fail[@] test_data_file_load_fail[@]
    else
        test_schema $test_dir test_schema_load_fail[@] test_data_file_load_fail[@]
    fi
    FAILS=$?
    TOTAL_FAILS=$((${TOTAL_FAILS}+${FAILS}))
    echo
done < "$tests_spec_file"

exit $TOTAL_FAILS
