#include <stdio.h>
#include "ex1.h"

int main(int argc, char* argv[]) {

    printf("%d\n", is_little_endian());

    printf("0x%lx\n", put_byte(0x12345678CDEF3456, 0xAB, 2));
    printf("0x%lx\n", put_byte(0x12345678CDEF3456, 0xAB, 0));
    printf("0x%lx\n", put_byte(0x12345678CDEF3456, 0xFF, 6));



    /////// Test 1  //////
    if (merge_bytes(0x89ABCDEF12893456, 0x76543210ABCDEF19) != 0x89abcdef12893419){
        printf(" test 1 failed");
    }

    /////// Test 2  //////
    if (merge_bytes(0x00ABCDEF12893400, 0x76543210ABCDEF19) != 0x00ABCDEF12893419){
        printf(" test 2 failed");
    }

    /////// Test 3  //////
    if (merge_bytes(0x00ABCDEF12893499, 0x76543210ABCDEF99) != 0x00ABCDEF12893499){
        printf(" test 3 failed");
    }

    /////// Test 4  //////
    if (merge_bytes(0x0000000000000001, 0x00000011110000FF) != 0x00000000000000FF){
        printf(" test 4 failed");
    }

    /////// Test 5  //////
    if (merge_bytes(0x1234567812345678, 0x0000001111000000) != 0x1234567812345600){
        printf(" test 5 failed");
    }

    /////// Test 6  //////
    if (put_byte(0x12345678CDEF3400, 0x12, 0) != 0x12345678CDEF3412){
        printf(" test 6 failed");
    }

    /////// Test 7  //////
    if (put_byte(0x12345678CDEF3400, 0xEF, 5) != 0x1234EF78CDEF3400){
        printf(" test 7 failed");
    }

    /////// Test 8  //////
    if (put_byte(0x12345678CDEF3400, 0x00, 7) != 0x00345678CDEF3400){
        printf(" test 8 failed");
    }

    /////// Test 9  //////
    if (put_byte(0x01, 0xAB, 2) != 0xAB0001){
        printf(" test 9 failed");
    }
    return 0;
}


