//
//  Use this file to import your target's public headers that you would like to expose to Swift.
//

#include <Foundation/Foundation.h>

@class FileEncrypter;

@interface FileEncrypter 

-(NSData *)encrypt:(NSData *)data withKey:(NSString *)key;
-(NSData *)decrypt:(NSData *)data withKey:(NSString *)key;

@end
