

#import <Foundation/Foundation.h>

@interface NSString (SandboxPath)
///请传入URL文件路径字符串
- (NSString *)appendDocumentDir;
///请传入URL文件路径字符串
- (NSString *)appendCacheDir;
///请传入URL文件路径字符串
- (NSString *)appendTmpDir;
@end
