//
//  NetUtils.h
//  Pickers
//
//  Created by air macbook on 12-2-19.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JSON.h"

@interface NetUtils : NSObject<NSURLConnectionDataDelegate,NSURLConnectionDelegate>{
    NSURLConnection *urlConnection;
    NSMutableURLRequest *urlRequest;
    NSTimeInterval requestTimeoutInterval;
    NSMutableData *activeData;
    SBJsonParser *jsonParser;
    NSMutableDictionary *connectionsForCallBackDict;
}
@property (nonatomic,strong)NSURLConnection *urlConnection;
@property (nonatomic,strong)NSMutableURLRequest *urlRequest;
@property (strong)NSMutableData *activeData;
@property (nonatomic)NSTimeInterval requestTimeoutInterval;
@property (nonatomic,strong)SBJsonParser *jsonParser;
@property (nonatomic,strong)NSMutableDictionary *connectionsForCallBackDict;

+ (id)shareNetworkHelper;
+(NSData *)synPostData:(NSMutableData *)postBody method:(NSString *)action;
+(NSData*)synGetHttpFile:(NSString*)action;
+(NSData *)synPostMultiData:(NSMutableData *)postBody method:(NSString *)action;
- (void)requestDataFromURL:(NSString*)action withParams:(NSMutableData*)params withHelperDelegate:(id)CallBackDelegate withSuccessRequestMethod:(NSString*)successMethod withFaildRequestMethod:(NSString*)faildMethod contentType:(bool)type;
@end
