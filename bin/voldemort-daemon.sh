#!/bin/bash
##
## Wrapper for jsvc
##

base_dir=$(cd $(dirname $0)/..; pwd)

JAVA_HOME=/usr/lib/jvm/jdk1.6.0_31

for file in $base_dir/dist/*.jar;
do
  CLASSPATH=$CLASSPATH:$file
done

for file in $base_dir/lib/*.jar;
do
  CLASSPATH=$CLASSPATH:$file
done

for file in $base_dir/contrib/*/lib/*.jar;
do
  CLASSPATH=$CLASSPATH:$file
done

CLASSPATH=$CLASSPATH:$base_dir/dist/resources

if [ -z "$VOLD_OPTS" ]; then
  VOLD_OPTS="-Xmx2G -Dcom.sun.management.jmxremote"
fi
CLASSPATH=$CLASSPATH:/usr/share/java/commons-daemon.jar

V_USER=voldemort
V_PIDFILE=/var/run/voldemort.pid
VOLDEMORT_HOME=/home/guillaume/Projects/voldemort/config/semetric-test

running_pid()
{
    # Check if a given process pid's cmdline matches a given name
    pid=$1
    [ -z "$pid" ] && return 1
    [ ! -d /proc/$pid ] &&  return 1
    return 0
}

start()
{
	jsvc \
	    -Dlog4j.configuration=file://$base_dir/dist/resources/log4j.properties \
	    $VOLD_OPTS \
	    -pidfile $V_PIDFILE \
	    -home $JAVA_HOME \
	    -cp $CLASSPATH \
	    -user $V_USER \
	    voldemort.server.VoldemortJsvcDaemon $VOLDEMORT_HOME
}

stop()
{
	jsvc -home $JAVA_HOME \
	    -cp $CLASSPATH \
	    -user $V_USER \
	    -pidfile $V_PIDFILE \
	    -stop voldemort.server.VoldemortJsvcDaemon $VOLDEMORT_HOME
}

case $1 in
    "start")
	running_pid $(cat $V_PIDFILE)
	if [ $? = 1 ]; then
	    echo "Voldemort not running, starting..."
	    start
	else
	    echo "Voldemort already running..."
	fi
	;;
    "restart")
	running_pid $(cat $V_PIDFILE)
	if [ $? = 1 ]; then
	    echo "Voldemort not running, starting..."
	    start
	else
	    echo "Restarting voldemort..."
	    stop
	    start
	fi

    "stop")
	running_pid $(cat $V_PIDFILE)
	if [ $? = 1 ]; then
	    echo "Voldemort not running"
	else
	    echo "Stopping voldemort..."
	    stop
	fi
	;;
esac
