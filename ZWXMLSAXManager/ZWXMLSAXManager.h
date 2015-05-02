
#import <Foundation/Foundation.h>
#import "ZWXMLSAXParse.h"
@interface ZWXMLSAXManager : NSObject
+(instancetype)sharedManager;
/**
 *  解析xml,解析完成后以数组包含字典的形式进行回调,目前只支持一层数据解析
 *
 *  @param URL      xml文件路径
 *  @param parseEnd 解析完成后以数组包含字典的形式的回调
 *  @param test     测试模式，输出各个阶段的NSLog
 */
-(void)parseWithURLString:(NSString *)URL parseEnd:(parseEndBlock)parseEnd andTestMod:(BOOL)test;
@end
