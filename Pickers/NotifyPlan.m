//
//  NotifyPlan.m
//  Pickers
//
//  Created by 张飞 on 12-4-10.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "NotifyPlan.h"
#import "JsonServer.h"
#import "NotifyPoiServices.h"
@implementation NotifyPlan

+(void)runNotifyPlan:(NSDictionary *)dic{
    @try{
        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);//手机震动
        NotifyServices *notifyConn=[NotifyServices getConnection];
        Notify *notify=[notifyConn findByParam:@"nt_type" param:[Global getNOTIFY_BF]];
        NotifyPlanServices *notifyPlanConn=[NotifyPlanServices getConnection];
        
        NSString *title=[NSString stringWithString:[[dic objectForKey:@"body"]objectForKey:@"visit_content"]];
        NSString *msgTitle;
        if(title.length>10){
            msgTitle=[title substringToIndex:10];
            msgTitle=[msgTitle stringByAppendingString:@"..."];
        }else{
            msgTitle=title;
        }
        
        if(notify.ntType==nil){
            [notifyConn insertNotify:@"拜访信息" isRead:@"N" readCount:0 ntDate:[Global getCurrentTime] toUser:@"" groupId:@"" ntType:[Global getNOTIFY_BF] detailText:msgTitle];
        }
        
        Notify *tempNotify=[notifyConn findByParam:@"nt_type" param:[Global getNOTIFY_BF]];
        int spId = [[[dic objectForKey:@"body"]objectForKey:@"serverid_id"] intValue];
        
        NotifyPlanE *plan=[[NotifyPlanE alloc]init];
        plan.ntId=tempNotify.ntId;
        plan.spId=spId;
        plan.npContent=[[dic objectForKey:@"body"]objectForKey:@"visit_content"];
        plan.createDate=[[dic objectForKey:@"body"]objectForKey:@"create_time"];
        plan.createUser=[[dic objectForKey:@"body"]objectForKey:@"create_user"];
        plan.endTime=[[dic objectForKey:@"body"]objectForKey:@"over_time"];
        plan.startTime=[[dic objectForKey:@"body"]objectForKey:@"start_time"];
        
        [notifyPlanConn insertNotifyPlan:plan];
        
        NotifyPlanE *newPlan=[notifyPlanConn findBySpId:spId];
        
        NSData* userData = [[NSUserDefaults standardUserDefaults] objectForKey:@"User"];
        User *user = [NSKeyedUnarchiver unarchiveObjectWithData:userData];
        
        NSDictionary *dict=[
                           [NSDictionary alloc] 
                           initWithObjects:
                           [NSArray arrayWithObjects:[[dic objectForKey:@"body"]objectForKey:@"serverid_id"],[Global getKey],user.imei,nil]
                           forKeys:[NSArray arrayWithObjects:@"serverid_id",@"key",@"imei",nil]
                           ];
        
        NSString *json=[dict JSONRepresentation];
        NSMutableData *postBody = [NSMutableData data];
        NSString *param =[NSString stringWithFormat:@"param=%@",json];
        [postBody appendData:[param dataUsingEncoding: NSUTF8StringEncoding allowLossyConversion:YES]]; 
        NSData *returnData=[NetUtils synPostData:postBody method:@"poi/getpoiByVisitPoiId"];
        NSString *retrunVal = [[NSString alloc] initWithData:returnData encoding:NSUTF8StringEncoding];
        NSDictionary *resultDict= [retrunVal JSONValue];
        
        if([[resultDict objectForKey:@"result"]isEqualToString:@"success"]){
            NotifyServices *notifyConn=[NotifyServices getConnection];
            Notify *notify=[notifyConn findByParam:@"nt_type" param:[Global getNOTIFY_BF]];
            
            NSArray *datas=[resultDict objectForKey:@"data"];
            for(int i=0;i<[datas count];i++){
                
                Client *client=[[ClientServices getConnection]findByCustomId:[[[datas objectAtIndex:i]objectForKey:@"customId"] intValue]];
                if(client.name==nil){
                    Client *c = [[Client alloc]init];
                    c.createtime =[[datas objectAtIndex:i]objectForKey:@"createtime"];
                    c.customId =[[[datas objectAtIndex:i]objectForKey:@"customId"] intValue];
                    c.faxphone =[[datas objectAtIndex:i]objectForKey:@"faxphone"];
                    c.email =[[datas objectAtIndex:i]objectForKey:@"email"];
                    c.address =[[datas objectAtIndex:i]objectForKey:@"address"];
                    c.namePinyin =[[datas objectAtIndex:i]objectForKey:@"namePinyin"];
                    c.uri =[[datas objectAtIndex:i]objectForKey:@"uri"];
                    c.telphone =[[datas objectAtIndex:i]objectForKey:@"telphone"];
                    c.name=[[datas objectAtIndex:i]objectForKey:@"name"];
                    
                    NSRange idsRange = NSMakeRange(0,1);
                    c.groupPy = [[[datas objectAtIndex:i]objectForKey:@"namePinyin"] substringWithRange:idsRange];
                    
                    [[ClientServices getConnection] insertClient:c];
                    Client *newClient=[[ClientServices getConnection]findByCustomId:[[[datas objectAtIndex:i]objectForKey:@"customId"] intValue]];
                    
                    NSArray *linkMans=[[datas objectAtIndex:i]objectForKey:@"linkmanList"];
                    for(int j=0;j<[linkMans count];j++){
                        ClientInfo *info=[[ClientInfo alloc]init];
                        info.linkmobile=[[linkMans objectAtIndex:j] objectForKey:@"linkmobile"];
                        info.officetel=[[linkMans objectAtIndex:j] objectForKey:@"officetel"];
                        info.remark=[[linkMans objectAtIndex:j] objectForKey:@"remark"];
                        info.email=[[linkMans objectAtIndex:j] objectForKey:@"email"];
                        info.linkname=[[linkMans objectAtIndex:j] objectForKey:@"linkname"];
                        info.spId=[[[linkMans objectAtIndex:j] objectForKey:@"id"] intValue];
                        info.cId=newClient.cId;
                        
                        ClientInfoServices *conn=[ClientInfoServices getConnection];
                        [conn insertClientInfo:info];
                    }
                }
                
                NotifyPoi *poi=[[NotifyPoi alloc]init];
                poi.npId=newPlan.npId;
                poi.spId=[[[datas objectAtIndex:i]objectForKey:@"customId"] intValue];
                poi.poiAddress=[[datas objectAtIndex:i]objectForKey:@"address"];
                poi.poiName=[[datas objectAtIndex:i]objectForKey:@"name"];
                poi.startTime=@"";
                poi.endTime=@"";
                poi.isFinish=@"N";
                [[NotifyPoiServices getConnection] insertNotify:poi];
            }

            int count=(int)notify.readCount;
            count++;
            [notifyConn updateById:notify.ntId readCount:count detailText:msgTitle ntDate:[Global getCurrentTime]];
        }
    }
    @catch (NSException *exception) {
        @throw exception;
    }
}


@end
