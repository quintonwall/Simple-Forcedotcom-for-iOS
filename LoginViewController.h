//
//  LoginViewController.h
//  SplitForce
//
//  Created by Dave Carroll on 6/20/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RootViewController.h"

@interface LoginViewController : UIViewController  {    
	UITextField *usernameTextField;
	UITextField	*passwordTextField;
}

@property (nonatomic, retain) IBOutlet UITextField *usernameTextField;
@property (nonatomic, retain) IBOutlet UITextField *passwordTextField;

- (IBAction)login:(id)sender;

@end

