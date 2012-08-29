//
//  SoundUtils.m
//  Pickers
//
//  Created by 张飞 on 12-4-8.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//


#import "SoundUtils.h"
#define VOICEIMG       700

@interface SoundUtils (private)

@end

@implementation SoundUtils

+(NSString *)distanceOfTime:(NSDate *)date{
    
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    df.dateFormat = @"yyyy-MM-dd HH:mm";
    NSString *dateString = [df stringFromDate:date];
    NSString *title = NSLocalizedString(@"今天", nil);
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [calendar components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit
                                               fromDate:date toDate:[NSDate date] options:0];
    int year = [components year];
    int month = [components month];
    int day = [components day];

    if (year == 0 && month == 0 && day < 3) {
        if (day == 0) {
            title = NSLocalizedString(@"今天",nil);
        } else if (day == 1) {
            title = NSLocalizedString(@"昨天",nil);
        } else if (day == 2) {
            title = NSLocalizedString(@"前天",nil);
        }
        df.dateFormat = [NSString stringWithFormat:@"%@ HH:mm",title];
        dateString = [df stringFromDate:date];
        
    }

    return dateString;
}

//文字信息
+(UIView *)bubbleView:(NSString *)text from:(BOOL)fromSelf peopleId:(NSInteger)peopleId showTime:(NSString *)showTime{
	//信息背景块图层
	UIView *returnView = [[UIView alloc] initWithFrame:CGRectZero];
	returnView.backgroundColor = [UIColor clearColor];
    
    
    //时间
    UIImage *timeImg = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"time_bg" ofType:@"png"]];
    
	UIImageView *timeImageView = [[UIImageView alloc] initWithImage:[timeImg stretchableImageWithLeftCapWidth:21 topCapHeight:14]];
    
    timeImageView.alpha=0.8;
    
    UIFont *timeFont = [UIFont systemFontOfSize:12];
    
    UILabel *currentTime=[[UILabel alloc]init];
    currentTime.backgroundColor = [UIColor clearColor];
	currentTime.font = timeFont;
	currentTime.numberOfLines = 0;
    currentTime.textColor=[UIColor whiteColor];
    currentTime.textAlignment=UITextAlignmentCenter;
	currentTime.lineBreakMode = UILineBreakModeCharacterWrap;
    
    NSDateFormatter *formatter =[[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
	currentTime.text = [self distanceOfTime:[formatter dateFromString:showTime]];
    
    
    //信息图层
	UIImage *bubble = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:fromSelf?@"bubbleSelf":@"bubble" ofType:@"png"]];
	UIImageView *bubbleImageView = [[UIImageView alloc] initWithImage:[bubble stretchableImageWithLeftCapWidth:21 topCapHeight:14]];
    
	UIFont *font = [UIFont systemFontOfSize:14];
	CGSize size = [text sizeWithFont:font constrainedToSize:CGSizeMake(150.0f, 1000.0f) lineBreakMode:UILineBreakModeCharacterWrap];
    
	UILabel *bubbleText = [[UILabel alloc] initWithFrame:CGRectMake(21.0f, 38.0f, size.width+10, size.height+10)];
	bubbleText.backgroundColor = [UIColor clearColor];
	bubbleText.font = font;
	bubbleText.numberOfLines = 0;
	bubbleText.lineBreakMode = UILineBreakModeCharacterWrap;
	bubbleText.text = text;
	
	bubbleImageView.frame = CGRectMake(0.0f, 30.0f, 200.0f, size.height+30.0f);
	if(fromSelf){//判断是自己发的还是别人发的
        timeImageView.frame=CGRectMake(22,0,120,25);
        currentTime.frame=CGRectMake(22,0,120,25);
        
        returnView.frame = CGRectMake(75.0f, 10.0f, 200.0f, size.height+70.0f);
        
        NSData* data = [[NSUserDefaults standardUserDefaults] objectForKey:@"User"];
        User* user = [NSKeyedUnarchiver unarchiveObjectWithData:data];
        
        //头像
        UIImage *selfFace = [Global getUserTopImage:user];
        UIImageView *selfFaceImageView = [[UIImageView alloc] initWithImage:[selfFace stretchableImageWithLeftCapWidth:21 topCapHeight:14]];
        
        selfFaceImageView.frame = CGRectMake(200.0f, size.height+13.0f, 42.0f, 42.0f);
        
        [returnView addSubview:selfFaceImageView];
    }else{
        timeImageView.frame=CGRectMake(50,0,120,25);
        currentTime.frame=CGRectMake(50,0,120,25);
        returnView.frame = CGRectMake(45.0f, 10.0f, 200.0f, size.height+70.0f);
        
        PeopleServices *conn=[PeopleServices getConnection];
        People *p=[conn findBySpId:peopleId];
        
        UIImage *otherFace = [Global getPeopleTopImage:p];
        UIImageView *otherFaceImageView = [[UIImageView alloc] initWithImage:[otherFace stretchableImageWithLeftCapWidth:21 topCapHeight:14]];
        otherFaceImageView.frame = CGRectMake(-42.0f, size.height+13.0f, 42.0f, 42.0f);
        
        [returnView addSubview:otherFaceImageView];
    }
    [returnView addSubview:timeImageView];
    [returnView addSubview:currentTime];
	[returnView addSubview:bubbleImageView];
	[returnView addSubview:bubbleText];  
	return returnView;
}

