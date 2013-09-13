//
//  IBJogShuttle.m
//  slider
//
//  Created by Ingo Böhme on 02.06.13.
//  Copyright (c) 2013 Ingo Böhme. All rights reserved.
//

#import "IBJogShuttle.h"

@implementation IBJogShuttle

-(id) init {
    self = [super init];
    if (self) {
    }
    
    return self;
  
}

-(id) initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
    }
    NSLog(@".. %@", self);
    return self;
    
}
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor  clearColor];
        self.backgroundColor = [UIColor  redColor];
        self.delegate = self;
        self.bounces = NO;
        self.showsHorizontalScrollIndicator = NO;
        self.showsVerticalScrollIndicator=NO;
        self.grooveCount = 11;
        self.borderBottom = YES;
        self.borderTop = YES;
        
        _minValue = 0.0;
        _maxValue = 100.0;
        _value = 50.0;
        
        self.jogShuttleDelegate=nil;
        CGRect sliderFrame = self.bounds;
        sliderFrame.size.width *= 2;
        sliderFrame.size.height -= 6;
        sliderFrame.origin.y += 3;
        
        _slider = [[IBJogShuttleSlider alloc] initWithFrame:sliderFrame];
        _slider.grooveCount = self.grooveCount;
        self.contentSize = sliderFrame.size;
        [self addSubview:_slider];
        [self centerSlider:NO];
        NSLog(@".. %@", self);

    }
    return self;
}

-(void) setGrooveCount:(NSInteger)grooveCount {
    _grooveCount = grooveCount;
    if (_slider) {
        _slider.grooveCount = _grooveCount;
    }
    
}

-(void) centerSlider: (BOOL) animated {
    
    int scrollViewWidth = self.frame.size.width;
    int contentViewWidth = self.contentSize.width;
    int offset = (contentViewWidth-scrollViewWidth)/2;
    if (animated) {
        [UIView beginAnimations:@"slideToCenter" context:nil];
        [UIView setAnimationDuration:0.2];
    }
    self.contentOffset = CGPointMake(offset, 0);
    if (animated) {
        [UIView commitAnimations];
    }
    
}


#pragma mark - The ScrollView Protocol - UIScrollViewDelegate

//scrollViewDidEndDecelerating:
//Tells the delegate that the scroll view has ended decelerating the scrolling movement.
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
  //  [self centerSlider:NO];


}

-(void) scrollViewWillBeginDecelerating:(UIScrollView *)scrollView {
 //   [self centerSlider:YES];

}

//scrollViewDidEndDragging:willDecelerate:
//Tells the delegate when dragging ended in the scroll view.
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {

  //  NSLog(@"%@ - %@", NSStringFromCGSize(self.contentSize), NSStringFromCGPoint(self.contentOffset));

    
    
    
    
    [self centerSlider:YES];
}

//scrollViewDidEndScrollingAnimation:
//Tells the delegate when a scrolling animation in the scroll view concludes.
//- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView { }

//scrollViewDidScroll:
//Tells the delegate when the user scrolls the content view within the receiver.
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    int scrollViewWidth = self.frame.size.width;
    int contentViewWidth = self.contentSize.width;
    int maxOffset = (contentViewWidth-scrollViewWidth);
    CGPoint currentOffset = self.contentOffset;
    if (currentOffset.x<=0) {
        currentOffset.x = 0;
    } else if (currentOffset.x>=maxOffset) {
        currentOffset.x = maxOffset;
    } else {
    //    currentOffset.x = floor(currentOffset.x / 2) * 2;
    }
    
    
    self.contentOffset = currentOffset;
    
    
    _value = (_maxValue - _minValue)/2   * (1 + [self getPercent]);
    
    
    
    [self didChangeJogShuttlePercentage:self];
    

}

-(float) getPercent {
    
    float percent = ((self.contentSize.width/2 - self.contentOffset.x) - self.contentSize.width/4) / (self.contentSize.width/4);
   // NSLog(@"%f", percent);
    return percent;
}


- (void)didChangeJogShuttlePercentage:(IBJogShuttle *)jogShuttle {
    if (_jogShuttleDelegate) {
        [_jogShuttleDelegate didChangeJogShuttlePercentage:jogShuttle];
    } else
        NSLog(@"%f   -   %f", [self getPercent], _value);
}


//scrollViewWillBeginDecelerating:
//Tells the delegate that the scroll view is starting to decelerate the scrolling movement.
//- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView { }

//scrollViewWillBeginDragging:
//Tells the delegate when the scroll view is about to start scrolling the content
//- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView { }





