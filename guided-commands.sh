#!/bin/bash

function check_reg_count {
    MAX_REG=65536
    MIN_REG=0

    reg_count=$1

    re='^[0-9]+$'
    if ! [[ $reg_count =~ $re ]]; then
        echo "Not a number"
        return
    fi

    if [ $reg_count -gt $MAX_REG ]; then
        echo "To manny registers"
        return
    fi

    if [ $reg_count -lt $MIN_REG ]; then
        echo "To few registers"
        return
    fi 

    echo ""
}

function read_reg_count {
    reg_type=$1
    err_msg=""

    while true; do
        read -p "${err_msg}Number of $reg_type registers: [65536] " num_regs
        if [ "$num_regs" == "" ]; then
            num_regs="65536"
        fi

        check=$(check_reg_count $num_regs)
        if [ "$check" != "" ]; then
            err_msg="${check}. Try again. "
        else
            break;
        fi
    done

    echo $num_regs
}

function guided_modbus_tcp_client_shm {
    scriptpath=$1

    # port
    while true; do
        read -p "Modbus TCP Client port: [502] " port
        if  [ "$port" = "" ]; then
            port="502"
        fi

        re='^[0-9]+$'
        if ! [[ $port =~ $re ]]; then
            echo "Not a number."
            continue
        fi

        break
    done

    # ip
    read -p "Modbus TCP Client listen Host: [::] " listen_ip
    if  [ "$listen_ip" = "" ]; then
        listen_ip="::"
    fi 

    # name prefix
    read -p "Modbus Shared memory name prefix: [modbus_] " name_prefix
    if  [ "$name_prefix" = "" ]; then
        name_prefix="modbus_"
    fi 

    # register count
    do_regs=$(read_reg_count "DO")
    di_regs=$(read_reg_count "DI")
    ao_regs=$(read_reg_count "AO")
    ai_regs=$(read_reg_count "AI")

    # monitor
    while true; do
        read -p "Output modbus telegrams to stdout: [y/N] " yn
        if [ "$yn" == "" ]; then
            yn="N"
        fi
        case $yn in
            [Yy]* ) monitor="true"; break;;
            [Nn]* ) monitor="false"; break;;
            * ) echo "Please answer yes (y) or no (n).";;
        esac
    done

    # reconnect
    while true; do
        read -p "Terminate if Modbus server disconnects: [y/N] " yn
        if [ "$yn" == "" ]; then
            yn="N"
        fi
        case $yn in
            [Yy]* ) reconnect="false"; break;;
            [Nn]* ) reconnect="true"; break;;
            * ) echo "Please answer yes (y) or no (n).";;
        esac
    done
    
    # force shm
    while true; do
        read -p "Overwrite existing shared memory: [y/N] " yn
        if [ "$yn" == "" ]; then
            yn="N"
        fi
        case $yn in
            [Yy]* ) force_shm="true"; break;;
            [Nn]* ) force_shm="false"; break;;
            * ) echo "Please answer yes (y) or no (n).";;
        esac
    done

    # print summary
    echo "The following settings were input:"
    echo "  -           Port: $port"
    echo "  -             IP: $listen_ip"
    echo "  -   DO registers: $do_regs"
    echo "  -   DI registers: $di_regs"
    echo "  -   AO registers: $ao_regs"
    echo "  -   AI registers: $ai_regs"
    echo "  - reconnect mode: $reconnect"
    echo "  -   monitor mode: $monitor"
    echo "  -      force shm: $force_shm"

    while true; do
        read -p "Do you want to start the modbus client? [Y/n] " yn
        if [ "$yn" == "" ]; then
            yn="Y"
        fi
        case $yn in
            [Yy]* ) break;;
            [Nn]* ) return;;
            * ) echo "Please answer yes (y) or no (n).";;
        esac
    done

    # create flags
    if [ "$force_shm" == "true" ]; then
        force_shm="--force"
    else
        force_shm=""
    fi

    if [ "$monitor" == "true" ]; then
        monitor="--monitor"
    else
        monitor=""
    fi

    if [ "$reconnect" == "true" ]; then
        reconnect="--reconnect"
    else
        reconnect=""
    fi

    #execute
    echo "Executing..."
    if [[ -x "$scriptpath/modbus-tcp-client-shm" ]]; then
        exe="$scriptpath/modbus-tcp-client-shm"
    elif [[ -x "/bin/modbus-tcp-client-shm" ]]; then
        exe="/bin/modbus-tcp-client-shm"
    elif [[ -x "/usr/bin/modbus-tcp-client-shm" ]]; then
        exe="/usr/bin/modbus-tcp-client-shm"
    elif [[ -x "/snap/bin/shm-modbus.modbus-tcp-client-shm" ]]; then
        exe="/snap/bin/shm-modbus.modbus-tcp-client-shm"
    else
        exe="modbus-tcp-client-shm"
    fi
    $exe --host $listen_ip --service $port --name-prefix $name_prefix --do-registers $do_regs --di-registers $di_regs --ao-registers $ao_regs --ai-registers $ai_regs $force_shm $reconnect $monitor
}

