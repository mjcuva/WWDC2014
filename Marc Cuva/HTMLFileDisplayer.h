//
//  HTMLFileDisplayer.h
//  Marc Cuva
//
//  Created by Marc Cuva on 4/10/14.
//  Copyright (c) 2014 Marc Cuva. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HTMLFileDisplayer : UITextView

- (id)initWithContentsOfFile:(NSString *)file andFrame:(CGRect)frame;

@property BOOL autoResize;

- (void)sizeToFitHeight;

@end