- (void)drawRect:(CGRect)rect
{
    //// General Declarations
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    //// Color Declarations
    UIColor* gradientColorDark = [UIColor colorWithRed: 0.409 green: 0.409 blue: 0.409 alpha: 1];
    CGFloat gradientColorDarkHSBA[4];
    [gradientColorDark getHue: &gradientColorDarkHSBA[0] saturation: &gradientColorDarkHSBA[1] brightness: &gradientColorDarkHSBA[2] alpha: &gradientColorDarkHSBA[3]];
    
    UIColor* gradientColorLight = [UIColor colorWithHue: gradientColorDarkHSBA[0] saturation: gradientColorDarkHSBA[1] brightness: 0.6 alpha: gradientColorDarkHSBA[3]];
    UIColor* gradientColorBack = [UIColor colorWithRed: 0.987 green: 0.987 blue: 0.987 alpha: 1];
    UIColor* gradientColorLightBorder = [UIColor colorWithRed: 0.736 green: 0.736 blue: 0.736 alpha: 1];
    
    //// Gradient Declarations
    NSArray* wheelGradientColors = [NSArray arrayWithObjects:
                                    (id)gradientColorDark.CGColor,
                                    (id)gradientColorLight.CGColor,
                                    (id)[UIColor colorWithRed: 0.793 green: 0.793 blue: 0.793 alpha: 1].CGColor,
                                    (id)gradientColorBack.CGColor,
                                    (id)gradientColorLight.CGColor,
                                    (id)gradientColorDark.CGColor, nil];
    CGFloat wheelGradientLocations[] = {0, 0.06, 0.13, 0.53, 0.93, 1};
    CGGradientRef wheelGradient = CGGradientCreateWithColors(colorSpace, (__bridge CFArrayRef)wheelGradientColors, wheelGradientLocations);
   
    
    NSArray* borderGradientColors = [NSArray arrayWithObjects:
                                     (id)gradientColorDark.CGColor,
                                     (id)[UIColor colorWithRed: 0.623 green: 0.623 blue: 0.623 alpha: 1].CGColor,
                                     (id)gradientColorLightBorder.CGColor,
                                     (id)[UIColor colorWithRed: 0.623 green: 0.623 blue: 0.623 alpha: 1].CGColor,
                                     (id)gradientColorDark.CGColor, nil];
    CGFloat borderGradientLocations[] = {0, 0.08, 0.5, 0.92, 1};
    CGGradientRef borderGradient = CGGradientCreateWithColors(colorSpace, (__bridge CFArrayRef)borderGradientColors, borderGradientLocations);
    
    //// Frames
    CGRect frame = rect; // CGRectMake(0, 16, 240, 27);
    
    
    //// wheel Drawing
    CGRect wheelRect = CGRectMake(CGRectGetMinX(frame), CGRectGetMinY(frame), CGRectGetWidth(frame), CGRectGetHeight(frame) );
    UIBezierPath* wheelPath = [UIBezierPath bezierPathWithRect: wheelRect];
    CGContextSaveGState(context);
    [wheelPath addClip];
    CGContextDrawLinearGradient(context, wheelGradient,
                                CGPointMake(CGRectGetMinX(wheelRect), CGRectGetMidY(wheelRect)),
                                CGPointMake(CGRectGetMaxX(wheelRect), CGRectGetMidY(wheelRect)),
                                0);
    CGContextRestoreGState(context);
    
    
    if (_borderBottom) {
        
        //// borderBottom Drawing
        CGRect borderBottomRect = CGRectMake(CGRectGetMinX(frame), CGRectGetMinY(frame) + CGRectGetHeight(frame) - 2, CGRectGetWidth(frame), 2);
        UIBezierPath* borderBottomPath = [UIBezierPath bezierPathWithRect: borderBottomRect];
        CGContextSaveGState(context);
        [borderBottomPath addClip];
        CGContextDrawLinearGradient(context, borderGradient,
                                    CGPointMake(CGRectGetMaxX(borderBottomRect), CGRectGetMidY(borderBottomRect)),
                                    CGPointMake(CGRectGetMinX(borderBottomRect), CGRectGetMidY(borderBottomRect)),
                                    0);
        CGContextRestoreGState(context);
        
    }
    
    if (_borderTop) {
        //// borderTop Drawing
        CGRect borderTopRect = CGRectMake(CGRectGetMinX(frame), CGRectGetMinY(frame), CGRectGetWidth(frame), 2);
        UIBezierPath* borderTopPath = [UIBezierPath bezierPathWithRect: borderTopRect];
        CGContextSaveGState(context);
        [borderTopPath addClip];
        CGContextDrawLinearGradient(context, borderGradient,
                                    CGPointMake(CGRectGetMaxX(borderTopRect), CGRectGetMidY(borderTopRect)),
                                    CGPointMake(CGRectGetMinX(borderTopRect), CGRectGetMidY(borderTopRect)),
                                    0);
        CGContextRestoreGState(context);
    }
    
    
    //// Cleanup
    CGGradientRelease(wheelGradient);
    CGGradientRelease(borderGradient);
    CGColorSpaceRelease(colorSpace);
    
    
    
}





@end







#pragma mark -Slider
@implementation IBJogShuttleSlider
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}


