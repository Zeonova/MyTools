//
//  MRZNewXMLparser.h
//  
//
//  Created by 疯兔 on 15/5/5.
//
//

#import <Foundation/Foundation.h>

@interface MRZNewXMLparser : NSObject
- (NSDictionary *)parseData:(NSData *)XMLData;
@end