//语音信息
+(UIView *)recordView:(BOOL)fromSelf recordCount:(NSString *)recordCount peopleId:(NSInteger)peopleId showTime:(NSString *)showTime{
    
    //信息背景块图层
	UIView *returnView = [[UIView alloc] initWithFrame:CGRectZero];
	returnView.backgroundColor = [UIColor clearColor];
    
    //时间
    UIImage *timeImg = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"time_bg" ofType:@"png"]];
    
	UIImageView *timeImageView = [[UIImageView alloc] initWithImage:[timeImg stretchableImageWithLeftCapWidth:21 topCapHeight:14]];
    
    timeImageView.alpha=0.8;
    
    UIFont *timeFont = [UIFont systemFontOfSize:12];
    
    UILabel *currentTime=[[UILabel alloc]init];
    currentTime.backgroundColor = [UIColor clearColor];
	currentTime.font = timeFont;
	currentTime.numberOfLines = 0;
    currentTime.textColor=[UIColor whiteColor];
    currentTime.textAlignment=UITextAlignmentCenter;
	currentTime.lineBreakMode = UILineBreakModeCharacterWrap;
    
	NSDateFormatter *formatter =[[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
	currentTime.text = [self distanceOfTime:[formatter dateFromString:showTime]];
    
    //信息图层
	UIImage *bubble = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:fromSelf?@"bubbleSelf":@"bubble" ofType:@"png"]];
	UIImageView *bubbleImageView = [[UIImageView alloc] initWithImage:[bubble stretchableImageWithLeftCapWidth:21 topCapHeight:14]];
	
	if(fromSelf){//判断是自己发的还是别人发的
        timeImageView.frame=CGRectMake(-25,0,120,25);
        currentTime.frame=CGRectMake(-25,0,120,25);
        
        bubbleImageView.frame = CGRectMake(28.0f, 30.0f, 120.0f,42.0f);
        [returnView addSubview:bubbleImageView];
        
        NSData* data = [[NSUserDefaults standardUserDefaults] objectForKey:@"User"];
        User* user = [NSKeyedUnarchiver unarchiveObjectWithData:data];
        
        //语音图片
        UIImage *record = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"chatto_voice_playing" ofType:@"png"]];
        UIImageView *recordImageView = [[UIImageView alloc] initWithImage:[record stretchableImageWithLeftCapWidth:21 topCapHeight:14]];    
        recordImageView.frame = CGRectMake(100.0f,36.0f, 20.0f,26.0f);
        recordImageView.tag=VOICEIMG;
        
        returnView.frame = CGRectMake(125.0f, 10.0f, 150.0f,72.0f);
        
        //头像
        UIImage *selfFace = [Global getUserTopImage:user];
        UIImageView *selfFaceImageView = [[UIImageView alloc] initWithImage:[selfFace stretchableImageWithLeftCapWidth:21 topCapHeight:14]];
        
        selfFaceImageView.frame = CGRectMake(150.0f,28.0f, 42.0f, 42.0f);
        
        
        UIFont *font = [UIFont systemFontOfSize:14];
        UILabel *lab=[[UILabel alloc]init];
        lab.frame=CGRectMake(0.0f, 30.0f, 25.0f,42.0f);
        lab.text=recordCount;
        lab.font=font;
        lab.numberOfLines=0;
        lab.backgroundColor=[UIColor clearColor];
        [returnView addSubview:lab];
        
        [returnView addSubview:selfFaceImageView];
        [returnView addSubview:recordImageView];
    }else{
        timeImageView.frame=CGRectMake(52,0,120,25);
        currentTime.frame=CGRectMake(52,0,120,25);
        bubbleImageView.frame = CGRectMake(3.0f,30.0f, 120.0f,42.0f);
        [returnView addSubview:bubbleImageView];
        
        PeopleServices *conn=[PeopleServices getConnection];
        People *p=[conn findBySpId:peopleId];
        
        //语音图片
        UIImage *record = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"chatfrom_voice_playing" ofType:@"png"]];
        UIImageView *recordImageView = [[UIImageView alloc] initWithImage:[record stretchableImageWithLeftCapWidth:21 topCapHeight:14]];
        recordImageView.frame = CGRectMake(30.0f,36.0f, 20.0f,26.0f);
        recordImageView.tag=VOICEIMG;
        
        returnView.frame = CGRectMake(45.0f, 10.0f, 150.0f,72.0f);
        UIImage *otherFace = [Global getPeopleTopImage:p];
        UIImageView *otherFaceImageView = [[UIImageView alloc] initWithImage:[otherFace stretchableImageWithLeftCapWidth:21 topCapHeight:14]];
        otherFaceImageView.frame = CGRectMake(-42.0f,28.0f, 42.0f, 42.0f);
        
        UIFont *font = [UIFont systemFontOfSize:14];
        UILabel *lab=[[UILabel alloc]init];
        lab.frame=CGRectMake(128.0f,30.0f, 25.0f,42.0f);
        lab.text=recordCount;
        lab.font=font;
        lab.numberOfLines=0;
        lab.backgroundColor=[UIColor clearColor];
        [returnView addSubview:lab];
        
        [returnView addSubview:otherFaceImageView];
        [returnView addSubview:recordImageView];
    }	
    [returnView addSubview:timeImageView];
    [returnView addSubview:currentTime];
	return returnView;
}

