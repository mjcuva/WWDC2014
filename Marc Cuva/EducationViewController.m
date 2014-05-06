//
//  educationViewController.m
//  Marc Cuva
//
//  Created by Marc Cuva on 4/11/14.
//  Copyright (c) 2014 Marc Cuva. All rights reserved.
//

#import "EducationViewController.h"
#import "ScrollingView.h"
#import "HTMLFileDisplayer.h"
#import "ExpandAnimationController.h"

@interface EducationViewController() <UIViewControllerTransitioningDelegate>
@property (strong, nonatomic) ExpandAnimationController *animationController;
@end

@implementation EducationViewController 


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIButton *back = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 80)];
    [back setTitle:@"Education" forState:UIControlStateNormal];
    back.backgroundColor = [UIColor colorWithRed:.93359375 green:.37109375 blue:.234375 alpha:1];
    back.titleLabel.textColor = [UIColor whiteColor];
    back.titleLabel.font = [UIFont systemFontOfSize:25];
    back.titleLabel.textAlignment = NSTextAlignmentCenter;
    [back addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    back.tag = 0;
    
    UIImage *top = [UIImage imageNamed:@"hs.jpg"];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:top];
    CGFloat ratio = self.view.frame.size.width/top.size.width;
    CGFloat height = top.size.height*ratio;
    imageView.frame = CGRectMake(0, 80, self.view.frame.size.width,height);
    [[self view] addSubview:imageView];
    
    HTMLFileDisplayer *num1 = [[HTMLFileDisplayer alloc] initWithContentsOfFile:@"education" andFrame:CGRectMake(0, 0, self.view.frame.size.width, 0)];
    [num1 sizeToFitHeight];
    
    int runningHeight = num1.frame.size.height;
    
    UIImage *um = [UIImage imageNamed:@"um.jpg"];
    UIImageView *umView = [[UIImageView alloc] initWithImage:um];
    ratio = self.view.frame.size.width/um.size.width;
    height = um.size.height*ratio;
    umView.frame = CGRectMake(0, runningHeight, self.view.frame.size.width,height);
    
    runningHeight += umView.frame.size.height;
    
    HTMLFileDisplayer *num2 = [[HTMLFileDisplayer alloc] initWithContentsOfFile:@"education2" andFrame:CGRectMake(0, runningHeight, self.view.frame.size.width, 0)];
    [num2 sizeToFitHeight];
    
    runningHeight += num2.frame.size.height;
    
    UIButton *projectsButton = [[UIButton alloc] initWithFrame:CGRectMake(0, runningHeight, self.view.frame.size.width, 80)];
    [projectsButton setTitle:@"Projects" forState:UIControlStateNormal];
    projectsButton.backgroundColor = [UIColor colorWithRed:.0703125 green:.546875 blue:.22265625 alpha:1];
    projectsButton.titleLabel.textColor = [UIColor whiteColor];
    projectsButton.titleLabel.font = [UIFont systemFontOfSize:25];
    projectsButton.titleLabel.textAlignment = NSTextAlignmentCenter;
    [projectsButton addTarget:self action:@selector(goToProjects) forControlEvents:UIControlEventTouchUpInside];
    projectsButton.tag = 1;
    
    
    ScrollingView *scroller = [[ScrollingView alloc] initWithFrame:CGRectMake(0, top.size.height, self.view.frame.size.width, 0)];
    [scroller addSubview:num1];
    [scroller addSubview:umView];
    [scroller addSubview:num2];
    
//    Wanted to add a way to get between each Controller,
//    but I couldn't get it working well enough in time
//    [scroller addSubview:projectsButton];
    
    [self.view addSubview:scroller];
    [self.view addSubview:back];
    [self.view bringSubviewToFront:back];
    
    self.animationController = [[ExpandAnimationController alloc] init];
    
    
}

- (void)back{
    self.animationController.buttonTag = 0;
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)goToProjects{
    self.animationController.buttonTag = 1;
    [self performSegueWithIdentifier:@"Projects" sender:self];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    UIViewController *end = segue.destinationViewController;
    end.transitioningDelegate = self;
}

/**
    Taken from: http://stackoverflow.com/questions/12380288/ios-create-an-darker-version-of-uiimage-and-leave-transparent-pixels-unchanged
 */
- (UIImage *)colorizeImage:(UIImage *)image withColor:(UIColor *)color {
    UIGraphicsBeginImageContext(image.size);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGRect area = CGRectMake(0, 0, image.size.width, image.size.height);
    
    CGContextScaleCTM(context, 1, -1);
    CGContextTranslateCTM(context, 0, -area.size.height);
    
    CGContextSaveGState(context);
    CGContextClipToMask(context, area, image.CGImage);
    
    [color set];
    CGContextFillRect(context, area);
    
    CGContextRestoreGState(context);
    
    CGContextSetBlendMode(context, kCGBlendModeMultiply);
    
    CGContextDrawImage(context, area, image.CGImage);
    
    UIImage *colorizedImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return colorizedImage;
}

@end
