//
//  Encrypter.c
//  FileEncrypter
//
//  Created by Anshumali Karna on 25/11/22.
//

#include "Encrypter.h"

void encryptFile(EncryptedFile *encryptedFile, File *file, char *key) {
    int i;
    for (i = 0; i < file->fileSize; i++) {
        encryptedFile->fileData[i] = file->fileData[i] ^ key[i % strlen(key)];
    }
}

void decryptFile(DecryptedFile *decryptedFile, EncryptedFile *encryptedFile, char *key) {
    int i;
    for (i = 0; i < encryptedFile->fileSize; i++) {
        decryptedFile->fileData[i] = encryptedFile->fileData[i] ^ key[i % strlen(key)];
    }
}

void writeEncryptedFile(EncryptedFile *encryptedFile) {
    FILE *file = fopen(encryptedFile->filePath, "w");
    fwrite(encryptedFile->fileData, sizeof(char), encryptedFile->fileSize, file);
    fclose(file);
}

void writeDecryptedFile(DecryptedFile *decryptedFile) {
    FILE *file = fopen(decryptedFile->filePath, "w");
    fwrite(decryptedFile->fileData, sizeof(char), decryptedFile->fileSize, file);
    fclose(file);
}

