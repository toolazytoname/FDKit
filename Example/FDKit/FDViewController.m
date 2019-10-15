//
//  FDViewController.m
//  FDKit
//
//  Created by toolazytoname on 11/22/2018.
//  Copyright (c) 2018 toolazytoname. All rights reserved.
//

#import "FDViewController.h"
#import "UIView+FDAdd.h"

@interface FDViewController ()

@end

@implementation FDViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    UIView *testView = [[UIView alloc] initWithFrame:CGRectMake(30, 30, 100, 120)];
    testView.backgroundColor = [UIColor purpleColor];
    [testView fd_addRoundedCornersRelativeWithRoundedRect:testView.bounds topLeftCornerRadius:10 topRightCornerRadius:20 bottomLeftCornerRadius:30 bottomRightCornerRadius:40 backgroundColor:testView.backgroundColor borderWidth:5   borderColor:[UIColor greenColor]];
    [self.view addSubview:testView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