//图片信息
+(UIView *)imageView:(NSString *)url from:(BOOL)fromSelf peopleId:(NSInteger)peopleId showTime:(NSString *)showTime{
    //信息背景块图层
	UIView *returnView = [[UIView alloc] initWithFrame:CGRectZero];
	returnView.backgroundColor = [UIColor clearColor];
    
    //时间
    UIImage *timeImg = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"time_bg" ofType:@"png"]];
    
	UIImageView *timeImageView = [[UIImageView alloc] initWithImage:[timeImg stretchableImageWithLeftCapWidth:21 topCapHeight:14]];
    
    timeImageView.alpha=0.8;
    
    UIFont *timeFont = [UIFont systemFontOfSize:12];
    
    UILabel *currentTime=[[UILabel alloc]init];
    currentTime.backgroundColor = [UIColor clearColor];
	currentTime.font = timeFont;
	currentTime.numberOfLines = 0;
    currentTime.textColor=[UIColor whiteColor];
    currentTime.textAlignment=UITextAlignmentCenter;
	currentTime.lineBreakMode = UILineBreakModeCharacterWrap;
    
	NSDateFormatter *formatter =[[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
	currentTime.text = [self distanceOfTime:[formatter dateFromString:showTime]];
    
    //信息图层
	UIImage *bubble = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:fromSelf?@"bubbleSelf":@"bubble" ofType:@"png"]];
	UIImageView *bubbleImageView = [[UIImageView alloc] initWithImage:[bubble stretchableImageWithLeftCapWidth:21 topCapHeight:14]];
    
	if(fromSelf){//判断是自己发的还是别人发的
        timeImageView.frame=CGRectMake(22,0,120,25);
        currentTime.frame=CGRectMake(22,0,120,25);
        
        bubbleImageView.frame = CGRectMake(40.0f,30.0f, 160.0f, 100.0f);
        [returnView addSubview:bubbleImageView];
        
        returnView.frame = CGRectMake(75.0f, 10.0f, 200.0f, 130.0f);
        
        NSData* data = [[NSUserDefaults standardUserDefaults] objectForKey:@"User"];
        User* user = [NSKeyedUnarchiver unarchiveObjectWithData:data];
        
        //头像
        UIImage *selfFace = [Global getUserTopImage:user];
        UIImageView *selfFaceImageView = [[UIImageView alloc] initWithImage:[selfFace stretchableImageWithLeftCapWidth:21 topCapHeight:14]];
        
        selfFaceImageView.frame = CGRectMake(200.0f,85.0f, 42.0f, 42.0f);
        
        UIImage *image=[[UIImage alloc]initWithContentsOfFile:url];
        UIImageView *imageView = [[UIImageView alloc] initWithImage:[image stretchableImageWithLeftCapWidth:21 topCapHeight:14]];
    	
        imageView.frame = CGRectMake(52.0f, 38.0f, 130.0f, 80.0f);
        [imageView.layer setMasksToBounds:YES];
        [imageView.layer setCornerRadius:10.0];
        [returnView addSubview:imageView];
        
        [returnView addSubview:selfFaceImageView];
    }else{
        timeImageView.frame=CGRectMake(56,0,120,25);
        currentTime.frame=CGRectMake(56,0,120,25);
        bubbleImageView.frame = CGRectMake(0.0f, 30.0f, 160.0f, 100.0f);
        [returnView addSubview:bubbleImageView];
        
        returnView.frame = CGRectMake(45.0f, 10.0f, 200.0f,130.0f);
        
        PeopleServices *conn=[PeopleServices getConnection];
        People *p=[conn findBySpId:peopleId];

        UIImage *otherFace = [Global getPeopleTopImage:p];
        UIImageView *otherFaceImageView = [[UIImageView alloc] initWithImage:[otherFace stretchableImageWithLeftCapWidth:21 topCapHeight:14]];
        otherFaceImageView.frame = CGRectMake(-42.0f,85.0f, 42.0f, 42.0f);
        
        UIImage *image=[[UIImage alloc]initWithContentsOfFile:url];
        UIImageView *imageView = [[UIImageView alloc] initWithImage:[image stretchableImageWithLeftCapWidth:21 topCapHeight:14]];
    	
        imageView.frame = CGRectMake(18.0f, 38.0f, 130.0f, 80.0f);
        [imageView.layer setMasksToBounds:YES];
        [imageView.layer setCornerRadius:10.0];
        [returnView addSubview:imageView];
        
        [returnView addSubview:otherFaceImageView];
    }
    [returnView addSubview:timeImageView];
    [returnView addSubview:currentTime];
	return returnView;
}

