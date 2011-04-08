//
//  DetailViewController.m
//  SplitForce
//
//  Created by Dave Carroll on 6/20/10.
//  Copyright __MyCompanyName__ 2010. All rights reserved.
//

#import "DetailViewController.h"
#import "RootViewController.h"
#import "ZKServerSwitchboard.h"
#import "BSForwardGeocoder.h"


@interface DetailViewController ()

@property (nonatomic, retain) UIPopoverController *popoverController;
- (void)configureView;

@end



@implementation DetailViewController

@synthesize toolbar, editToolbar, popoverController, detailItem, detailDescriptionLabel;

@synthesize editView;
@synthesize lblAccountName, lblStreet, lblCity, lblZip, lblState, lblCountry;
@synthesize txtAccountName, txtStreet, txtCity, txtZip, txtState, txtCountry;
@synthesize mapView;
@synthesize forwardGeocoder;

#pragma mark - Map Delegate methods

// gets called when a users location is updates via geolocating
//only when  mapView.showsUserLocation=TRUE;
- (void)mapView:(MKMapView *)kmapView didUpdateUserLocation:(MKUserLocation *)userLocation {
    
    MKCoordinateRegion region;
    region.center.latitude = userLocation.coordinate.latitude;
    region.center.longitude = userLocation.coordinate.longitude;
    
    MKCoordinateSpan span = {0.4, 0.4};
    region.span = span;
    
    [kmapView setRegion:region animated:YES];
}

- (void)viewDidLoad 
{
    //initialize the map to default to our current location
    mapView.showsUserLocation=TRUE;
    mapView.mapType = MKMapTypeHybrid;

    
	// Initial view toolbar (read only)
	UIBarButtonItem *editBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:self action:@selector(showEditView:)];
	UIBarButtonItem *spacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
	[self.toolbar setItems:[NSArray arrayWithObjects:spacer, editBtn, nil]];
	
	// Edit view toolbar
	UIBarButtonItem *cancelBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(hideEditView:)];
	UIBarButtonItem *saveBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(saveData:)];
	[editToolbar setItems:[NSArray arrayWithObjects:cancelBtn, saveBtn, nil]];
    
       
	[spacer release];
	[saveBtn release];
	[editBtn release];
	[cancelBtn release];
}

#pragma mark -
#pragma mark Managing the detail item

/*
 When setting the detail item, update the view and dismiss the popover controller if it's showing.
 */
- (void)setDetailItem:(id)newDetailItem 
{
    if (detailItem != newDetailItem) 
    {
        [detailItem release];
        detailItem = [newDetailItem retain];
        
        // Update the view.
        [self configureView];
    }

    if (popoverController != nil) 
    {
        [popoverController dismissPopoverAnimated:YES];
    }        
}


- (void)configureView 
{
    // Update the user interface for the detail item.
	ZKSObject *sobject = (ZKSObject *)detailItem;

	lblAccountName.text = [sobject fieldValue:@"Name"];
	lblStreet.text = [sobject fieldValue:@"ShippingStreet"];
	lblCity.text = [sobject fieldValue:@"ShippingCity"];
	lblZip.text = [sobject fieldValue:@"ShippingPostalCode"];
	lblState.text = [sobject fieldValue:@"ShippingState"];
	lblCountry.text = [sobject fieldValue:@"ShippingCountry"];

	txtAccountName.text = [sobject fieldValue:@"Name"];
	txtStreet.text = [sobject fieldValue:@"ShippingStreet"];
	txtCity.text = [sobject fieldValue:@"ShippingCity"];
	txtZip.text = [sobject fieldValue:@"ShippingPostalCode"];
	txtState.text = [sobject fieldValue:@"ShippingState"];
	txtCountry.text = [sobject fieldValue:@"ShippingCountry"];
    
  
    //Now that we have an account, lets forward geocode the address from salesforce and convert it to a long/lat.
    //then update the mapview with the accounts location
    forwardGeocoder = [[BSForwardGeocoder alloc] initWithDelegate:self];
  
    NSString *currAddress = [NSString stringWithFormat:@"%@/%@/%@/%@", [sobject fieldValue:@"ShippingStreet"], [sobject fieldValue:@"ShippingCity"], [sobject fieldValue:@"ShippingPostalCode"], [sobject fieldValue:@"ShippingState"]];
	[forwardGeocoder findLocation:currAddress];

                          
    
    
}

