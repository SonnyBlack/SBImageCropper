//
//  UIImage+Additions.h
//  TestRecognizers
//
//  Created by  Sonny Black on 05.02.13.
//  Copyright (c) 2013 Sonny Black. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Additions)

- (UIImage *)croppedImage:(CGRect)bounds;
+ (UIImage*)imageWithImage:(UIImage*)sourceImage scaledToSizeWithSameAspectRatio:(CGSize)targetSize;

@end
