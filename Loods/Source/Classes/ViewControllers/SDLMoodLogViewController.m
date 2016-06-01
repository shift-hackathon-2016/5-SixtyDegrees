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
    
    self.imageViewLogo.alpha = 0.0;
    self.buttonInfo.alpha = 0.0;
    self.buttonSearch.alpha = 0.0;
    self.labelStatus.alpha = 0.0;
    self.labelTownDescription.alpha = 0.0;
    self.labelAddressDescription.alpha = 0.0;
    self.scrollViewMoodCards.alpha = 0.0;
    
    [UIView animateWithDuration:0.5 delay:0.4 options:UIViewAnimationOptionCurveEaseIn animations:^{
        self.imageViewLogo.alpha = 1.0;
        self.buttonInfo.alpha = 1.0;
        self.buttonSearch.alpha = 1.0;
    } completion:^(BOOL finished) {
        [manager updateCurrentLocation];
    }];
    
    [UIView animateWithDuration:0.2 delay:0.8 options:UIViewAnimationOptionCurveEaseIn animations:^{
        self.labelStatus.alpha = 1.0;
    } completion:^(BOOL finished) {
        [manager updateCurrentLocation];
    }];
    
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTapScrollView:)];
    tapGestureRecognizer.numberOfTapsRequired = 1;
    tapGestureRecognizer.enabled = YES;
    tapGestureRecognizer.cancelsTouchesInView = NO;
    [self.scrollViewMoodCards addGestureRecognizer:tapGestureRecognizer];
    
}

- (void)viewDidAppear:(BOOL)animated
{
    
}

- (void)didTapScrollView:(UITapGestureRecognizer *)gesture
{
    [self performSegueWithIdentifier:@"LogToMapSegue" sender:self];
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
    CGFloat itemMargins = 90;
    
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
    
    
    
    [UIView animateWithDuration:0.2 delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.labelStatus.alpha = 0.0;
    } completion:^(BOOL finished) {
        self.labelStatus.text = @"How do you feel?";
        [UIView animateWithDuration:0.2 delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            self.labelStatus.alpha = 1.0;
        } completion:^(BOOL finished) {
        }];
    }];
    
    self.labelTownDescription.hidden = NO;
    self.labelAddressDescription.hidden = NO;
    
    self.labelTownDescription.text = [NSString stringWithFormat:@"You are in %@", placemark.locality];
    self.labelAddressDescription.text = [NSString stringWithFormat:@"at %@, %@", placemark.thoroughfare, placemark.administrativeArea];
    
    [UIView animateWithDuration:0.4 delay:0.3 options:UIViewAnimationOptionCurveEaseOut animations:^{
        self.labelTownDescription.alpha = 1.0;
    } completion:^(BOOL finished) {
    }];
    
    [UIView animateWithDuration:0.5 delay:0.8 options:UIViewAnimationOptionCurveEaseOut animations:^{
        self.labelAddressDescription.alpha = 1.0;
    } completion:^(BOOL finished) {
    }];
    
    
    [self zoomMap:self.mapView location:self.lastLocation delta:0.03 animated:NO];
    
    
    [UIView animateWithDuration:0.8 delay:0.8 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.imageViewBackground.alpha = 0.85;
    } completion:^(BOOL finished) {
    }];
    
    [UIView animateWithDuration:0.1 delay:1.1 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        [self zoomMap:self.mapView location:self.lastLocation delta:0.02 animated:YES];
    } completion:^(BOOL finished) {
    }];
    
    
    
    [UIView animateWithDuration:0.6 delay:1.1 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.scrollViewMoodCards.alpha = 1.0;
    } completion:^(BOOL finished) {
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
