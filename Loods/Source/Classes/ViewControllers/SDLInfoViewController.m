//
//  SDLInfoViewController.m
//  Loods
//
//  Created by Nikola on 31/05/16.
//  Copyright © 2016 SixtyDegrees. All rights reserved.
//

#import "SDLInfoViewController.h"

@interface SDLInfoViewController ()

@property (weak, nonatomic) IBOutlet UIButton *buttonClose;
@property (weak, nonatomic) IBOutlet UILabel *labelTitle;

@end

@implementation SDLInfoViewController

#pragma mark - VC Lifecycle -

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self customizeUI];
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
    self.labelTitle.text = @"Help & Inspiration";
}

#pragma mark - ButtonActions -

- (IBAction)buttonClosePressed:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
