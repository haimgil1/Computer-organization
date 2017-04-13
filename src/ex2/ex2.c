/******************************************
* Haim Gil
* 203676945
* 8923004
* ex2
******************************************/
#include<stdio.h>
#include <string.h>

/************************************************************************
* function name: new_encoding_file.
* The Input: Two path of file and three flags.
* The output: none.
* The Function operation: The function encoding a new file from one operation
* systen to another.
* Note: if the last flag is "swap" the encoding will be with oposite bytes.
*************************************************************************/
void new_encoding_file(char *r1, char *r2, char *flag1, char *flag2, char *endian);

/************************************************************************
* function name: write_by_encoding.
* The Input: a path of file ,three flags and a buffer that read from the original file.
* The output: none.
* The Function operation: The function write on the new file from one operation
* systen to another.
* Note: if the last flag is "swap" the encoding will be with oposite bytes.
*************************************************************************/
void write_by_encoding(FILE *newFile, char *buffer, char *flag2, char *endian, int isSwapFile);

/************************************************************************
* function name: write_by_endian.
* The Input: a path of file ,one flag and a buffer that read from the original file.
* The output: none.
* The Function operation: The function write on the new file from one operation
* systen to another.
* Note: if the last flag is "swap" the encoding will be with oposite bytes.
*************************************************************************/
void write_by_endian(FILE *newFile, char *buffer, char *endian);

void new_encoding_file(char *r1, char *r2, char *flag1, char *flag2, char *endian) {

    FILE *sourceFile = fopen(r1, "rb"); // Open the original file read only.
    if (sourceFile == 0) {// Didn't found the file.
        return;
    }
    FILE *newFile = fopen(r2, "wb"); // Open new file to copy the text.

    char buffer[2]; // Copying the text char by char.
    int isSameFlag = 0; // A flag that checks whether its the same operation system flag.
    int isSwapFile; // A flag that checks the endian of the source file.
    char *macLine = "\r";// A line represented in mac.
    char *unixLine = "\n"; // A line represented in unix.
    char *littleEndian = "\xff"; // Little endian encoding.
    char *bigEndian = "\xfe"; // Big endian encoding.

    // Checking whether its the same operation system flag.
    if ((flag1 != NULL) && (flag2 != NULL) && (strcmp(flag1, flag2) == 0)) {
        isSameFlag = 1;
    }

    fread(buffer, 2, 1, sourceFile); // Read the first 2 bytes.

    // Checking the endian of the source file
    if (buffer[0] == *bigEndian) {
        isSwapFile = 1;
    } else if (buffer[0] == *littleEndian) {
        isSwapFile = 0;
    }

    do {
        // Checking if the buffer is "\r" and its not same system operation flag.
        if ((((buffer[0] == *macLine) && (buffer[1] == 0)) ||
             ((buffer[0] == 0) && (buffer[1] == *macLine)))
            && (flag1 != NULL) && (isSameFlag == 0)) {

            if (strcmp(flag1, "-win") == 0) {
                fread(buffer, 2, 1, sourceFile);
            }
            write_by_encoding(newFile, buffer, flag2, endian, isSwapFile);

            // Checking if the buffer is "\n" its not same system operation flag.
        } else if ((((buffer[0] == *unixLine) && (buffer[1] == 0)) ||
                    ((buffer[0] == 0) && (buffer[1] == *unixLine)))
                   && (flag1 != NULL) && (isSameFlag == 0)) {
            write_by_encoding(newFile, buffer, flag2, endian, isSwapFile);
        } else {
            write_by_endian(newFile, buffer, endian);
        }

    } while (fread(buffer, 2, 1, sourceFile) != 0); // The file isn't empty.

    fclose(sourceFile);
    fclose(newFile);
    return;
}

void write_by_encoding(FILE *newFile, char *buffer, char *flag2, char *endian, int isSwapFile) {

    // Case "win".
    if (strcmp(flag2, "-win") == 0) {
        if (isSwapFile) {
            buffer[0] = 0x00;
            buffer[1] = 0x0d;
        } else {
            buffer[1] = 0x00;
            buffer[0] = 0x0d;
        }
        write_by_endian(newFile, buffer, endian);

        if (isSwapFile) {
            buffer[0] = 0x00;
            buffer[1] = 0x0a;
        } else {
            buffer[1] = 0x00;
            buffer[0] = 0x0a;
        }
        write_by_endian(newFile, buffer, endian);
        // Case "unix".
    } else if (strcmp(flag2, "-unix") == 0) {
        if (isSwapFile) {
            buffer[0] = 0x00;
            buffer[1] = 0x0a;
        } else {
            buffer[1] = 0x00;
            buffer[0] = 0x0a;
        }
        write_by_endian(newFile, buffer, endian);

        // Case "mac".
    } else {
        if (isSwapFile) {
            buffer[0] = 0x00;
            buffer[1] = 0x0d;
        } else {
            buffer[1] = 0x00;
            buffer[0] = 0x0d;
        }
        write_by_endian(newFile, buffer, endian);
    }
}

void write_by_endian(FILE *newFile, char *buffer, char *endian) {

    // If the flag is swap it should change the endian.
    if ((endian != NULL) && (strcmp(endian, "-swap") == 0)) {
        fwrite(&buffer[1], 1, 1, newFile);
        fwrite(&buffer[0], 1, 1, newFile);
    } else {
        fwrite(buffer, 2, 1, newFile);
    }
}

int main(int argc, char *argv[]) {

    // Checking that the args is between 2 and 5 and the size isn't 4;
    if ((argv[2] == NULL) || (argv[3] != NULL && argv[4] == NULL) || (argc > 6)) {
        return 0;
    }

    // Checking that there are two file names.
    if ((argv[1] != NULL) && (!strstr(argv[1], ".")) ||
        (argv[2] != NULL) && (!strstr(argv[2], "."))) {
        return 0;
    }

    // Checking that the fourth argument is a system operation flag.
    if (argc >= 4 && argv[4] != NULL && strcmp(argv[4], "-win") && strcmp(argv[4], "-unix") &&
        strcmp(argv[4], "-mac")) {
        return 0;
    }

    new_encoding_file(argv[1], argv[2], argv[3], argv[4], argv[5]);
    return 0;
}

