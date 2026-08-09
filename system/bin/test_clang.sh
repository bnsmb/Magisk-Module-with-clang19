#!/system/bin/sh

CLANG_ENV="/bin/init_clang19_env"

CLANG="$( which clang )"

if [ "${CLANG}"x = ""x ] ; then
  if [ ! -r "${CLANG_ENV}" ] ; then
    echo "ERROR: No clang found and the file \"${CLANG_ENV}\" does not exist"
    exit 1
  fi
  echo
  echo "*** Initializing the clang19 environment ..."
  echo 
  source "${CLANG_ENV}"
fi


echo 
echo "*** Testing the C compiler clang ..."
echo

cd /data/local/tmp

SOURCE_FILE="./helloworld_in_c.c"

if [ ! -r "${SOURCE_FILE}" ] ; then
  echo "Creating the file \"${SOURCE_FILE}\" ..."

  cat >"${SOURCE_FILE}" <<EOT
#include <stdio.h>

int main() {
    printf("Hello, World from a C program!\n");
    return 0;
}
EOT
fi

clang ${CFLAGS} ${LDFLAGS} -o helloworld_in_c "${SOURCE_FILE}"  && ./helloworld_in_c


echo 
echo "*** Testing the C++ compiler clang++ ..."
echo 

SOURCE_FILE="./helloworld_in_c++.cpp"

cd /data/local/tmp

if [ ! -r "${SOURCE_FILE}" ] ; then
  echo "Creating the file \"${SOURCE_FILE}\" ..."
  cat >"${SOURCE_FILE}" <<EOT
#include <iostream>  // include the input-output stream library

int main() {
    std::cout << "Hello, World from a C++ program!" << std::endl;  // output the message to the console
    return 0;  // indicate successful completion of the program
}
EOT

fi

clang++ ${CPPFLAGS} ${LDFLAGS}  -o helloworld_in_c++ ${SOURCE_FILE} && ./helloworld_in_c++


echo 
echo "*** Testing the Assembler from the clang ..."

SOURCE_FILE="helloworld_in_assembler.s"
if [ ! -r "${SOURCE_FILE}" ] ; then
  echo "Creating the file \"${SOURCE_FILE}\" ..."
  cat >"${SOURCE_FILE}" <<EOT
.section .data
msg:    .ascii "Hello, World from an assembler program compiled with clang!\n"
len = . - msg

.section .text
.global _start

_start:
    // write(1, msg, len)
    mov     x8, #64         // syscall number: write = 64 on arm64
    mov     x0, #1          // stdout (fd = 1)
    ldr     x1, =msg        // pointer to message
    mov     x2, #len        // message length
    svc     #0              // syscall

    // exit(0)
    mov     x8, #93         // syscall number: exit = 93 on arm64
    mov     x0, #0          // exit code
    svc     #0              // syscall

EOT

fi

clang -nostdlib -static -Wl,--entry=_start -o helloworld_in_assembler "${SOURCE_FILE}" && ./helloworld_in_assembler

echo

