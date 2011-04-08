    //
//  LoginViewController.m
//  SplitForce
//
//  Created by Dave Carroll on 6/20/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "LoginViewController.h"
#import "SimpleForcedotcomAppDelegate.h"
#import "ZKSforce.h"

@implementation LoginViewController

@synthesize usernameTextField, passwordTextField;

- (IBAction)login:(id)sender 
{
	SimpleForcedotcomAppDelegate *app = [[UIApplication sharedApplication] delegate];
	RootViewController *rootViewController = app.rootViewController;
    [ZKServerSwitchboard switchboard].logXMLInOut = YES;
    [[ZKServerSwitchboard switchboard] loginWithUsername:usernameTextField.text password:passwordTextField.text target:rootViewController selector:@selector(loginResult:error:)];
}



// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad 
{
    [super viewDidLoad];
    NSString *password = @""; 
    NSString *token = @""; ;
    passwordTextField.text = [NSString stringWithFormat:@"%@%@", password, token];
    usernameTextField.text = @"";

}



- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation 
{
    // Overriden to allow any orientation.
    return YES;
}


- (void)didReceiveMemoryWarning 
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}


- (void)viewDidUnload 
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc 
{
    [super dealloc];
}



@end