-(IBAction)showEditView:(id)sender 
{
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationDuration:1.0];
	[UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight forView:[self view] cache:YES];
	[[self view] addSubview:editView];
	[UIView commitAnimations];
	[txtAccountName becomeFirstResponder];
	
}

-(IBAction)hideEditView:(id)sender {
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationDuration:1.0];
	[UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:[self view] cache:YES];
	[editView removeFromSuperview];
	[UIView commitAnimations];
}

-(IBAction)saveData:(id)sender 
{
	[self setEditing:NO];
}

- (void)failed:(id)err 
{
	NSLog(@"Error:%@", err);
}

-(void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
	
}

- (void) setEditing:(BOOL) editing animated:(BOOL) animated 
{
	[super setEditing:editing animated:animated];
	
	if (!editing) {
		self.editButtonItem.title = @"Edit";
		self.title = @"Account Details";
		lblAccountName.text = txtAccountName.text;
		lblStreet.text = txtStreet.text;
		lblCity.text = txtCity.text;
		lblZip.text = txtZip.text;
		lblState.text = txtState.text;
		lblCountry.text = txtCountry.text;
		
		ZKSObject *account = (ZKSObject *)detailItem;
		[account setType:@"Account"];
		[account setFieldValue:txtAccountName.text field:@"Name"];
		[account setFieldValue:txtStreet.text field:@"ShippingStreet"];
		[account setFieldValue:txtCity.text field:@"ShippingCity"];
		[account setFieldValue:txtZip.text field:@"ShippingPostalCode"];
		[account setFieldValue:txtState.text field:@"ShippingState"];
		[account setFieldValue:txtCountry.text field:@"ShippingCountry"];
		
		NSArray *objects = [[NSArray alloc] initWithObjects:account, nil];

		if ([account fieldValue:@"Id"] == nil) 
        {
            [[ZKServerSwitchboard switchboard] create:objects target:self selector:@selector(updateResults:error:context:) context:nil];
		} 
        else 
        {
            [[ZKServerSwitchboard switchboard] update:objects target:self selector:@selector(updateResults:error:context:) context:nil];
		}
		[objects release];
	} else {
		self.title = @"Edit Account";
		self.editButtonItem.title = @"Save";
		[self showEditView:nil];
	}

}



#pragma mark -
#pragma mark Split view support

- (void)splitViewController: (UISplitViewController*)svc 
     willHideViewController:(UIViewController *)aViewController 
          withBarButtonItem:(UIBarButtonItem*)barButtonItem 
       forPopoverController: (UIPopoverController*)pc 
{
    
    barButtonItem.title = @"Root List";
    NSMutableArray *items = [[toolbar items] mutableCopy];
    [items insertObject:barButtonItem atIndex:0];
    [toolbar setItems:items animated:YES];
    [items release];
    self.popoverController = pc;
}


// Called when the view is shown again in the split view, invalidating the button and popover controller.
- (void)splitViewController: (UISplitViewController*)svc 
     willShowViewController:(UIViewController *)aViewController 
  invalidatingBarButtonItem:(UIBarButtonItem *)barButtonItem 
{
    NSMutableArray *items = [[toolbar items] mutableCopy];
    [items removeObjectAtIndex:0];
    [toolbar setItems:items animated:YES];
    [items release];
    self.popoverController = nil;
}


#pragma mark -
#pragma mark Rotation support

// Ensure that the view controller supports rotation and that the split view can therefore show in both portrait and landscape.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation 
{
    return YES;
}


#pragma mark -
#pragma mark View lifecycle

/*
 // Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
}
 */

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

