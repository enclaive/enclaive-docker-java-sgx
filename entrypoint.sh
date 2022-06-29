#!/bin/sh

gramine-sgx-get-token --output java.token --sig java.sig
gramine-sgx java
