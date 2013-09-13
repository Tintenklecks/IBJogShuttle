//
//  IBJogShuttle.m
//  slider
//
//  Created by Ingo Böhme on 02.06.13.
//  Copyright (c) 2013 Ingo Böhme. All rights reserved.
//

#import "IBJogShuttle.h"

@interface IBJogShuttleSlider : UIView
    @property (nonatomic,strong) IBJogShuttle* jogShuttle; // reference to the jogshuttle that contains the button
@end



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
//        self.delegate = self;
        
        
        self.jogShuttleButtonType = IBJogButtonArrows;
        
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
        _slider.jogShuttle = self;
        self.contentSize = sliderFrame.size;
        [self addSubview:_slider];
        [self centerSlider:NO];
        NSLog(@".. %@", self);

    }
    return self;
}

-(void) setGrooveCount:(NSInteger)grooveCount {
    _grooveCount = grooveCount;
    // to be done: refresh groove display  (13-09-13 13:07)
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


//scrollViewDidEndDragging:willDecelerate:
//Tells the delegate when dragging ended in the scroll view.
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {

  //  NSLog(@"%@ - %@", NSStringFromCGSize(self.contentSize), NSStringFromCGPoint(self.contentOffset));

    
    
    
    
    [self centerSlider:YES];
}

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
    
    
    
    [self IBJogShuttledidChangePercentage:self];
    

}

-(float) getPercent {
    
    float percent = ((self.contentSize.width/2 - self.contentOffset.x) - self.contentSize.width/4) / (self.contentSize.width/4);
   // NSLog(@"%f", percent);
    return percent;
}


- (void)IBJogShuttledidChangePercentage:(IBJogShuttle *)jogShuttle {
    _percent = [self getPercent];
    if (_jogShuttleDelegate) {
        [_jogShuttleDelegate IBJogShuttledidChangePercentage:jogShuttle];
    } else
        NSLog(@"%f   -   %f", [self getPercent], _value);
}



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


