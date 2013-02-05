//
//  SBImageCropper.h
//  TestRecognizers
//
//  Created by Sonny Black on 2/2/13.
//  Copyright (c) 2013 Sonny Black. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SBImageCropperDelegate;

@interface SBImageCropper : UIViewController <UIGestureRecognizerDelegate>
{
    UIImageView     *imageView;
	
    UIView          *cropper;
	
	CGFloat			lastScale;
	CGPoint			lastPoint;
	
	__unsafe_unretained id<SBImageCropperDelegate> _delegate;
}

@property (nonatomic, strong)	UIImage							*image;
@property (nonatomic, assign)	id<SBImageCropperDelegate>		delegate;

@end



@protocol SBImageCropperDelegate <NSObject>

@optional
-(void)cropperDidFinished:(SBImageCropper *)cropper withImage:(UIImage *)image;

@end