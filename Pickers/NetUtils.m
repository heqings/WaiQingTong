//
//  NetUtils.m
//  Pickers
//
//  Created by air macbook on 12-2-19.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "NetUtils.h"
#import "AppGlobalServices.h"
static NetUtils *shareHelper;
@implementation NetUtils
@synthesize urlConnection,urlRequest,activeData,requestTimeoutInterval,jsonParser,connectionsForCallBackDict;

//是否有网络请求
//[ASIHTTPRequest isNetworkInUse];

//是否显示网络请求信息在status bar上
//[ASIHTTPRequest setShouldUpdateNetworkActivityIndicator:YES];

+ (id)shareNetworkHelper
{
    @synchronized(self){
        if (!shareHelper) {
            shareHelper = [[NetUtils alloc]init];
        }
    }
    return shareHelper;
}

- (id)init{
    self = [super init];
    if (self) {
        self.requestTimeoutInterval = 30;
        self.jsonParser = [[SBJsonParser alloc]init];
        self.connectionsForCallBackDict = [[NSMutableDictionary alloc]initWithCapacity:0];
         }
    return self;
}

+(NSData*)synGetHttpFile:(NSString*)action
{

    NSURL* url =[NSURL URLWithString:action];

    NSMutableURLRequest *urlRequest = [[NSMutableURLRequest alloc] initWithURL:url]; 
    NSError* err = nil;
    NSData *returnData = [NSURLConnection sendSynchronousRequest:urlRequest returningResponse:nil error:&err];
    if(err !=nil)
    {

        NSException* e  = [NSException exceptionWithName:@"NetError" reason:
                           [err localizedDescription] 
                                                userInfo:nil];
        @throw e;
        
    }

    return returnData;
}

