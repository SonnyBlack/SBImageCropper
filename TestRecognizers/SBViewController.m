//
//  SBViewController.m
//  TestRecognizers
//
//  Created by Sonny Black on 2/2/13.
//  Copyright (c) 2013 Sonny Black. All rights reserved.
//

#import "SBViewController.h"
#import "SBImageCropper.h"


@interface SBViewController ()

@end

@implementation SBViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
	preview = [[UIImageView alloc] initWithFrame:CGRectMake(10.0, 20.0, 300.0, 300.0)];
	preview.contentMode = UIViewContentModeScaleAspectFit;
	[self.view addSubview:preview];
	
    UIButton *openGallery = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [openGallery setTitle:@"Open" forState:UIControlStateNormal];
    openGallery.frame = CGRectMake(100.0, 400.0, 120.0, 40.0);
    [openGallery addTarget:self action:@selector(openActionDidPressed) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:openGallery];
    
}


-(void) openActionDidPressed
{
    imPicker = [[SBImagePickerController alloc] init];
    imPicker.delegate = self;
    [self presentViewController:imPicker animated:YES completion:nil];
    
}


- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info;

{
    UIImage *selectedIm = [info objectForKey:UIImagePickerControllerOriginalImage];
	SBImageCropper *cropper = [[SBImageCropper alloc] init];
	cropper.delegate = self;
	cropper.image = selectedIm;
	[picker pushViewController:cropper animated:YES];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)cropperDidFinished:(SBImageCropper *)cropper withImage:(UIImage *)image
{
	[imPicker dismissViewControllerAnimated:YES completion:nil];
	preview.image = image;
	imPicker = nil;
	
}

@end