function guided_modbus_rtu_client_shm {
    scriptpath=$1

    # client id
    while true; do
        read -p "Modbus Client ID: [0] " client_id
        if  [ "$client_id" = "" ]; then
            client_id="0"
        fi

        re='^[0-9]+$'
        if ! [[ $client_id =~ $re ]]; then
            echo "Not a number."
            continue
        fi

        break
    done

    # device
    while true; do
        read -p "Modbus RTU device: " device
        if  [ -e "$device" ]; then
            break;
        else
            echo "no such file."
        fi 
    done

    # name prefix
    read -p "Modbus Shared memory name prefix: [modbus_] " name_prefix
    if  [ "$name_prefix" = "" ]; then
        name_prefix="modbus_"
    fi 

    # register count
    do_regs=$(read_reg_count "DO")
    di_regs=$(read_reg_count "DI")
    ao_regs=$(read_reg_count "AO")
    ai_regs=$(read_reg_count "AI")

    # monitor
    while true; do
        read -p "Output modbus telegrams to stdout: [y/N] " yn
        if [ "$yn" == "" ]; then
            yn="N"
        fi
        case $yn in
            [Yy]* ) monitor="true"; break;;
            [Nn]* ) monitor="false"; break;;
            * ) echo "Please answer yes (y) or no (n).";;
        esac
    done
    
    # force shm
    while true; do
        read -p "Overwrite existing shared memory: [y/N] " yn
        if [ "$yn" == "" ]; then
            yn="N"
        fi
        case $yn in
            [Yy]* ) force_shm="true"; break;;
            [Nn]* ) force_shm="false"; break;;
            * ) echo "Please answer yes (y) or no (n).";;
        esac
    done

    # print summary
    echo "The following settings were input:"
    echo "  -      Client ID: $client_id"
    echo "  -         Device: $device"
    echo "  -   DO registers: $do_regs"
    echo "  -   DI registers: $di_regs"
    echo "  -   AO registers: $ao_regs"
    echo "  -   AI registers: $ai_regs"
    echo "  -   monitor mode: $monitor"
    echo "  -      force shm: $force_shm"

    while true; do
        read -p "Do you want to start the modbus client? [Y/n] " yn
        if [ "$yn" == "" ]; then
            yn="Y"
        fi
        case $yn in
            [Yy]* ) break;;
            [Nn]* ) return;;
            * ) echo "Please answer yes (y) or no (n).";;
        esac
    done

    # create flags
    if [ "$force_shm" == "true" ]; then
        force_shm="--force"
    else
        force_shm=""
    fi

    if [ "$monitor" == "true" ]; then
        monitor="--monitor"
    else
        monitor=""
    fi

    #execute
    echo "Executing..."
    if [[ -x "$scriptpath/modbus-rtu-client-shm" ]]; then
        exe="$scriptpath/modbus-rtu-client-shm"
    elif [[ -x "/bin/modbus-rtu-client-shm" ]]; then
        exe="/bin/modbus-rtu-client-shm"
    elif [[ -x "/usr/bin/modbus-rtu-client-shm" ]]; then
        exe="/usr/bin/modbus-rtu-client-shm"
    elif [[ -x "/snap/bin/shm-modbus.modbus-rtu-client-shm" ]]; then
        exe="/snap/bin/shm-modbus.modbus-rtu-client-shm"
    else
        exe="modbus-rtu-client-shm"
    fi
    $exe --device $device --id $client_id --name-prefix $name_prefix --do-registers $do_regs --di-registers $di_regs --ao-registers $ao_regs --ai-registers $ai_regs $force_shm $monitor
}

