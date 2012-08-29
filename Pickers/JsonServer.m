//
//  JsonServer.m
//  Pickers
//
//  Created by  on 12-3-27.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "JsonServer.h"
#import "Global.h"
#import "NetUtils.h"
#import "JSON.h"
#import "SignIn.h"
#import "User.h"
#import "AppGlobalServices.h"
@implementation JsonServer
static NSString * const BOUNDRY        = @"--------------------------7d71a819230404";
+(NSDictionary*)updateUserInfoToServer:(User *)ds
{
    
    
    NSMutableDictionary* nmd = [NSMutableDictionary dictionary];
    [nmd setValue:[Global getKey] forKey:@"key"];
    [nmd setValue:ds.email forKey:@"email"];
    [nmd setValue:ds.nicke forKey:@"nicke"];
    [nmd setValue:ds.sex forKey:@"sex"];
    [nmd setValue:ds.area forKey:@"area"];
    [nmd setValue:ds.topimage forKey:@"topimg"];
    [nmd setValue:ds.autograph forKey:@"autograph"];
    [nmd setValue:ds.imei forKey:@"imei"];
    [nmd setValue:ds.token forKey:@"token"];
    [nmd setValue:@"IOS" forKey:@"mobiletype"];
    NSString *json=[nmd JSONRepresentation];
    
    NSMutableData *postBody = [NSMutableData data];
    NSString *param =[NSString stringWithFormat:@"param=%@",json];
    [postBody appendData:[param dataUsingEncoding: NSUTF8StringEncoding allowLossyConversion:YES]]; 
    NSData  *returnData=[NetUtils synPostData:postBody method:@"mobileterminal/updatemobileterminal"];
    
    NSString *retrunVal = [[NSString alloc] initWithData:returnData encoding:NSUTF8StringEncoding];
    
    NSDictionary *result= [retrunVal JSONValue];
    
    if(![[result objectForKey:@"result"]isEqualToString:@"success"])
    {
        NSException* e  = [NSException exceptionWithName:@"UpdateUserInfoToServerError" reason:
                           [result objectForKey:@"msg"]
                                                userInfo:nil];
        @throw e;
    }
    return result;
}
+(NSDictionary*)getUserInfo:(NSString*)imei Key:(NSString*)key
{
    NSDictionary *dic=[
                       [NSDictionary alloc] 
                       initWithObjects:
                       [NSArray arrayWithObjects:imei,key,nil]
                       forKeys:[NSArray arrayWithObjects:@"imei",@"key",nil]
                       ];
    NSString *json=[dic JSONRepresentation];
    NSMutableData *postBody = [NSMutableData data];
    NSString *param =[NSString stringWithFormat:@"param=%@",json];
    [postBody appendData:[param dataUsingEncoding: NSUTF8StringEncoding allowLossyConversion:YES]]; 
    NSData *returnData=[NetUtils synPostData:postBody method:@"mobileterminal/getmobileterminal"];
    NSString *retrunVal = [[NSString alloc] initWithData:returnData encoding:NSUTF8StringEncoding];
    
    NSDictionary *result= [retrunVal JSONValue];
    if(![[result objectForKey:@"result"]isEqualToString:@"success"])
    {
        NSException* e  = [NSException exceptionWithName:@"getUserError" reason:
                           [result objectForKey:@"msg"]
                                                userInfo:nil];
        @throw e;
    }
    
    return result;
    
}
+(NSDictionary*)updateVisitstatus:(User*)user np_id:(int)np_id
{
    
    NSDictionary *dic=[
                       [NSDictionary alloc] 
                       initWithObjects:
                       [NSArray arrayWithObjects:[NSString stringWithFormat:@"%i",np_id],[Global getKey],user.imei,nil]
                       forKeys:[NSArray arrayWithObjects:@"visitId",@"key",@"imei",nil]
                       ];
    
    NSString *json=[dic JSONRepresentation];
    NSMutableData *postBody = [NSMutableData data];
    NSString *param =[NSString stringWithFormat:@"param=%@",json];
    [postBody appendData:[param dataUsingEncoding: NSUTF8StringEncoding allowLossyConversion:YES]]; 
    NSData  *returnData=[NetUtils synPostData:postBody method:@"visit/updateVisitstatus"];
    
    NSString *retrunVal = [[NSString alloc] initWithData:returnData encoding:NSUTF8StringEncoding];
    
    NSDictionary *result= [retrunVal JSONValue];
    
    if(![[result objectForKey:@"result"]isEqualToString:@"success"])
    {
        NSException* e  = [NSException exceptionWithName:@"visit/updateVisitstatus" reason:
                           [result objectForKey:@"msg"]
                                                userInfo:nil];
        @throw e;
    }
    return result;

}
+(NSDictionary*)sumitattendance:(User*)user lat:(float)lat lng:(float)lng address:(NSString*)address
{
    NSDictionary *dic=[
                       [NSDictionary alloc] 
                       initWithObjects:
                       [NSArray arrayWithObjects:[NSString stringWithFormat:@"%f", lat],[NSString stringWithFormat:@"%f", lng],address,[Global getKey],user.imei,nil]
                       forKeys:[NSArray arrayWithObjects:@"lat",@"lng",@"address",@"key",@"imei",nil]
                       ];
    NSString *json=[dic JSONRepresentation];
    NSMutableData *postBody = [NSMutableData data];
    NSString *param =[NSString stringWithFormat:@"param=%@",json];
    [postBody appendData:[param dataUsingEncoding: NSUTF8StringEncoding allowLossyConversion:YES]]; 
    NSData *returnData=[NetUtils synPostData:postBody method:@"attendance!sumitattendance.action"];
    NSString *retrunVal = [[NSString alloc] initWithData:returnData encoding:NSUTF8StringEncoding];
    
    NSDictionary *result= [retrunVal JSONValue];
    if(![[result objectForKey:@"result"]isEqualToString:@"success"])
    {
        NSException* e  = [NSException exceptionWithName:@"getUserError" reason:
                           [result objectForKey:@"msg"]
                                                userInfo:nil];
        @throw e;
    }
    
    return result;
    
}
+(void)saveSignIn:(User*)user signIn:(SignIn*)signIn;
{
    
   
    NSDictionary *dic=[
                       [NSDictionary alloc] 
                       initWithObjects:
                       [NSArray arrayWithObjects:signIn.OLat,signIn.OLng,signIn.signInType,signIn.signInName,signIn.signInRemark,signIn.signInAddress,[Global getKey],user.imei,nil]
                       forKeys:[NSArray arrayWithObjects:@"OLat",@"OLng",@"type",@"name",@"remark",@"address",@"key",@"imei",nil]
                       ];
    NSString *json=[dic JSONRepresentation];
   
    int len=512;
    NSMutableData  * postData =[NSMutableData dataWithCapacity:len];
    
    [postData  appendData: [[NSString  stringWithFormat:@"\r\n--%@\r\n",BOUNDRY] dataUsingEncoding:NSUTF8StringEncoding]];
    
    [postData  appendData: [[NSString  stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n",@"param" ] dataUsingEncoding:NSUTF8StringEncoding]];
    
    [postData  appendData:[[NSString   stringWithFormat:@"%@",json] dataUsingEncoding:NSUTF8StringEncoding]];
   
    NSArray* arry = [signIn.signInImgUrl componentsSeparatedByString:@"^"];
    for(int i=1;i<[arry count];i++)
    {
        NSString *path=[arry objectAtIndex:i];
        NSData* imgData = [NSData dataWithContentsOfFile:path];
      
        if(imgData !=nil){
            
            len = imgData.length + 512;
            
            [postData  appendData:[[NSString   stringWithFormat:@"\r\n--%@\r\n",BOUNDRY] dataUsingEncoding:NSUTF8StringEncoding]];
            NSString* fileName = [path lastPathComponent];
            [postData  appendData: [[NSString  stringWithFormat:@"Content-Disposition: form-data; name=\"%@\";filename=\"%@\"\r\nContent-Type: image/png\r\n\r\n",@"imageFile",fileName] dataUsingEncoding:NSUTF8StringEncoding]];
            [postData  appendData:imgData];
            
        }   
       
    }
     [postData  appendData:[[NSString stringWithFormat:@"\r\n--%@--\r\n",BOUNDRY] dataUsingEncoding:NSUTF8StringEncoding]];
      
        NSData *returnData=[NetUtils synPostMultiData:postData method:@"poi/savepoi"];
        NSString *retrunVal = [[NSString alloc] initWithData:returnData encoding:NSUTF8StringEncoding];
        
        
        NSDictionary *result= [retrunVal JSONValue];
        
        
        if(![[result objectForKey:@"result"]isEqualToString:@"success"])
        {
            NSException* e  = [NSException exceptionWithName:@"UploadTopImageError" reason:
                               [result objectForKey:@"msg"]
                                                    userInfo:nil];
            @throw e;
        }

}
+(NSArray*)getCompanGates:(User*)user
{
    NSArray* pyArray=[NSArray arrayWithObjects:@"A",@"B",@"C",@"D",@"E",@"F",@"G",@"H",@"I",@"J",@"K",@"L",@"M",@"N",@"O",@"P",@"Q",@"R",@"S",@"T",@"U",@"V",@"W",@"X",@"Y",@"Z", nil];
    NSDictionary *dic=[
                       [NSDictionary alloc] 
                       initWithObjects:
                       [NSArray arrayWithObjects:@"pinyin",user.imei,[Global getKey],nil]
                       forKeys:[NSArray arrayWithObjects:@"type",@"imei",@"key",nil]
                       ];
    
    NSString *json=[dic JSONRepresentation];
    NSMutableData *postBody = [NSMutableData data];
    NSString *param =[NSString stringWithFormat:@"param=%@",json];
    [postBody appendData:[param dataUsingEncoding: NSUTF8StringEncoding allowLossyConversion:YES]]; 
    NSData *returnData=[NetUtils synPostData:postBody method:@"mobileterminal!getcompanyters.action"];
    NSString *retrunVal = [[NSString alloc] initWithData:returnData encoding:NSUTF8StringEncoding];
    NSDictionary *result= [retrunVal JSONValue];
    NSMutableArray* peoples = [NSMutableArray arrayWithCapacity:10];
    for(int j=0;j<[pyArray count];j++){
        NSArray *array=[[result objectForKey:@"data"]objectForKey:[pyArray objectAtIndex:j]];
        if([array count]>0){
            for(int i=0;i<[array count];i++){
                People* p = [[People alloc]init ];
                p.name =[[array objectAtIndex:i]objectForKey:@"name"];
                p.spId =[[[array objectAtIndex:i]objectForKey:@"id"] intValue];
                p.imei =[[array objectAtIndex:i]objectForKey:@"imei"];
                p.namePinyin =[[array objectAtIndex:i]objectForKey:@"namePinyin"];
                p.nicke =[[array objectAtIndex:i]objectForKey:@"nicke"];
                p.nickPinyin =[[array objectAtIndex:i]objectForKey:@"nickPinyin"];
                p.topimg =[[array objectAtIndex:i]objectForKey:@"topimg"];
                p.type =[[array objectAtIndex:i]objectForKey:@"type"];
                p.email =[[array objectAtIndex:i]objectForKey:@"email"];
                p.mobile =[[array objectAtIndex:i]objectForKey:@"mobile"];
                p.groupPy = [pyArray objectAtIndex:j] ;
                p.groupDp = @"";
                [peoples addObject:p];
            }
        }
    }
    
    return peoples;
}

+(NSDictionary *)getOffline:(NSString*)imei key:(NSString*)key
{
    NSDictionary *dic=[
                       [NSDictionary alloc] 
                       initWithObjects:
                       [NSArray arrayWithObjects:imei,key,nil]
                       forKeys:[NSArray arrayWithObjects:@"imei",@"key",nil]
                       ];
    NSString *json=[dic JSONRepresentation];
    NSMutableData *postBody = [NSMutableData data];
    NSString *param =[NSString stringWithFormat:@"param=%@",json];
    [postBody appendData:[param dataUsingEncoding: NSUTF8StringEncoding allowLossyConversion:YES]]; 
    NSData *returnData=[NetUtils synPostData:postBody method:@"mobileterminal/setonline"];
    NSString *retrunVal = [[NSString alloc] initWithData:returnData encoding:NSUTF8StringEncoding];
    
    NSDictionary *result= [retrunVal JSONValue];
    
    if(![[result objectForKey:@"result"]isEqualToString:@"success"])
    {
        NSException* e  = [NSException exceptionWithName:@"getAreajsonError" reason:
                           [result objectForKey:@"msg"]
                                                userInfo:nil];
        @throw e;
    }
    
    return result;
}
+(NSDictionary*)getAreajson:(NSString*)imei key:(NSString*)key
{
    NSDictionary *dic=[
                       [NSDictionary alloc] 
                       initWithObjects:
                       [NSArray arrayWithObjects:imei,key,nil]
                       forKeys:[NSArray arrayWithObjects:@"imei",@"key",nil]
                       ];
    NSString *json=[dic JSONRepresentation];
    NSMutableData *postBody = [NSMutableData data];
    NSString *param =[NSString stringWithFormat:@"param=%@",json];
    [postBody appendData:[param dataUsingEncoding: NSUTF8StringEncoding allowLossyConversion:YES]]; 
    NSData *returnData=[NetUtils synPostData:postBody method:@"areaterminal/getareajson"];
    NSString *retrunVal = [[NSString alloc] initWithData:returnData encoding:NSUTF8StringEncoding];
    NSDictionary *result= [retrunVal JSONValue];
    
    if(![[result objectForKey:@"result"]isEqualToString:@"success"])
    {
        NSException* e  = [NSException exceptionWithName:@"getAreajsonError" reason:
                           [result objectForKey:@"msg"]
                                                userInfo:nil];
        @throw e;
    }
    
    return result;
}
+(NSDictionary*)getpoiByVisitPoiId:(NSDictionary*)dic
{
    NSString *json=[dic JSONRepresentation];
      NSMutableData *postBody = [NSMutableData data];
    NSString *param =[NSString stringWithFormat:@"param=%@",json];
    [postBody appendData:[param dataUsingEncoding: NSUTF8StringEncoding allowLossyConversion:YES]]; 
    NSData *returnData=[NetUtils synPostData:postBody method:@"poi/getpoiByVisitPoiId"];
    NSString *retrunVal = [[NSString alloc] initWithData:returnData encoding:NSUTF8StringEncoding];
    NSDictionary *result= [retrunVal JSONValue];
    
    if(![[result objectForKey:@"result"]isEqualToString:@"success"])
    {
        NSException* e  = [NSException exceptionWithName:@"registerUserError" reason:
                           [result objectForKey:@"msg"]
                                                userInfo:nil];
        @throw e;
    }
    
    return result;
}
+(NSDictionary*)registerUser:(NSDictionary*)dic
{
    NSString *json=[dic JSONRepresentation];

    NSMutableData *postBody = [NSMutableData data];
    NSString *param =[NSString stringWithFormat:@"param=%@",json];
    [postBody appendData:[param dataUsingEncoding: NSUTF8StringEncoding allowLossyConversion:YES]]; 
    NSData *returnData=[NetUtils synPostData:postBody method:@"mobileterminal/submitmobileterminal"];
    NSString *retrunVal = [[NSString alloc] initWithData:returnData encoding:NSUTF8StringEncoding];

    NSDictionary *result= [retrunVal JSONValue];
    
    if(![[result objectForKey:@"result"]isEqualToString:@"success"])
    {
        NSException* e  = [NSException exceptionWithName:@"registerUserError" reason:
                           [result objectForKey:@"msg"]
                                                userInfo:nil];
        @throw e;
    }
    
    return result;
}
+(NSDictionary*)loginUser:(NSDictionary*)dic
{
    
    NSString *json=[dic JSONRepresentation];
    NSMutableData *postBody = [NSMutableData data];
    NSString *param =[NSString stringWithFormat:@"param=%@",json];
    [postBody appendData:[param dataUsingEncoding: NSUTF8StringEncoding allowLossyConversion:YES]]; 
    NSData *returnData=[NetUtils synPostData:postBody method:@"mobileterminal/ioslogin"];
    NSString *retrunVal = [[NSString alloc] initWithData:returnData encoding:NSUTF8StringEncoding];
    
    
    NSDictionary *result= [retrunVal JSONValue];
    if(![[result objectForKey:@"result"]isEqualToString:@"success"])
    {
        NSException* e  = [NSException exceptionWithName:@"loginUserError" reason:
                           [result objectForKey:@"msg"]
                                                userInfo:nil];
        @throw e;
    }
    
    return result;
}

+(void)uploadUserTopImage:(User*)user

{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *imagePath = [documentsDirectory stringByAppendingPathComponent:user.topimage];
    NSString* json =[NSString stringWithFormat:@"{\"imei\":\"%@\",\"key\":\"%@\"}",user.imei,[Global getKey]];
    NSData* imgData = [NSData dataWithContentsOfFile:imagePath];
    int len=512;
    
    if(imgData !=nil){
        
        len = imgData.length + 512;
        
    }
    NSMutableData  * postData =[NSMutableData dataWithCapacity:len];
    
    
    
    [postData  appendData: [[NSString  stringWithFormat:@"\r\n--%@\r\n",BOUNDRY] dataUsingEncoding:NSUTF8StringEncoding]];
    
    [postData  appendData: [[NSString  stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n",@"param" ] dataUsingEncoding:NSUTF8StringEncoding]];
    
    [postData  appendData:[[NSString   stringWithFormat:@"%@",json] dataUsingEncoding:NSUTF8StringEncoding]];
    
    
    if (imgData != nil ) {
        
        [postData  appendData:[[NSString   stringWithFormat:@"\r\n--%@\r\n",BOUNDRY] dataUsingEncoding:NSUTF8StringEncoding]];
        NSArray* arr = [imagePath pathComponents];
        NSString * str = [arr objectAtIndex:arr.count-1];
        [postData  appendData: [[NSString  stringWithFormat:@"Content-Disposition: form-data; name=\"%@\";filename=\"%@\"\r\nContent-Type: image/png\r\n\r\n",@"imageFile",str] dataUsingEncoding:NSUTF8StringEncoding]];
        [postData  appendData:imgData];
        
    }   
    
    [postData  appendData:[[NSString stringWithFormat:@"\r\n--%@--\r\n",BOUNDRY] dataUsingEncoding:NSUTF8StringEncoding]];

    NSData *returnData=[NetUtils synPostMultiData:postData method:@"mobileterminal/uploadphoto"];
    NSString *retrunVal = [[NSString alloc] initWithData:returnData encoding:NSUTF8StringEncoding];
    
    
    NSDictionary *result= [retrunVal JSONValue];
    
    
    if(![[result objectForKey:@"result"]isEqualToString:@"success"])
    {
        NSException* e  = [NSException exceptionWithName:@"UploadTopImageError" reason:
                           [result objectForKey:@"msg"]
                                                userInfo:nil];
        @throw e;
    }
}
+(void)downloadUserTopImage:(NSString*)fileName
{

   AppGlobalServices* gns = [AppGlobalServices getConnection];
   NSDictionary* ds =  [gns findAll];

    NSString* imgURL=[ds valueForKey:@"t_downloadtopimgurl"];
    NSString *action  = [NSString stringWithFormat:@"%@%@",imgURL,fileName];
    
    NSData * retrunData=[NetUtils synGetHttpFile:action];
    fileName= [fileName lastPathComponent];

    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *imagePath = [documentsDirectory stringByAppendingPathComponent:fileName];

    
    [retrunData writeToFile:imagePath atomically:false];
}
@end
