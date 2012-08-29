//
//  XyWebViewController.h
//  Pickers
//
//  Created by air macbook on 12-2-28.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XyWebViewController : UIViewController<UIScrollViewDelegate>{
    
    IBOutlet UIScrollView *scroll;
}
@property(nonatomic,retain)IBOutlet UIScrollView *scroll;
-(IBAction)backBtnClick:(id)sender;
@end
