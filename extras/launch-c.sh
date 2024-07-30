#!/bin/sh

export CCACHE_CPP2=true
exec ccache clang "$@"
