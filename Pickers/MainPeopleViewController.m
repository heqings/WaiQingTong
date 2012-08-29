//
//  MainPeopleViewController.m
//  Pickers
//
//  Created by  on 12-4-12.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "MainPeopleViewController.h"
#import "PeopleAreaViewController.h"
#import "DoubleComponentPickerViewController.h"
#import "MessageInfoViewController.h"
#import "GeneralSettingService.h"
#import "JSON.h"
#import "JsonServer.h"
@implementation MainPeopleViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
   
      
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    //
    // Release any cached data, images, etc that aren't in use.
}
- (void)selectMessage:(NSNotification*) notification {
	//
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStyleBordered target:nil action:nil];
    [self.navigationItem setBackBarButtonItem:backItem];

     MessageInfoViewController *info = [[MessageInfoViewController alloc]init];
    [self.navigationController pushViewController:info animated:YES];  
    //
}

#pragma mark - View lifecycle

-(void)viewWillAppear:(BOOL)animated
{
   
    for(UIViewController* v in self.childViewControllers)
    {
        [v viewWillAppear:true];
    }

}
- (void)viewDidLoad
{
    [super viewDidLoad];


    // Do any additional setup after loading the view from its nib.
    DoubleComponentPickerViewController* vv = [[DoubleComponentPickerViewController alloc]initWithNibName:@"DoubleComponentPickerViewController" bundle:nil];

   // PeopleAreaViewController* mm =[[PeopleAreaViewController alloc] initWithStyle:UITableViewStylePlain ];
   

    //
  //  [self addChildViewController:mm];
    [self addChildViewController:vv];
   // [self.view addSubview:mm.view];
    [self.view addSubview:vv.view]; 
   
    // 暂时不要拼音和地区的转换
    /*
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc ]initWithTitle:@"拼音" style:UIBarButtonItemStylePlain target:self action:@selector(btnChangeGroupMode)];

    self.navigationItem.rightBarButtonItem=rightButton;
     */
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]
            initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh
                                 target:self
                                 action:@selector(btnFlushPeople)];
   
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(selectMessage:) name:@"selectMessage" object:nil];
    
   
}
-(void)downloadAreaPeople:(id)temp
{
    NSString* imei=[[NSUserDefaults standardUserDefaults] objectForKey:@"imei"];
    //向服务器请求用户数据
    NSDictionary* i1 = [JsonServer getAreajson:imei key:[Global getKey]];
    //存入用户数据
    GeneralSettingService* gs=[GeneralSettingService getConnection];
    [gs clearGeneralSetting];
    //
    NSString* str = [i1 JSONRepresentation];
    
    
    NSMutableDictionary* ds = [[NSMutableDictionary alloc]init];
    
    [ ds setValue:str forKey:@"t_area_people"];
    [gs insertGeneralSetting:ds];
}
-(void)downloadCompanygates:(id)temp
{
    //
    NSData* data = [[NSUserDefaults standardUserDefaults] objectForKey:@"User"];
    User *user = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    
    
    PeopleServices *conn=[PeopleServices getConnection];
    [conn clearPeople];
    NSArray* result = [JsonServer getCompanGates:user];
    for (People* p in result)
    {
        [conn insertPeople:p];
        if(![p.topimg isEqualToString:@""])
        {
            [JsonServer downloadUserTopImage:p.topimg];
        }
        //每次加入一个联系人都重新刷新界面
        
    }   
}
-(void)btnFlushPeople
{
    //
    [MBProgressHUD showHUDAddedTo:self.view withLabel:@"刷新人员列表..." animated:TRUE];
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{  
        
        dispatch_async(dispatch_get_main_queue(), ^{ 
            @try{
                
                [self downloadCompanygates:nil];
                //[self downloadAreaPeople:nil];暂时不要目录树
                [MBProgressHUD hideHUDForView:self.view animated:YES];
                //更新界面
                for(UIViewController* v in self.childViewControllers)
                {
                    [v viewWillAppear:true];
                }
            }@catch (NSException* e) {
                [MBProgressHUD hideHUDForView:self.view animated:YES];
                if([e.name isEqualToString:@"NetError"])
                {
                    
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"网络错误"
                                                                    message:e.reason
                                                                   delegate:self
                                                          cancelButtonTitle:@"确定"
                                                          otherButtonTitles:nil];
                    [alert show];
                }else
                {
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"参数错误"
                                                                    message:e.reason
                                                                   delegate:self
                                                          cancelButtonTitle:@"确定"
                                                          otherButtonTitles:nil];
                    [alert show];
                }
                
            }
        });  
    }); 
    //
    
}
-(void)btnChangeGroupMode
{
    //
   [self.view exchangeSubviewAtIndex:0 withSubviewAtIndex:1];
   if([self.navigationItem.rightBarButtonItem.title isEqualToString:@"拼音"])
   {
    
       self.navigationItem.rightBarButtonItem.title=@"地区";
   }else
   {
        self.navigationItem.rightBarButtonItem.title=@"拼音";
   }
    //
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