- (void)drawRectButtonInRect:(CGRect)rect {
    //// General Declarations
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    //// Color Declarations
    UIColor* flareWhite = [UIColor colorWithRed: 1 green: 1 blue: 1 alpha: 0.781];
    UIColor* leftRectButtonGradientColor = [UIColor colorWithRed: 1 green: 1 blue: 1 alpha: 0];
    UIColor* rightRectButtonGradientColor = [UIColor colorWithRed: 0 green: 0 blue: 0 alpha: 0];
    UIColor* color = [UIColor colorWithRed: 0.5 green: 0.5 blue: 0.5 alpha: 1];
    
    //// Gradient Declarations
    NSArray* rectButtonGradientColors = [NSArray arrayWithObjects:
                                         (id)rightRectButtonGradientColor.CGColor,
                                         (id)[UIColor colorWithRed: 0.5 green: 0.5 blue: 0.5 alpha: 0.391].CGColor,
                                         (id)flareWhite.CGColor,
                                         (id)[UIColor colorWithRed: 1 green: 1 blue: 1 alpha: 0.781].CGColor,
                                         (id)flareWhite.CGColor,
                                         (id)[UIColor colorWithRed: 1 green: 1 blue: 1 alpha: 0.391].CGColor,
                                         (id)leftRectButtonGradientColor.CGColor, nil];
    CGFloat rectButtonGradientLocations[] = {0, 0.05, 0.22, 0.41, 0.6, 0.84, 1};
    CGGradientRef rectButtonGradient = CGGradientCreateWithColors(colorSpace, (__bridge CFArrayRef)rectButtonGradientColors, rectButtonGradientLocations);
    
    //// Shadow Declarations
    UIColor* buttonOuterShadow = color;
    CGSize buttonOuterShadowOffset = CGSizeMake(1.1, 1.1);
    CGFloat buttonOuterShadowBlurRadius = 12.5;
    
    //// Frames
    CGRect frame = rect; // CGRectMake(0, 0, 20, 56);
    
    
    //// buttonRectangle Drawing
    CGRect buttonRectangleRect = CGRectMake(CGRectGetMinX(frame) + floor(CGRectGetWidth(frame) * 0.00000 + 0.5), CGRectGetMinY(frame) + floor(CGRectGetHeight(frame) * 0.00000 + 0.5), floor(CGRectGetWidth(frame) * 1.00000 + 0.5) - floor(CGRectGetWidth(frame) * 0.00000 + 0.5), floor(CGRectGetHeight(frame) * 1.00000 + 0.5) - floor(CGRectGetHeight(frame) * 0.00000 + 0.5));
    UIBezierPath* buttonRectanglePath = [UIBezierPath bezierPathWithRect: buttonRectangleRect];
    CGContextSaveGState(context);
    CGContextSetShadowWithColor(context, buttonOuterShadowOffset, buttonOuterShadowBlurRadius, buttonOuterShadow.CGColor);
    CGContextBeginTransparencyLayer(context, NULL);
    [buttonRectanglePath addClip];
    CGContextDrawLinearGradient(context, rectButtonGradient,
                                CGPointMake(CGRectGetMinX(buttonRectangleRect), CGRectGetMidY(buttonRectangleRect)),
                                CGPointMake(CGRectGetMaxX(buttonRectangleRect), CGRectGetMidY(buttonRectangleRect)),
                                0);
    CGContextEndTransparencyLayer(context);
    CGContextRestoreGState(context);
    
    
    
    //// Cleanup
    CGGradientRelease(rectButtonGradient);
    CGColorSpaceRelease(colorSpace);
    

    
}


