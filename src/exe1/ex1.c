/******************************************
* Haim Gil
* 203676945
* 8923004
* ex1
******************************************/
#include "ex1.h"

/************************************************************************
* function name: is_little_endian.
* The Input:none
* The output: 1 if the function compiled by little endian, 0 otherwise.
* The Function operation: The function checks weather this function compiled
* by little endian or by big endian.
*************************************************************************/
int is_little_endian() {
    unsigned long num = 0x1234567891123211;
    unsigned short int *checkingEndian = (unsigned short int *) &num;
    if (*checkingEndian == 0x3211) { // checking which byte saved in the pointer.
        return 1;
    }
    return 0;
}

/************************************************************************
* function name: merge_bytes.
* The Input: two unsigned long parameters.
* The output: an unsigned long number.
* The Function operation: The function return a unsigned long that contain
* the first 7 byte of x and the last byte of y.
*************************************************************************/
unsigned long merge_bytes(unsigned long x, unsigned long int y) {
    unsigned long mask =0x00000000000000FF;
    x = (x >> 8) << 8; // Delete the first byte.
    return x + (mask & y); // Adding the the lsb of y into x.
}

/************************************************************************
* function name: put_byte.
* The Input: an unsigned long number, an char and an index.
* The output: an unsigned long number.
* The Function operation: The function replace the i-byte of x and return
* the new number.
*************************************************************************/
unsigned long put_byte(unsigned long x, unsigned char b, int i) {
    unsigned long mask1, mask2, c;
    c = (unsigned long) b; // Casting to long.
    mask1 = 0xFFFFFFFFFFFFFFFF;
    mask2 = 0x00000000000000FF;
    mask2 <<= (8 * i); // Isolating the i-byte.
    c <<= (8 * i); // Taking it to the i-byte.
    return ((mask2 ^ mask1) & x) + c; // Replace the i-byte of x with b.
}
