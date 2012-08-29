//
//  PersonSignController.m
//  Pickers
//
//  Created by  on 12-3-2.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "PersonSignController.h"
#import "UserServices.h"
#import "JsonServer.h"
#import "MBProgressHUD.h"
#define  UITEXTVIEW  100

@implementation PersonSignController
@synthesize infoView;

#pragma mark - View lifecycle

- (void)viewDidLoad
{

    self.navigationItem.title=@"个性签名";

    infoView=[[UIView alloc] initWithFrame:CGRectMake(20.0f, 20.0f,280.0f, 150.0f)];
    [[infoView layer] setBorderWidth:1.3];//画线的宽度
    [[infoView layer] setBorderColor:[UIColor colorWithRed:171.0/255.0 green:171.0/255.0 blue:171.0/255.0 alpha:1.0f].CGColor];//颜色
    [[infoView layer]setCornerRadius:8.0];//圆角
    
    User *user = [[UserServices getConnection] getLoginUser];
    
    UIFont *font = [UIFont systemFontOfSize:18];
    UITextView *textView=[[UITextView alloc]initWithFrame:CGRectMake(5, 5, 270, 140)];
    textView.text=user.autograph;
    textView.tag=UITEXTVIEW;
    textView.delegate = self;
    textView.returnKeyType = UIReturnKeySend;
    textView.backgroundColor = [UIColor clearColor];
    textView.font=font;
    [infoView addSubview:textView];
    
    [self.view addSubview:infoView];

    [super viewDidLoad];
}

- (void)alertWithMassage:(NSString *)tMessage
{
    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"提示信息" message:tMessage delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [alertView show];
    [MBProgressHUD hideHUDForView:self.view animated:YES];
}


- (void)requestSuccess:(NSObject*)result{
    NSDictionary *resultDict = (NSDictionary *)result;
    if([[resultDict objectForKey:@"result"]isEqualToString:@"success"]){
        
        UITextView *textView=(UITextView*)[infoView viewWithTag:UITEXTVIEW];

        NSData* userData = [[NSUserDefaults standardUserDefaults] objectForKey:@"User"];
        User *user = [NSKeyedUnarchiver unarchiveObjectWithData:userData];
        user.autograph=textView.text;
        
        UserServices * service = [UserServices getConnection];
        [service updateUser:user];
        
        [[NSUserDefaults standardUserDefaults] setObject:user forKey:@"User"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    [self alertWithMassage:[resultDict objectForKey:@"msg"]];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if(buttonIndex==alertView.cancelButtonIndex){
        [self.navigationController popViewControllerAnimated:YES];
    }
} 

- (void)requestFaild:(NSObject*)result
{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
}

- (void)viewDidUnload{
 
}

-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    
    if ([text isEqualToString:@"\n"]) {//按下return键        
        if(![textView.text isEqualToString:@""]){
            [textView resignFirstResponder];
            
            [MBProgressHUD showHUDAddedTo:self.view withLabel:@"提交中..." animated:YES ];
            NSData* userData = [[NSUserDefaults standardUserDefaults] objectForKey:@"User"];
            User *user = [NSKeyedUnarchiver unarchiveObjectWithData:userData];
            
            NSDictionary *dic=[
                               [NSDictionary alloc] 
                               initWithObjects:
                               [NSArray arrayWithObjects:[Global getKey],user.email,user.nicke,user.sex,user.area,user.topimage,textView.text,user.imei,user.token,@"IOS",nil]
                               forKeys:[NSArray arrayWithObjects:@"key",@"email",@"nicke",@"sex",@"area",@"topimg",@"autograph",@"imei",@"token",@"mobiletype",nil]
                               ];
            
            NSString *json=[dic JSONRepresentation];
            NSMutableData *postBody = [NSMutableData data];
            NSString *param =[NSString stringWithFormat:@"param=%@",json];
            [postBody appendData:[param dataUsingEncoding: NSUTF8StringEncoding allowLossyConversion:YES]];
            
            [[NetUtils shareNetworkHelper] requestDataFromURL:@"mobileterminal/updatemobileterminal" withParams:postBody withHelperDelegate:self withSuccessRequestMethod:@"requestSuccess:" withFaildRequestMethod:@"requestFaild:" contentType:NO];
        }
    }
    return YES;
}    
 
@end