- (void)drawRoundButtonInRect:(CGRect)rect {
    //// General Declarations
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    //// Color Declarations
    UIColor* upColorOut = [UIColor colorWithRed: 0.748 green: 0.748 blue: 0.748 alpha: 1];
    UIColor* bottomColorDown = [UIColor colorWithRed: 0.16 green: 0.16 blue: 0.16 alpha: 1];
    UIColor* upColorInner = [UIColor colorWithRed: 0.129 green: 0.132 blue: 0.148 alpha: 1];
    UIColor* bottomColorInner = [UIColor colorWithRed: 0.975 green: 0.975 blue: 0.985 alpha: 1];
    UIColor* buttonColor = [UIColor colorWithRed: 0 green: 0.308 blue: 1 alpha: 1];
    CGFloat buttonColorRGBA[4];
    [buttonColor getRed: &buttonColorRGBA[0] green: &buttonColorRGBA[1] blue: &buttonColorRGBA[2] alpha: &buttonColorRGBA[3]];
    
    UIColor* buttonTopColor = [UIColor colorWithRed: (buttonColorRGBA[0] * 0.8) green: (buttonColorRGBA[1] * 0.8) blue: (buttonColorRGBA[2] * 0.8) alpha: (buttonColorRGBA[3] * 0.8 + 0.2)];
    UIColor* buttonBottomColor = [UIColor colorWithRed: (buttonColorRGBA[0] * 0 + 1) green: (buttonColorRGBA[1] * 0 + 1) blue: (buttonColorRGBA[2] * 0 + 1) alpha: (buttonColorRGBA[3] * 0 + 1)];
    UIColor* buttonFlareUpColor = [UIColor colorWithRed: (buttonColorRGBA[0] * 0.3 + 0.7) green: (buttonColorRGBA[1] * 0.3 + 0.7) blue: (buttonColorRGBA[2] * 0.3 + 0.7) alpha: (buttonColorRGBA[3] * 0.3 + 0.7)];
    UIColor* buttonFlareBottomColor = [UIColor colorWithRed: (buttonColorRGBA[0] * 0.8 + 0.2) green: (buttonColorRGBA[1] * 0.8 + 0.2) blue: (buttonColorRGBA[2] * 0.8 + 0.2) alpha: (buttonColorRGBA[3] * 0.8 + 0.2)];
    UIColor* flareWhite = [UIColor colorWithRed: 1 green: 1 blue: 1 alpha: 0.83];
    
    //// Gradient Declarations
    NSArray* ringGradientColors = [NSArray arrayWithObjects:
                                   (id)upColorOut.CGColor,
                                   (id)bottomColorDown.CGColor, nil];
    CGFloat ringGradientLocations[] = {0, 1};
    CGGradientRef ringGradient = CGGradientCreateWithColors(colorSpace, (__bridge CFArrayRef)ringGradientColors, ringGradientLocations);
    NSArray* ringInnerGradientColors = [NSArray arrayWithObjects:
                                        (id)upColorInner.CGColor,
                                        (id)bottomColorInner.CGColor, nil];
    CGFloat ringInnerGradientLocations[] = {0, 1};
    CGGradientRef ringInnerGradient = CGGradientCreateWithColors(colorSpace, (__bridge CFArrayRef)ringInnerGradientColors, ringInnerGradientLocations);
    NSArray* buttonGradientColors = [NSArray arrayWithObjects:
                                     (id)buttonBottomColor.CGColor,
                                     (id)buttonTopColor.CGColor, nil];
    CGFloat buttonGradientLocations[] = {0, 1};
    CGGradientRef buttonGradient = CGGradientCreateWithColors(colorSpace, (__bridge CFArrayRef)buttonGradientColors, buttonGradientLocations);
    NSArray* overlayGradientColors = [NSArray arrayWithObjects:
                                      (id)flareWhite.CGColor,
                                      (id)[UIColor clearColor].CGColor, nil];
    CGFloat overlayGradientLocations[] = {0, 1};
    CGGradientRef overlayGradient = CGGradientCreateWithColors(colorSpace, (__bridge CFArrayRef)overlayGradientColors, overlayGradientLocations);
    NSArray* buttonFlareGradientColors = [NSArray arrayWithObjects:
                                          (id)buttonFlareUpColor.CGColor,
                                          (id)buttonFlareBottomColor.CGColor, nil];
    CGFloat buttonFlareGradientLocations[] = {0, 1};
    CGGradientRef buttonFlareGradient = CGGradientCreateWithColors(colorSpace, (__bridge CFArrayRef)buttonFlareGradientColors, buttonFlareGradientLocations);
    
    //// Shadow Declarations
    UIColor* buttonInnerShadow = [UIColor blackColor];
    CGSize buttonInnerShadowOffset = CGSizeMake(0.1, -0.1);
    CGFloat buttonInnerShadowBlurRadius = 5;
    UIColor* buttonOuterShadow = [UIColor blackColor];
    CGSize buttonOuterShadowOffset = CGSizeMake(0.1, 2.1);
    CGFloat buttonOuterShadowBlurRadius = 5;
    
    //// Frames
    CGRect frame = rect; // CGRectMake(0, 0, 71, 71);
    
    
    //// outerOval Drawing
    CGRect outerOvalRect = CGRectMake(CGRectGetMinX(frame) + floor(CGRectGetWidth(frame) * 0.04225 + 0.5), CGRectGetMinY(frame) + floor(CGRectGetHeight(frame) * 0.04225 + 0.5), floor(CGRectGetWidth(frame) * 0.92958 + 0.5) - floor(CGRectGetWidth(frame) * 0.04225 + 0.5), floor(CGRectGetHeight(frame) * 0.92958 + 0.5) - floor(CGRectGetHeight(frame) * 0.04225 + 0.5));
    UIBezierPath* outerOvalPath = [UIBezierPath bezierPathWithOvalInRect: outerOvalRect];
    CGContextSaveGState(context);
    CGContextSetShadowWithColor(context, buttonOuterShadowOffset, buttonOuterShadowBlurRadius, buttonOuterShadow.CGColor);
    CGContextBeginTransparencyLayer(context, NULL);
    [outerOvalPath addClip];
    CGContextDrawLinearGradient(context, ringGradient,
                                CGPointMake(CGRectGetMidX(outerOvalRect), CGRectGetMinY(outerOvalRect)),
                                CGPointMake(CGRectGetMidX(outerOvalRect), CGRectGetMaxY(outerOvalRect)),
                                0);
    CGContextEndTransparencyLayer(context);
    CGContextRestoreGState(context);
    
    
    
    //// overlayOval Drawing
    CGRect overlayOvalRect = CGRectMake(CGRectGetMinX(frame) + floor(CGRectGetWidth(frame) * 0.04225 + 0.5), CGRectGetMinY(frame) + floor(CGRectGetHeight(frame) * 0.04225 + 0.5), floor(CGRectGetWidth(frame) * 0.92958 + 0.5) - floor(CGRectGetWidth(frame) * 0.04225 + 0.5), floor(CGRectGetHeight(frame) * 0.92958 + 0.5) - floor(CGRectGetHeight(frame) * 0.04225 + 0.5));
    UIBezierPath* overlayOvalPath = [UIBezierPath bezierPathWithOvalInRect: overlayOvalRect];
    CGContextSaveGState(context);
    [overlayOvalPath addClip];
    CGFloat overlayOvalResizeRatio = MIN(CGRectGetWidth(overlayOvalRect) / 63, CGRectGetHeight(overlayOvalRect) / 63);
    CGContextDrawRadialGradient(context, overlayGradient,
                                CGPointMake(CGRectGetMidX(overlayOvalRect) + 0 * overlayOvalResizeRatio, CGRectGetMidY(overlayOvalRect) + -24.27 * overlayOvalResizeRatio), 17.75 * overlayOvalResizeRatio,
                                CGPointMake(CGRectGetMidX(overlayOvalRect) + 0 * overlayOvalResizeRatio, CGRectGetMidY(overlayOvalRect) + 0 * overlayOvalResizeRatio), 44.61 * overlayOvalResizeRatio,
                                kCGGradientDrawsBeforeStartLocation | kCGGradientDrawsAfterEndLocation);
    CGContextRestoreGState(context);
    
    
    //// innerOval Drawing
    CGRect innerOvalRect = CGRectMake(CGRectGetMinX(frame) + floor(CGRectGetWidth(frame) * 0.14085 + 0.5), CGRectGetMinY(frame) + floor(CGRectGetHeight(frame) * 0.14085 + 0.5), floor(CGRectGetWidth(frame) * 0.83099 + 0.5) - floor(CGRectGetWidth(frame) * 0.14085 + 0.5), floor(CGRectGetHeight(frame) * 0.83099 + 0.5) - floor(CGRectGetHeight(frame) * 0.14085 + 0.5));
    UIBezierPath* innerOvalPath = [UIBezierPath bezierPathWithOvalInRect: innerOvalRect];
    CGContextSaveGState(context);
    [innerOvalPath addClip];
    CGContextDrawLinearGradient(context, ringInnerGradient,
                                CGPointMake(CGRectGetMidX(innerOvalRect), CGRectGetMinY(innerOvalRect)),
                                CGPointMake(CGRectGetMidX(innerOvalRect), CGRectGetMaxY(innerOvalRect)),
                                0);
    CGContextRestoreGState(context);
    
    
    //// buttonOval Drawing
    CGRect buttonOvalRect = CGRectMake(CGRectGetMinX(frame) + floor(CGRectGetWidth(frame) * 0.16901 + 0.5), CGRectGetMinY(frame) + floor(CGRectGetHeight(frame) * 0.15493 + 0.5), floor(CGRectGetWidth(frame) * 0.81690 + 0.5) - floor(CGRectGetWidth(frame) * 0.16901 + 0.5), floor(CGRectGetHeight(frame) * 0.80282 + 0.5) - floor(CGRectGetHeight(frame) * 0.15493 + 0.5));
    UIBezierPath* buttonOvalPath = [UIBezierPath bezierPathWithOvalInRect: buttonOvalRect];
    CGContextSaveGState(context);
    [buttonOvalPath addClip];
    CGFloat buttonOvalResizeRatio = MIN(CGRectGetWidth(buttonOvalRect) / 46, CGRectGetHeight(buttonOvalRect) / 46);
    CGContextDrawRadialGradient(context, buttonGradient,
                                CGPointMake(CGRectGetMidX(buttonOvalRect) + 0 * buttonOvalResizeRatio, CGRectGetMidY(buttonOvalRect) + 27.23 * buttonOvalResizeRatio), 2.44 * buttonOvalResizeRatio,
                                CGPointMake(CGRectGetMidX(buttonOvalRect) + 0 * buttonOvalResizeRatio, CGRectGetMidY(buttonOvalRect) + 8.48 * buttonOvalResizeRatio), 23.14 * buttonOvalResizeRatio,
                                kCGGradientDrawsBeforeStartLocation | kCGGradientDrawsAfterEndLocation);
    CGContextRestoreGState(context);
    
    ////// buttonOval Inner Shadow
    CGRect buttonOvalBorderRect = CGRectInset([buttonOvalPath bounds], -buttonInnerShadowBlurRadius, -buttonInnerShadowBlurRadius);
    buttonOvalBorderRect = CGRectOffset(buttonOvalBorderRect, -buttonInnerShadowOffset.width, -buttonInnerShadowOffset.height);
    buttonOvalBorderRect = CGRectInset(CGRectUnion(buttonOvalBorderRect, [buttonOvalPath bounds]), -1, -1);
    
    UIBezierPath* buttonOvalNegativePath = [UIBezierPath bezierPathWithRect: buttonOvalBorderRect];
    [buttonOvalNegativePath appendPath: buttonOvalPath];
    buttonOvalNegativePath.usesEvenOddFillRule = YES;
    
    CGContextSaveGState(context);
    {
        CGFloat xOffset = buttonInnerShadowOffset.width + round(buttonOvalBorderRect.size.width);
        CGFloat yOffset = buttonInnerShadowOffset.height;
        CGContextSetShadowWithColor(context,
                                    CGSizeMake(xOffset + copysign(0.1, xOffset), yOffset + copysign(0.1, yOffset)),
                                    buttonInnerShadowBlurRadius,
                                    buttonInnerShadow.CGColor);
        
        [buttonOvalPath addClip];
        CGAffineTransform transform = CGAffineTransformMakeTranslation(-round(buttonOvalBorderRect.size.width), 0);
        [buttonOvalNegativePath applyTransform: transform];
        [[UIColor grayColor] setFill];
        [buttonOvalNegativePath fill];
    }
    CGContextRestoreGState(context);
    
    
    
    //// flareOval Drawing
    CGRect flareOvalRect = CGRectMake(CGRectGetMinX(frame) + floor(CGRectGetWidth(frame) * 0.28169 + 0.5), CGRectGetMinY(frame) + floor(CGRectGetHeight(frame) * 0.16901 + 0.5), floor(CGRectGetWidth(frame) * 0.69014 + 0.5) - floor(CGRectGetWidth(frame) * 0.28169 + 0.5), floor(CGRectGetHeight(frame) * 0.38028 + 0.5) - floor(CGRectGetHeight(frame) * 0.16901 + 0.5));
    UIBezierPath* flareOvalPath = [UIBezierPath bezierPathWithOvalInRect: flareOvalRect];
    CGContextSaveGState(context);
    [flareOvalPath addClip];
    CGContextDrawLinearGradient(context, buttonFlareGradient,
                                CGPointMake(CGRectGetMidX(flareOvalRect), CGRectGetMinY(flareOvalRect)),
                                CGPointMake(CGRectGetMidX(flareOvalRect), CGRectGetMaxY(flareOvalRect)),
                                0);
    CGContextRestoreGState(context);
    
    
    //// Cleanup
    CGGradientRelease(ringGradient);
    CGGradientRelease(ringInnerGradient);
    CGGradientRelease(buttonGradient);
    CGGradientRelease(overlayGradient);
    CGGradientRelease(buttonFlareGradient);
    CGColorSpaceRelease(colorSpace);
    

}



