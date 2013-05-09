//
//  UIImage+Additions.m
//  TestRecognizers
//
//  Created by  Sonny Black on 05.02.13.
//  Copyright (c) 2013 Sonny Black. All rights reserved.
//

#import "UIImage+Additions.h"

@implementation UIImage (Additions)


- (UIImage *)croppedImage:(CGRect)bounds {
    CGImageRef imageRef = CGImageCreateWithImageInRect([self CGImage], bounds);
    UIImage *croppedImage = [UIImage imageWithCGImage:imageRef];
    CGImageRelease(imageRef);
    return croppedImage;
}

- (UIImage *)resizeImageToSize:(CGSize)newSize {
    CGRect newRect = CGRectIntegral(CGRectMake(0, 0, newSize.width, newSize.height));
    CGImageRef imageRef = self.CGImage;
	
    UIGraphicsBeginImageContextWithOptions(newSize, NO, 0);
    CGContextRef context = UIGraphicsGetCurrentContext();
	
    // Set the quality level to use when rescaling
    CGContextSetInterpolationQuality(context, kCGInterpolationHigh);
    CGAffineTransform flipVertical = CGAffineTransformMake(1.0, 0, 0, -1.0, 0, newSize.height);
    CGContextConcatCTM(context, flipVertical);
	
    // Draw into the context; this scales the image
    CGContextDrawImage(context, newRect, imageRef);
	
    // Get the resized image from the context and a UIImage
    CGImageRef newImageRef = CGBitmapContextCreateImage(context);
    UIImage *newImage = [UIImage imageWithCGImage:newImageRef];
	
    CGImageRelease(newImageRef);
    UIGraphicsEndImageContext();
	
    return newImage;
}

@end
