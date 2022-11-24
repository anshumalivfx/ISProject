//
//  ViewController.m
//  FileEncrypter
//
//  Created by Anshumali Karna on 24/11/22.
//

#include "ViewController.h"
#include <CommonCrypto/CommonCrypto.h>

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSVisualEffectView *visualEffectView = [[NSVisualEffectView alloc] initWithFrame:self.view.bounds];
    visualEffectView.material = NSVisualEffectMaterialTitlebar;
    visualEffectView.blendingMode = NSVisualEffectBlendingModeBehindWindow;
    visualEffectView.state = NSVisualEffectStateActive;
    [self.view addSubview:visualEffectView positioned:NSWindowBelow relativeTo:nil];
    self.view.window.title = @"File Encrypter";
    [self.view.window center];
    self.view.window.opaque = NO;
    self.view.window.backgroundColor = [NSColor clearColor];
    
    [self.view.window makeFirstResponder:self.view];
    NSTextField *filePathTextField = [[NSTextField alloc] initWithFrame:NSMakeRect(0, 50, 300, 20)];
    filePathTextField.editable = NO;
    filePathTextField.selectable = NO;
    filePathTextField.placeholderString = @"No file selected";

    [self.view addSubview:filePathTextField];
    NSButton *selectFileButton = [[NSButton alloc] initWithFrame:NSMakeRect(310, 50, 100, 30)];
    selectFileButton.bezelStyle = NSBezelStyleRegularSquare;
    [selectFileButton setTitle:@"Select File"];
    [self.view.window makeFirstResponder:selectFileButton];
    [selectFileButton setTarget:self];
    [selectFileButton setAction:@selector(selectFileButtonAction:)];
    [self.view addSubview:selectFileButton];
    NSButton *encryptFileButton = [[NSButton alloc] initWithFrame:NSMakeRect(310, 10, 100, 30)];
    encryptFileButton.bezelStyle = NSBezelStyleRegularSquare;
    [encryptFileButton setTitle:@"Encrypt File"];
    [encryptFileButton setHidden:YES];
    [encryptFileButton setTarget:self];
    [self.view addSubview:encryptFileButton];
    NSProgressIndicator *loadingIndicator = [[NSProgressIndicator alloc] initWithFrame:NSMakeRect(0, 100, 300, 20)];
    // loadingIndicator style
    loadingIndicator.style = NSProgressIndicatorStyleBar;
    loadingIndicator.indeterminate = YES;
    [loadingIndicator setHidden:YES];
    [self.view addSubview:loadingIndicator];

    // Add a decrypt button
    NSButton *decryptFileButton = [[NSButton alloc] initWithFrame:NSMakeRect(310, 90, 100, 30)];
    decryptFileButton.bezelStyle = NSBezelStyleRegularSquare;
    [decryptFileButton setTitle:@"Decrypt File"];
    [decryptFileButton setHidden:YES];
    [decryptFileButton setTarget:self];
    [decryptFileButton setAction:@selector(decryptFileButtonAction)];
    [self.view addSubview:decryptFileButton];

    
}
- (void)selectFileButtonAction:(NSString *)action {
    NSOpenPanel *openPanel = [NSOpenPanel openPanel];
    openPanel.animationBehavior = NSWindowAnimationBehaviorDocumentWindow;
    openPanel.allowsMultipleSelection = NO;
    openPanel.canChooseDirectories = NO;
    openPanel.canChooseFiles = YES;
    [openPanel beginWithCompletionHandler:^(NSInteger result) {
        if (result == NSModalResponseOK) {
            NSString *filePath = openPanel.URL.path;
            [self.view.subviews[1] setStringValue:filePath];
            [self.view.subviews[3] setAction:@selector(encryptFileButtonAction)];
            [self.view.subviews[3] setHidden:NO];
            [self.view.subviews[5] setHidden:NO];
        }
    }];

}


- (void)encryptFileButtonAction {
    NSString *filePath = [self.view.subviews[1] stringValue];
    [self.view.subviews[3] setHidden:YES];
    [self.view.subviews[4] setHidden:NO];
    [self.view.subviews[4] startAnimation:nil];
   
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSData *fileData = [NSData dataWithContentsOfFile:filePath];
        NSData *encryptedData = [self encryptData:fileData];
        // set ecrypted data extension
        NSString *encryptedFilePath = [filePath stringByAppendingString:@""];
        [encryptedData writeToFile:encryptedFilePath atomically:YES];
        dispatch_async(dispatch_get_main_queue(), ^{
            sleep(2);
            [self.view.subviews[4] setHidden:YES];
            [self.view.subviews[4] stopAnimation:nil];
            [self.view.subviews[3] setHidden:NO];
            [self.view.subviews[1] setStringValue:@"No file selected"];
            if (encryptedData) {
                NSAlert *alert = [[NSAlert alloc] init];
                alert.messageText = @"File encrypted successfully";
                alert.informativeText = [NSString stringWithFormat:@"Encrypted file saved at %@", encryptedFilePath];
                [alert addButtonWithTitle:@"OK"];
                [alert runModal];
            }
            else {
                NSAlert *alert = [[NSAlert alloc] init];
                alert.messageText = @"File encryption failed";
                alert.informativeText = @"Please try again";
                [alert addButtonWithTitle:@"OK"];
                [alert runModal];
            }
        });
    });

}   