function guided_dump_shm {
    scriptpath=$1

    # name
    while true; do
        read -p "Name of the shared memory you want to dump: " shm_name
        if  [ "$shm_name" = "" ]; then
            echo "name is mandatory."
        else
            break
        fi
    done

    # action
    echo "Possible actions:"
    echo "  -  raw: directly dump to stdout"
    echo "  -  hex: create a hexump"
    echo "  - file: dump to a file" 
    while true; do
        read -p "what do you want to do {raw, hex, file}: " action 
        if [ "$action" = "raw" ]; then
            break
        fi
        if [ "$action" = "hex" ]; then
            break
        fi
        if [ "$action" = "file" ]; then
            break
        fi

        echo "invlaid action. Try again."
    done

    if [[ -x "$scriptpath/dump-shm" ]]; then
        exe="$scriptpath/dump-shm"
    elif [[ -x "/bin/dump-shm" ]]; then
        exe="/bin/dump-shm"
    elif [[ -x "/usr/bin/dump-shm" ]]; then
        exe="/usr/bin/dump-shm"
    elif [[ -x "/snap/bin/shm-modbus.dump-shm" ]]; then
        exe="/snap/bin/shm-modbus.dump-shm"
    else
        exe="dump-shm"
    fi

    if [ "$action" = "file" ]; then
        while true; do
            read -p "Name of the dump file: " fname
            if  [ "$fname" = "" ]; then
                echo "file name is mandatory."
            else
                break
            fi
        done

        echo "Executing..."
        $exe $shm_name > $fname
    elif [ "$action" = "hex" ]; then
        echo "Executing..."
        $exe $shm_name | hexdump -C -v | more
    elif [ "$action" = "raw" ]; then
        echo "Executing..."
        $exe $shm_name
    fi
}

function guided_write_shm {
    scriptpath=$1

    # name
    while true; do
        read -p "Name of the shared memory you want to write to: " shm_name
        if  [ "$shm_name" = "" ]; then
            echo "name is mandatory."
        else
            break
        fi
    done

    # file name
    while true; do
        read -p "Name of the file you want to write to the shared memory (empty for reading from stdin): " fname
        if [ "$fname" != "" ]; then
            if [ -e "$fname" ]; then
                break;
            fi;
            echo "No such file."
        else
            break;
        fi;
    done

    # invert
    while true; do
        read -p "Do you want to invert all bytes: [y/N] " yn
        if [ "$yn" == "" ]; then
            yn="N"
        fi
        case $yn in
            [Yy]* ) invert="-i"; break;;
            [Nn]* ) invert=""; break;;
            * ) echo "Please answer yes (y) or no (n).";;
        esac
    done

    # repeat
    while true; do
        read -p "Do you want to repeat the input to fill the complete shared memory: [y/N] " yn
        if [ "$yn" == "" ]; then
            yn="N"
        fi
        case $yn in
            [Yy]* ) repeat="-r"; break;;
            [Nn]* ) repeat=""; break;;
            * ) echo "Please answer yes (y) or no (n).";;
        esac
    done

    echo "Executing..."
    if [[ -x "$scriptpath/write-shm" ]]; then
        exe="$scriptpath/write-shm"
    elif [[ -x "/bin/write-shm" ]]; then
        exe="/bin/write-shm"
    elif [[ -x "/usr/bin/write-shm" ]]; then
        exe="/usr/bin/write-shm"
    elif [[ -x "/snap/bin/shm-modbus.write-shm" ]]; then
        exe="/snap/bin/shm-modbus.write-shm"
    else
        exe="write-shm"
    fi

    if [ "$fname" = "" ]; then
        $exe -n $shm_name $repeat $invert
    else
        $exe -n $shm_name $repeat $invert < $fname
    fi
}

