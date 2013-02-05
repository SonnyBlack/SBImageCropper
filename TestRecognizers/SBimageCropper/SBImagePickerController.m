//
//  SBImagePickerController.m
//  TestRecognizers
//
//  Created by  Sonny Black on 04.02.13.
//  Copyright (c) 2013 Sonny Black. All rights reserved.
//

#import "SBImagePickerController.h"


@interface SBImagePickerController ()

@end

@implementation SBImagePickerController

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

-(void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
	
	[UIApplication sharedApplication].statusBarHidden = YES;
}

-(void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
	
	[UIApplication sharedApplication].statusBarHidden = NO;
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
