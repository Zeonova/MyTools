

#import <Foundation/Foundation.h>
typedef void (^parseEndBlock)(NSArray *parseXMLcontents);
@interface ZWXMLSAXParse : NSObject
+ (instancetype)XMLSAXParseWithURLString:(NSString *)URL parseEnd:(parseEndBlock)parseEnd andTestMod:(BOOL)test;
///开始解析
- (void)beginParse;
@end