- (void)drawArrowsInRect:(CGRect)rect {
    //// General Declarations
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    //// Color Declarations
    UIColor* arrowGradientLight = [UIColor colorWithRed: 1 green: 1 blue: 1 alpha: 0.175];
    UIColor* arrowGradientBright = [UIColor colorWithRed: 1 green: 1 blue: 1 alpha: 1];
    
    //// Gradient Declarations
    NSArray* arrowGradientLeftColors = [NSArray arrayWithObjects:
                                        (id)arrowGradientBright.CGColor,
                                        (id)[UIColor colorWithRed: 1 green: 1 blue: 1 alpha: 0.588].CGColor,
                                        (id)arrowGradientLight.CGColor, nil];
    CGFloat arrowGradientLeftLocations[] = {0, 0.37, 1};
    CGGradientRef arrowGradientLeft = CGGradientCreateWithColors(colorSpace, (__bridge CFArrayRef)arrowGradientLeftColors, arrowGradientLeftLocations);
    NSArray* arrowGradientRightColors = [NSArray arrayWithObjects:
                                         (id)arrowGradientLight.CGColor,
                                         (id)arrowGradientBright.CGColor, nil];
    CGFloat arrowGradientRightLocations[] = {0, 1};
    CGGradientRef arrowGradientRight = CGGradientCreateWithColors(colorSpace, (__bridge CFArrayRef)arrowGradientRightColors, arrowGradientRightLocations);
    
    //// Frames
    CGRect frame = rect; // CGRectMake(0, 0, 80, 14);
    frame.size.width = 6 * frame.size.height;
    
    //// leftArrows Drawing
    UIBezierPath* leftArrowsPath = [UIBezierPath bezierPath];
    [leftArrowsPath moveToPoint: CGPointMake(CGRectGetMinX(frame) + 0.11890 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.96429 * CGRectGetHeight(frame))];
    [leftArrowsPath addLineToPoint: CGPointMake(CGRectGetMinX(frame) + 0.07449 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.96429 * CGRectGetHeight(frame))];
    [leftArrowsPath addLineToPoint: CGPointMake(CGRectGetMinX(frame) + 0.01129 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.49313 * CGRectGetHeight(frame))];
    [leftArrowsPath addLineToPoint: CGPointMake(CGRectGetMinX(frame) + 0.07449 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.02264 * CGRectGetHeight(frame))];
    [leftArrowsPath addLineToPoint: CGPointMake(CGRectGetMinX(frame) + 0.11890 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.02264 * CGRectGetHeight(frame))];
    [leftArrowsPath addLineToPoint: CGPointMake(CGRectGetMinX(frame) + 0.05570 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.49313 * CGRectGetHeight(frame))];
    [leftArrowsPath addLineToPoint: CGPointMake(CGRectGetMinX(frame) + 0.11890 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.96429 * CGRectGetHeight(frame))];
    [leftArrowsPath closePath];
    [leftArrowsPath moveToPoint: CGPointMake(CGRectGetMinX(frame) + 0.23974 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.96429 * CGRectGetHeight(frame))];
    [leftArrowsPath addLineToPoint: CGPointMake(CGRectGetMinX(frame) + 0.19532 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.96429 * CGRectGetHeight(frame))];
    [leftArrowsPath addLineToPoint: CGPointMake(CGRectGetMinX(frame) + 0.13212 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.49313 * CGRectGetHeight(frame))];
    [leftArrowsPath addLineToPoint: CGPointMake(CGRectGetMinX(frame) + 0.19532 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.02264 * CGRectGetHeight(frame))];
    [leftArrowsPath addLineToPoint: CGPointMake(CGRectGetMinX(frame) + 0.23974 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.02264 * CGRectGetHeight(frame))];
    [leftArrowsPath addLineToPoint: CGPointMake(CGRectGetMinX(frame) + 0.17654 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.49313 * CGRectGetHeight(frame))];
    [leftArrowsPath addLineToPoint: CGPointMake(CGRectGetMinX(frame) + 0.23974 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.96429 * CGRectGetHeight(frame))];
    [leftArrowsPath closePath];
    [leftArrowsPath moveToPoint: CGPointMake(CGRectGetMinX(frame) + 0.36058 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.96429 * CGRectGetHeight(frame))];
    [leftArrowsPath addLineToPoint: CGPointMake(CGRectGetMinX(frame) + 0.31616 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.96429 * CGRectGetHeight(frame))];
    [leftArrowsPath addLineToPoint: CGPointMake(CGRectGetMinX(frame) + 0.25296 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.49313 * CGRectGetHeight(frame))];
    [leftArrowsPath addLineToPoint: CGPointMake(CGRectGetMinX(frame) + 0.31616 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.02264 * CGRectGetHeight(frame))];
    [leftArrowsPath addLineToPoint: CGPointMake(CGRectGetMinX(frame) + 0.36058 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.02264 * CGRectGetHeight(frame))];
    [leftArrowsPath addLineToPoint: CGPointMake(CGRectGetMinX(frame) + 0.29738 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.49313 * CGRectGetHeight(frame))];
    [leftArrowsPath addLineToPoint: CGPointMake(CGRectGetMinX(frame) + 0.36058 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.96429 * CGRectGetHeight(frame))];
    [leftArrowsPath closePath];
    CGContextSaveGState(context);
    [leftArrowsPath addClip];
    CGRect leftArrowsBounds = CGPathGetPathBoundingBox(leftArrowsPath.CGPath);
    CGContextDrawLinearGradient(context, arrowGradientLeft,
                                CGPointMake(CGRectGetMinX(leftArrowsBounds), CGRectGetMidY(leftArrowsBounds)),
                                CGPointMake(CGRectGetMaxX(leftArrowsBounds), CGRectGetMidY(leftArrowsBounds)),
                                0);
    CGContextRestoreGState(context);
    
    
    //// rightArrows Drawing
    UIBezierPath* rightArrowsPath = [UIBezierPath bezierPath];
    [rightArrowsPath moveToPoint: CGPointMake(CGRectGetMinX(frame) + 0.74704 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.49313 * CGRectGetHeight(frame))];
    [rightArrowsPath addLineToPoint: CGPointMake(CGRectGetMinX(frame) + 0.68384 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.96429 * CGRectGetHeight(frame))];
    [rightArrowsPath addLineToPoint: CGPointMake(CGRectGetMinX(frame) + 0.63942 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.96429 * CGRectGetHeight(frame))];
    [rightArrowsPath addLineToPoint: CGPointMake(CGRectGetMinX(frame) + 0.70262 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.49313 * CGRectGetHeight(frame))];
    [rightArrowsPath addLineToPoint: CGPointMake(CGRectGetMinX(frame) + 0.63942 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.02264 * CGRectGetHeight(frame))];
    [rightArrowsPath addLineToPoint: CGPointMake(CGRectGetMinX(frame) + 0.68384 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.02264 * CGRectGetHeight(frame))];
    [rightArrowsPath addLineToPoint: CGPointMake(CGRectGetMinX(frame) + 0.74704 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.49313 * CGRectGetHeight(frame))];
    [rightArrowsPath closePath];
    [rightArrowsPath moveToPoint: CGPointMake(CGRectGetMinX(frame) + 0.86788 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.49313 * CGRectGetHeight(frame))];
    [rightArrowsPath addLineToPoint: CGPointMake(CGRectGetMinX(frame) + 0.80468 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.96429 * CGRectGetHeight(frame))];
    [rightArrowsPath addLineToPoint: CGPointMake(CGRectGetMinX(frame) + 0.76026 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.96429 * CGRectGetHeight(frame))];
    [rightArrowsPath addLineToPoint: CGPointMake(CGRectGetMinX(frame) + 0.82346 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.49313 * CGRectGetHeight(frame))];
    [rightArrowsPath addLineToPoint: CGPointMake(CGRectGetMinX(frame) + 0.76026 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.02264 * CGRectGetHeight(frame))];
    [rightArrowsPath addLineToPoint: CGPointMake(CGRectGetMinX(frame) + 0.80468 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.02264 * CGRectGetHeight(frame))];
    [rightArrowsPath addLineToPoint: CGPointMake(CGRectGetMinX(frame) + 0.86788 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.49313 * CGRectGetHeight(frame))];
    [rightArrowsPath closePath];
    [rightArrowsPath moveToPoint: CGPointMake(CGRectGetMinX(frame) + 0.98871 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.49313 * CGRectGetHeight(frame))];
    [rightArrowsPath addLineToPoint: CGPointMake(CGRectGetMinX(frame) + 0.92551 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.96429 * CGRectGetHeight(frame))];
    [rightArrowsPath addLineToPoint: CGPointMake(CGRectGetMinX(frame) + 0.88110 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.96429 * CGRectGetHeight(frame))];
    [rightArrowsPath addLineToPoint: CGPointMake(CGRectGetMinX(frame) + 0.94430 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.49313 * CGRectGetHeight(frame))];
    [rightArrowsPath addLineToPoint: CGPointMake(CGRectGetMinX(frame) + 0.88110 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.02264 * CGRectGetHeight(frame))];
    [rightArrowsPath addLineToPoint: CGPointMake(CGRectGetMinX(frame) + 0.92551 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.02264 * CGRectGetHeight(frame))];
    [rightArrowsPath addLineToPoint: CGPointMake(CGRectGetMinX(frame) + 0.98871 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.49313 * CGRectGetHeight(frame))];
    [rightArrowsPath closePath];
    CGContextSaveGState(context);
    [rightArrowsPath addClip];
    CGRect rightArrowsBounds = CGPathGetPathBoundingBox(rightArrowsPath.CGPath);
    CGContextDrawLinearGradient(context, arrowGradientRight,
                                CGPointMake(CGRectGetMinX(rightArrowsBounds), CGRectGetMidY(rightArrowsBounds)),
                                CGPointMake(CGRectGetMaxX(rightArrowsBounds), CGRectGetMidY(rightArrowsBounds)),
                                0);
    CGContextRestoreGState(context);
    
    
    //// Cleanup
    CGGradientRelease(arrowGradientLeft);
    CGGradientRelease(arrowGradientRight);
    CGColorSpaceRelease(colorSpace);
    

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
    
    if (_jogShuttle.grooveCount < 1) {
        _jogShuttle.grooveCount = 11;
    } else if (_jogShuttle.grooveCount % 2 == 0) {
        _jogShuttle.grooveCount += 1;
    }
    NSLog(@"Grooves: %d", _jogShuttle.grooveCount);
    
    
    NSInteger dx = frame.size.width / _jogShuttle.grooveCount;
    
    for (int i=0; i<=_jogShuttle.grooveCount; i++) {
        int grooveWidth = 1;
        
        
            CGRect rectangleRect = CGRectMake(i * dx + dx/2, 1, grooveWidth, floor(CGRectGetHeight(group)  ) );
            
            CGContextSaveGState(context);
            
            CGContextDrawLinearGradient(context, wheelGradient,
                                        CGPointMake(CGRectGetMinX(rectangleRect), CGRectGetMidY(rectangleRect)),
                                        CGPointMake(CGRectGetMaxX(rectangleRect), CGRectGetMidY(rectangleRect)),
                                        0);
            CGContextRestoreGState(context);

    }
    
    int i = floor(_jogShuttle.grooveCount / 2);
    
    switch (_jogShuttle.jogShuttleButtonType) {
        case IBJogButtonArrows:
            [self drawArrowsInRect:CGRectMake(i * dx, frame.size.height/4, 2 * dx, frame.size.height /2 )];
            break;
        case IBJogButtonRectButton:
            [self drawRectButtonInRect:CGRectMake(i * dx +10  , 0, 20, frame.size.height )];
            break;
        case IBJogButtonRoundButton:
            [self drawRoundButtonInRect:CGRectMake(i * dx +1 , 1.5, floor(CGRectGetHeight(group))-1, floor(CGRectGetHeight(group)  )-1 )];
            break;
            
        default:
            break;
    }
    
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
