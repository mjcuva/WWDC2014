//
//  IntroViewController.m
//  Marc Cuva
//
//  Created by Marc Cuva on 4/5/14.
//  Copyright (c) 2014 Marc Cuva. All rights reserved.
//

#import "IntroViewController.h"
#import "ScrollingView.h"
#import "HTMLFileDisplayer.h"
#import "ExpandAnimationController.h"
#import <MapKit/MapKit.h>

@interface IntroViewController () <ScrollingViewProtocol, UIViewControllerTransitioningDelegate>
@property (strong, nonatomic) ExpandAnimationController *animationController;
@end

@implementation IntroViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    UIImage *image = [UIImage imageNamed:@"grad.jpeg"];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
    CGFloat ratio = self.view.frame.size.width/image.size.width;
    CGFloat height = image.size.height*ratio;
    imageView.frame = CGRectMake(0, 0, self.view.frame.size.width,height);
    [[self view] addSubview:imageView];
    
    [self updateStatusBar:UIStatusBarStyleLightContent];
    
    CGFloat runningHeight = 0;
    
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 30)];
    [title setText:@"About Marc Cuva"];
    [title setTextColor:[UIColor colorWithRed:.80859375 green:.0234375 blue:.12890625 alpha:1]];
    [title setFont:[UIFont systemFontOfSize:30]];
    [title sizeToFit];
    [title setTextAlignment:NSTextAlignmentCenter];
    title.frame = CGRectMake(0, 10, self.view.frame.size.width, title.frame.size.height);
    
    runningHeight += title.frame.size.height;
    
    MKMapView *mapView = [[MKMapView alloc] initWithFrame:CGRectMake(0, runningHeight + 20, self.view.frame.size.width, 200)];
    CLLocationCoordinate2D minneapolis = CLLocationCoordinate2DMake(44.9833, -93.2667);
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(minneapolis, 1000000,1000000);
    [mapView setRegion:region];
    [mapView setCenterCoordinate:minneapolis animated:NO];
    [mapView setScrollEnabled:NO];
    [mapView addAnnotation: [[MKPlacemark alloc] initWithCoordinate:minneapolis addressDictionary:nil]];
    
    runningHeight += mapView.frame.size.height + 20;
    
    
    HTMLFileDisplayer *body = [[HTMLFileDisplayer alloc] initWithContentsOfFile:@"intro" andFrame:CGRectMake(0, runningHeight + 10, self.view.frame.size.width, 0)];
    [body sizeToFit];
    
    runningHeight += body.frame.size.height + 10;
    
    UIButton *educationButton = [[UIButton alloc] initWithFrame:CGRectMake(0, runningHeight, self.view.frame.size.width, 80)];
    [educationButton setTitle:@"Education" forState:UIControlStateNormal];
    
    // #ef5f3c
    educationButton.backgroundColor = [UIColor colorWithRed:.93359375 green:.37109375 blue:.234375 alpha:1];
    educationButton.titleLabel.textColor = [UIColor whiteColor];
    [educationButton.titleLabel setFont:[UIFont systemFontOfSize:25]];
    educationButton.tag = 0;
    [educationButton addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    runningHeight += educationButton.frame.size.height;
    
    UIButton *projectsButton = [[UIButton alloc] initWithFrame:CGRectMake(0, runningHeight, self.view.frame.size.width, 80)];
    [projectsButton setTitle:@"Projects" forState:UIControlStateNormal];
    
    // #404040
    projectsButton.backgroundColor = [UIColor colorWithRed:.25 green:.25 blue:.25 alpha:1];
    projectsButton.titleLabel.textColor = [UIColor whiteColor];
    [projectsButton.titleLabel setFont:[UIFont systemFontOfSize:25]];
    projectsButton.tag = 1;
    [projectsButton addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    runningHeight += projectsButton.frame.size.height;
    
    UIButton *skillsInterestsButton = [[UIButton alloc] initWithFrame:CGRectMake(0, runningHeight, self.view.frame.size.width, 80)];
    [skillsInterestsButton setTitle:@"Skills and Interests" forState:UIControlStateNormal];
    
    // #56acab
    skillsInterestsButton.backgroundColor = [UIColor colorWithRed:.3359375 green:.671875 blue:.66796875 alpha:1];
    skillsInterestsButton.titleLabel.textColor = [UIColor whiteColor];
    [skillsInterestsButton.titleLabel setFont:[UIFont systemFontOfSize:25]];
    skillsInterestsButton.tag = 2;
    [skillsInterestsButton addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    runningHeight += skillsInterestsButton.frame.size.height;
    
    
    ScrollingView *scroller = [[ScrollingView alloc] initWithFrame:CGRectMake(0, height, self.view.frame.size.width, 400)];
    scroller.delegate = self;
    
    [scroller addSubview:title];
    [scroller addSubview:mapView];
    [scroller addSubview:body];
    [scroller addSubview:educationButton];
    [scroller addSubview:projectsButton];
    [scroller addSubview:skillsInterestsButton];
    
    [[self view] addSubview:scroller];
    
    self.animationController = [[ExpandAnimationController alloc] init];
    
}

- (void)buttonClicked:(UIButton *)button{
    switch (button.tag) {
        case 0:
            self.animationController.buttonTag = 0;
            [self performSegueWithIdentifier:@"Education" sender:self];
            break;
        case 1:
            self.animationController.buttonTag = 1;
            [self performSegueWithIdentifier:@"Projects" sender:self];
            break;
        case 2:
            self.animationController.buttonTag = 2;
            [self performSegueWithIdentifier:@"Skills" sender:self];
            break;
        default:
            NSLog(@"Shouldn't get here...");
            break;
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    UIViewController *end = segue.destinationViewController;
    end.transitioningDelegate = self;
}

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented
                                                                  presentingController:(UIViewController *)presenting
                                                                      sourceController:(UIViewController *)source
{
    self.animationController.isPresenting = YES;
    
    return self.animationController;
}

- (id <UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed {
    self.animationController.isPresenting = NO;
    
    return self.animationController;
}

- (void)updateStatusBar:(UIStatusBarStyle)style{
    if(style == UIStatusBarStyleDefault){
        [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationSlide];
    }else{
        [[UIApplication sharedApplication] setStatusBarStyle:style];
        [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationSlide];
    }
    [self setNeedsStatusBarAppearanceUpdate];
}

@end
