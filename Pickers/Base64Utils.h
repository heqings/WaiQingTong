//
//  Base64Utils.h
//  Pickers
//
//  Created by 张飞 on 12-3-28.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Base64Utils : NSData
+ (id)dataWithBase64EncodedString:(NSString *)string; 
+ (NSString *)base64Encoding:(NSData *)data;
@end