- (void)xxdrawButtonInRect:(CGRect)rect
{
    
    //// General Declarations
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    //// Color Declarations
    UIColor* upColorOut = [UIColor colorWithRed: 0.748 green: 0.748 blue: 0.748 alpha: 1];
    UIColor* bottomColorDown = [UIColor colorWithRed: 0.16 green: 0.16 blue: 0.16 alpha: 1];
    UIColor* upColorInner = [UIColor colorWithRed: 0.129 green: 0.132 blue: 0.148 alpha: 1];
    UIColor* bottomColorInner = [UIColor colorWithRed: 0.975 green: 0.975 blue: 0.985 alpha: 1];
    UIColor* buttonColor = [UIColor colorWithRed: 0.323 green: 0.338 blue: 0.37 alpha: 1];
    CGFloat buttonColorRGBA[4];
    [buttonColor getRed: &buttonColorRGBA[0] green: &buttonColorRGBA[1] blue: &buttonColorRGBA[2] alpha: &buttonColorRGBA[3]];
    
    UIColor* buttonBottomColor = [UIColor colorWithRed: (buttonColorRGBA[0] * 0 + 1) green: (buttonColorRGBA[1] * 0 + 1) blue: (buttonColorRGBA[2] * 0 + 1) alpha: (buttonColorRGBA[3] * 0 + 1)];
    UIColor* buttonTopColor = [UIColor colorWithRed: 0.58 green: 0.58 blue: 0.58 alpha: 0.279];
    UIColor* flareWhite = [UIColor colorWithRed: 1 green: 1 blue: 1 alpha: 0.83];
    
    //// Gradient Declarations
    NSArray* ringGradientColors = [NSArray arrayWithObjects:
                                   (id)upColorOut.CGColor,
                                   (id)bottomColorDown.CGColor, nil];
    CGFloat ringGradientLocations[] = {0, 1};
    CGGradientRef ringGradient = CGGradientCreateWithColors(colorSpace, (__bridge CFArrayRef)ringGradientColors, ringGradientLocations);
    NSArray* ringInnerGradientColors = [NSArray arrayWithObjects:
                                        (id)upColorInner.CGColor,
                                        (id)bottomColorInner.CGColor, nil];
    CGFloat ringInnerGradientLocations[] = {0, 1};
    CGGradientRef ringInnerGradient = CGGradientCreateWithColors(colorSpace, (__bridge CFArrayRef)ringInnerGradientColors, ringInnerGradientLocations);
    NSArray* buttonGradientColors = [NSArray arrayWithObjects:
                                     (id)buttonBottomColor.CGColor,
                                     (id)[UIColor colorWithRed: 0.79 green: 0.79 blue: 0.79 alpha: 0.639].CGColor,
                                     (id)buttonTopColor.CGColor, nil];
    CGFloat buttonGradientLocations[] = {0, 0.47, 1};
    CGGradientRef buttonGradient = CGGradientCreateWithColors(colorSpace, (__bridge CFArrayRef)buttonGradientColors, buttonGradientLocations);
    NSArray* overlayGradientColors = [NSArray arrayWithObjects:
                                      (id)flareWhite.CGColor,
                                      (id)[UIColor clearColor].CGColor, nil];
    CGFloat overlayGradientLocations[] = {0, 1};
    CGGradientRef overlayGradient = CGGradientCreateWithColors(colorSpace, (__bridge CFArrayRef)overlayGradientColors, overlayGradientLocations);
    
    //// Shadow Declarations
    UIColor* buttonInnerShadow = [UIColor blackColor];
    CGSize buttonInnerShadowOffset = CGSizeMake(0.1, -0.1);
    CGFloat buttonInnerShadowBlurRadius = 5;
    UIColor* buttonOuterShadow = [UIColor blackColor];
    CGSize buttonOuterShadowOffset = CGSizeMake(0.1, -0.1);
    CGFloat buttonOuterShadowBlurRadius = 2;
    
    //// Frames
    CGRect frame = rect; // CGRectMake(0, 0, 65, 65);
    
    
    //// outerOval Drawing
    UIBezierPath* outerOvalPath = [UIBezierPath bezierPathWithOvalInRect: CGRectMake(CGRectGetMinX(frame) + floor(CGRectGetWidth(frame) * 0.00000 + 0.5), CGRectGetMinY(frame) + floor(CGRectGetHeight(frame) * 0.01538 + 0.5), floor(CGRectGetWidth(frame) * 0.96923 + 0.5) - floor(CGRectGetWidth(frame) * 0.00000 + 0.5), floor(CGRectGetHeight(frame) * 0.98462 + 0.5) - floor(CGRectGetHeight(frame) * 0.01538 + 0.5))];
    CGContextSaveGState(context);
    CGContextSetShadowWithColor(context, buttonOuterShadowOffset, buttonOuterShadowBlurRadius, buttonOuterShadow.CGColor);
    CGContextBeginTransparencyLayer(context, NULL);
    [outerOvalPath addClip];
    UIBezierPath* outerOvalRotatedPath = [outerOvalPath copy];
    CGAffineTransform outerOvalTransform = CGAffineTransformMakeRotation(45*(-M_PI/180));
    [outerOvalRotatedPath applyTransform: outerOvalTransform];
    CGRect outerOvalBounds = CGPathGetPathBoundingBox(outerOvalRotatedPath.CGPath);
    outerOvalTransform = CGAffineTransformInvert(outerOvalTransform);
    
    CGContextDrawLinearGradient(context, ringGradient,
                                CGPointApplyAffineTransform(CGPointMake(CGRectGetMinX(outerOvalBounds), CGRectGetMidY(outerOvalBounds)), outerOvalTransform),
                                CGPointApplyAffineTransform(CGPointMake(CGRectGetMaxX(outerOvalBounds), CGRectGetMidY(outerOvalBounds)), outerOvalTransform),
                                0);
    CGContextEndTransparencyLayer(context);
    CGContextRestoreGState(context);
    
    
    
    //// overlayOval Drawing
    CGRect overlayOvalRect = CGRectMake(CGRectGetMinX(frame) + floor(CGRectGetWidth(frame) * 0.00000 + 0.5), CGRectGetMinY(frame) + floor(CGRectGetHeight(frame) * 0.01538 + 0.5), floor(CGRectGetWidth(frame) * 0.96923 + 0.5) - floor(CGRectGetWidth(frame) * 0.00000 + 0.5), floor(CGRectGetHeight(frame) * 0.98462 + 0.5) - floor(CGRectGetHeight(frame) * 0.01538 + 0.5));
    UIBezierPath* overlayOvalPath = [UIBezierPath bezierPathWithOvalInRect: overlayOvalRect];
    CGContextSaveGState(context);
    [overlayOvalPath addClip];
    CGFloat overlayOvalResizeRatio = MIN(CGRectGetWidth(overlayOvalRect) / 63, CGRectGetHeight(overlayOvalRect) / 63);
    CGContextDrawRadialGradient(context, overlayGradient,
                                CGPointMake(CGRectGetMidX(overlayOvalRect) + 0 * overlayOvalResizeRatio, CGRectGetMidY(overlayOvalRect) + -24.27 * overlayOvalResizeRatio), 17.75 * overlayOvalResizeRatio,
                                CGPointMake(CGRectGetMidX(overlayOvalRect) + 0 * overlayOvalResizeRatio, CGRectGetMidY(overlayOvalRect) + 0 * overlayOvalResizeRatio), 44.61 * overlayOvalResizeRatio,
                                kCGGradientDrawsBeforeStartLocation | kCGGradientDrawsAfterEndLocation);
    CGContextRestoreGState(context);
    
    
    //// innerOval Drawing
    UIBezierPath* innerOvalPath = [UIBezierPath bezierPathWithOvalInRect: CGRectMake(CGRectGetMinX(frame) + floor(CGRectGetWidth(frame) * 0.10769 + 0.5), CGRectGetMinY(frame) + floor(CGRectGetHeight(frame) * 0.12308 + 0.5), floor(CGRectGetWidth(frame) * 0.86154 + 0.5) - floor(CGRectGetWidth(frame) * 0.10769 + 0.5), floor(CGRectGetHeight(frame) * 0.87692 + 0.5) - floor(CGRectGetHeight(frame) * 0.12308 + 0.5))];
    CGContextSaveGState(context);
    [innerOvalPath addClip];
    UIBezierPath* innerOvalRotatedPath = [innerOvalPath copy];
    CGAffineTransform innerOvalTransform = CGAffineTransformMakeRotation(45*(-M_PI/180));
    [innerOvalRotatedPath applyTransform: innerOvalTransform];
    CGRect innerOvalBounds = CGPathGetPathBoundingBox(innerOvalRotatedPath.CGPath);
    innerOvalTransform = CGAffineTransformInvert(innerOvalTransform);
    
    CGContextDrawLinearGradient(context, ringInnerGradient,
                                CGPointApplyAffineTransform(CGPointMake(CGRectGetMinX(innerOvalBounds), CGRectGetMidY(innerOvalBounds)), innerOvalTransform),
                                CGPointApplyAffineTransform(CGPointMake(CGRectGetMaxX(innerOvalBounds), CGRectGetMidY(innerOvalBounds)), innerOvalTransform),
                                0);
    CGContextRestoreGState(context);
    
    
    //// buttonOval Drawing
    UIBezierPath* buttonOvalPath = [UIBezierPath bezierPathWithOvalInRect: CGRectMake(CGRectGetMinX(frame) + floor(CGRectGetWidth(frame) * 0.13846 + 0.5), CGRectGetMinY(frame) + floor(CGRectGetHeight(frame) * 0.13846 + 0.5), floor(CGRectGetWidth(frame) * 0.84615 + 0.5) - floor(CGRectGetWidth(frame) * 0.13846 + 0.5), floor(CGRectGetHeight(frame) * 0.84615 + 0.5) - floor(CGRectGetHeight(frame) * 0.13846 + 0.5))];
    CGContextSaveGState(context);
    [buttonOvalPath addClip];
    UIBezierPath* buttonOvalRotatedPath = [buttonOvalPath copy];
    CGAffineTransform buttonOvalTransform = CGAffineTransformMakeRotation(45*(-M_PI/180));
    [buttonOvalRotatedPath applyTransform: buttonOvalTransform];
    CGRect buttonOvalBounds = CGPathGetPathBoundingBox(buttonOvalRotatedPath.CGPath);
    buttonOvalTransform = CGAffineTransformInvert(buttonOvalTransform);
    
    CGContextDrawLinearGradient(context, buttonGradient,
                                CGPointApplyAffineTransform(CGPointMake(CGRectGetMinX(buttonOvalBounds), CGRectGetMidY(buttonOvalBounds)), buttonOvalTransform),
                                CGPointApplyAffineTransform(CGPointMake(CGRectGetMaxX(buttonOvalBounds), CGRectGetMidY(buttonOvalBounds)), buttonOvalTransform),
                                0);
    CGContextRestoreGState(context);
    
    ////// buttonOval Inner Shadow
    CGRect buttonOvalBorderRect = CGRectInset([buttonOvalPath bounds], -buttonInnerShadowBlurRadius, -buttonInnerShadowBlurRadius);
    buttonOvalBorderRect = CGRectOffset(buttonOvalBorderRect, -buttonInnerShadowOffset.width, -buttonInnerShadowOffset.height);
    buttonOvalBorderRect = CGRectInset(CGRectUnion(buttonOvalBorderRect, [buttonOvalPath bounds]), -1, -1);
    
    UIBezierPath* buttonOvalNegativePath = [UIBezierPath bezierPathWithRect: buttonOvalBorderRect];
    [buttonOvalNegativePath appendPath: buttonOvalPath];
    buttonOvalNegativePath.usesEvenOddFillRule = YES;
    
    CGContextSaveGState(context);
    {
        CGFloat xOffset = buttonInnerShadowOffset.width + round(buttonOvalBorderRect.size.width);
        CGFloat yOffset = buttonInnerShadowOffset.height;
        CGContextSetShadowWithColor(context,
                                    CGSizeMake(xOffset + copysign(0.1, xOffset), yOffset + copysign(0.1, yOffset)),
                                    buttonInnerShadowBlurRadius,
                                    buttonInnerShadow.CGColor);
        
        [buttonOvalPath addClip];
        CGAffineTransform transform = CGAffineTransformMakeTranslation(-round(buttonOvalBorderRect.size.width), 0);
        [buttonOvalNegativePath applyTransform: transform];
        [[UIColor grayColor] setFill];
        [buttonOvalNegativePath fill];
    }
    CGContextRestoreGState(context);
    
    
    
    //// Cleanup
    CGGradientRelease(ringGradient);
    CGGradientRelease(ringInnerGradient);
    CGGradientRelease(buttonGradient);
    CGGradientRelease(overlayGradient);
    CGColorSpaceRelease(colorSpace);
    
    
    
}






