//
//  MainViewController.h
//  NBEX
//
//  Created by Will on 10-6-11.
//  Copyright __MyCompanyName__ 2010. All rights reserved.
//


#import "MyScrollView.h"

@interface MainViewController : UIViewController <UIScrollViewDelegate>
{
	IBOutlet UIScrollView *scrView;
	
	NSInteger lastPage;
    NSArray *array;
}
@property(nonatomic,retain)NSArray *array;
@end
