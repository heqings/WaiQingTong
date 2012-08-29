//
//  MessageInfoViewController.h
//  Pickers
//
//  Created by 张飞 on 12-3-8.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SimpleTableViewController.h"
#import "OtherViewController.h"
#import "ApplyViewController.h"
#import "BMapKit.h"
#import "Global.h"
#include <math.h>
#import "AppointmentViewcontroller.h"
#import "GTAppDelegate.h"
#import "WorkplanViewController.h"

@interface MessageInfoViewController : UIViewController<UINavigationControllerDelegate,UIScrollViewDelegate>{
    UISegmentedControl *segmentedControl;
    IBOutlet UIScrollView *scroll;
    IBOutlet UIButton *button;
    IBOutlet UIButton *openTelBtn;
    IBOutlet UIButton *openMettingBtn;

    IBOutlet UILabel *nameLabel;
    IBOutlet UILabel *depLabel;
    IBOutlet UILabel *loginLabel;
    IBOutlet UILabel *nickeLabel;
    IBOutlet UIImageView *img;

    IBOutlet UIView *bodyView;
}
@property(nonatomic,strong) IBOutlet UIView *bodyView;
@property(nonatomic,strong) IBOutlet UILabel *nickeLabel;
@property(nonatomic,strong) IBOutlet UILabel *loginLabel;
@property(nonatomic,strong) IBOutlet UIButton *openTelBtn;
@property(nonatomic,strong) IBOutlet UIButton *openMettingBtn;
@property(nonatomic,strong) IBOutlet UILabel *nameLabel;
@property(nonatomic,strong) IBOutlet UILabel *depLabel;
@property(nonatomic,strong) IBOutlet UIScrollView *scroll;
@property(nonatomic,strong) IBOutlet UIButton *button;
@property(nonatomic,strong) IBOutlet UIImageView *img;
-(IBAction)sendMessage:(id)sender;
-(void)openTel:(id)sender;
-(IBAction)openMetting:(id)sender;
-(UIImage*)getPeopleTopImage:(People*)p;
@end
