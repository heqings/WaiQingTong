//
//  ShowUserViewController.h
//  Pickers
//
//  Created by 张飞 on 12-4-7.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ImageViewForScrollView.h"
#import "NotifyServices.h"
#import "Notify.h"
#import "User.h"
#import "PeopleServices.h"
#import "AddUserViewController.h"

@interface ShowUserViewController : UIViewController{
    
    UIScrollView *productScrollView;
    UIView *backgroudView;
}
@property (nonatomic, strong) IBOutlet UIScrollView *productScrollView;
@property (nonatomic, strong) IBOutlet UIView *backgroudView;
@end
