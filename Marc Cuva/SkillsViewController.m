//
//  SkillsViewController.m
//  Marc Cuva
//
//  Created by Marc Cuva on 4/11/14.
//  Copyright (c) 2014 Marc Cuva. All rights reserved.
//

#import "SkillsViewController.h"
#import "ScrollingView.h"
#import "HTMLFileDisplayer.h"

@interface SkillsViewController ()

@end

@implementation SkillsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIButton *back = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 80)];
    [back setTitle:@"Skills and Interests" forState:UIControlStateNormal];
    back.backgroundColor = [UIColor colorWithRed:.3359375 green:.671875 blue:.66796875 alpha:1];
    back.titleLabel.textColor = [UIColor whiteColor];
    back.titleLabel.font = [UIFont systemFontOfSize:25];
    back.titleLabel.textAlignment = NSTextAlignmentCenter;
    [back addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    back.tag = 0;
    
    UIImage *codeImg = [UIImage imageNamed:@"codes.jpg"];
    UIImageView *codeView = [[UIImageView alloc] initWithImage:codeImg];
    CGFloat ratio = self.view.frame.size.width/codeImg.size.width;
    CGFloat height = codeImg.size.height*ratio;
    codeView.frame = CGRectMake(0, 80, self.view.frame.size.width,height);
    codeView.backgroundColor = [UIColor colorWithWhite:.5 alpha:.7];
    
    HTMLFileDisplayer *part1 = [[HTMLFileDisplayer alloc] initWithContentsOfFile:@"skills" andFrame:CGRectMake(0, 0, self.view.frame.size.width, 0)];
    [part1 sizeToFitHeight];
    
    ScrollingView *scroller = [[ScrollingView alloc] initWithFrame:CGRectMake(0, 80 + codeView.frame.size.height, self.view.frame.size.width, 0)];
    [scroller addSubview:part1];
    
    
    [self.view addSubview:codeView];
    [self.view addSubview:scroller];
    [self.view addSubview:back];
}

- (void)back{
    if([[[self presentingViewController] presentingViewController] respondsToSelector:@selector(dismissViewControllerAnimated:completion:)]){
        [[[self presentingViewController] presentingViewController] dismissViewControllerAnimated:YES completion:nil];
    }else{
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

@end