-(NSString *) hexStringFromData:(NSData *)data {
    const unsigned char *dataBuffer = (const unsigned char *)[data bytes];
    if (!dataBuffer)
        return [NSString string];
    NSUInteger dataLength  = [data length];
    NSMutableString *hexString  = [NSMutableString stringWithCapacity:(dataLength * 2)];
    for (int i = 0; i < dataLength; ++i)
        [hexString appendString:[NSString stringWithFormat:@"%02lx", (unsigned long)dataBuffer[i]]];
    return [NSString stringWithString:hexString];
}


-(NSData *)encryptData:(NSData *)data {
    NSData *key = [@"1234567890123456" dataUsingEncoding:NSUTF8StringEncoding];
    // use hashing algorithm to generate 256 bit key
    NSData *hashedKey = [self sha256:key];
    NSData *iv = [@"1234567890123456" dataUsingEncoding:NSUTF8StringEncoding];
    NSData *encryptedData = [self aes256Encrypt:data key:hashedKey iv:iv];
    return encryptedData;
}

-(NSData *)sha256:(NSData *)data {
    uint8_t digest[CC_SHA256_DIGEST_LENGTH];
    CC_SHA256(data.bytes, (CC_LONG)data.length, digest);
    return [NSData dataWithBytes:digest length:CC_SHA256_DIGEST_LENGTH];
}

-(NSData *)aes256Encrypt:(NSData *)data key:(NSData *)key iv:(NSData *)iv {
    size_t bufferSize = data.length + kCCBlockSizeAES128;
    void *buffer = malloc(bufferSize);
    size_t numBytesEncrypted = 0;
    CCCryptorStatus cryptStatus = CCCrypt(kCCEncrypt, kCCAlgorithmAES128, kCCOptionPKCS7Padding, key.bytes, kCCKeySizeAES256, iv.bytes, data.bytes, data.length, buffer, bufferSize, &numBytesEncrypted);
    if (cryptStatus == kCCSuccess) {
        return [NSData dataWithBytesNoCopy:buffer length:numBytesEncrypted];
    }
    free(buffer);
    return nil;
}


-(NSData *)aes256Decrypt:(NSData *)data key:(NSData *)key iv:(NSData *)iv {
    size_t bufferSize = data.length + kCCBlockSizeAES128;
    void *buffer = malloc(bufferSize);
    size_t numBytesDecrypted = 0;
    CCCryptorStatus cryptStatus = CCCrypt(kCCDecrypt, kCCAlgorithmAES128, kCCOptionPKCS7Padding, key.bytes, kCCKeySizeAES256, iv.bytes, data.bytes, data.length, buffer, bufferSize, &numBytesDecrypted);
    if (cryptStatus == kCCSuccess) {
        return [NSData dataWithBytesNoCopy:buffer length:numBytesDecrypted];
    }
    free(buffer);
    return nil;
}


-(NSData *)decryptData:(NSData *)data {
    NSData *key = [@"1234567890123456" dataUsingEncoding:NSUTF8StringEncoding];
    // use hashing algorithm to generate 256 bit key
    NSData *hashedKey = [self sha256:key];
    NSData *iv = [@"1234567890123456" dataUsingEncoding:NSUTF8StringEncoding];
    NSData *decryptedData = [self aes256Decrypt:data key:hashedKey iv:iv];
    return decryptedData;
}

- (void)decryptFileButtonAction {
    NSString *filePath = [self.view.subviews[1] stringValue];
    [self.view.subviews[3] setHidden:YES];
    [self.view.subviews[4] setHidden:NO];
    [self.view.subviews[4] startAnimation:nil];
   
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSData *fileData = [NSData dataWithContentsOfFile:filePath];
        NSData *decryptedData = [self decryptData:fileData];
        // set ecrypted data extension
        NSString *decryptedFilePath = [filePath stringByAppendingString:@""];
        [decryptedData writeToFile:decryptedFilePath atomically:YES];
        dispatch_async(dispatch_get_main_queue(), ^{
            sleep(2);
            [self.view.subviews[4] setHidden:YES];
            [self.view.subviews[4] stopAnimation:nil];
            [self.view.subviews[3] setHidden:NO];
            [self.view.subviews[1] setStringValue:@"No file selected"];
            if (decryptedData) {
                NSAlert *alert = [[NSAlert alloc] init];
                alert.messageText = @"File decrypted successfully";
                alert.informativeText = [NSString stringWithFormat:@"Decrypted file saved at %@", decryptedFilePath];
                [alert addButtonWithTitle:@"OK"];
                [alert runModal];
            }
            else {
                NSAlert *alert = [[NSAlert alloc] init];
                alert.messageText = @"File decryption failed";
                alert.informativeText = @"Please try again";
                [alert addButtonWithTitle:@"OK"];
                [alert runModal];
            }
        });
    });

}



- (void)setRepresentedObject:(id)representedObject {
    [super setRepresentedObject:representedObject];

    // Update the view, if already loaded.
}


@end
