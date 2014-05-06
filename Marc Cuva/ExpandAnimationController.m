//
//  ExpandAnimationController.m
//  Marc Cuva
//
//  Created by Marc Cuva on 4/11/14.
//  Copyright (c) 2014 Marc Cuva. All rights reserved.
//

#import "ExpandAnimationController.h"
#import "QuartzCore/QuartzCore.h"
#import "ScrollingView.h"
#import "HTMLFileDisplayer.h"

@implementation ExpandAnimationController 

- (NSTimeInterval)transitionDuration:(id <UIViewControllerContextTransitioning>)transitionContext
{
    return .5;
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext
{
    if(self.isPresenting){
        [self growTransition:transitionContext];
    }else{
        [self shrinkTransition:transitionContext];
    }
    
}

- (void)growTransition:(id<UIViewControllerContextTransitioning>)transitionContext{
    UIViewController* toViewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIViewController* fromViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    
    CGFloat height = 0;
    
    NSMutableArray *aboveButtons = [[NSMutableArray alloc] init];
    NSMutableArray *belowButtons = [[NSMutableArray alloc] init];
    
    CGPoint position = CGPointZero;
    
    for(id view in fromViewController.view.subviews){
        if([view isKindOfClass:[ScrollingView class]]){
            ScrollingView *sv = view;
            position = [sv.superview convertPoint:sv.frame.origin fromView:nil];
            [sv addSubview:toViewController.view];
            for(id svSubView in sv.subviews){
                if([svSubView isKindOfClass:[UIButton class]]){
                    UIButton *button = svSubView;
                    if(button.tag == self.buttonTag){
                        height = [button.superview convertPoint:button.frame.origin toView:nil].y;
                        button.alpha = 0;
                        toViewController.view.frame = CGRectMake(button.frame.origin.x, button.frame.origin.y, toViewController.view.frame.size.width, toViewController.view.frame.size.height);
                    }else if(button.tag < self.buttonTag){
                        [aboveButtons addObject:button];
                        [sv bringSubviewToFront:button];
                    }else{
                        [belowButtons addObject:button];
                        [sv bringSubviewToFront:button];
                    }
                }
            }
        }
    }
    
    [UIView animateWithDuration:[self transitionDuration:transitionContext] animations:^{
        for(UIButton *button in aboveButtons){
            int mult;
            if(self.buttonTag == 1){
                mult = 2;
            }else{
                mult = 1;
            }
            button.center = CGPointMake(button.center.x, button.center.y - fromViewController.view.frame.size.height + (80 * mult));
        }
        for(UIButton *button in belowButtons){
            button.center = CGPointMake(button.center.x, button.center.y + 200);
        }
        toViewController.view.frame = CGRectMake(0 - position.x, 0 - position.y, toViewController.view.bounds.size.width, toViewController.view.bounds.size.height);
    } completion:^(BOOL finished){
        [toViewController.view removeFromSuperview];
        toViewController.view.frame = CGRectMake(0, 0, toViewController.view.frame.size.width, toViewController.view.frame.size.height);
        [[transitionContext containerView] addSubview:toViewController.view];
        [fromViewController.view removeFromSuperview];
        [transitionContext completeTransition:YES];
    }];
}

- (void)shrinkTransition:(id<UIViewControllerContextTransitioning>)transitionContext{
    
    UIViewController* toViewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIViewController* fromViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    [fromViewController.view removeFromSuperview];
    [[transitionContext containerView] addSubview:toViewController.view];
    [[transitionContext containerView] sendSubviewToBack:toViewController.view];
    
    NSMutableArray *buttons = [[NSMutableArray alloc] init];
    UIButton *caller;
    
    for(id view in toViewController.view.subviews){
        if([view isKindOfClass:[ScrollingView class]]){
            ScrollingView *sv = view;
            fromViewController.view.center = [sv convertPoint:fromViewController.view.center fromView:nil];
            [sv addSubview:fromViewController.view];
            for(id svSubView in sv.subviews){
                if([svSubView isKindOfClass:[UIButton class]]){
                    UIButton *button = svSubView;
                    if(button.tag != self.buttonTag){
                        [buttons addObject:button];
                        [sv bringSubviewToFront:button];
                    }else{
                        caller = button;
                    }
                }
            }
        }
    }
    
    for(UIView *view in fromViewController.view.subviews){
        if([view isKindOfClass:[ScrollingView class]]){
            ScrollingView *sv = (ScrollingView *)view;
            
            [sv scrollToTop:^{
                caller.alpha = 0;
                
                [UIView animateWithDuration:[self transitionDuration:transitionContext] animations:^{
                    for(UIButton *button in buttons){
                        int mult = 1;
                        if(self.buttonTag == 1){
                            mult = 2;
                        }
                        if(button.center.y < 1000){
                            button.center = CGPointMake(button.center.x, button.center.y + toViewController.view.frame.size.height - (80 * mult));
                        }else{
                            button.center = CGPointMake(button.center.x, button.center.y - 200);
                        }
                    }
                    fromViewController.view.frame = CGRectMake(0, caller.frame.origin.y, fromViewController.view.frame.size.width, fromViewController.view.frame.size.height);
                    caller.alpha = 1;
                } completion:^(BOOL finished){
                    ScrollingView *sv = (ScrollingView *)[fromViewController.view superview];
                    [fromViewController.view removeFromSuperview];
                    [sv sizeToFit];
                    [transitionContext completeTransition:YES];
                }];

            }];
        }
    }
    
}

@end
