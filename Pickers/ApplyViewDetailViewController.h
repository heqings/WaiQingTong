//
//  ApplyViewDetailViewController.h
//  Pickers
//
//  Created by 张飞 on 12-7-11.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Apply.h"

@interface ApplyViewDetailViewController : UIViewController<UIScrollViewDelegate>{
    Apply *apply;
    
    IBOutlet UILabel *type;
    IBOutlet UIScrollView *scroll;
    IBOutlet UILabel *applyTime;
}
@property(nonatomic,retain)Apply *apply;
@property(nonatomic,retain)IBOutlet UILabel *type;
@property(nonatomic,retain)IBOutlet UIScrollView *scroll;
@property(nonatomic,retain)IBOutlet UILabel *applyTime;
@end