- (void)drawRect:(CGRect)rect
{
    
    //// General Declarations
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    //// Color Declarations
    UIColor* color = [UIColor colorWithRed: 0.652 green: 0.652 blue: 0.652 alpha: 0];
    UIColor* shadowColor2 = [UIColor colorWithRed: 0 green: 0 blue: 0 alpha: 0.547];
    
    //// Gradient Declarations
    NSArray* kerbenGradientColors = [NSArray arrayWithObjects:
                                     (id)color.CGColor,
                                     (id)[UIColor colorWithRed: 0.826 green: 0.826 blue: 0.826 alpha: 0.1].CGColor,
                                     (id)shadowColor2.CGColor,
                                     (id)color.CGColor, nil];
    CGFloat kerbenGradientLocations[] = {0, 0.15, 0.8, 1};
    CGGradientRef kerbenGradient = CGGradientCreateWithColors(colorSpace, (__bridge CFArrayRef)kerbenGradientColors, kerbenGradientLocations);
    
    
    
    
    
    UIColor* gradientColorDark = [UIColor colorWithRed: 0.409 green: 0.409 blue: 0.409 alpha: 1];
    CGFloat gradientColorDarkHSBA[4];
    [gradientColorDark getHue: &gradientColorDarkHSBA[0] saturation: &gradientColorDarkHSBA[1] brightness: &gradientColorDarkHSBA[2] alpha: &gradientColorDarkHSBA[3]];
    
    UIColor* gradientColorLight = [UIColor colorWithHue: gradientColorDarkHSBA[0] saturation: gradientColorDarkHSBA[1] brightness: 0.6 alpha: gradientColorDarkHSBA[3]];
    UIColor* gradientColorBack = [UIColor colorWithRed: 0.987 green: 0.987 blue: 0.987 alpha: 1];
    
    //// Gradient Declarations
    NSArray* wheelGradientColors = [NSArray arrayWithObjects:
                                    (id)gradientColorDark.CGColor,
                                    (id)gradientColorLight.CGColor,
                                    (id)[UIColor colorWithRed: 0.793 green: 0.793 blue: 0.793 alpha: 1].CGColor,
                                    (id)gradientColorBack.CGColor,
                                    (id)gradientColorLight.CGColor,
                                    (id)gradientColorDark.CGColor, nil];
    CGFloat wheelGradientLocations[] = {0, 0.06, 0.13, 0.53, 0.93, 1};
    CGGradientRef wheelGradient = CGGradientCreateWithColors(colorSpace, (__bridge CFArrayRef)wheelGradientColors, wheelGradientLocations);
    

    
    
    
    //// Frames
    CGRect frame = rect;
    
    //// Subframes
    CGRect group = frame; //  CGRectMake(CGRectGetMinX(frame) + floor(CGRectGetWidth(frame) * 0.01400 + 0.5), CGRectGetMinY(frame) + floor(CGRectGetHeight(frame) * 0.02439 + 0.5), floor(CGRectGetWidth(frame) * 0.98600 + 0.5) - floor(CGRectGetWidth(frame) * 0.01400 + 0.5), floor(CGRectGetHeight(frame) * 0.95122 + 0.5) - floor(CGRectGetHeight(frame) * 0.02439 + 0.5));
    
    if (self.grooveCount < 1) {
        self.grooveCount = 11;
    } else if (self.grooveCount % 2 == 0) {
        self.grooveCount += 1;
    }
    NSLog(@"Grooves: %d", self.grooveCount);
    
    
    NSInteger dx = frame.size.width / self.grooveCount;
    
    for (int i=0; i<=_grooveCount; i++) {
        int grooveWidth = 1;
        
        
            CGRect rectangleRect = CGRectMake(i * dx + dx/2, 1, grooveWidth, floor(CGRectGetHeight(group)  ) );
            
       //     UIBezierPath* rectanglePath = [UIBezierPath bezierPathWithRect: rectangleRect];
            CGContextSaveGState(context);
         //   [rectanglePath addClip];
            
            CGContextDrawLinearGradient(context, wheelGradient,
                                        CGPointMake(CGRectGetMinX(rectangleRect), CGRectGetMidY(rectangleRect)),
                                        CGPointMake(CGRectGetMaxX(rectangleRect), CGRectGetMidY(rectangleRect)),
                                        0);
        CGContextRestoreGState(context);


        
        
        
    }
    
    int i = floor(_grooveCount / 2);
    [self drawRectButtonInRect:CGRectMake(i * dx +10  , 0, 20, frame.size.height )];
     //            [self drawRoundButtonInRect:CGRectMake(i * dx +1 , 1.5, floor(CGRectGetHeight(group))-1, floor(CGRectGetHeight(group)  )-1 )];
        
        
        
    
    //// Cleanup
    CGGradientRelease(kerbenGradient);
    CGColorSpaceRelease(colorSpace);
    
    CGContextSetCMYKStrokeColor(context, 255, 0, 0, 0, 1);
    
    int centerx = rect.size.width/2;
    int centery = rect.size.height/2;
    CGContextMoveToPoint(context, centerx-1, centery-1);
    
    CGContextAddLineToPoint(context, centerx+1, centery+1);
    CGContextMoveToPoint(context, centerx+1, centery-1);
    CGContextAddLineToPoint(context, centerx-1  , centery+1);
    CGContextDrawPath(context  , kCGPathStroke);
    
    
    
}
@end
