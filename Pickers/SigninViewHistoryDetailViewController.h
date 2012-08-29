//
// Created by HeQing on 12-5-15.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "Global.h"
#import "JSON.h"
#import "SpeechHelper.h"
#import "SigninTypeViewController.h"
#import "SignIn.h"
#import "SigninTypeViewController.h"
#import "WorkUtilsDelegate.h"
#import "NetUtils.h"
#import "MBProgressHUD.h"
#import "SignInService.h"
#import "JsonServer.h"


@interface SigninViewHistoryDetailViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,UITextViewDelegate,WorkUtilsDelegate,UIImagePickerControllerDelegate,UIAlertViewDelegate,UINavigationControllerDelegate>{
    IBOutlet UITableView *table;
    NSDictionary * myData;
    NSString *address;
    SpeechHelper *speechHelper;
    BOOL isCamera;//拍照或选择照片
    
    double latitude;
    double longitude;
    
    NSMutableArray *picDataArray;
    UITextField *nameText;
    UITextView *remarkText;
    UILabel *sqLabel;
}
@property(nonatomic,retain)IBOutlet UITableView *table;
@property(nonatomic,retain)NSDictionary * myData;
@property(nonatomic,strong)NSString *address;
@property(nonatomic,retain)NSMutableArray *picDataArray;
@property(nonatomic,nonatomic)double latitude;
@property(nonatomic,nonatomic)double longitude;
@property(nonatomic,retain)UITextField *nameText;
@property(nonatomic,retain)UITextView *remarkText;
@property(nonatomic,retain)UILabel *sqLabel;
@end