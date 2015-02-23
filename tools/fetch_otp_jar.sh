#!/bin/bash

ERL_LIB_ROOT=`erl -noshell -s init stop -eval 'io:format("~s", [code:root_dir()])'`
JINTERFACE_JAR="$ERL_LIB_ROOT/lib/jinterface-*/priv/OtpErlang.jar"

cp $JINTERFACE_JAR vendor/otp_erlang.jar
