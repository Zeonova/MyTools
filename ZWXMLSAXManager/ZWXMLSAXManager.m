

#import "ZWXMLSAXManager.h"

@implementation ZWXMLSAXManager
+(instancetype)sharedManager
{
    static id instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [self new];
    });
    return instance;
}
-(void)parseWithURLString:(NSString *)URL parseEnd:(parseEndBlock)parseEnd andTestMod:(BOOL)test
{
    ZWXMLSAXParse *parse = [ZWXMLSAXParse XMLSAXParseWithURLString:URL parseEnd:parseEnd andTestMod:test];
    [parse beginParse];
}
@end
