//
//  SBImageCropper.m
//  TestRecognizers
//
//  Created by Sonny Black on 2/2/13.
//  Copyright (c) 2013 Sonny Black. All rights reserved.
//

#import "SBImageCropper.h"
#import "UIView+Additions.h"
#import "UIImage+Additions.h"

#define kEXTERNAL_OFFSET	200.0
#define kINTERNAL_OFFSET	200.0


@interface SBImageCropper ()

@end

#define IS_WIDESCREEN ([[UIScreen mainScreen ] bounds].size.height == 568.0f)

@implementation SBImageCropper

@synthesize delegate = _delegate;
@synthesize image = _image;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        [UIApplication sharedApplication].statusBarHidden = YES;
        self.navigationController.navigationBarHidden = YES;
        
    }
    return self;
}

-(void)viewDidLoad
{
	[super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
	// Do any additional setup after loading the view.
    
    
    self.view.backgroundColor = [UIColor blackColor];
	
	// add imageview (without loading)
    imageView = [[UIImageView alloc] initWithFrame:self.view.frame];
	[self.view addSubview:imageView];
    imageView.center = self.view.center;
    imageView.userInteractionEnabled = YES;
    
	
	// recognizers
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] init];
    [pan addTarget:self action:@selector(panAction:)];
    pan.minimumNumberOfTouches = 1;
    pan.minimumNumberOfTouches = 1;
    pan.delegate = self;
    [imageView addGestureRecognizer:pan];
    
    UIPinchGestureRecognizer *pinch = [[UIPinchGestureRecognizer alloc] init];
    [pinch addTarget:self action:@selector(zoomAction:)];
    pinch.delegate = self;
    [imageView addGestureRecognizer:pinch];
    
    // add masking view (with topMaskingView and bottomMaskingView better looks)
	UIView	*topMaskingView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, 320.0, 80.0)];
	topMaskingView.backgroundColor = [UIColor blackColor];
	topMaskingView.alpha = 0.4;
	topMaskingView.userInteractionEnabled = NO;
	[self.view addSubview:topMaskingView];
	
    cropper = [[UIView alloc] initWithFrame:CGRectMake(0, 80, 320, 320)];
    cropper.backgroundColor = [UIColor clearColor];
    cropper.userInteractionEnabled = NO;
	cropper.layer.borderColor = [[UIColor lightGrayColor] CGColor];
	cropper.layer.borderWidth = 1.0;
	cropper.layer.masksToBounds = NO;
	cropper.layer.shouldRasterize = YES;
    [self.view addSubview:cropper];
    
	UIView	*bottomMaskingView = [[UIView alloc] initWithFrame:CGRectMake(0.0, (IS_WIDESCREEN ? 488 : 400.0), 320.0, 80.0)];
	bottomMaskingView.backgroundColor = [UIColor blackColor];
	bottomMaskingView.alpha = 0.4;
	bottomMaskingView.userInteractionEnabled = NO;
	[self.view addSubview:bottomMaskingView];
	
	// add navigation bar in bottom side of view with items
	UINavigationBar *navigationBar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0.0, (IS_WIDESCREEN ? 524 : 436.0), 320.0, 44.0)];
	[navigationBar setBarStyle:UIBarStyleBlack];
	[navigationBar setTranslucent:YES];
	UINavigationItem *navigationItem = [[UINavigationItem alloc] initWithTitle:@"Move and Scale"];
	[navigationItem setLeftBarButtonItem:[[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelCropping)] autorelease]];
	[navigationItem setRightBarButtonItem:[[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(finishCropping)] autorelease]];
	[navigationBar setItems:[NSArray arrayWithObject:navigationItem]];
	
	[self.view addSubview:navigationBar];
}

