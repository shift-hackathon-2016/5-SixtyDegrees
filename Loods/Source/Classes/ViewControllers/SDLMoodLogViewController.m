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
#import "SDLMoodCard.h"
#import "UIView+FLKAutoLayout.h"

@interface SDLMoodLogViewController () <SDLLocationManagerDelegate>

@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (weak, nonatomic) IBOutlet UIImageView *imageViewBackground;
@property (weak, nonatomic) IBOutlet UIImageView *imageViewLogo;
@property (weak, nonatomic) IBOutlet UIButton *buttonInfo;
@property (weak, nonatomic) IBOutlet UIButton *buttonSearch;
@property (weak, nonatomic) IBOutlet UILabel *labelStatus;
@property (weak, nonatomic) IBOutlet UILabel *labelTownDescription;
@property (weak, nonatomic) IBOutlet UILabel *labelAddressDescription;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollViewMoodCards;

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
    
    
    NSMutableArray *selectionItems = [NSMutableArray array];
    
    CGFloat itemSpacing = 20;
    CGFloat itemWidth = 200;
    CGFloat itemHeight = 250;
    CGFloat itemMargins = 20;
    
    for(NSString *moodTitle in [self moodTitles]){
        
        UINib *customNib = [UINib nibWithNibName:@"SDLMoodCardView" bundle:nil];
        SDLMoodCard *moodCardView = [[customNib instantiateWithOwner:self options:nil] objectAtIndex:0];
        
        NSUInteger index = [[self moodTitles] indexOfObject:moodTitle];
        
        moodCardView.labelMoodTitle.text = moodTitle;
        moodCardView.imageViewMoodCard.image = [UIImage imageNamed:[[self moodFaceImages] objectAtIndex:index]];
        [moodCardView.labelMoodTitle setTextColor:[[self moodTitleColors] objectAtIndex:index]];
        
        [self.scrollViewMoodCards addSubview:moodCardView];
        
        [moodCardView constrainWidth:[NSString stringWithFormat:@"%f", itemWidth]];
        [moodCardView constrainHeight:[NSString stringWithFormat:@"%f", itemHeight]];
        [moodCardView alignCenterYWithView:self.scrollViewMoodCards predicate:@"0"];
        
        [selectionItems addObject:moodCardView];
    }
    
    
    [UIView spaceOutViewsHorizontally:selectionItems predicate:[NSString stringWithFormat:@"%f", itemSpacing]];
    [selectionItems.firstObject constrainLeadingSpaceToView:self.scrollViewMoodCards predicate:[NSString stringWithFormat:@"%f", itemMargins]];
    
    NSInteger numberOfItems = [self moodTitles].count;
    
    [self.scrollViewMoodCards setContentSize:CGSizeMake(itemWidth * numberOfItems + 2 * itemMargins + itemSpacing * (numberOfItems - 1), itemHeight)];

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

#pragma mark - Helper -

- (NSArray *)moodFaceImages
{
    return @[@"MoodFaceExcited", @"MoodFaceHappy", @"MoodFaceRelaxed", @"MoodFaceNeutral", @"MoodFaceBored", @"MoodFaceSad", @"MoodFaceAngry"];
}

- (NSArray *)moodTitles
{
    return @[@"Excited", @"Happy", @"Relaxed", @"Neutral", @"Bored", @"Sad", @"Angry"];
}

- (NSArray *)moodTitleColors
{
    return @[[self positiveMoodColor], [self positiveMoodColor], [self positiveMoodColor], [self neutralMoodColor], [self negativeMoodColor], [self negativeMoodColor], [self negativeMoodColor]];
}

- (UIColor *)positiveMoodColor
{
    return [UIColor colorWithRed:50.0/255.0 green:198.0/255.0 blue:53.0/255.0 alpha:1.0];
}
- (UIColor *)neutralMoodColor
{
    return [UIColor colorWithRed:247.0/255.0 green:174.0/255.0 blue:0 alpha:1.0];
}

- (UIColor *)negativeMoodColor
{
    return [UIColor colorWithRed:228.0/255.0 green:72.0/255.0 blue:35.0/255.0 alpha:1.0];
}

@end
