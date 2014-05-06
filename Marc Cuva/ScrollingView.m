//
//  ScrollingView.m
//  Marc Cuva
//
//  Created by Marc Cuva on 4/10/14.
//  Copyright (c) 2014 Marc Cuva. All rights reserved.
//

#import "ScrollingView.h"
#import "DecelerationBehaviour.h"

@interface ScrollingView()  <DecelerationBehaviourTarget>
@property CGFloat startingY;

@property (strong,nonatomic) DecelerationBehaviour *db;
@end

@implementation ScrollingView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        self.panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(scrolled:)];
        [self addGestureRecognizer:self.panGesture];
        self.startingY = self.frame.origin.y;
        
        self.db = [[DecelerationBehaviour alloc] initWithTarget:self];
        self.db.smoothnessFactor = .7;
    }
    return self;
}

- (void)scrolled:(UIPanGestureRecognizer *)recognizer{
    if(recognizer.state == UIGestureRecognizerStateEnded || 
       recognizer.state == UIGestureRecognizerStateFailed || 
       recognizer.state == UIGestureRecognizerStateCancelled)
    {
        [self.db decelerateWithVelocity:[recognizer velocityInView:self] withCompletionBlock:nil];
    }else{
        CGPoint translation = [recognizer translationInView:self];
        [self addTranslation:translation];
        [recognizer setTranslation:CGPointZero inView:self];
    }
}

- (void)addSubview:view{
    [super addSubview:view];
    [self sizeToFit];
}

-(void)sizeToFit
{
    float w = 0;
    float h = 0;
    
    for (UIView *v in [self subviews]) {
        float fw = v.frame.origin.x + v.frame.size.width;
        float fh = v.frame.origin.y + v.frame.size.height;
        w = MAX(fw, w);
        h = MAX(fh, h);
    }
    [self setFrame:CGRectMake(self.frame.origin.x, self.frame.origin.y, w, h)];
}

- (void)addTranslation:(CGPoint)translation{
    CGFloat newY = self.frame.origin.y + translation.y;
    self.offset -= translation.y;
    self.direction = (translation.y < 0) ? -1 : 1;
    if(self.offset < 0){
        self.offset = 0;
    }else if(self.offset > self.frame.size.height){
        self.offset = self.frame.size.height;
    }
    if(newY + self.frame.size.height < self.superview.frame.size.height){
        newY = self.superview.frame.size.height - self.frame.size.height;
    }else if(newY > self.startingY){
        newY = self.startingY;
    }
    self.frame = CGRectMake(self.frame.origin.x, newY, self.frame.size.width, self.frame.size.height);
    
    if([self.delegate respondsToSelector:@selector(updateStatusBar:)]){
        if(newY < 0){
            [self.delegate updateStatusBar:UIStatusBarStyleDefault];
        }else{
            [self.delegate updateStatusBar:UIStatusBarStyleLightContent];
        }
    }
    
    if([self.delegate respondsToSelector:@selector(didScroll:)]){
        [self.delegate didScroll:self];
    }
}

- (void)scrollToTop:(void(^)())finish{
    [UIView animateWithDuration:.5 animations:^{
        self.frame = CGRectMake(self.frame.origin.x, self.startingY, self.frame.size.width, self.frame.size.height);
    } completion:^(BOOL finished){
        finish();
    }];
}

@end
