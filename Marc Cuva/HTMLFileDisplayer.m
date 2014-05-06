//
//  HTMLFileDisplayer.m
//  Marc Cuva
//
//  Created by Marc Cuva on 4/10/14.
//  Copyright (c) 2014 Marc Cuva. All rights reserved.
//

#import "HTMLFileDisplayer.h"

@implementation HTMLFileDisplayer

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.autoResize = NO;
    }
    return self;
}

- (id)initWithContentsOfFile:(NSString *)file andFrame:(CGRect)frame{
    self = [self initWithFrame:frame];
    NSError *err;
    NSString *path = [[NSBundle mainBundle] pathForResource:file ofType:@"html"];
    NSString *s = [NSString stringWithContentsOfFile:path encoding:NSASCIIStringEncoding error:&err];
    if(err){
        NSLog(@"%@", [err description]);
    }
    NSAttributedString *as = [[NSAttributedString alloc] initWithData:[s dataUsingEncoding:NSUnicodeStringEncoding] options:@{NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType} documentAttributes: nil error:nil];
    self.attributedText = as;
    
    CGFloat width = self.frame.size.width;
    if(self.autoResize){
        [self sizeToFit];
    }
    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, width, self.frame.size.height);
    
    [self removeGestureRecognizer:self.panGestureRecognizer];
    
    [self setEditable:NO];
    
    return self;
}

- (void)sizeToFitHeight{
    CGFloat width = self.frame.size.width;
    [super sizeToFit];
    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, width, self.frame.size.height);
}

@end
