//
//  ScrollingView.h
//  Marc Cuva
//
//  Created by Marc Cuva on 4/10/14.
//  Copyright (c) 2014 Marc Cuva. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ScrollingView;

@protocol ScrollingViewProtocol <NSObject>
@optional
- (void)updateStatusBar:(UIStatusBarStyle)style;
- (void)didScroll:(ScrollingView *)scroller;
@end

@interface ScrollingView : UIView
@property (strong, nonatomic) id<ScrollingViewProtocol> delegate;
@property (strong, nonatomic) UIPanGestureRecognizer *panGesture;
@property CGFloat offset;
@property int direction;

- (void)scrollToTop:(void(^)())finish;

@end


