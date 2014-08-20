//
//  MBTContentViewController.m
//  3DGridViewController
//
//  Created by Matteo Battaglio on 19/08/14.
//  Copyright (c) 2014 Matteo Battaglio. All rights reserved.
//

#import "MBTContentViewController.h"

@implementation MBTContentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"%@ %@", self.title, @"viewDidLoad");
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    NSLog(@"%@ %@", self.title, @"viewWillAppear");
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    NSLog(@"%@ %@", self.title, @"viewDidAppear");
    
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    NSLog(@"%@ %@", self.title, @"viewWillDisappear");
}

@end