- (void)viewDidUnload 
{
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    self.popoverController = nil;
}


#pragma mark -
#pragma mark Memory management

/*
- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}
*/

- (void)dealloc 
{
    [popoverController release];
    [toolbar release];
    
    [detailItem release];
    [detailDescriptionLabel release];
    [super dealloc];
}

#pragma mark Server Switchboard Responses

- (void)updateResults:(NSArray *)results error:(NSError *)error context:(id)context
{
	SimpleForcedotcomAppDelegate *app = (SimpleForcedotcomAppDelegate *)[[UIApplication sharedApplication] delegate];
    if (results && !error)
    {
        for (ZKSaveResult *saveResult in results)
        {
            if ([saveResult success]) {
                if ([app.rootViewController.dataRows indexOfObject:detailItem] == NSNotFound) {
                    // Need to add the new contact to the table.
                    [detailItem setFieldValue:[saveResult id] field:@"Id"];
                    [app.rootViewController.dataRows insertObject:detailItem atIndex:0];
                } else {
                    // Need to pass the changes back to the table.
                    [app.rootViewController.dataRows replaceObjectAtIndex:[app.rootViewController.dataRows indexOfObject:detailItem] withObject:detailItem];
                }
                [app.rootViewController.tableView reloadData];
            } else {
                NSLog([saveResult message], "$@");
            }
        }
        
        [self hideEditView:nil];
    }
    else {
        [app popupActionSheet:error];
    }
}

#pragma mark - BSForwardGeocoderDelegate methods
- (void)forwardGeocoderError:(BSForwardGeocoder*)geocoder errorMessage:(NSString *)errorMessage
{
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error!" 
													message:errorMessage
												   delegate:nil 
										  cancelButtonTitle:@"OK" 
										  otherButtonTitles: nil];
	[alert show];
	[alert release];
	
}

- (void)forwardGeocoderFoundLocation:(BSForwardGeocoder*)geocoder
{
	if(forwardGeocoder.status == G_GEO_SUCCESS)
	{
		int searchResults = [forwardGeocoder.results count];
		
		// Add placemarks for each result
		for(int i = 0; i < searchResults; i++)
		{
			BSKmlResult *place = [forwardGeocoder.results objectAtIndex:i];
			
			// Add a placemark on the map
			CustomPlacemark *placemark = [[[CustomPlacemark alloc] initWithRegion:place.coordinateRegion] autorelease];
			placemark.title = place.address;
			placemark.subtitle = place.countryName;
			[mapView addAnnotation:placemark];	
			
			NSArray *countryName = [place findAddressComponent:@"country"];
			if([countryName count] > 0)
			{
				NSLog(@"Country: %@", ((BSAddressComponent*)[countryName objectAtIndex:0]).longName );
			}
		}
		
		if([forwardGeocoder.results count] == 1)
		{
            //now we have a result, we want to turn of user geo location tracking off
             mapView.showsUserLocation=FALSE;
            
			BSKmlResult *place = [forwardGeocoder.results objectAtIndex:0];
			
            MKCoordinateRegion region;
            region.center.latitude = place.latitude;
            region.center.longitude = place.longitude;
            
            [mapView setRegion:region animated:TRUE];
            

		}
		
	}
	else {
		NSString *message = @"";
		
		switch (forwardGeocoder.status) {
			case G_GEO_BAD_KEY:
				message = @"The API key is invalid.";
				break;
				
			case G_GEO_UNKNOWN_ADDRESS:
				message = [NSString stringWithFormat:@"Could not find %@", forwardGeocoder.searchQuery];
				break;
				
			case G_GEO_TOO_MANY_QUERIES:
				message = @"Too many queries has been made for this API key.";
				break;
				
			case G_GEO_SERVER_ERROR:
				message = @"Server error, please try again.";
				break;
				
				
			default:
				break;
		}
		
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Information" 
														message:message
													   delegate:nil 
											  cancelButtonTitle:@"OK" 
											  otherButtonTitles: nil];
		[alert show];
		[alert release];
	}
}



@end
