//
//  Encrypter.h
//  FileEncrypter
//
//  Created by Anshumali Karna on 25/11/22.
//

#ifndef Encrypter_h
#define Encrypter_h

#include <stdio.h>
#include <string.h>
#include <unistd.h>
#include <sys/stat.h>

#define MAX_FILE_NAME 256
#define MAX_FILE_PATH 1024
#define MAX_FILE_SIZE 1024*1024*1024

#define ENCRYPTED_FILE_EXT ".enc"
#define DECRYPTED_FILE_EXT ".dec"

typedef struct EncryptedFile {
    char fileName[MAX_FILE_NAME];
    char filePath[MAX_FILE_PATH];
    char fileExt[MAX_FILE_NAME];
    char fileData[MAX_FILE_SIZE];
    int fileSize;
} EncryptedFile;

typedef struct DecryptedFile {
    char fileName[MAX_FILE_NAME];
    char filePath[MAX_FILE_PATH];
    char fileExt[MAX_FILE_NAME];
    char fileData[MAX_FILE_SIZE];
    int fileSize;
} DecryptedFile;

typedef struct File {
    char fileName[MAX_FILE_NAME];
    char filePath[MAX_FILE_PATH];
    char fileExt[MAX_FILE_NAME];
    char fileData[MAX_FILE_SIZE];
    int fileSize;
} File;

void encryptFile(EncryptedFile *encryptedFile, File *file, char *key);
void decryptFile(DecryptedFile *decryptedFile, EncryptedFile *encryptedFile, char *key);
void writeEncryptedFile(EncryptedFile *encryptedFile);
void writeDecryptedFile(DecryptedFile *decryptedFile);




#endif /* Encrypter_h */