-(void)viewDidAppear:(BOOL)animated
{
	[super viewDidAppear:animated];
	
	imageView.image = self.image;
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    //  imageView.layer.borderColor = [[UIColor redColor] CGColor];
    //  imageView.layer.borderWidth = 1.0;
    CGSize imageSize = imageView.image.size;
    CGFloat imageScale = fminf(CGRectGetWidth(imageView.bounds)/imageSize.width, CGRectGetHeight(imageView.bounds)/imageSize.height);
    CGSize scaledImageSize = CGSizeMake(imageSize.width*imageScale, imageSize.height*imageScale);
    CGRect imageFrame = CGRectMake(floorf(0.5 * (CGRectGetWidth(imageView.bounds) - scaledImageSize.width)), floorf(0.5f * (CGRectGetHeight(imageView.bounds) - scaledImageSize.height)), scaledImageSize.width, scaledImageSize.height);
    imageView.frame = imageFrame;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Gesture selectors

-(void) panAction:(UIPanGestureRecognizer *)recognizer
{
    CGPoint translation = [recognizer translationInView:self.view];
    recognizer.view.center = CGPointMake(recognizer.view.center.x + translation.x,
                                         recognizer.view.center.y + translation.y);
    [recognizer setTranslation:CGPointMake(0, 0) inView:self.view];
    
	UIView	*pannedView = [recognizer view];
	
	
	if (recognizer.state == UIGestureRecognizerStateChanged)
    {
		if (imageView.width <= cropper.width || imageView.height <= cropper.height)
		{
			if (pannedView.left < cropper.left - kINTERNAL_OFFSET)
			{
				pannedView.center = CGPointMake (cropper.left + pannedView.width / 2 - kINTERNAL_OFFSET, pannedView.center.y);
			}
			
			if (pannedView.top < cropper.top - kINTERNAL_OFFSET)
			{
				pannedView.center = CGPointMake (pannedView.center.x, cropper.top + pannedView.height / 2 - kINTERNAL_OFFSET);
			}
            
			if (pannedView.right > cropper.right + kINTERNAL_OFFSET)
			{
				pannedView.center = CGPointMake (cropper.right - pannedView.width / 2 + kINTERNAL_OFFSET, pannedView.center.y);
			}
			
			if (pannedView.bottom > cropper.bottom + kINTERNAL_OFFSET)
			{
				pannedView.center = CGPointMake (pannedView.center.x, cropper.bottom - pannedView.height / 2 + kINTERNAL_OFFSET);
			}
		}
		else
		{
			if (pannedView.left > cropper.left + kEXTERNAL_OFFSET)
			{
				pannedView.center = CGPointMake (cropper.left + pannedView.width / 2 + kEXTERNAL_OFFSET, recognizer.view.center.y);
			}
            
			
			if (pannedView.top > cropper.top + kEXTERNAL_OFFSET)
			{
				pannedView.center = CGPointMake (pannedView.center.x, cropper.top + pannedView.height/2 + kEXTERNAL_OFFSET);
			}
			
			if (pannedView.left + pannedView.width < cropper.left - kEXTERNAL_OFFSET)
			{
				pannedView.center = CGPointMake (cropper.left - pannedView.width/2 - kEXTERNAL_OFFSET, pannedView.center.y);
			}
			
			if (pannedView.bottom < cropper.bottom - kEXTERNAL_OFFSET)
			{
				pannedView.center = CGPointMake (pannedView.center.x, cropper.bottom - pannedView.height / 2 - kEXTERNAL_OFFSET);
			}
		}
	}
	else if (recognizer.state == UIGestureRecognizerStateEnded)
	{
        
		if (imageView.width < cropper.width)
		{
			if (imageView.top >= cropper.top)
			{
				[UIView animateWithDuration:0.4 delay:0.0 options:UIViewAnimationOptionCurveEaseOut animations:^{
                    pannedView.center = CGPointMake (cropper.left + pannedView.width / 2, cropper.top + pannedView.height / 2);
                } completion:nil];
				return;
			}
			else if (imageView.bottom <= cropper.bottom)
			{
				[UIView animateWithDuration:0.4 delay:0.0 options:UIViewAnimationOptionCurveEaseOut animations:^{
					pannedView.center = CGPointMake (cropper.left + pannedView.width / 2, cropper.bottom - pannedView.height / 2);
				} completion:nil];
				return;
			}
			else
			{
				[UIView animateWithDuration:0.4 delay:0.0 options:UIViewAnimationOptionCurveEaseOut animations:^{
					recognizer.view.center = CGPointMake (cropper.left + pannedView.width / 2, pannedView.center.y);
				} completion:nil];
				return;
			}
		}
		else if (imageView.height < cropper.height)
		{
			if (imageView.top <= cropper.top)
			{
				[UIView animateWithDuration:0.4 delay:0.0 options:UIViewAnimationOptionCurveEaseOut animations:^{
					recognizer.view.center = CGPointMake (cropper.left + pannedView.width / 2, cropper.top + pannedView.height / 2);
				} completion:nil];
				return;
			}
			else if (imageView.bottom >= cropper.bottom)
			{
				[UIView animateWithDuration:0.4 delay:0.0 options:UIViewAnimationOptionCurveEaseOut animations:^{
					recognizer.view.center = CGPointMake (cropper.frame.origin.x + pannedView.width / 2, cropper.top + cropper.height - pannedView.height / 2);
				} completion:nil];
                
				return;
			}
			else
			{
				[UIView animateWithDuration:0.4 delay:0.0 options:UIViewAnimationOptionCurveEaseOut animations:^{
					recognizer.view.center = CGPointMake (cropper.left + pannedView.width / 2, pannedView.center.y);
				} completion:nil];
				return;
                
			}
		}
		else
		{
			if (pannedView.left > cropper.left && pannedView.top > cropper.top)
			{
				[UIView animateWithDuration:0.4 delay:0.0 options:UIViewAnimationOptionCurveEaseOut animations:^{
					pannedView.center = CGPointMake (cropper.left + pannedView.width / 2, cropper.top + pannedView.height / 2);
				} completion:nil];
				return;
			}
			
			if (pannedView.right < cropper.right && pannedView.top > cropper.top)
			{
				[UIView animateWithDuration:0.4 delay:0.0 options:UIViewAnimationOptionCurveEaseOut animations:^{
					recognizer.view.center = CGPointMake (cropper.right - pannedView.width / 2, cropper.top + pannedView.height / 2);
				} completion:nil];
				return;
			}
            
			if (pannedView.right < cropper.right && pannedView.bottom < cropper.bottom)
			{
				[UIView animateWithDuration:0.4 delay:0.0 options:UIViewAnimationOptionCurveEaseOut animations:^{
					recognizer.view.center = CGPointMake (cropper.right - pannedView.width / 2, cropper.bottom - pannedView.height / 2);
				} completion:nil];
				return;
				
			}
            
			if (pannedView.left > cropper.left && pannedView.bottom < cropper.bottom)
			{
				[UIView animateWithDuration:0.4 delay:0.0 options:UIViewAnimationOptionCurveEaseOut animations:^{
					recognizer.view.center = CGPointMake (cropper.left + pannedView.width / 2, cropper.bottom - pannedView.height / 2);
				} completion:nil];
				return;
				
			}
            ////
			if (pannedView.left > cropper.left)
			{
				[UIView animateWithDuration:0.4 delay:0.0 options:UIViewAnimationOptionCurveEaseOut animations:^{
					recognizer.view.center = CGPointMake (cropper.left + pannedView.width / 2, pannedView.center.y);
				} completion:nil];
			}
			
			if (pannedView.top > cropper.top)
			{
				[UIView animateWithDuration:0.4 delay:0.0 options:UIViewAnimationOptionCurveEaseOut animations:^{
					recognizer.view.center = CGPointMake (pannedView.center.x, cropper.frame.origin.y + pannedView.height / 2);
				} completion:nil];
				
			}
			
			if (pannedView.right < cropper.right)
			{
				[UIView animateWithDuration:0.4 delay:0.0 options:UIViewAnimationOptionCurveEaseOut animations:^{
					recognizer.view.center = CGPointMake (cropper.right - pannedView.width / 2, pannedView.center.y);
				} completion:nil];
				
				
			}
			
			if (pannedView.bottom < cropper.bottom)
			{
				[UIView animateWithDuration:0.4 delay:0.0 options:UIViewAnimationOptionCurveEaseOut animations:^{
					recognizer.view.center = CGPointMake (pannedView.center.x, cropper.bottom - pannedView.height / 2);
				} completion:nil];
                
			}
		}
	}
}

-(void) zoomAction:(UIPinchGestureRecognizer *)recognizer
{
	if([recognizer state] == UIGestureRecognizerStateBegan) {
        // Reset the last scale, necessary if there are multiple objects with different scales
        lastScale = [recognizer scale];
    }
	
    if ([recognizer state] == UIGestureRecognizerStateBegan ||
		[recognizer state] == UIGestureRecognizerStateChanged)
	{
		
        CGFloat currentScale = [[[recognizer view].layer valueForKeyPath:@"transform.scale"] floatValue];
		
        // Constants to adjust the max/min values of zoom
        const CGFloat kMaxScale = 1.4;
        const CGFloat kMinScale = 1.0;
		
        CGFloat newScale = 1 -  (lastScale - [recognizer scale]);
        newScale = MIN(newScale, kMaxScale / currentScale);
        newScale = MAX(newScale, kMinScale / currentScale);
        CGAffineTransform transform = CGAffineTransformScale([[recognizer view] transform], newScale, newScale);
        [recognizer view].transform = transform;
		
        lastScale = [recognizer scale];  // Store the previous scale factor for the next pinch gesture call
    }
	
	if ([recognizer state] == UIGestureRecognizerStateEnded  && lastScale <= 1)
	{
		[UIView animateWithDuration:0.4 delay:0.0 options:UIViewAnimationOptionCurveEaseOut animations:^{
			recognizer.view.center = CGPointMake (self.view.center.x, self.view.center.y);
		} completion:nil];
	}
}


#pragma mark - navigation selectors


-(void) cancelCropping
{
	[self.navigationController popViewControllerAnimated:YES];
}

-(void) finishCropping
{
	UIImage *resizedImage = [UIImage imageWithImage:self.image scaledToSizeWithSameAspectRatio:imageView.bounds.size];
	UIImage *croppedImage = [resizedImage croppedImage:[cropper convertRect:cropper.bounds toView:imageView]];
	
	if (_delegate && [_delegate respondsToSelector:@selector(cropperDidFinished:withImage:)])
	{
		//[self.navigationController popToRootViewControllerAnimated:YES];
		[_delegate cropperDidFinished:self withImage:croppedImage];
	}
	
}





@end
