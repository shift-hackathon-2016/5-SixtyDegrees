//
//  SDLMoodLogViewController.m
//  Loods
//
//  Created by Nikola on 31/05/16.
//  Copyright © 2016 SixtyDegrees. All rights reserved.
//

#import "SDLMoodLogViewController.h"
#import <MapKit/MapKit.h>
#import "SDLLocationManager.h"

@interface SDLMoodLogViewController () <SDLLocationManagerDelegate>

@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (weak, nonatomic) IBOutlet UIImageView *imageViewBackground;
@property (weak, nonatomic) IBOutlet UIImageView *imageViewLogo;
@property (weak, nonatomic) IBOutlet UIButton *buttonInfo;
@property (weak, nonatomic) IBOutlet UIButton *buttonSearch;
@property (weak, nonatomic) IBOutlet UILabel *labelStatus;
@property (weak, nonatomic) IBOutlet UILabel *labelTownDescription;
@property (weak, nonatomic) IBOutlet UILabel *labelAddressDescription;

@property (strong, nonatomic) CLLocation *lastLocation;

@end

@implementation SDLMoodLogViewController

#pragma mark - VC Lifecycle -

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self customizeUI];
    
    SDLLocationManager *manager = [SDLLocationManager sharedManager];
    manager.delegate = self;
    
    [manager updateCurrentLocation];
    
}

- (void)viewDidAppear:(BOOL)animated
{
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - UI -

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (void)customizeUI
{
    self.labelStatus.text = @"Getting location...";
}

- (void)didUpdateCurrentLocation:(CLLocation *)location
{
    //NSLog(@"Location: %@", location);
    
    self.lastLocation = location;
    
    [[SDLLocationManager sharedManager] updatePlacemarkForLocation:location];
}

- (void)didUpdatePlacemark:(CLPlacemark *)placemark
{
    /*
    NSLog(@"City: %@", placemark.locality);
    NSLog(@"Adress: %@ - %@ - %@ : %@", placemark.name, placemark.thoroughfare, placemark.subThoroughfare, placemark.administrativeArea);
    
    NSLog(@"%@", placemark);
     */
    
    self.labelStatus.text = @"How do you feel?";
    self.labelTownDescription.text = [NSString stringWithFormat:@"You are in %@", placemark.locality];
    self.labelAddressDescription.text = [NSString stringWithFormat:@"at %@, %@", placemark.thoroughfare, placemark.administrativeArea];
    
    self.labelTownDescription.hidden = NO;
    self.labelAddressDescription.hidden = NO;
    
    [self zoomMap:self.mapView location:self.lastLocation delta:0.03 animated:NO];
    [self zoomMap:self.mapView location:self.lastLocation delta:0.02 animated:YES];
    
    [UIView animateWithDuration:0.4 animations:^{
        self.imageViewBackground.alpha = 0.85;
    }];
    
    
}

- (void)zoomMap:(MKMapView*)mapView location:(CLLocation *)location delta:(CGFloat)delta animated:(BOOL)animated
{
    MKCoordinateRegion mapRegion;
    mapRegion.center = location.coordinate;
    mapRegion.span.latitudeDelta = delta;
    mapRegion.span.longitudeDelta = delta;
    
    [mapView setRegion:mapRegion animated:animated];
}

@end
