//
//  MBTContentView.m
//  3DGridViewController
//
//  Created by Matteo Battaglio on 19/08/14.
//  Copyright (c) 2014 Matteo Battaglio. All rights reserved.
//

#import "MBTContentView.h"

@implementation MBTContentView

- (void)removeFromSuperview {
    [super removeFromSuperview];
    NSLog(@"%@ removeFromSuperview", ((UIViewController *)self.nextResponder).title);
}

@end
