//
//  NotifiWork.m
//  Pickers
//
//  Created by 张飞 on 12-4-10.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "NotifyWork.h"

@implementation NotifyWork

+(void)runNotifyWork:(NSDictionary *)dic{
    @try{
        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);//手机震动
        NotifyServices *notifyConn=[NotifyServices getConnection];
        Notify *notify=[notifyConn findByParam:@"nt_type" param:[Global getNOTIFY_GZRZ]];
        
        NotifyGzrzServices *notifyGzrzConn=[NotifyGzrzServices getConnection];
        NotifyGzrz *notifyGzrz=[notifyGzrzConn findByParam:@"sp_id" param:[[[dic objectForKey:@"body"]objectForKey:@"serverid_id"]intValue]];
        
        NSString *title=[NSString stringWithString:[[dic objectForKey:@"body"]objectForKey:@"content"]];
        NSString *msgTitle;
        if(title.length>10){
            msgTitle=[title substringToIndex:10];
            msgTitle=[msgTitle stringByAppendingString:@"..."];
        }else{
            msgTitle=title;
        }
        
        if(notifyGzrz.ngContent==nil){    
            if(notify.ntType==nil){
                [notifyConn insertNotify:@"工作日志" isRead:@"N" readCount:0 ntDate:[Global getCurrentTime] toUser:@"" groupId:@"" ntType:[Global getNOTIFY_GZRZ] detailText:msgTitle];
            } 
            Notify *tempNotify=[notifyConn findByParam:@"nt_type" param:[Global getNOTIFY_GZRZ]];
            
            [notifyGzrzConn insertNotifyGzrz:[[dic objectForKey:@"fm"]intValue] ntId:tempNotify.ntId spId:[[[dic objectForKey:@"body"]objectForKey:@"serverid_id"]intValue] ngContent:[[dic objectForKey:@"body"]objectForKey:@"content"] ngCreateDate:[[dic objectForKey:@"body"]objectForKey:@"createtime"] ngRemarkContent:@"" ngRemarkPeople:@"" status:@"N" ngType:[[dic objectForKey:@"body"]objectForKey:@"worklog_type"]];
            
        }else{
            People *p=[[PeopleServices getConnection]findBySpId:[[dic objectForKey:@"fm"]intValue]];

            [notifyGzrzConn updateByParam:[[[dic objectForKey:@"body"]objectForKey:@"serverid_id"]intValue] ngRemarkContent:[[dic objectForKey:@"body"]objectForKey:@"handle_content"] ngRemarkPeople:p.name status:@"Y" ngRemarkTime:[[dic objectForKey:@"body"]objectForKey:@"handle_time"]];
        }
        int count=(int)notify.readCount;
        count++;
        [notifyConn updateById:notify.ntId readCount:count detailText:msgTitle ntDate:[Global getCurrentTime]];
    }
    @catch (NSException *exception) {
        @throw exception;
    }
}
@end