function guided_shared_mem_random {
    scriptpath=$1

    # name
    while true; do
        read -p "Name of the shared memory you want to write random values to: " shm_name
        if  [ "$shm_name" = "" ]; then
            echo "name is mandatory."
        else
            break
        fi
    done

    # inverval
    while true; do
        read -p "Interval in milliseconds: [1000] " interval

        if [ "$interval" = "" ]; then
            interval=1000
            break
        fi
        
        re='^[0-9]+$'
        if ! [[ $interval =~ $re ]]; then
            echo "Not a number."
            continue
        fi

        if [ $interval -lt 1 ]; then
            echo "Interval of 0 ms is not possible."
        fi

        break
    done

    # limit
    limit=0
    while true; do
        read -p "Number of execution cycles (0 for infinite): [0] " limit

        if [ "$limit" = "" ]; then
            limit=0
            break
        fi

        re='^[0-9]+$'
        if [[ $limit =~ $re ]]; then
            break
        fi

        echo "Not a number."
    done

    # alignment
    allignment=1
    while true; do
        read -p "How many bytes should the chunks in which random values are generated be? {1, 2, 4, 8} [1] " allignment

        if [ "$allignment" = "" ]; then
            allignment=1
        fi

        if [ "$allignment" = "1" ]; then
            break
        fi
        if [ "$allignment" = "2" ]; then
            break
        fi
        if [ "$allignment" = "4" ]; then
            break
        fi
        if [ "$allignment" = "8" ]; then
            break
        fi

        echo "Invalid input."
    done

    # mask
    while true; do
        read -p "Bit mask to apply to the random chunks: [no mask] " mask

        if [ "$mask" = "" ]; then
            mask="0xFFFFFFFFFFFFFFFF"
        fi

        re='^(0x)?[1-9A-Fa-f][0-9A-Fa-f]*$'
        if [[ $mask =~ $re ]]; then
            break
        fi

        echo "Not a number."
    done

    echo "Executing..."
    if [[ -x "$scriptpath/shared-mem-random" ]]; then
        exe="$scriptpath/shared-mem-random"
    elif [[ -x "/bin/shared-mem-random" ]]; then
        exe="/bin/shared-mem-random"
    elif [[ -x "/usr/bin/shared-mem-random" ]]; then
        exe="/usr/bin/shared-mem-random"
    elif [[ -x "/snap/bin/shm-modbus.shared-mem-random" ]]; then
        exe="/snap/bin/shm-modbus.shared-mem-random"
    else
        exe="shared-mem-random"
    fi
    $exe -a $allignment -m $mask -n $shm_name -i $interval -l $limit
}

function guided_stdin_to_modbus_shm {
    scriptpath=$1

    # name prefix
    read -p "Modbus Shared memory name prefix: [modbus_] " name_prefix
    if  [ "$name_prefix" = "" ]; then
        name_prefix="modbus_"
    fi 

    # input file
    while true; do
        read -p "file to redirect output (stdout) (press return for none): " fname

        if [ "$fname" = "" ]; then
            break
        fi

        re='^([0-9]|[a-z]|[A-Z]|[/\._]|[+-/])*$'
        if ! [[ $fname =~ $re ]]; then
            echo "invalid characters in file"
            continue
        fi

        break
    done

    echo "Executing..."
    if [[ -x "$scriptpath/stdin-to-modbus-shm" ]]; then
        exe="$scriptpath/stdin-to-modbus-shm"
    elif [[ -x "/bin/stdin-to-modbus-shm" ]]; then
        exe="/bin/stdin-to-modbus-shm"
    elif [[ -x "/usr/bin/stdin-to-modbus-shm" ]]; then
        exe="/usr/bin/stdin-to-modbus-shm"
    elif [[ -x "/snap/bin/shm-modbus.stdin-to-modbus-shm" ]]; then
        exe="/snap/bin/shm-modbus.stdin-to-modbus-shm"
    else
        exe="stdin-to-modbus-shm"
    fi
    if [ "$fname" = "" ]; then
        $exe -n $name_prefix
    else
        $exe -n $name_prefix < $fname
    fi
}
