//
//  ProjectsViewController.m
//  Marc Cuva
//
//  Created by Marc Cuva on 4/11/14.
//  Copyright (c) 2014 Marc Cuva. All rights reserved.
//

#import "ProjectsViewController.h"
#import "ScrollingView.h"
#import "HTMLFileDisplayer.h"
#import "ExpandAnimationController.h"

@interface ProjectsViewController () <UIViewControllerTransitioningDelegate>
@property (strong, nonatomic) ExpandAnimationController *animationController;
@end

@implementation ProjectsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIButton *back = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 80)];
    [back setTitle:@"Projects" forState:UIControlStateNormal];
    back.backgroundColor = [UIColor colorWithRed:.25 green:.25 blue:.25 alpha:1];
    back.titleLabel.textColor = [UIColor whiteColor];
    back.titleLabel.font = [UIFont systemFontOfSize:25];
    back.titleLabel.textAlignment = NSTextAlignmentCenter;
    [back addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    back.tag = 0;
    
    UIImage *es = [UIImage imageNamed:@"es.png"];
    UIImageView *esView = [[UIImageView alloc] initWithImage:es];
    CGFloat ratio = self.view.frame.size.width/es.size.width;
    CGFloat height = es.size.height*ratio;
    esView.frame = CGRectMake(0, 80, self.view.frame.size.width,height);
    esView.backgroundColor = [UIColor colorWithWhite:.5 alpha:.7];
    
    HTMLFileDisplayer *part1 = [[HTMLFileDisplayer alloc] initWithContentsOfFile:@"projects" andFrame:CGRectMake(0, 0, self.view.frame.size.width, 0)];
    [part1 sizeToFitHeight];
    
    int runningHeight = part1.frame.size.height;
    
    UIImage *cw = [UIImage imageNamed:@"connectedwire.png"];
    UIImageView *cwView = [[UIImageView alloc] initWithImage:cw];
    ratio = self.view.frame.size.width/cw.size.width;
    height = cw.size.height*ratio;
    cwView.frame = CGRectMake(0, runningHeight, self.view.frame.size.width,height);
    
    runningHeight += cwView.frame.size.height;
    
    HTMLFileDisplayer *part2 = [[HTMLFileDisplayer alloc] initWithContentsOfFile:@"projects2" andFrame:CGRectMake(0, runningHeight, self.view.frame.size.width, 0)];
    [part2 sizeToFitHeight];
    
    runningHeight += part2.frame.size.height;
    
    UIButton *skillsButton = [[UIButton alloc] initWithFrame:CGRectMake(0, runningHeight, self.view.frame.size.width, 80)];
    [skillsButton setTitle:@"Skills/Interests" forState:UIControlStateNormal];
    skillsButton.backgroundColor = [UIColor colorWithRed:.08203125 green:.34765625 blue:.8359375 alpha:1];
    skillsButton.titleLabel.textColor = [UIColor whiteColor];
    skillsButton.titleLabel.font = [UIFont systemFontOfSize:25];
    skillsButton.titleLabel.textAlignment = NSTextAlignmentCenter;
    [skillsButton addTarget:self action:@selector(goToSkills) forControlEvents:UIControlEventTouchUpInside];
    skillsButton.tag = 1;
    
    ScrollingView *scroller = [[ScrollingView alloc] initWithFrame:CGRectMake(0, 80 + esView.frame.size.height, self.view.frame.size.width, 0)];
    [scroller addSubview:part1];
    [scroller addSubview:cwView];
    [scroller addSubview:part2];
//    [scroller addSubview:skillsButton];
    
    [self.view addSubview:esView];
    [self.view addSubview:scroller];
    [self.view addSubview:back];
}

- (void)goToSkills{
    self.animationController.buttonTag = 1;
    [self performSegueWithIdentifier:@"Skills" sender:self];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    UIViewController *end = segue.destinationViewController;
    end.transitioningDelegate = self;
}


- (void)back{
    [self dismissViewControllerAnimated:YES completion:nil];
}


@end
