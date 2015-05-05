//
//  MRZNewXMLparser.m
//  
//
//  Created by 疯兔 on 15/5/5.
//
//

#import "MRZNewXMLparser.h"
@interface MRZNewXMLparser ()<NSXMLParserDelegate>
@property (nonatomic,strong)NSMutableString *parsedData;
@property (nonatomic,strong)NSMutableArray *objectArray;
@property (nonatomic,strong)NSMutableDictionary *resulitObject;
@end
@implementation MRZNewXMLparser
- (NSDictionary *)parseData:(NSData *)XMLData
{
    
    NSXMLParser *parser = [[NSXMLParser alloc] initWithData:XMLData];
    
    [parser setDelegate:self];
    
    if ([parser parse] == YES)
        return _resulitObject;
    
    return nil;
}
-(void)parserDidStartDocument:(NSXMLParser *)parser
{
    [NSThread currentThread].name = @"XML";
    NSLog(@"1.打开文档%@",[NSThread currentThread]);
    _objectArray = [NSMutableArray array];
    _resulitObject = [NSMutableDictionary dictionary];
    
}

-(void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict
{
    _parsedData = [NSMutableString string];
    
    
    if ([attributeDict count]) {
        [_objectArray addObject:elementName];
        [_resulitObject setObject:[NSMutableDictionary dictionaryWithDictionary:attributeDict] forKey:elementName];
    }
}
-(void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
    [_parsedData appendString:string];
}
-(void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{
    NSMutableDictionary *tempDict = [_resulitObject objectForKey:[_objectArray lastObject]];
    if (_parsedData) {
        [tempDict setValue:_parsedData forKey:elementName];
        _parsedData = nil;
    }
    if ([elementName isEqualToString:[_objectArray lastObject]]) {
        [_objectArray removeLastObject];
        NSMutableDictionary *newDict = [_resulitObject objectForKey:[_objectArray lastObject]];
        [newDict setObject:tempDict forKey:elementName];
        if ([_objectArray count]) {
            [_resulitObject removeObjectForKey:elementName];
        }
        NSString *arrayPath = [NSString stringWithFormat:@"%@[]",elementName];
        if ([_resulitObject objectForKey:arrayPath]){
            NSMutableArray *array = [_resulitObject objectForKey:arrayPath];
            [array addObject:[_resulitObject objectForKey:elementName]];
            [_resulitObject removeObjectForKey:elementName];
        }
        if ([[_resulitObject objectForKey:elementName] isKindOfClass:[NSDictionary class]]) {
            NSMutableDictionary *tempChangeDict = [_resulitObject objectForKey:elementName];
            NSMutableArray *array = [NSMutableArray array];
            [array addObject:tempChangeDict];
            [_resulitObject setObject:array forKey:arrayPath];
        }
    }
    
    
}
-(void)parserDidEndDocument:(NSXMLParser *)parser
{
    for (NSString *key in _resulitObject.allKeys) {
        if ([key hasSuffix:@"[]"]) {
            NSString *newKey = [key substringToIndex:key.length - 2];
            [_resulitObject setObject:[_resulitObject objectForKey:key] forKey:newKey];
            [_resulitObject removeObjectForKey:key];
        }
    }
}
@end
