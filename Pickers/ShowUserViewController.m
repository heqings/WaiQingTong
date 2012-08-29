//
//  ShowUserViewController.m
//  Pickers
//
//  Created by 张飞 on 12-4-7.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "ShowUserViewController.h"


@implementation ShowUserViewController
@synthesize productScrollView,backgroudView;

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    /*
    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"add_body"] style:UITabBarSystemItemContacts target:self action:@selector(addBtnClick:)]; 
    
    self.navigationItem.rightBarButtonItem= addButton;
     */
    
    self.navigationItem.title=@"聊天信息";
    backgroudView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"img_bottom"]];
    backgroudView.opaque = NO;
    
    NSData* userData = [[NSUserDefaults standardUserDefaults] objectForKey:@"User"];
    User *user = [NSKeyedUnarchiver unarchiveObjectWithData:userData];
    NotifyServices *nConn=[NotifyServices getConnection];
    NSInteger notifyId=[[NSUserDefaults standardUserDefaults] integerForKey:@"notifyId"];
    Notify *notify=[nConn findById:notifyId];
    NSMutableArray *array=[[NSMutableArray alloc]init];
    [array addObject:[NSNumber numberWithInteger:user.userId]];
    
    NSArray *userArray= [notify.toUser componentsSeparatedByString:@"|"];
    for(int i=0;i<[userArray count];i++){
        [array addObject:[NSNumber numberWithInteger:[[userArray objectAtIndex:i]intValue]]];
    }
    PeopleServices *pConn=[PeopleServices getConnection];
    UIFont *font = [UIFont systemFontOfSize:14];
    for(int i=0;i<[array count];i++){
        if([[array objectAtIndex:i]intValue]==user.userId){
            UIImage *image;
            if(user.topimage!=nil){
                NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
                NSString *documentsDirectory = [paths objectAtIndex:0];
                NSString* fileName= [user.topimage lastPathComponent];
                NSString *strPath = [documentsDirectory stringByAppendingPathComponent:fileName];
                
                image = [UIImage imageWithContentsOfFile:strPath];
            }else{
                image= [UIImage imageNamed:@"header70"];
            }
            
            CGRect viewFrame = CGRectMake(78*i, 5, 70, 70);
            ImageViewForScrollView *imageView = [[ImageViewForScrollView alloc] initWithFrame:viewFrame];
            imageView.image = image;
            imageView.tag = i;
            imageView.displayHost = self;
            imageView.imageDidTouched = @selector(imageNewDidTouched:);
            imageView.userInteractionEnabled = YES;
            
            UILabel *label=[[UILabel alloc]init];
            label.frame=CGRectMake(78*i, 75, 70, 25);
            label.text=user.name;
            label.font=font;
            label.textAlignment=UITextAlignmentCenter;
            label.backgroundColor=[UIColor clearColor];
            label.textColor = [UIColor whiteColor];
            
            [self.productScrollView addSubview:imageView];
            [self.productScrollView addSubview:label];
        }else{
            People *p=[pConn findBySpId:[[array objectAtIndex:i]intValue]];
            
            if (p.topimg !=nil) {
                UIImage *image = [Global getPeopleTopImage:p];
                CGRect viewFrame = CGRectMake(78*i, 5, 70, 70);
                ImageViewForScrollView *imageView = [[ImageViewForScrollView alloc] initWithFrame:viewFrame];
                imageView.image = image;
                imageView.tag = i;
                imageView.displayHost = self;
                imageView.imageDidTouched = @selector(imageNewDidTouched:);
                imageView.userInteractionEnabled = YES;
                
                UILabel *label=[[UILabel alloc]init];
                label.frame=CGRectMake(78*i, 75, 70, 25);
                label.text=p.name;
                label.font=font;
                label.textAlignment=UITextAlignmentCenter;
                label.backgroundColor=[UIColor clearColor];
                label.textColor = [UIColor whiteColor];
                
                [self.productScrollView addSubview:imageView];
                [self.productScrollView addSubview:label];
            } 
        }
    }

    self.productScrollView.contentSize = CGSizeMake(78*[array count]-6,84);
    [super viewDidLoad];
}

//添加多人会话
-(void)addBtnClick:(id)sender{
    AddUserViewController *add=[[AddUserViewController alloc] init];
    add.from=@"N";
    [self presentModalViewController:add animated:YES];
}

-(void)imageNewDidTouched:(ImageViewForScrollView *)imageView{

}

- (void)viewDidUnload
{
    productScrollView=nil;
    [super viewDidUnload];
}

@end