//表情信息
+(UIView *)faceView:(BOOL)fromSelf textArray:(NSMutableArray *)textArray{
	//信息背景块图层
	UIView *returnView = [[UIView alloc] initWithFrame:CGRectZero];
	returnView.backgroundColor = [UIColor clearColor];
    
    //信息图层
	UIImage *bubble = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:fromSelf?@"bubbleSelf":@"bubble" ofType:@"png"]];
	UIImageView *bubbleImageView = [[UIImageView alloc] initWithImage:[bubble stretchableImageWithLeftCapWidth:21 topCapHeight:14]];
    
    CGFloat faceX=11.0f;
    CGFloat faceY=15.0f;
    int j=0;//一行放7个表情 
    for (int i=0;i<[textArray count];i++) {
        
        NSString *str=[textArray objectAtIndex:i];   
        if ([str hasPrefix:@"<"]&&[str hasSuffix:@">"]) {
            j++;
            NSString *imageName=[str substringWithRange:NSMakeRange(1, str.length-2)];
            UIImage *img=[UIImage imageNamed:imageName];
            UIImageView *faceImageView = [[UIImageView alloc]initWithFrame:CGRectMake(faceX,faceY, 24.0f, 24.0f)];
            faceImageView.image=img;
            [bubbleImageView addSubview:faceImageView];
            faceX=24+faceX;
            if(j/7>0){
                faceX=11.0f;
                faceY=26+faceY;
                j=0;
            }
        }else{
            faceX=11.0f;
            if(j==0){
                faceY=faceY-7;
            }else{
                faceY=17+faceY;
            }
            UIFont *font = [UIFont systemFontOfSize:14];
            CGSize size = [str sizeWithFont:font constrainedToSize:CGSizeMake(150.0f, 1000.0f) lineBreakMode:UILineBreakModeCharacterWrap];
            
            UILabel *bubbleText = [[UILabel alloc] initWithFrame:CGRectMake(faceX,faceY, size.width+28, size.height+10)];
            bubbleText.backgroundColor = [UIColor clearColor];
            bubbleText.font = font;
            bubbleText.numberOfLines = 0;
            bubbleText.lineBreakMode = UILineBreakModeCharacterWrap;
            bubbleText.text = str;
            
            [bubbleImageView addSubview:bubbleText]; 
            faceY=size.height+10+faceY;
        }
    }
    //faceY=26+faceY;
    
	bubbleImageView.frame = CGRectMake(0.0f, 0.0f, 200.0f, faceY+18.0f);
	if(fromSelf){//判断是自己发的还是别人发的
        returnView.frame = CGRectMake(75.0f, 10.0f, 200.0f, faceY+40.0f);
        //头像
        UIImage *selfFace = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"assistant" ofType:@"png"]];
        UIImageView *selfFaceImageView = [[UIImageView alloc] initWithImage:[selfFace stretchableImageWithLeftCapWidth:21 topCapHeight:14]];
        
        selfFaceImageView.frame = CGRectMake(200.0f, faceY-26.0f, 42.0f, 42.0f);
        
        [returnView addSubview:selfFaceImageView];
        
    }else{
        returnView.frame = CGRectMake(45.0f, 10.0f, 200.0f, faceY+40.0f);
        
        UIImage *otherFace = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"joke" ofType:@"png"]];
        UIImageView *otherFaceImageView = [[UIImageView alloc] initWithImage:[otherFace stretchableImageWithLeftCapWidth:21 topCapHeight:14]];
        otherFaceImageView.frame = CGRectMake(-42.0f, faceY-26.0f, 42.0f, 42.0f);
        
        [returnView addSubview:otherFaceImageView];
    }
	[returnView addSubview:bubbleImageView]; 
	return returnView;
}
+(void)insertNotify:(NSDictionary*)dic
{
    NSString *idsIdentity = [Global getSortIdentity:[dic objectForKey:@"fm"] toUser:[dic objectForKey:@"to"]];
    NotifyServices *conn=[NotifyServices getConnection];
    Notify *notify=[conn findByGroup:idsIdentity];
    NSData* data = [[NSUserDefaults standardUserDefaults] objectForKey:@"User"];
    User *user = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    PeopleServices *peopleConn=[PeopleServices getConnection];
    People *people=[peopleConn findBySpId:[[dic objectForKey:@"fm"] intValue]];
    
    NSString *type=[dic objectForKey:@"type"];
    NSString *detailText=[[NSString alloc]init];
    
    if([type isEqualToString:[Global getAUDIO_MSG]]){//语音
        detailText=@"[语音]";
    }else if([type isEqualToString:[Global getIMAGE_MSG]]){//图片
        detailText=@"[图片]";
    }else if([type isEqualToString:[Global getTEXT_MSG]]){//文字

        NSString *tempMsg=[NSString stringWithString:[dic objectForKey:@"body"]];
        NSString *msgTitle;
        if(tempMsg.length>10){
            msgTitle=[tempMsg substringToIndex:10];
            msgTitle=[msgTitle stringByAppendingString:@"..."];
        }else{
            msgTitle=tempMsg;
        }
        
        detailText=[NSString stringWithFormat:@"%@：%@",people.name,msgTitle];
    }else if([type isEqualToString:[Global getVEDIO_MSG]]){//视频
        
    }else if([type isEqualToString:[Global getPHIZ_MSG]]){//表情
        
    } 
    
    if(notify ==nil)//插入消息组
    {
        NSArray  *array= [[dic objectForKey:@"to"] componentsSeparatedByString:@"|"];
        
        if([array count]-1>0){//单对单聊天
            NSMutableString *title=[[NSMutableString alloc]init];
            NSMutableString *toUser=[[NSMutableString alloc]init];
            array=[array arrayByAddingObject:[dic objectForKey:@"fm"]];
            
            for(NSString *idString in array){
                People *people=[peopleConn findBySpId:[idString intValue]];
                if(people.name!=nil){
                    [title appendString:[NSString stringWithFormat:@"%@ ",people.name]];
                }
                if([idString intValue]!=user.userId){
                    [toUser appendString:[NSString stringWithFormat:@"%@|",idString]];
                }
            }
            NSString *tempName=nil;
            if([title length]>7){
                NSRange nameRange = NSMakeRange(0,7);
                tempName = [title substringWithRange:nameRange];
                tempName=[NSString stringWithFormat:@"%@...(%i)",tempName,[array count]];
            }else{
                tempName=[NSString stringWithFormat:@"%@...(%i)",title,[array count]];
            }

            [conn insertNotify:tempName isRead:@"N" readCount:0 ntDate:[Global getCurrentTime] toUser:[Global getString:toUser] groupId:idsIdentity ntType:[Global getNOTIFY_YY] detailText:detailText];
        }else{//单对多聊天
            
            if(people.name!=nil){
                [conn insertNotify:people.name isRead:@"N" readCount:0 ntDate:[Global getCurrentTime] toUser:[dic objectForKey:@"fm"] groupId:idsIdentity ntType:[Global getNOTIFY_YY] detailText:detailText];
            }
        }    
    }
}
+(void)runNotifySound:(NSDictionary *)dic{
    @try{
        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
        
        NSString *idsIdentity = [Global getSortIdentity:[dic objectForKey:@"fm"] toUser:[dic objectForKey:@"to"]];
        NotifyServices *conn=[NotifyServices getConnection];
        Notify *notify=[conn findByGroup:idsIdentity];
        
        if(notify !=nil){//根据标识查询出消息组是否存在
            NSString *type=[dic objectForKey:@"type"];
            NSInteger peopleId=[[dic objectForKey:@"fm"]intValue];
            
            if([type isEqualToString:[Global getAUDIO_MSG]]){//语音
                NSData *recordData=[Base64Utils dataWithBase64EncodedString:[dic objectForKey:@"body"]];
              
                NSString *strDocPath = [[NSString alloc] initWithString:[Global getRecordPath]];
                NSFileManager *fileManager = [NSFileManager defaultManager];
                [fileManager createDirectoryAtPath:strDocPath attributes:nil];
                
                NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                formatter.dateFormat = @"yyyyMMddhhmmss";    
                
                NSString *name=[[formatter stringFromDate:[NSDate date]] stringByAppendingString:@".caf"];
                NSString *path=[strDocPath stringByAppendingPathComponent:name];  
                [Global writeFile:path writeData:recordData];
                [dic setValue:path forKey:@"path"];
                NSURL *url = [NSURL fileURLWithPath:path];
                
                AVAudioPlayer *player = [[AVAudioPlayer alloc] initWithContentsOfURL: url error: nil];
                NSTimeInterval time = player.duration;
                
                div_t h = div(time, 3600); 
                div_t m = div(h.rem, 60); 
                int minutes = m.quot; 
                int seconds = m.rem; 
                NSString *recordCount;
                //获取语音总播放时间
                if (seconds < 60){
                    recordCount=[NSString stringWithFormat:@"%02d\"", seconds];
                }else{
                    recordCount=[NSString stringWithFormat:@"%d'%02d\"", minutes, seconds];
                }
                [dic setValue:recordCount forKey:@"recordCount"];
                
                [[NotifyInfoServices getConnection]insertNotifyInfo:notify.ntId peopelId:peopleId niType:type niName:name niPath:path niStatus:@"Y" niDate:[Global getCurrentTime] isRead:@"N" isMySpeaking:@"N" niContent:@"" recordTime:recordCount];
                
                recordCount=nil;
            }else if([type isEqualToString:[Global getIMAGE_MSG]]){//图片
                
                NSData *imgData=[Base64Utils dataWithBase64EncodedString:[dic objectForKey:@"body"]];
                NSString *strDocPath = [[NSString alloc] initWithString:[Global getImgPath]];
                
                NSFileManager *fileManager = [NSFileManager defaultManager];
                [fileManager createDirectoryAtPath:strDocPath attributes:nil];
                NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                [formatter setDateFormat:@"yyyyMMddhhmmss"];
                NSString *strTime = [formatter stringFromDate:[NSDate date]] ;
                
                NSString *strName = [strTime stringByAppendingString:@".png"];
           
                [Global writeFile:[strDocPath stringByAppendingPathComponent:strName] writeData:imgData];
                [dic setValue:[strDocPath stringByAppendingPathComponent:strName] forKey:@"path"];
                [[NotifyInfoServices getConnection]insertNotifyInfo:[[NSUserDefaults standardUserDefaults] integerForKey:@"notifyId"] peopelId:peopleId niType:[Global getIMAGE_MSG] niName:strName niPath:[strDocPath stringByAppendingPathComponent:strName] niStatus:@"Y" niDate:[Global getCurrentTime] isRead:@"Y" isMySpeaking:@"N" niContent:@"" recordTime:@""];
            }else if([type isEqualToString:[Global getTEXT_MSG]]){//文字
                [[NotifyInfoServices getConnection]insertNotifyInfo:notify.ntId peopelId:peopleId niType:type niName:@"" niPath:@"" niStatus:@"Y" niDate:[Global getCurrentTime] isRead:@"Y" isMySpeaking:@"N" niContent:[dic objectForKey:@"body"] recordTime:@""];
                
            }else if([type isEqualToString:[Global getVEDIO_MSG]]){//视频
                
            }else if([type isEqualToString:[Global getPHIZ_MSG]]){//表情
                [[NotifyInfoServices getConnection]insertNotifyInfo:notify.ntId peopelId:peopleId niType:type niName:@"" niPath:@"" niStatus:@"Y" niDate:[Global getCurrentTime] isRead:@"Y" isMySpeaking:@"N" niContent:[dic objectForKey:@"body"] recordTime:@""];
                
            }
                int count=(int)notify.readCount;
                count++;
            
                PeopleServices *peopleConn=[PeopleServices getConnection];
                People *people=[peopleConn findBySpId:[[dic objectForKey:@"fm"] intValue]];
                NSString *detailText=[[NSString alloc]init];
                
                if([type isEqualToString:[Global getAUDIO_MSG]]){//语音
                    detailText=@"[语音]";
                }else if([type isEqualToString:[Global getIMAGE_MSG]]){//图片
                    detailText=@"[图片]";
                }else if([type isEqualToString:[Global getTEXT_MSG]]){//文字
                    
                    NSString *tempMsg=[NSString stringWithString:[dic objectForKey:@"body"]];
                    NSString *msgTitle;
                    if(tempMsg.length>10){
                        msgTitle=[tempMsg substringToIndex:10];
                        msgTitle=[msgTitle stringByAppendingString:@"..."];
                    }else{
                        msgTitle=tempMsg;
                    }
                    
                    detailText=[NSString stringWithFormat:@"%@：%@",people.name,msgTitle];
                }else if([type isEqualToString:[Global getVEDIO_MSG]]){//视频
                    
                }else if([type isEqualToString:[Global getPHIZ_MSG]]){//表情
                    
                } 
                [conn updateById:notify.ntId readCount:count detailText:detailText ntDate:[Global getCurrentTime]];
        }
    }
    @catch (NSException *exception) {
        @throw exception;
    }
}
@end
