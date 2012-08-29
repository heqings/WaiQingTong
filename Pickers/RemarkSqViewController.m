//
//  RemarkSqViewController.m
//  Pickers
//
//  Created by 张飞 on 12-4-11.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "RemarkSqViewController.h"
#define TEXTVIEW  100

@implementation RemarkSqViewController
@synthesize workUtilsDelegate;

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    UIFont *font = [UIFont systemFontOfSize:18];
    UITextView *textView=[[UITextView alloc]initWithFrame:CGRectMake(10, 50, 300, 100)];
    textView.tag=TEXTVIEW;
    textView.delegate = self;
    textView.returnKeyType = UIReturnKeySend;
    textView.backgroundColor = [UIColor clearColor];
    textView.layer.masksToBounds=YES;
    textView.layer.borderWidth=1.0;
    textView.layer.borderColor=[[UIColor grayColor] CGColor];
    textView.font=font;
    if([[[NSUserDefaults standardUserDefaults] objectForKey:@"sqStatus"]isEqualToString:@"Y"]){
        self.navigationItem.title=@"通过申请回复";
    }else{
        self.navigationItem.title=@"拒绝申请回复";
    }
    
    [self.view addSubview:textView];
    
    [super viewDidLoad];
}

- (void)viewDidUnload
{
    textContent=nil;
    [super viewDidUnload];
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
                               [NSArray arrayWithObjects:[NSString stringWithFormat:@"%i",[[NSUserDefaults standardUserDefaults]integerForKey:@"sqSpId"]],[[NSUserDefaults standardUserDefaults] objectForKey:@"sqStatus"],textView.text,[Global getKey],user.imei,nil]
                               forKeys:[NSArray arrayWithObjects:@"server_id",@"handle_status",@"handle_content",@"key",@"imei",nil]
                               ];
            
            NSString *json=[dic JSONRepresentation];
            NSMutableData *postBody = [NSMutableData data];
            NSString *param =[NSString stringWithFormat:@"param=%@",json];
            [postBody appendData:[param dataUsingEncoding: NSUTF8StringEncoding allowLossyConversion:YES]];
            
            [[NetUtils shareNetworkHelper] requestDataFromURL:@"apply/applypass" withParams:postBody withHelperDelegate:self withSuccessRequestMethod:@"requestSuccess:" withFaildRequestMethod:@"requestFaild:" contentType:NO];
            
            textContent=[[NSString alloc]initWithFormat:@"%@",textView.text];
            
            self.navigationItem.rightBarButtonItem = NULL;
            return NO;
        }  
    }
    return YES;
}

- (void)requestSuccess:(NSObject*)result{
    NSDictionary *dic=(NSDictionary *)result;
     if([[dic objectForKey:@"result"]isEqualToString:@"success"]){
         NSData* userData = [[NSUserDefaults standardUserDefaults] objectForKey:@"User"];
         User *user = [NSKeyedUnarchiver unarchiveObjectWithData:userData];
         
         NotifySqServices *sqConn=[NotifySqServices getConnection];
         [sqConn updateByParam:[[NSUserDefaults standardUserDefaults]integerForKey:@"sqSpId"] nsRemarkContent:textContent nsRemarkPeople:user.name status:@"Y" nsRemarkTime:[[dic objectForKey:@"data"]objectForKey:@"handletime"] nsRemarkType:[[NSUserDefaults standardUserDefaults] objectForKey:@"sqStatus"]];

    }
    textContent=nil;
    [workUtilsDelegate reloadTableView];
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)requestFaild:(NSObject*)result
{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
}

-(void)dealloc{
    textContent=nil;
}
@end
