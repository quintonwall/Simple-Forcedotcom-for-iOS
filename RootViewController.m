//
//  RootViewController.m
//  SplitForce
//
//  Created by Dave Carroll on 6/20/10.
//  Copyright __MyCompanyName__ 2010. All rights reserved.
//

#import "RootViewController.h"
#import "DetailViewController.h"
#import "SimpleForcedotcomAppDelegate.h"
#import "ZKLoginResult.h"
#import "ZKOAuthViewController.h"

@interface RootViewController (Private)

- (void)getRows;
- (void)searchTest;
- (void)getDeletedTest;
- (void)getServerTimestampTest;
- (void)emptyRecycleBinTest;
- (void)sendEmailTest;
- (void)setPasswordTest;
- (void)resetPasswordTest;
- (void)unDeleteTest;
- (void)getUpdatedTest;
- (void)describeGlobalTest;
- (void)describeSObjectTest;
- (void)describeSObjectsTest;
- (void)describeLayoutTest;
- (void)getUserInfoTest;
- (void)makeContactTest;
- (void)nameTest;

@end


@implementation RootViewController

@synthesize detailViewController;
@synthesize dataRows;
@synthesize deleteIndexPath;

#pragma mark -
#pragma mark View lifecycle

- (void)viewDidLoad 
{
    [super viewDidLoad];
    self.clearsSelectionOnViewWillAppear = NO;
    self.contentSizeForViewInPopover = CGSizeMake(420.0, 800.0);
	
	self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc]
												initWithBarButtonSystemItem:UIBarButtonSystemItemAdd 
												target:self
												action:@selector(addItem:)] autorelease];
}


-(void)receivedErrorFromAPICall:(NSError *)err 
{
	SimpleForcedotcomAppDelegate *app = [[UIApplication sharedApplication] delegate];
	[app popupActionSheet:err];
}



- (IBAction)addItem:(id)sender 
{
	ZKSObject *newObject = [[[ZKSObject alloc] initWithType:@"Account"] autorelease];
	
	[self.detailViewController setDetailItem:newObject];
	[self.detailViewController setEditing:YES];
	[self.detailViewController showEditView:sender];
}

/*
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}
*/
/*
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}
*/
/*
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}
*/
/*
- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
}
*/

// Ensure that the view controller supports rotation and that the split view can therefore show in both portrait and landscape.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation 
{
    return YES;
}


#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)aTableView 
{
    // Return the number of sections.
    return 1;
}


