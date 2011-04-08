//
//  RootViewController.h
//  SplitForce
//
//  Created by Dave Carroll on 6/20/10.
//  Copyright __MyCompanyName__ 2010. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZKSforce.h"

@class DetailViewController;


@interface RootViewController : UITableViewController <UIActionSheetDelegate, UIAlertViewDelegate> {
    DetailViewController *detailViewController;
	
	NSMutableArray *dataRows;
	NSIndexPath *deleteIndexPath;
    

}

@property (nonatomic, retain) IBOutlet DetailViewController *detailViewController;
@property (nonatomic, retain) NSMutableArray *dataRows;
@property (nonatomic, retain) NSIndexPath *deleteIndexPath;

-(void)alertOKCancelAction:(NSString *)title withMessage:(NSString *)message;
-(void)alertOKAction:(NSString *)title withMessage:(NSString *)message;

@end
