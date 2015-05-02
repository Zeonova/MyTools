

#import "ZWXMLSAXParse.h"
@interface ZWXMLSAXParse()<NSXMLParserDelegate>
@property (nonatomic,strong)NSMutableArray *aryContents;
@property (nonatomic,strong)NSMutableDictionary *dictParseContents;
@property (nonatomic,strong)NSMutableString *elementString;
@property (nonatomic,copy)NSString *objectName;
@property (nonatomic,copy)NSString *fristName;
@property (nonatomic,assign,getter=isTest)BOOL Test;


#pragma mark - 类方法用参数
@property (nonatomic,copy)NSString *urlString;
@property (nonatomic,copy)parseEndBlock parseBlock;
@end

@implementation ZWXMLSAXParse
+(instancetype)XMLSAXParseWithURLString:(NSString *)URL parseEnd:(parseEndBlock)parseEnd andTestMod:(BOOL)test
{
    ZWXMLSAXParse *parse = [ZWXMLSAXParse new];
    parse.Test = test;
    parse.urlString = URL;
    parse.parseBlock = parseEnd;
    return parse;
}
- (void)beginParse
{
    NSURL *url = [NSURL URLWithString:self.urlString];
    NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:15];
    [NSURLConnection sendAsynchronousRequest:request queue:[[NSOperationQueue alloc]init] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        NSXMLParser *parser = [[NSXMLParser alloc]initWithData:data];
        parser.delegate = self;
        [parser parse];
    }];
}
#pragma mark - NSXMLParserDelegate
// 1. 打开文档
-(void)parserDidStartDocument:(NSXMLParser *)parser
{
    if (self.isTest) {
        [NSThread currentThread].name = @"XML";
        NSLog(@"1.打开文档%@",[NSThread currentThread]);
    }
    [self.aryContents removeAllObjects];
}
// 2. 开始节点 - "Element" 元素 节点
- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict
{
    if (self.isTest) {
        NSLog(@"2. 开始节点 %@", elementName);
    }
    if (self.fristName == nil) {
        self.fristName = elementName;
    }
    if ([attributeDict allKeys].count != 0) {
        if (self.isTest) {
            NSLog(@"发现对象%@",attributeDict);
        }
        self.dictParseContents = [[NSMutableDictionary alloc]init];
        [self.dictParseContents setDictionary:attributeDict];
        self.objectName = elementName;
    }
    [self.elementString setString:@""];
}

// 3. 发现节点的内容
- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string {
    
    [self.elementString appendString:string];
    if (self.isTest) {
        NSLog(@"节点内容==> %@", self.elementString);
    }
}
// 4. 结束节点
- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{
    if (self.isTest) {
        NSLog(@"4. 结束节点 %@", elementName);
    }
    if ([elementName isEqualToString:self.objectName]) {
        [self.aryContents addObject:self.dictParseContents];
    } else if (![elementName isEqualToString:self.fristName]) {
        [self.dictParseContents setValue:self.elementString forKey:elementName];
    }
}
// 5. 结束文档
- (void)parserDidEndDocument:(NSXMLParser *)parser {
    if (self.isTest) {
        NSLog(@"5. 结束文档 %@  %@", self.aryContents, [NSThread currentThread]);
    }
    if (self.parseBlock) {
        dispatch_async(dispatch_get_main_queue(), ^{
            self.parseBlock(self.aryContents);
        });
    }
    self.fristName = nil;
}
#pragma mark - other
- (NSMutableArray *)aryContents {
    if (_aryContents == nil) {
        _aryContents = [[NSMutableArray alloc] init];
    }
    return _aryContents;
}

- (NSMutableString *)elementString {
    if (_elementString == nil) {
        _elementString = [[NSMutableString alloc] init];
    }
    return _elementString;
}
@end
