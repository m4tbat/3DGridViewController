//
//  MBTSplashViewController.m
//  3DGridViewController
//
//  Created by Matteo Battaglio on 11/08/14.
//  Copyright (c) 2014 Matteo Battaglio. All rights reserved.
//

#import "MBTSplashViewController.h"
#import <MBT3DGridViewController.h>
#import "MBT3DGridDataSource.h"
#import "MBT3DGridDelegate.h"

@interface MBTSplashViewController ()

@property (strong, nonatomic) MBT3DGridDataSource *gridDataSource;
@property (strong, nonatomic) MBT3DGridDelegate *gridDelegate;

@end

@implementation MBTSplashViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [self performSegueWithIdentifier:@"SplashToGrid" sender:self];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    MBT3DGridViewController *controller = [segue destinationViewController];
    
    if (!self.gridDataSource) {
        self.gridDataSource = [[MBT3DGridDataSource alloc] init];
    }
    controller.dataSource = self.gridDataSource;
    
    if (!self.gridDelegate) {
        self.gridDelegate = [[MBT3DGridDelegate alloc] initWithGridController:controller];
    }
    controller.delegate = self.gridDelegate;
}

@end
