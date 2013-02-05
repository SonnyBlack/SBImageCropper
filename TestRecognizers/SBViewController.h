//
//  SBViewController.h
//  TestRecognizers
//
//  Created by Sonny Black on 2/2/13.
//  Copyright (c) 2013 Sonny Black. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SBImageCropper.h"
#import "SBImagePickerController.h"

@interface SBViewController : UIViewController <SBImageCropperDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate>
{
	SBImagePickerController *imPicker;
	UIImageView				*preview;
}

@end
