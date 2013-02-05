#import "UIView+Additions.h"
#import "QuartzCore/QuartzCore.h"

/**
 * Additions.
 */

@implementation UIView (TTCategory)


///////////////////////////////////////////////////////////////////////////////////////////////////
- (CGFloat)left {
  return self.frame.origin.x;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)setLeft:(CGFloat)x {
  CGRect frame = self.frame;
  frame.origin.x = x;
  self.frame = frame;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (CGFloat)top {
  return self.frame.origin.y;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)setTop:(CGFloat)y {
  CGRect frame = self.frame;
  frame.origin.y = y;
  self.frame = frame;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (CGFloat)right {
  return self.frame.origin.x + self.frame.size.width;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)setRight:(CGFloat)right {
  CGRect frame = self.frame;
  frame.origin.x = right - frame.size.width;
  self.frame = frame;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (CGFloat)bottom {
  return self.frame.origin.y + self.frame.size.height;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)setBottom:(CGFloat)bottom {
  CGRect frame = self.frame;
  frame.origin.y = bottom - frame.size.height;
  self.frame = frame;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (CGFloat)centerX {
  return self.center.x;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)setCenterX:(CGFloat)centerX {
  self.center = CGPointMake(centerX, self.center.y);
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (CGFloat)centerY {
  return self.center.y;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)setCenterY:(CGFloat)centerY {
  self.center = CGPointMake(self.center.x, centerY);
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (CGFloat)width {
  return self.frame.size.width;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)setWidth:(CGFloat)width {
  CGRect frame = self.frame;
  frame.size.width = width;
  self.frame = frame;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (CGFloat)height {
  return self.frame.size.height;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)setHeight:(CGFloat)height {
  CGRect frame = self.frame;
  frame.size.height = height;
  self.frame = frame;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (CGFloat)ttScreenX {
  CGFloat x = 0.0f;
  for (UIView* view = self; view; view = view.superview) {
    x += view.left;
  }
  return x;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (CGFloat)ttScreenY {
  CGFloat y = 0.0f;
  for (UIView* view = self; view; view = view.superview) {
    y += view.top;
  }
  return y;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (CGFloat)screenViewX {
  CGFloat x = 0.0f;
  for (UIView* view = self; view; view = view.superview) {
      x += view.left;

    if ([view isKindOfClass:[UIScrollView class]]) {
      UIScrollView* scrollView = (UIScrollView*)view;
      x -= scrollView.contentOffset.x;
    }
  }

  return x;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (CGFloat)screenViewY {
  CGFloat y = 0;
  for (UIView* view = self; view; view = view.superview) {
    y += view.top;

    if ([view isKindOfClass:[UIScrollView class]]) {
      UIScrollView* scrollView = (UIScrollView*)view;
      y -= scrollView.contentOffset.y;
    }
  }
  return y;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (CGRect)screenFrame {
  return CGRectMake(self.screenViewX, self.screenViewY, self.width, self.height);
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (CGPoint)origin {
  return self.frame.origin;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)setOrigin:(CGPoint)origin {
  CGRect frame = self.frame;
  frame.origin = origin;
  self.frame = frame;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (CGSize)size {
  return self.frame.size;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)setSize:(CGSize)size {
  CGRect frame = self.frame;
  frame.size = size;
  self.frame = frame;
}



///////////////////////////////////////////////////////////////////////////////////////////////////
- (UIView*)descendantOrSelfWithClass:(Class)cls {
  if ([self isKindOfClass:cls])
    return self;

  for (UIView* child in self.subviews) {
    UIView* it = [child descendantOrSelfWithClass:cls];
    if (it)
      return it;
  }

  return nil;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (UIView*)ancestorOrSelfWithClass:(Class)cls {
  if ([self isKindOfClass:cls]) {
    return self;

  } else if (self.superview) {
    return [self.superview ancestorOrSelfWithClass:cls];

  } else {
    return nil;
  }
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)removeAllSubviews {
  while (self.subviews.count) {
    UIView* child = self.subviews.lastObject;
    [child removeFromSuperview];
  }
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (CGPoint)offsetFromView:(UIView*)otherView {
  CGFloat x = 0.0f, y = 0.0f;
  for (UIView* view = self; view && view != otherView; view = view.superview) {
    x += view.left;
    y += view.top;
  }
  return CGPointMake(x, y);
}

- (UIImage *) imageByRenderingView {
    CGFloat oldAlpha = self.alpha;
    self.alpha = 1;
    UIGraphicsBeginImageContextWithOptions(self.bounds.size, self.opaque, 0.0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetAllowsAntialiasing(context, true);
    CGContextSetAllowsFontSmoothing(context, true);
    CGContextSetAllowsFontSubpixelQuantization(context, true);
    CGContextSetAllowsFontSubpixelPositioning(context, true);
    [self.layer renderInContext:context];
	UIImage *resultingImage = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
    self.alpha = oldAlpha;
    return resultingImage;
}

+ (id)gradientViewWithFrame:(CGRect)frame colors:(NSArray*)colors directions:(NSArray*)directions{
    if ([colors count]==2 && [[colors objectAtIndex:0] isKindOfClass:[UIColor class]] && [[colors objectAtIndex:1] isKindOfClass:[UIColor class]]) {
        UIView *newView = [[UIView alloc] initWithFrame:frame];
        newView.userInteractionEnabled = NO;
        newView.backgroundColor = [UIColor clearColor];
        CAGradientLayer *gradientLayer = [CAGradientLayer layer];
        gradientLayer.frame = newView.bounds;
        gradientLayer.colors = [NSArray arrayWithObjects:(id)((UIColor*)[colors objectAtIndex:0]).CGColor, (id)((UIColor*)[colors objectAtIndex:1]).CGColor, nil];
        if ([directions count]==2 && [[directions objectAtIndex:0] isKindOfClass:[NSValue class]] && [[directions objectAtIndex:1] isKindOfClass:[NSValue class]]) {
            gradientLayer.startPoint = [[directions objectAtIndex:0] CGPointValue];
            gradientLayer.endPoint = [[directions objectAtIndex:1] CGPointValue];
        }
        [newView.layer addSublayer:gradientLayer];
        return newView;
    }
    return nil;
}

- (void)addGradient:(NSArray*)colors directions:(NSArray*)directions{
    if ([colors count]==2 && [[colors objectAtIndex:0] isKindOfClass:[UIColor class]] && [[colors objectAtIndex:1] isKindOfClass:[UIColor class]]) {
        self.backgroundColor = [UIColor clearColor];
        CAGradientLayer *gradientLayer = [CAGradientLayer layer];
        gradientLayer.frame = self.bounds;
        gradientLayer.colors = [NSArray arrayWithObjects:(id)((UIColor*)[colors objectAtIndex:0]).CGColor, (id)((UIColor*)[colors objectAtIndex:1]).CGColor, nil];
        if ([directions count]==2 && [[directions objectAtIndex:0] isKindOfClass:[NSValue class]] && [[directions objectAtIndex:1] isKindOfClass:[NSValue class]]) {
            gradientLayer.startPoint = [[directions objectAtIndex:0] CGPointValue];
            gradientLayer.endPoint = [[directions objectAtIndex:1] CGPointValue];
        }
        [self.layer addSublayer:gradientLayer];
    }
}

- (UIView*)loadNib:(NSString*)nibName{
    UIView *contentView = [[[NSBundle mainBundle] loadNibNamed:nibName owner:self options:nil] objectAtIndex:0];
    self.size = contentView.bounds.size;
    [self addSubview:contentView];
    return contentView;
}

@end