- (NSInteger)tableView:(UITableView *)aTableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [dataRows count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath 
{
    
    static NSString *CellIdentifier = @"CellIdentifier";
    
    // Dequeue or create a cell of the appropriate type.
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    // Configure the cell.
	ZKSObject *obj = [dataRows objectAtIndex:indexPath.row];
	cell.textLabel.text = [obj fieldValue:@"Name"];

    //cell.textLabel.text = [NSString stringWithFormat:@"Row %d", indexPath.row];
    return cell;
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/


// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath 
{
	
	if (editingStyle == UITableViewCellEditingStyleDelete) {
		// Delete the row from the data source
		deleteIndexPath = indexPath;
		[self alertOKCancelAction:@"Delete Contact" withMessage:@"Click OK to permanently delete row."];
		//[tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:YES];
	} else if (editingStyle == UITableViewCellEditingStyleInsert) {
		// Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
	}   
}

- (void)alertOKCancelAction:(NSString *)title withMessage:(NSString *)message 
{
	// open a alert with an OK and cancel button
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:message delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK", nil];
	[alert show];
	[alert release];
}

- (void)alertView:(UIAlertView *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex 
{
	// the user clicked one of the OK/Cancel buttons
	if (buttonIndex == 0)
	{
		NSLog(@"cancel");
	}
	else
	{
		NSLog(@"ok");
		ZKSObject *delObj = (ZKSObject *)[self.dataRows objectAtIndex:deleteIndexPath.row];
		NSString *objectID = [delObj fieldValue:@"Id"];
        [[ZKServerSwitchboard switchboard] delete:[NSArray arrayWithObject:objectID] target:self selector:@selector(deleteResult:error:context:) context:nil];
	}
}



- (void)alertOKAction:(NSString *)title withMessage:(NSString *)message {
	// open a alert with an OK and cancel button
	UIAlertView *alert = [[UIAlertView alloc] init];
	[alert setTitle:title];
	[alert setMessage:message]; 
	[alert addButtonWithTitle:@"OK"];
	[alert show];
	[alert release];
}



/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/


/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/


#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)aTableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath 
{
    /*
     When a row is selected, set the detail view controller's detail item to the item associated with the selected row.
     */
    detailViewController.detailItem = [dataRows objectAtIndex:indexPath.row];
}


#pragma mark -
#pragma mark Memory management

- (void)didReceiveMemoryWarning 
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Relinquish ownership any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload 
{
    // Relinquish ownership of anything that can be recreated in viewDidLoad or on demand.
    // For example: self.myOutlet = nil;
}


- (void)dealloc 
{
    [detailViewController release];
    [super dealloc];
}


#pragma mark Server Switchboard Results

- (void)loginResult:(ZKLoginResult *)result error:(NSError *)error
{
    //NSLog(@"loginResult: %@ error: %@", result, error);
    if (result && !error)
    {
        NSLog(@"Hey, we logged in (with the new switchboard)!");
        
        [self getRows];
        //[self searchTest];
        //[self getDeletedTest];
        //[self getServerTimestampTest];
        //[self emptyRecycleBinTest];
        //[self sendEmailTest];
        //[self setPasswordTest];
        //[self resetPasswordTest];
        //[self unDeleteTest];
        //[self getUpdatedTest];
        //[self describeGlobalTest];
        //[self describeSObjectTest];
        //[self describeSObjectsTest];
        //[self describeLayoutTest];
        //[self getUserInfoTest];
        
        // remove login dialog
        SimpleForcedotcomAppDelegate *app = [[UIApplication sharedApplication] delegate];
        [app hideLogin];
    }
    else if (error)
    {
        [self receivedErrorFromAPICall: error];
    }
}



/**
* This is the method which gets executed upon successful login
*/
- (void)loginOAuth:(ZKOAuthViewController *)oAuthViewController error:(NSError *)error
{
    NSLog(@"loginOAuth: %@ error: %@", oAuthViewController, error);
    
    if ([oAuthViewController accessToken] && !error)
    {
        [[ZKServerSwitchboard switchboard] setApiUrlFromOAuthInstanceUrl:[oAuthViewController instanceUrl]];
        [[ZKServerSwitchboard switchboard] setSessionId:[oAuthViewController accessToken]];
        [[ZKServerSwitchboard switchboard] setOAuthRefreshToken:[oAuthViewController refreshToken]];
        SimpleForcedotcomAppDelegate *app = [[UIApplication sharedApplication] delegate];
        [app hideLogin];
        [self getRows];
        //[self nameTest];
        
        //sampleApexWebSvcTest = [[ZKSampleApexWebSvcTest alloc] init];
        //[sampleApexWebSvcTest runAllTests];
    }
}

- (void)queryResult:(ZKQueryResult *)result error:(NSError *)error context:(id)context
{
    //NSLog(@"queryResult:%@ eror:%@ context:%@", result, error, context);
    if (result && !error)
    {
        self.dataRows = [NSMutableArray arrayWithArray:[result records]];
        [self.tableView reloadData];
        //[self makeContactTest];
    }
    else if (error)
    {
        [self receivedErrorFromAPICall: error];
    }
}

- (void)deleteResult:(NSArray *)results error:(NSError *)error context:(id)context
{
    //NSLog(@"deleteResult: %@ error: %@ context: %@", results, error, context);
    if (results && !error)
    {
		ZKSaveResult *res = [results objectAtIndex:0];
		
		if ([res success]) {
			[self.dataRows removeObjectAtIndex:deleteIndexPath.row];
			[self.tableView beginUpdates];
			[self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:deleteIndexPath] withRowAnimation:UITableViewRowAnimationFade];
			[self.tableView endUpdates];
		} else {
			NSLog(@"%@", [res message]);
			[self alertOKAction:@"Action Failed" withMessage:[res message]];
			[self.tableView setEditing:NO animated:YES];
		}
    }
    else if (error)
    {
        [self receivedErrorFromAPICall: error];
    }
}

- (void)searchResult:(NSArray *)results error:(NSError *)error context:(id)context
{
    //NSLog(@"searchResult: %@ error: %@ context: %@", results, error, context);
    if (results && !error)
    {

    }
    else if (error)
    {
        [self receivedErrorFromAPICall: error];
    }
}

- (void)getDeletedResult:(ZKGetDeletedResult *)result error:(NSError *)error context:(id)context
{
    NSLog(@"getDeletedResult: %@ error: %@ context: %@", result, error, context);
    if (result && !error)
    {
        NSLog(@"deleted records: %@", result.records);
    }
    else if (error)
    {
        [self receivedErrorFromAPICall: error];
    }
}

- (void)getServerTimestampResult:(NSDate *)timestamp error:(NSError *)error context:(id)context
{
    NSLog(@"getServerTimestampResult: %@ error: %@ context: %@", timestamp, error, context);
    if (timestamp && !error)
    {
    }
    else if (error)
    {
        [self receivedErrorFromAPICall: error];
    }
}

- (void)emptyRecycleBinResult:(NSArray *)result error:(NSError *)error context:(id)context
{
    NSLog(@"emptyRecycleBinResult: %@ error: %@ context: %@", result, error, context);
    if (result && !error)
    {
    }
    else if (error)
    {
        [self receivedErrorFromAPICall: error];
    }
}

- (void)sendEmailResult:(NSNumber *)result error:(NSError *)error context:(id)context
{
    NSLog(@"sendEmailResult: %@ error: %@ context: %@", result, error, context);
    if (result && !error)
    {
    }
    else if (error)
    {
        [self receivedErrorFromAPICall: error];
    }
}

- (void)setPasswordResult:(NSNumber *)result error:(NSError *)error context:(id)context
{
    NSLog(@"setPasswordResult: %@ error: %@ context: %@", result, error, context);
    if (result && !error)
    {
    }
    else if (error)
    {
        [self receivedErrorFromAPICall: error];
    }
}

- (void)unDeleteResult:(NSString *)result error:(NSError *)error context:(id)context
{
    NSLog(@"unDeleteResult: %@ error: %@ context: %@", result, error, context);
    if (result && !error)
    {
    }
    else if (error)
    {
        [self receivedErrorFromAPICall: error];
    }
}

- (void)getUpdatedResult:(ZKGetUpdatedResult *)result error:(NSError *)error context:(id)context
{
    NSLog(@"getUpdatedResult: %@ error: %@ context: %@", result, error, context);
    if (result && !error)
    {
        NSLog(@"records = %@", result.records);
        NSLog(@"latestDate = %@", result.latestDateCovered);
    }
    else if (error)
    {
        [self receivedErrorFromAPICall: error];
    }
}

- (void)describeGlobalResult:(id)result error:(NSError *)error context:(id)context
{
    NSLog(@"describeGlobalResult: %@ error: %@ context: %@", result, error, context);
    if (result && !error)
    {
    }
    else if (error)
    {
        [self receivedErrorFromAPICall: error];
    }
}

- (void)describeSObjectResult:(id)result error:(NSError *)error context:(id)context
{
    NSLog(@"describeSObjectResult: %@ error: %@ context: %@", result, error, context);
    if (result && !error)
    {
    }
    else if (error)
    {
        [self receivedErrorFromAPICall: error];
    }
}

- (void)describeSObjectsResult:(id)result error:(NSError *)error context:(id)context
{
    NSLog(@"describeSObjectsResult: %@ error: %@ context: %@", result, error, context);
    if (result && !error)
    {
    }
    else if (error)
    {
        [self receivedErrorFromAPICall: error];
    }
}

- (void)describeLayoutResult:(id)result error:(NSError *)error context:(id)context
{
    NSLog(@"describeLayoutResult: %@ error: %@ context: %@", result, error, context);
    if (result && !error)
    {
    }
    else if (error)
    {
        [self receivedErrorFromAPICall: error];
    }
}

- (void)getUserInfoResult:(id)result error:(NSError *)error context:(id)context
{
    NSLog(@"getUserInfoResult: %@ error: %@ context: %@", result, error, context);
    if (result && !error)
    {
    }
    else if (error)
    {
        [self receivedErrorFromAPICall: error];
    }
}

- (void)makeContactResult:(id)result error:(NSError *)error context:(id)context
{
    NSLog(@"makeContactResult: %@ error: %@ context: %@", result, error, context);
    if (result && !error)
    {
    }
    else if (error)
    {
        [self receivedErrorFromAPICall: error];
    }
}

- (void)nameTestResult:(id)result error:(NSError *)error context:(id)context
{
    NSLog(@"nameTestResult: %@ error: %@ context: %@", result, error, context);
    if (result && !error)
    {
    }
    else if (error)
    {
        [self receivedErrorFromAPICall: error];
    }
}

#pragma mark UIActionSheetDelegate

- (void)willPresentActionSheet:(UIActionSheet *)actionSheet 
{
	actionSheet.frame = CGRectMake(50, 50, 600.0, 600.0 ); 
}

#pragma mark UIActionViewDelegate

- (void)willPresentAlertView:(UIAlertView *)alertView 
{
    alertView.frame = CGRectMake(50, 50, 600.0, 600.0 );
}

- (void)didPresentAlertView:(UIAlertView *)alertView 
{
    alertView.frame = CGRectMake(50, 50, 600.0, 600.0 );
}

#pragma mark Private

- (void)getRows 
{
    NSString *queryString = @"Select Id, Name, BillingStreet, BillingCity, BillingState, BillingPostalCode, BillingCountry, Phone, ShippingStreet, ShippingCity, ShippingState, ShippingPostalCode, ShippingCountry, Type, Website From Account";
    [[ZKServerSwitchboard switchboard] query:queryString target:self selector:@selector(queryResult:error:context:) context:nil];
}

- (void)searchTest
{
    NSString *queryString = @"find {4159017000} in phone fields returning contact(id, phone, firstname, lastname), lead(id, phone, firstname, lastname), account(id, phone, name)";
    [[ZKServerSwitchboard switchboard] search:queryString target:self selector:@selector(searchResult:error:context:) context:nil];
}

- (void)getDeletedTest
{
    NSDate *startDate = [NSDate dateWithTimeIntervalSinceNow: - (60*60*24)];
    [[ZKServerSwitchboard switchboard] getDeleted:@"Account" fromDate:startDate toDate:nil target:self selector:@selector(getDeletedResult:error:context:) context:nil];
}

- (void)getServerTimestampTest
{
    [[ZKServerSwitchboard switchboard] getServerTimestampWithTarget:self selector:@selector(getServerTimestampResult:error:context:) context:nil];
}

- (void)emptyRecycleBinTest
{
    NSArray *objectIDs = [NSArray arrayWithObject:@"001A000000KKopAIAT"];
    [[ZKServerSwitchboard switchboard] emptyRecycleBin:objectIDs target:self selector:@selector(emptyRecycleBinResult:error:context:) context:nil];    
}

- (void)sendEmailTest
{
    ZKEmailMessage *message = [[[ZKEmailMessage alloc] init] autorelease];
    message.plainTextBody = @"This is a test message from the sendEmail function via the iOS toolkit.";
    message.targetObjectId = @"005A0000000h8tgIAA";
    NSArray *messages = [NSArray arrayWithObject: message];
    [[ZKServerSwitchboard switchboard] sendEmail:messages target:self selector:@selector(sendEmailResult:error:context:) context:nil];
}

- (void)setPasswordTest
{
    NSString *userId = @"005A0000000rP0UIAU";
    NSString *newPassword = @"test1234";
    [[ZKServerSwitchboard switchboard] setPassword:newPassword forUserId:userId target:self selector:@selector(setPasswordResult:error:context:) context:nil];    
}

- (void)resetPasswordTest
{
    NSString *userId = @"005A0000000rP0UIAU";
    [[ZKServerSwitchboard switchboard] resetPasswordForUserId:userId triggerUserEmail:YES target:self selector:@selector(resetPasswordResult:error:context:) context:nil];
}

- (void)unDeleteTest
{
    NSArray *objectIds = [NSArray arrayWithObjects:@"001A000000KRgJ1IAL", nil];
    [[ZKServerSwitchboard switchboard] unDelete:objectIds target:self selector:@selector(unDeleteResult:error:context:) context:nil];
}

- (void)getUpdatedTest
{
    NSDate *startDate = [NSDate dateWithTimeIntervalSinceNow: - (60*60*24)];
    NSDate *endDate = [NSDate dateWithTimeIntervalSinceNow: + (60*60*12)];

    [[ZKServerSwitchboard switchboard] getUpdated:@"Account" fromDate:startDate toDate:endDate target:self selector:@selector(getUpdatedResult:error:context:) context:nil];
}

- (void)describeGlobalTest
{
    [[ZKServerSwitchboard switchboard] describeGlobalWithTarget:self selector:@selector(describeGlobalResult:error:context:) context:nil];
}

- (void)describeSObjectTest
{
    [[ZKServerSwitchboard switchboard] describeSObject:@"Account" target:self selector:@selector(describeSObjectResult:error:context:) context:nil];
}

- (void)describeSObjectsTest
{
    NSArray *sObjectTypes = [NSArray arrayWithObjects:@"Account", @"Contact", nil];
    [[ZKServerSwitchboard switchboard] describeSObjects:sObjectTypes target:self selector:@selector(describeSObjectsResult:error:context:) context:nil];
}

- (void)describeLayoutTest
{
    [[ZKServerSwitchboard switchboard] describeLayout:@"Account" target:self selector:@selector(describeLayoutResult:error:context:) context:nil];
}

- (void)getUserInfoTest
{
    [[ZKServerSwitchboard switchboard] getUserInfoWithTarget:self selector:@selector(getUserInfoResult:error:context:) context:nil];
}

/*
- (void)makeContactTest
{
    NSLog(@"makeContactTest");
    ZKSObject *account = [dataRows lastObject];
    NSLog(@"account = %@", account);
    NSString *lastName = @"Fillion";
    [[ZKServerSwitchboard switchboard] apexMyWebServiceMakeContactWithLastName:lastName account:account target:self selector:@selector(makeContactResult:error:context:) context:nil];
}

- (void)nameTest
{
    NSLog(@"nameTest");
    NSString *name = @"Fillion";
    [[ZKServerSwitchboard switchboard] apexMyWebServiceNameTest:name target:self selector:@selector(nameTestResult:error:context:) context:nil];
}
*/
@end