//post发送数据,如果请求失败，返回null值
+(NSData *)synPostData:(NSMutableData *)postBody method:(NSString *)action{
    AppGlobalServices* gs =[AppGlobalServices getConnection];
    NSDictionary* ns = [gs findAll];
    NSString* netURL = [ns valueForKey:@"t_url"];

    NSURL *url =[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", netURL,action]]; 
    NSMutableURLRequest *urlRequest = [[NSMutableURLRequest alloc] initWithURL:url]; 
    [urlRequest setHTTPMethod:@"POST"];
    [urlRequest setHTTPBody:postBody];
    NSError* err=nil;
    NSData *returnData = [NSURLConnection sendSynchronousRequest:urlRequest returningResponse:nil error:&err];
    if(err !=nil)
    {
       
        NSException* e  = [NSException exceptionWithName:@"NetError" reason:
                           [err localizedDescription] 
                                                userInfo:nil];
        @throw e;
        
    }

    return returnData;
}
+(NSData *)synPostMultiData:(NSMutableData *)postBody method:(NSString *)action{
    AppGlobalServices* gs =[AppGlobalServices getConnection];
    NSDictionary* ns = [gs findAll];
    NSString* netURL = [ns valueForKey:@"t_url"];

    NSURL *url =[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",netURL,action]]; 
    NSMutableURLRequest *urlRequest = [[NSMutableURLRequest alloc] initWithURL:url]; 
    [urlRequest setHTTPMethod:@"POST"];
    [urlRequest setValue: [NSString stringWithFormat:@"multipart/form-data; boundary=%@", @"--------------------------7d71a819230404"]forHTTPHeaderField:@"Content-Type"];
    [urlRequest setHTTPBody:postBody];
    NSError* err=nil;
    NSData *returnData = [NSURLConnection sendSynchronousRequest:urlRequest returningResponse:nil error:&err];
    if(err !=nil)
    {
        //
        NSException* e  = [NSException exceptionWithName:@"NetError" reason:
                           [err localizedDescription] 
                                                userInfo:nil];
        @throw e;
        
    }
    return returnData;
}
//请求数据
- (void)requestDataFromURL:(NSString *)action withParams:(NSMutableData *)params withHelperDelegate:(id)CallBackDelegate withSuccessRequestMethod:(NSString*)successMethod withFaildRequestMethod:(NSString*)faildMethod contentType:(bool)type
{
    AppGlobalServices* gs =[AppGlobalServices getConnection];
    NSDictionary* ns = [gs findAll];
    NSString* netURL = [ns valueForKey:@"t_url"];

    NSURL *url =[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",netURL,action]]; 
    
    //接收callbackDelegate 和 成功调用方法 失败调用方法
    NSDictionary *callBackDict = [NSDictionary dictionaryWithObjectsAndKeys:CallBackDelegate,@"delegate",successMethod,@"success",faildMethod,@"faild", nil];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    //设置请求参数
    request.HTTPMethod = @"POST";
    request.timeoutInterval = self.requestTimeoutInterval;
    request.cachePolicy = NSURLRequestUseProtocolCachePolicy;
    request.HTTPBody = params;

    if(type){
        NSString *stringBoundary = @"--------------------------7d71a819230404";
        NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@", stringBoundary];
        [request setValue:contentType forHTTPHeaderField:@"Content-Type"]; 
    }
     
    
    //判断当前请求是否为空对象,是则清空，否则创建连接
    if (nil != urlConnection ) {
        
        urlConnection = nil;
    }
    urlConnection = [[NSURLConnection alloc]initWithRequest:request delegate:self];

    //判断当前存储是否有数据，是则清空，否则创建
    if (nil != activeData) {
        activeData = nil;
    }
    activeData = [[NSMutableData alloc]initWithLength:0];
    
    //存储新建连接的所有信息
    [connectionsForCallBackDict setObject:callBackDict forKey:[NSNumber numberWithLongLong:[urlConnection hash]]];
    
    //开始请求
    //    [_urlConnection start];    
}

- (void)alertWithErrorCode:(NSInteger)errorCode
{
    NSString *errorMessage = nil;
    switch (errorCode) {
        case NSURLErrorBadURL:
            errorMessage = @"网络地址无效";
            break;
        case NSURLErrorCannotConnectToHost:
            errorMessage = @"服务器没有响应";
            break;
        case NSURLErrorCannotFindHost:
            errorMessage = @"无法找到指定主机";
            break;
        case NSURLErrorCannotParseResponse:
            errorMessage = @"无法解析回复";
            break;
        case NSURLErrorBadServerResponse:
            errorMessage = @"错误得服务器返回";
            break;
            
        default:
            errorMessage = nil;
            break;
    }
    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"网络错误" message:errorMessage delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [alertView show];
}

#pragma mark - 
#pragma mark connectionDelegate
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    //重新接收数据
    if (activeData != nil) {
        activeData = nil;
    }
    activeData = [[NSMutableData alloc]initWithLength:0];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    [self alertWithErrorCode:[error code]];//错误处理
    
    //获取connection匹配
    NSNumber *connectionKey = [NSNumber numberWithLongLong:[connection hash]];
    
    //执行失败响应方法 
    for (id key in [connectionsForCallBackDict keyEnumerator]) {
        if ([key longLongValue] == [connectionKey longLongValue]) {
            //获取当前connection对应的dict
            NSDictionary *connectDict = [connectionsForCallBackDict objectForKey:key];
            
            //执行代理方法
            [[connectDict objectForKey:@"delegate"] performSelector:NSSelectorFromString([connectDict objectForKey:@"faild"]) withObject:@"Request Faild!"];
            break;
        }
    }
    [connectionsForCallBackDict removeObjectForKey:connectionKey];//移除这个连接
    
}
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{    
    
    //将数据存储到活动数据缓存中收集
    [activeData appendData:data];
    
}
//收取数据完了开始解析传递给请求得对象
- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    //获取connection匹配
    NSNumber *connectionKey = [NSNumber numberWithLongLong:[connection hash]];
    
    //将data转化为dict
    NSDictionary *resultDict = [jsonParser objectWithData:activeData];
    
    //将数据传递给请求者
    for (id key in [connectionsForCallBackDict keyEnumerator]) {
        if ([key  longLongValue] == [connectionKey longLongValue]) {
            //获取当前connection对应的dict
            NSDictionary *connectDict = [connectionsForCallBackDict objectForKey:key];
            
            //执行代理方法
            [[connectDict objectForKey:@"delegate"] performSelector:NSSelectorFromString([connectDict objectForKey:@"success"]) withObject:resultDict];
            
        }
        
    }
    [connectionsForCallBackDict removeObjectForKey:connectionKey];//移除连接
    //将活动数据设为空，重新接收新数据
    activeData = nil;
}

@end
