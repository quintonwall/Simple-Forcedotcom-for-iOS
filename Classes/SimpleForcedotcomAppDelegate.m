//
//  SplitForceAppDelegate.m
//  SplitForce
//
//  Created by Dave Carroll on 6/20/10.
//  Copyright __MyCompanyName__ 2010. All rights reserved.
//

#import "SimpleForcedotcomAppDelegate.h"
#import "RootViewController.h"
#import "DetailViewController.h"
#import "LoginViewController.h"
#import "ZKOAuthViewController.h"

#define kSFOAuthConsumerKey @"3MVG9CVKiXR7Ri5oh_84IylskqHQ62FcZmNu1sa4AqZpap0V_cQgleM9Gn70TdoQ11O9M99P2BtELOz_Cij9U"

@implementation SimpleForcedotcomAppDelegate

@synthesize window, splitViewController, rootViewController, detailViewController;
@synthesize loginViewController;


#pragma mark -
#pragma mark Application lifecycle

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions 
{    
    //[ZKServerSwitchboard switchboard].logXMLInOut = YES;
    [[ZKServerSwitchboard switchboard] setClientId:kSFOAuthConsumerKey];
    
    // Override point for customization after app launch    
	loginViewController = [[LoginViewController alloc] initWithNibName:@"LoginView" bundle:nil];
	
    oAuthViewController = [[ZKOAuthViewController alloc] initWithTarget:rootViewController selector:@selector(loginOAuth:error:) clientId:kSFOAuthConsumerKey];
    // Add the split view controller's view to the window and display.
    [window addSubview:splitViewController.view];
    [window makeKeyAndVisible];
    
	[self showLogin];
	
   return YES;
}

- (void)showLogin 
{
    oAuthViewController.modalPresentationStyle = UIModalPresentationFormSheet;
    [splitViewController presentModalViewController:oAuthViewController animated:YES];
	loginViewController.modalPresentationStyle = UIModalPresentationFormSheet;
	//[splitViewController presentModalViewController:loginViewController animated:YES];
}


- (void)hideLogin 
{
	[splitViewController dismissModalViewControllerAnimated:YES];
    [oAuthViewController autorelease];
    [loginViewController release];
}

-(void)popupActionSheet:(NSError *)err 
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:[[err userInfo] objectForKey:@"faultcode"]
                                                        message:[[err userInfo] objectForKey:@"faultstring"]
                                                       delegate:rootViewController
                                              cancelButtonTitle:nil
                                              otherButtonTitles:@"OK", nil];
    [alertView show];
    [alertView autorelease];
}

- (void)applicationWillTerminate:(UIApplication *)application 
{
    // Save data if appropriate
}


#pragma mark -
#pragma mark Memory management

- (void)dealloc 
{
    [splitViewController release];
    [window release];
    [super dealloc];
}


@end

