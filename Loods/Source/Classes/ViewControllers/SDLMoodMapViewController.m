//
//  SDLMoodMapViewController.m
//  Loods
//
//  Created by Nikola on 31/05/16.
//  Copyright © 2016 SixtyDegrees. All rights reserved.
//

#import "SDLMoodMapViewController.h"
#import <MapKit/MapKit.h>
#import "SDLLocationManager.h"

@interface SDLMoodMapViewController ()

@property (weak, nonatomic) IBOutlet MKMapView *mapViewMood;

@property (assign, nonatomic) BOOL animatedMapToUserLocation;
@property (weak, nonatomic) IBOutlet UIButton *buttonInfo;
@property (weak, nonatomic) IBOutlet UIButton *buttonAdd;

@end

@implementation SDLMoodMapViewController

#pragma mark - VC Lifecycle -

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self addRadiusCircle:[[CLLocation alloc] initWithLatitude:46.7667 longitude:23.58]];
    
    [self zoomMap:self.mapViewMood toUserLocationAnimated:NO];
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

#pragma mark - Helper -

- (void)addRadiusCircle:(CLLocation *)location
{
    MKCircle *circle = [MKCircle circleWithCenterCoordinate:location.coordinate radius:10000]; //meters
    [self.mapViewMood addOverlay:circle];
}

- (void)zoomMap:(MKMapView*)mapView toUserLocationAnimated:(BOOL)animated
{
    MKCoordinateRegion mapRegion;
    mapRegion.center = [[SDLLocationManager sharedManager] cachedLocation].coordinate;
    mapRegion.span.latitudeDelta = 0.02;
    mapRegion.span.longitudeDelta = 0.02;
    
    [mapView setRegion:mapRegion animated:animated];
}

#pragma mark - MKMapView Delegate -

- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation
{
    /*
    if(!self.animatedMapToUserLocation){
        self.animatedMapToUserLocation = YES;
        [self zoomMap:mapView toUserLocationAnimated:YES];
    }
     */
}

- (MKOverlayRenderer *)mapView:(MKMapView *)mapView rendererForOverlay:(id<MKOverlay>)overlay
{
    if([overlay isKindOfClass:[MKCircle class]]){
        MKCircleRenderer *circle = [[MKCircleRenderer alloc] initWithOverlay:overlay];
        circle.strokeColor = [UIColor greenColor];
        circle.fillColor = [UIColor greenColor];
        circle.lineWidth = 2;
        circle.alpha = 0.2;
        
        return circle;
    }
    else{
        return nil;
    }
}

#pragma mark - Button Actions -

- (IBAction)buttonInfoPressed:(id)sender
{
}

- (IBAction)buttonAddPressed:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
