//
//  ExpandAnimationController.h
//  Marc Cuva
//
//  Created by Marc Cuva on 4/11/14.
//  Copyright (c) 2014 Marc Cuva. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ExpandAnimationController : NSObject <UIViewControllerAnimatedTransitioning>
@property BOOL isPresenting;
@property int buttonTag;
@end
