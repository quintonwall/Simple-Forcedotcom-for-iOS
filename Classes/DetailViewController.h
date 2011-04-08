//
//  DetailViewController.h
//  SplitForce
//
//  Created by Dave Carroll on 6/20/10.
//  Copyright __MyCompanyName__ 2010. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SimpleForcedotcomAppDelegate.h"
#import <MapKit/MapKit.h> 
#import "BSForwardGeocoder.h"
#import "BSKmlResult.h"
#import "CustomPlacemark.h"

@class ZKSObject;

@interface DetailViewController : UIViewController <MKMapViewDelegate, UIPopoverControllerDelegate, UISplitViewControllerDelegate, BSForwardGeocoderDelegate> {
    
    UIPopoverController *popoverController;
    UIToolbar *toolbar;
    UIToolbar *editToolbar;
    ZKSObject *detailItem;
    UILabel *detailDescriptionLabel;
	
	UIView *editView;
	
	UILabel *lblAccountName;
	UILabel *lblStreet;
	UILabel *lblCity;
	UILabel *lblZip;
	UILabel *lblState;
	UILabel *lblCountry;
	
	UITextField *txtAccountName;
	UITextField *txtStreet;
	UITextField *txtCity;
	UITextField *txtZip;
	UITextField *txtState;
	UITextField *txtCountry;
    
    MKMapView	*mapView;
    //UIView *mapView;
    
    BSForwardGeocoder *forwardGeocoder;
	
}

@property (nonatomic, retain) IBOutlet UIToolbar *toolbar;
@property (nonatomic, retain) IBOutlet UIToolbar *editToolbar;

@property (nonatomic, retain) id detailItem;
@property (nonatomic, retain) IBOutlet UILabel *detailDescriptionLabel;

@property (nonatomic, retain) IBOutlet UIView *editView;

@property (nonatomic, retain) IBOutlet UILabel *lblAccountName;
@property (nonatomic, retain) IBOutlet UILabel *lblStreet;
@property (nonatomic, retain) IBOutlet UILabel *lblCity;
@property (nonatomic, retain) IBOutlet UILabel *lblZip;
@property (nonatomic, retain) IBOutlet UILabel *lblState;
@property (nonatomic, retain) IBOutlet UILabel *lblCountry;

@property (nonatomic, retain) IBOutlet UITextField *txtAccountName;
@property (nonatomic, retain) IBOutlet UITextField *txtStreet;
@property (nonatomic, retain) IBOutlet UITextField *txtCity;
@property (nonatomic, retain) IBOutlet UITextField *txtZip;
@property (nonatomic, retain) IBOutlet UITextField *txtState;
@property (nonatomic, retain) IBOutlet UITextField *txtCountry;

@property (nonatomic, retain) IBOutlet MKMapView *mapView;

@property (nonatomic, retain) BSForwardGeocoder *forwardGeocoder;

-(IBAction)showEditView:(id)sender;
-(IBAction)hideEditView:(id)sender;
-(IBAction)saveData:(id)sender;

- (void)configureView;

@end
