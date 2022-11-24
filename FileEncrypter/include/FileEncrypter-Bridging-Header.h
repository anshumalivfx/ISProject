//
//  Use this file to import your target's public headers that you would like to expose to Swift.
//

#include <Foundation/Foundation.h>

@class FileEncrypter;

@interface Crypt : NSObject

-(NSString *) encryptFile: (NSString *) path withKey:(NSString *) key;
-(NSString *) decryptFile: (NSString *) path withKey:(NSString *) key;

@end
