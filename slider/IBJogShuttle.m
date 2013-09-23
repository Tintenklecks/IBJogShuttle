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

- (id)initWithFrame:(CGRect)frame { // IBJogShuttle
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor  clearColor];
        
        
        _jogShuttleButtonType = IBJogButtonRoundButton; // IBJogButtonArrows;
        
        _grooveCount = 11;
        _borderBottom = YES;
        _borderTop = YES;
        
        _minValue = 0.0;
        _maxValue = 100.0;
        _value = 50.0;
        
        _jogShuttleDelegate=nil;
        
        CGRect sliderFrame = self.bounds;
        sliderFrame.size.width *= 2;
        sliderFrame.size.height -= 6;
        sliderFrame.origin.y += 3;
        
        _slider = [[IBJogShuttleSlider alloc] initWithFrame:sliderFrame];
        self.clipsToBounds = YES;
      //  self.autoresizingMask = UIViewAutoresizingFlexibleHeight + UIViewAutoresizingFlexibleWidth;
        _slider.center = self.center;
        _slider.jogShuttle = self;
        
        UIPanGestureRecognizer* pgr = [[UIPanGestureRecognizer alloc]
                                       initWithTarget:self
                                       action:@selector(handlePan:)];
        [_slider addGestureRecognizer:pgr];

        
        
        [self addSubview:_slider];
        [self centerSlider:NO];
        NSLog(@".. %@", self);

    }
    return self;
}

-(void)handlePan:(UIPanGestureRecognizer*)pgr;
{
    static NSTimer* timer = nil;
    if (pgr.state == UIGestureRecognizerStateBegan) {
       timer =  [NSTimer scheduledTimerWithTimeInterval:0.1
                                         target:self
                                       selector:@selector(fireShuttleChange:)
                                       userInfo:nil
                                        repeats:YES];
    } else if (pgr.state == UIGestureRecognizerStateCancelled) {
        [timer invalidate];
        [self centerSlider:YES];
    } else if (pgr.state == UIGestureRecognizerStateEnded) {
        [timer invalidate];
        [self centerSlider:YES];
    } else if (pgr.state == UIGestureRecognizerStateChanged) {
        [self setNeedsDisplay];
        
        
        CGPoint center = pgr.view.center;
        CGPoint translation = [pgr translationInView:pgr.view];
        
        self.percent = self.bounds.size.width/2 - center.x;
        self.percent = - _percent / (self.bounds.size.width/2.0);
        NSLog(@"per %3.10f", _percent);
        
        float decelleration = 1 - (_percent * _percent);
        NSLog(@"dec %3.10f", decelleration);
        translation.x = decelleration * translation.x;
        
        float x = center.x + translation.x;
        
        if (x < 0) x = 0;
        if (x > self.bounds.size.width) x = self.bounds.size.width;
        
        NSLog(@"%3.0f / %3.0f", translation.x, center.x + translation.x);
        
        
        center = CGPointMake(x,
                             center.y );
        pgr.view.center = center;
        [pgr setTranslation:CGPointZero inView:pgr.view];
        
        
        
//        _value = (_maxValue - _minValue)/2   * (1 + [self getPercent]);
//        
//        
//        
//        [self IBJogShuttledidChangePercentage:self];
        
        

        
        
        
    }
}

-(void) fireShuttleChange: (NSTimer*) timer {
//    if (self.de) {
//        <#statements#>
//    }
//    NSLog(@"Timer X: %2.0f", self.slider.center.x);
}

-(void) setGrooveCount:(NSInteger)grooveCount {
    _grooveCount = grooveCount;  // to be done: refresh groove display  (13-09-13 13:07)
}

-(void) centerSlider: (BOOL) animated {
    
//    if (animated) {
//        [UIView beginAnimations:@"slideToCenter" context:nil];
//        [UIView setAnimationDuration:0.2];
//    }
//    self.slider.center = self.center;
//    if (animated) {
//        [UIView commitAnimations];
//    }

    if(animated) {
        [UIView animateWithDuration:0.2
                              delay:0
                            options:   UIViewAnimationOptionCurveLinear
                         animations:^{
                             //here you may add any othe actions,
                             self.slider.center = self.center;
                         }
                         completion:^(BOOL finished){
                             
                             //here any actions, thet must be done AFTER 1st animation is finished. If you whant to loop animations, call your function here.
                         }];
    } else {
        self.slider.center = self.center;
        
    }

    
}


#pragma mark - The ScrollView Protocol - UIScrollViewDelegate



//scrollViewDidScroll:
//Tells the delegate when the user scrolls the content view within the receiver.

/*
 
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
 
 */

/*
-(float) getPercent {
    
    float percent = ((self.contentSize.width/2 - self.contentOffset.x) - self.contentSize.width/4) / (self.contentSize.width/4);
   // NSLog(@"%f", percent);
    return percent;
}
*/

/*
- (void)IBJogShuttledidChangePercentage:(IBJogShuttle *)jogShuttle {
    _percent = [self getPercent];
    if (_jogShuttleDelegate) {
        [_jogShuttleDelegate IBJogShuttledidChangePercentage:jogShuttle];
    } else
        NSLog(@"%f   -   %f", [self getPercent], _value);
}
*/


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
    UIColor* darkColor = [UIColor colorWithRed: 0.333 green: 0.333 blue: 0.333 alpha: 1];
    UIColor* lightColor = [UIColor colorWithRed: 0.5 green: 0.5 blue: 0.5 alpha: 0.146];
    
    //// Gradient Declarations
    NSArray* gradientColors = [NSArray arrayWithObjects:
                               (id)darkColor.CGColor,
                               (id)lightColor.CGColor, nil];
    CGFloat gradientLocations[] = {0, 1};
    CGGradientRef gradient = CGGradientCreateWithColors(colorSpace, (__bridge CFArrayRef)gradientColors, gradientLocations);
    
    //// Frames
//    CGRect rect = CGRectMake(0, 0, 125.5, 14);
    
    
    //// leftArrow Drawing
    UIBezierPath* leftArrowPath = [UIBezierPath bezierPath];
    [leftArrowPath moveToPoint: CGPointMake(CGRectGetMinX(rect) + 0.36938 * CGRectGetWidth(rect), CGRectGetMinY(rect) + 0.53554 * CGRectGetHeight(rect))];
    [leftArrowPath addLineToPoint: CGPointMake(CGRectGetMinX(rect) + 0.39578 * CGRectGetWidth(rect), CGRectGetMinY(rect) + 0.78571 * CGRectGetHeight(rect))];
    [leftArrowPath addLineToPoint: CGPointMake(CGRectGetMinX(rect) + 0.41434 * CGRectGetWidth(rect), CGRectGetMinY(rect) + 0.78571 * CGRectGetHeight(rect))];
    [leftArrowPath addLineToPoint: CGPointMake(CGRectGetMinX(rect) + 0.38793 * CGRectGetWidth(rect), CGRectGetMinY(rect) + 0.53554 * CGRectGetHeight(rect))];
    [leftArrowPath addLineToPoint: CGPointMake(CGRectGetMinX(rect) + 0.41434 * CGRectGetWidth(rect), CGRectGetMinY(rect) + 0.28571 * CGRectGetHeight(rect))];
    [leftArrowPath addLineToPoint: CGPointMake(CGRectGetMinX(rect) + 0.39578 * CGRectGetWidth(rect), CGRectGetMinY(rect) + 0.28571 * CGRectGetHeight(rect))];
    [leftArrowPath addLineToPoint: CGPointMake(CGRectGetMinX(rect) + 0.36938 * CGRectGetWidth(rect), CGRectGetMinY(rect) + 0.53554 * CGRectGetHeight(rect))];
    [leftArrowPath closePath];
    [leftArrowPath moveToPoint: CGPointMake(CGRectGetMinX(rect) + 0.31888 * CGRectGetWidth(rect), CGRectGetMinY(rect) + 0.53554 * CGRectGetHeight(rect))];
    [leftArrowPath addLineToPoint: CGPointMake(CGRectGetMinX(rect) + 0.34529 * CGRectGetWidth(rect), CGRectGetMinY(rect) + 0.78571 * CGRectGetHeight(rect))];
    [leftArrowPath addLineToPoint: CGPointMake(CGRectGetMinX(rect) + 0.36385 * CGRectGetWidth(rect), CGRectGetMinY(rect) + 0.78571 * CGRectGetHeight(rect))];
    [leftArrowPath addLineToPoint: CGPointMake(CGRectGetMinX(rect) + 0.33744 * CGRectGetWidth(rect), CGRectGetMinY(rect) + 0.53554 * CGRectGetHeight(rect))];
    [leftArrowPath addLineToPoint: CGPointMake(CGRectGetMinX(rect) + 0.36385 * CGRectGetWidth(rect), CGRectGetMinY(rect) + 0.28571 * CGRectGetHeight(rect))];
    [leftArrowPath addLineToPoint: CGPointMake(CGRectGetMinX(rect) + 0.34529 * CGRectGetWidth(rect), CGRectGetMinY(rect) + 0.28571 * CGRectGetHeight(rect))];
    [leftArrowPath addLineToPoint: CGPointMake(CGRectGetMinX(rect) + 0.31888 * CGRectGetWidth(rect), CGRectGetMinY(rect) + 0.53554 * CGRectGetHeight(rect))];
    [leftArrowPath closePath];
    [leftArrowPath moveToPoint: CGPointMake(CGRectGetMinX(rect) + 0.26839 * CGRectGetWidth(rect), CGRectGetMinY(rect) + 0.53554 * CGRectGetHeight(rect))];
    [leftArrowPath addLineToPoint: CGPointMake(CGRectGetMinX(rect) + 0.29480 * CGRectGetWidth(rect), CGRectGetMinY(rect) + 0.78571 * CGRectGetHeight(rect))];
    [leftArrowPath addLineToPoint: CGPointMake(CGRectGetMinX(rect) + 0.31336 * CGRectGetWidth(rect), CGRectGetMinY(rect) + 0.78571 * CGRectGetHeight(rect))];
    [leftArrowPath addLineToPoint: CGPointMake(CGRectGetMinX(rect) + 0.28695 * CGRectGetWidth(rect), CGRectGetMinY(rect) + 0.53554 * CGRectGetHeight(rect))];
    [leftArrowPath addLineToPoint: CGPointMake(CGRectGetMinX(rect) + 0.31336 * CGRectGetWidth(rect), CGRectGetMinY(rect) + 0.28571 * CGRectGetHeight(rect))];
    [leftArrowPath addLineToPoint: CGPointMake(CGRectGetMinX(rect) + 0.29480 * CGRectGetWidth(rect), CGRectGetMinY(rect) + 0.28571 * CGRectGetHeight(rect))];
    [leftArrowPath addLineToPoint: CGPointMake(CGRectGetMinX(rect) + 0.26839 * CGRectGetWidth(rect), CGRectGetMinY(rect) + 0.53554 * CGRectGetHeight(rect))];
    [leftArrowPath closePath];
    [leftArrowPath moveToPoint: CGPointMake(CGRectGetMinX(rect) + 0.21790 * CGRectGetWidth(rect), CGRectGetMinY(rect) + 0.53554 * CGRectGetHeight(rect))];
    [leftArrowPath addLineToPoint: CGPointMake(CGRectGetMinX(rect) + 0.24431 * CGRectGetWidth(rect), CGRectGetMinY(rect) + 0.78571 * CGRectGetHeight(rect))];
    [leftArrowPath addLineToPoint: CGPointMake(CGRectGetMinX(rect) + 0.26287 * CGRectGetWidth(rect), CGRectGetMinY(rect) + 0.78571 * CGRectGetHeight(rect))];
    [leftArrowPath addLineToPoint: CGPointMake(CGRectGetMinX(rect) + 0.23646 * CGRectGetWidth(rect), CGRectGetMinY(rect) + 0.53554 * CGRectGetHeight(rect))];
    [leftArrowPath addLineToPoint: CGPointMake(CGRectGetMinX(rect) + 0.26287 * CGRectGetWidth(rect), CGRectGetMinY(rect) + 0.28571 * CGRectGetHeight(rect))];
    [leftArrowPath addLineToPoint: CGPointMake(CGRectGetMinX(rect) + 0.24431 * CGRectGetWidth(rect), CGRectGetMinY(rect) + 0.28571 * CGRectGetHeight(rect))];
    [leftArrowPath addLineToPoint: CGPointMake(CGRectGetMinX(rect) + 0.21790 * CGRectGetWidth(rect), CGRectGetMinY(rect) + 0.53554 * CGRectGetHeight(rect))];
    [leftArrowPath closePath];
    [leftArrowPath moveToPoint: CGPointMake(CGRectGetMinX(rect) + 0.16741 * CGRectGetWidth(rect), CGRectGetMinY(rect) + 0.53554 * CGRectGetHeight(rect))];
    [leftArrowPath addLineToPoint: CGPointMake(CGRectGetMinX(rect) + 0.19382 * CGRectGetWidth(rect), CGRectGetMinY(rect) + 0.78571 * CGRectGetHeight(rect))];
    [leftArrowPath addLineToPoint: CGPointMake(CGRectGetMinX(rect) + 0.21238 * CGRectGetWidth(rect), CGRectGetMinY(rect) + 0.78571 * CGRectGetHeight(rect))];
    [leftArrowPath addLineToPoint: CGPointMake(CGRectGetMinX(rect) + 0.18597 * CGRectGetWidth(rect), CGRectGetMinY(rect) + 0.53554 * CGRectGetHeight(rect))];
    [leftArrowPath addLineToPoint: CGPointMake(CGRectGetMinX(rect) + 0.21238 * CGRectGetWidth(rect), CGRectGetMinY(rect) + 0.28571 * CGRectGetHeight(rect))];
    [leftArrowPath addLineToPoint: CGPointMake(CGRectGetMinX(rect) + 0.19382 * CGRectGetWidth(rect), CGRectGetMinY(rect) + 0.28571 * CGRectGetHeight(rect))];
    [leftArrowPath addLineToPoint: CGPointMake(CGRectGetMinX(rect) + 0.16741 * CGRectGetWidth(rect), CGRectGetMinY(rect) + 0.53554 * CGRectGetHeight(rect))];
    [leftArrowPath closePath];
    [leftArrowPath moveToPoint: CGPointMake(CGRectGetMinX(rect) + 0.11692 * CGRectGetWidth(rect), CGRectGetMinY(rect) + 0.53554 * CGRectGetHeight(rect))];
    [leftArrowPath addLineToPoint: CGPointMake(CGRectGetMinX(rect) + 0.14333 * CGRectGetWidth(rect), CGRectGetMinY(rect) + 0.78571 * CGRectGetHeight(rect))];
    [leftArrowPath addLineToPoint: CGPointMake(CGRectGetMinX(rect) + 0.16189 * CGRectGetWidth(rect), CGRectGetMinY(rect) + 0.78571 * CGRectGetHeight(rect))];
    [leftArrowPath addLineToPoint: CGPointMake(CGRectGetMinX(rect) + 0.13548 * CGRectGetWidth(rect), CGRectGetMinY(rect) + 0.53554 * CGRectGetHeight(rect))];
    [leftArrowPath addLineToPoint: CGPointMake(CGRectGetMinX(rect) + 0.16189 * CGRectGetWidth(rect), CGRectGetMinY(rect) + 0.28571 * CGRectGetHeight(rect))];
    [leftArrowPath addLineToPoint: CGPointMake(CGRectGetMinX(rect) + 0.14333 * CGRectGetWidth(rect), CGRectGetMinY(rect) + 0.28571 * CGRectGetHeight(rect))];
    [leftArrowPath addLineToPoint: CGPointMake(CGRectGetMinX(rect) + 0.11692 * CGRectGetWidth(rect), CGRectGetMinY(rect) + 0.53554 * CGRectGetHeight(rect))];
    [leftArrowPath closePath];
    [leftArrowPath moveToPoint: CGPointMake(CGRectGetMinX(rect) + 0.06643 * CGRectGetWidth(rect), CGRectGetMinY(rect) + 0.53554 * CGRectGetHeight(rect))];
    [leftArrowPath addLineToPoint: CGPointMake(CGRectGetMinX(rect) + 0.09284 * CGRectGetWidth(rect), CGRectGetMinY(rect) + 0.78571 * CGRectGetHeight(rect))];
    [leftArrowPath addLineToPoint: CGPointMake(CGRectGetMinX(rect) + 0.11139 * CGRectGetWidth(rect), CGRectGetMinY(rect) + 0.78571 * CGRectGetHeight(rect))];
    [leftArrowPath addLineToPoint: CGPointMake(CGRectGetMinX(rect) + 0.08499 * CGRectGetWidth(rect), CGRectGetMinY(rect) + 0.53554 * CGRectGetHeight(rect))];
    [leftArrowPath addLineToPoint: CGPointMake(CGRectGetMinX(rect) + 0.11139 * CGRectGetWidth(rect), CGRectGetMinY(rect) + 0.28571 * CGRectGetHeight(rect))];
    [leftArrowPath addLineToPoint: CGPointMake(CGRectGetMinX(rect) + 0.09284 * CGRectGetWidth(rect), CGRectGetMinY(rect) + 0.28571 * CGRectGetHeight(rect))];
    [leftArrowPath addLineToPoint: CGPointMake(CGRectGetMinX(rect) + 0.06643 * CGRectGetWidth(rect), CGRectGetMinY(rect) + 0.53554 * CGRectGetHeight(rect))];
    [leftArrowPath closePath];
    [leftArrowPath moveToPoint: CGPointMake(CGRectGetMinX(rect) + 0.01594 * CGRectGetWidth(rect), CGRectGetMinY(rect) + 0.53554 * CGRectGetHeight(rect))];
    [leftArrowPath addLineToPoint: CGPointMake(CGRectGetMinX(rect) + 0.04234 * CGRectGetWidth(rect), CGRectGetMinY(rect) + 0.78571 * CGRectGetHeight(rect))];
    [leftArrowPath addLineToPoint: CGPointMake(CGRectGetMinX(rect) + 0.06090 * CGRectGetWidth(rect), CGRectGetMinY(rect) + 0.78571 * CGRectGetHeight(rect))];
    [leftArrowPath addLineToPoint: CGPointMake(CGRectGetMinX(rect) + 0.03449 * CGRectGetWidth(rect), CGRectGetMinY(rect) + 0.53554 * CGRectGetHeight(rect))];
    [leftArrowPath addLineToPoint: CGPointMake(CGRectGetMinX(rect) + 0.06090 * CGRectGetWidth(rect), CGRectGetMinY(rect) + 0.28571 * CGRectGetHeight(rect))];
    [leftArrowPath addLineToPoint: CGPointMake(CGRectGetMinX(rect) + 0.04234 * CGRectGetWidth(rect), CGRectGetMinY(rect) + 0.28571 * CGRectGetHeight(rect))];
    [leftArrowPath addLineToPoint: CGPointMake(CGRectGetMinX(rect) + 0.01594 * CGRectGetWidth(rect), CGRectGetMinY(rect) + 0.53554 * CGRectGetHeight(rect))];
    [leftArrowPath closePath];
    CGContextSaveGState(context);
    [leftArrowPath addClip];
    CGRect leftArrowBounds = CGPathGetPathBoundingBox(leftArrowPath.CGPath);
    CGContextDrawLinearGradient(context, gradient,
                                CGPointMake(CGRectGetMaxX(leftArrowBounds), CGRectGetMidY(leftArrowBounds)),
                                CGPointMake(CGRectGetMinX(leftArrowBounds), CGRectGetMidY(leftArrowBounds)),
                                0);
    CGContextRestoreGState(context);
    
    
    //// rightArrow Drawing
    UIBezierPath* rightArrowPath = [UIBezierPath bezierPath];
    [rightArrowPath moveToPoint: CGPointMake(CGRectGetMinX(rect) + 0.63461 * CGRectGetWidth(rect), CGRectGetMinY(rect) + 0.53554 * CGRectGetHeight(rect))];
    [rightArrowPath addLineToPoint: CGPointMake(CGRectGetMinX(rect) + 0.60820 * CGRectGetWidth(rect), CGRectGetMinY(rect) + 0.78571 * CGRectGetHeight(rect))];
    [rightArrowPath addLineToPoint: CGPointMake(CGRectGetMinX(rect) + 0.58964 * CGRectGetWidth(rect), CGRectGetMinY(rect) + 0.78571 * CGRectGetHeight(rect))];
    [rightArrowPath addLineToPoint: CGPointMake(CGRectGetMinX(rect) + 0.61605 * CGRectGetWidth(rect), CGRectGetMinY(rect) + 0.53554 * CGRectGetHeight(rect))];
    [rightArrowPath addLineToPoint: CGPointMake(CGRectGetMinX(rect) + 0.58964 * CGRectGetWidth(rect), CGRectGetMinY(rect) + 0.28571 * CGRectGetHeight(rect))];
    [rightArrowPath addLineToPoint: CGPointMake(CGRectGetMinX(rect) + 0.60820 * CGRectGetWidth(rect), CGRectGetMinY(rect) + 0.28571 * CGRectGetHeight(rect))];
    [rightArrowPath addLineToPoint: CGPointMake(CGRectGetMinX(rect) + 0.63461 * CGRectGetWidth(rect), CGRectGetMinY(rect) + 0.53554 * CGRectGetHeight(rect))];
    [rightArrowPath closePath];
    [rightArrowPath moveToPoint: CGPointMake(CGRectGetMinX(rect) + 0.68510 * CGRectGetWidth(rect), CGRectGetMinY(rect) + 0.53554 * CGRectGetHeight(rect))];
    [rightArrowPath addLineToPoint: CGPointMake(CGRectGetMinX(rect) + 0.65869 * CGRectGetWidth(rect), CGRectGetMinY(rect) + 0.78571 * CGRectGetHeight(rect))];
    [rightArrowPath addLineToPoint: CGPointMake(CGRectGetMinX(rect) + 0.64013 * CGRectGetWidth(rect), CGRectGetMinY(rect) + 0.78571 * CGRectGetHeight(rect))];
    [rightArrowPath addLineToPoint: CGPointMake(CGRectGetMinX(rect) + 0.66654 * CGRectGetWidth(rect), CGRectGetMinY(rect) + 0.53554 * CGRectGetHeight(rect))];
    [rightArrowPath addLineToPoint: CGPointMake(CGRectGetMinX(rect) + 0.64013 * CGRectGetWidth(rect), CGRectGetMinY(rect) + 0.28571 * CGRectGetHeight(rect))];
    [rightArrowPath addLineToPoint: CGPointMake(CGRectGetMinX(rect) + 0.65869 * CGRectGetWidth(rect), CGRectGetMinY(rect) + 0.28571 * CGRectGetHeight(rect))];
    [rightArrowPath addLineToPoint: CGPointMake(CGRectGetMinX(rect) + 0.68510 * CGRectGetWidth(rect), CGRectGetMinY(rect) + 0.53554 * CGRectGetHeight(rect))];
    [rightArrowPath closePath];
    [rightArrowPath moveToPoint: CGPointMake(CGRectGetMinX(rect) + 0.73559 * CGRectGetWidth(rect), CGRectGetMinY(rect) + 0.53554 * CGRectGetHeight(rect))];
    [rightArrowPath addLineToPoint: CGPointMake(CGRectGetMinX(rect) + 0.70918 * CGRectGetWidth(rect), CGRectGetMinY(rect) + 0.78571 * CGRectGetHeight(rect))];
    [rightArrowPath addLineToPoint: CGPointMake(CGRectGetMinX(rect) + 0.69062 * CGRectGetWidth(rect), CGRectGetMinY(rect) + 0.78571 * CGRectGetHeight(rect))];
    [rightArrowPath addLineToPoint: CGPointMake(CGRectGetMinX(rect) + 0.71703 * CGRectGetWidth(rect), CGRectGetMinY(rect) + 0.53554 * CGRectGetHeight(rect))];
    [rightArrowPath addLineToPoint: CGPointMake(CGRectGetMinX(rect) + 0.69062 * CGRectGetWidth(rect), CGRectGetMinY(rect) + 0.28571 * CGRectGetHeight(rect))];
    [rightArrowPath addLineToPoint: CGPointMake(CGRectGetMinX(rect) + 0.70918 * CGRectGetWidth(rect), CGRectGetMinY(rect) + 0.28571 * CGRectGetHeight(rect))];
    [rightArrowPath addLineToPoint: CGPointMake(CGRectGetMinX(rect) + 0.73559 * CGRectGetWidth(rect), CGRectGetMinY(rect) + 0.53554 * CGRectGetHeight(rect))];
    [rightArrowPath closePath];
    [rightArrowPath moveToPoint: CGPointMake(CGRectGetMinX(rect) + 0.78608 * CGRectGetWidth(rect), CGRectGetMinY(rect) + 0.53554 * CGRectGetHeight(rect))];
    [rightArrowPath addLineToPoint: CGPointMake(CGRectGetMinX(rect) + 0.75967 * CGRectGetWidth(rect), CGRectGetMinY(rect) + 0.78571 * CGRectGetHeight(rect))];
    [rightArrowPath addLineToPoint: CGPointMake(CGRectGetMinX(rect) + 0.74112 * CGRectGetWidth(rect), CGRectGetMinY(rect) + 0.78571 * CGRectGetHeight(rect))];
    [rightArrowPath addLineToPoint: CGPointMake(CGRectGetMinX(rect) + 0.76752 * CGRectGetWidth(rect), CGRectGetMinY(rect) + 0.53554 * CGRectGetHeight(rect))];
    [rightArrowPath addLineToPoint: CGPointMake(CGRectGetMinX(rect) + 0.74112 * CGRectGetWidth(rect), CGRectGetMinY(rect) + 0.28571 * CGRectGetHeight(rect))];
    [rightArrowPath addLineToPoint: CGPointMake(CGRectGetMinX(rect) + 0.75967 * CGRectGetWidth(rect), CGRectGetMinY(rect) + 0.28571 * CGRectGetHeight(rect))];
    [rightArrowPath addLineToPoint: CGPointMake(CGRectGetMinX(rect) + 0.78608 * CGRectGetWidth(rect), CGRectGetMinY(rect) + 0.53554 * CGRectGetHeight(rect))];
    [rightArrowPath closePath];
    [rightArrowPath moveToPoint: CGPointMake(CGRectGetMinX(rect) + 0.83657 * CGRectGetWidth(rect), CGRectGetMinY(rect) + 0.53554 * CGRectGetHeight(rect))];
    [rightArrowPath addLineToPoint: CGPointMake(CGRectGetMinX(rect) + 0.81017 * CGRectGetWidth(rect), CGRectGetMinY(rect) + 0.78571 * CGRectGetHeight(rect))];
    [rightArrowPath addLineToPoint: CGPointMake(CGRectGetMinX(rect) + 0.79161 * CGRectGetWidth(rect), CGRectGetMinY(rect) + 0.78571 * CGRectGetHeight(rect))];
    [rightArrowPath addLineToPoint: CGPointMake(CGRectGetMinX(rect) + 0.81802 * CGRectGetWidth(rect), CGRectGetMinY(rect) + 0.53554 * CGRectGetHeight(rect))];
    [rightArrowPath addLineToPoint: CGPointMake(CGRectGetMinX(rect) + 0.79161 * CGRectGetWidth(rect), CGRectGetMinY(rect) + 0.28571 * CGRectGetHeight(rect))];
    [rightArrowPath addLineToPoint: CGPointMake(CGRectGetMinX(rect) + 0.81017 * CGRectGetWidth(rect), CGRectGetMinY(rect) + 0.28571 * CGRectGetHeight(rect))];
    [rightArrowPath addLineToPoint: CGPointMake(CGRectGetMinX(rect) + 0.83657 * CGRectGetWidth(rect), CGRectGetMinY(rect) + 0.53554 * CGRectGetHeight(rect))];
    [rightArrowPath closePath];
    [rightArrowPath moveToPoint: CGPointMake(CGRectGetMinX(rect) + 0.88707 * CGRectGetWidth(rect), CGRectGetMinY(rect) + 0.53554 * CGRectGetHeight(rect))];
    [rightArrowPath addLineToPoint: CGPointMake(CGRectGetMinX(rect) + 0.86066 * CGRectGetWidth(rect), CGRectGetMinY(rect) + 0.78571 * CGRectGetHeight(rect))];
    [rightArrowPath addLineToPoint: CGPointMake(CGRectGetMinX(rect) + 0.84210 * CGRectGetWidth(rect), CGRectGetMinY(rect) + 0.78571 * CGRectGetHeight(rect))];
    [rightArrowPath addLineToPoint: CGPointMake(CGRectGetMinX(rect) + 0.86851 * CGRectGetWidth(rect), CGRectGetMinY(rect) + 0.53554 * CGRectGetHeight(rect))];
    [rightArrowPath addLineToPoint: CGPointMake(CGRectGetMinX(rect) + 0.84210 * CGRectGetWidth(rect), CGRectGetMinY(rect) + 0.28571 * CGRectGetHeight(rect))];
    [rightArrowPath addLineToPoint: CGPointMake(CGRectGetMinX(rect) + 0.86066 * CGRectGetWidth(rect), CGRectGetMinY(rect) + 0.28571 * CGRectGetHeight(rect))];
    [rightArrowPath addLineToPoint: CGPointMake(CGRectGetMinX(rect) + 0.88707 * CGRectGetWidth(rect), CGRectGetMinY(rect) + 0.53554 * CGRectGetHeight(rect))];
    [rightArrowPath closePath];
    [rightArrowPath moveToPoint: CGPointMake(CGRectGetMinX(rect) + 0.93756 * CGRectGetWidth(rect), CGRectGetMinY(rect) + 0.53554 * CGRectGetHeight(rect))];
    [rightArrowPath addLineToPoint: CGPointMake(CGRectGetMinX(rect) + 0.91115 * CGRectGetWidth(rect), CGRectGetMinY(rect) + 0.78571 * CGRectGetHeight(rect))];
    [rightArrowPath addLineToPoint: CGPointMake(CGRectGetMinX(rect) + 0.89259 * CGRectGetWidth(rect), CGRectGetMinY(rect) + 0.78571 * CGRectGetHeight(rect))];
    [rightArrowPath addLineToPoint: CGPointMake(CGRectGetMinX(rect) + 0.91900 * CGRectGetWidth(rect), CGRectGetMinY(rect) + 0.53554 * CGRectGetHeight(rect))];
    [rightArrowPath addLineToPoint: CGPointMake(CGRectGetMinX(rect) + 0.89259 * CGRectGetWidth(rect), CGRectGetMinY(rect) + 0.28571 * CGRectGetHeight(rect))];
    [rightArrowPath addLineToPoint: CGPointMake(CGRectGetMinX(rect) + 0.91115 * CGRectGetWidth(rect), CGRectGetMinY(rect) + 0.28571 * CGRectGetHeight(rect))];
    [rightArrowPath addLineToPoint: CGPointMake(CGRectGetMinX(rect) + 0.93756 * CGRectGetWidth(rect), CGRectGetMinY(rect) + 0.53554 * CGRectGetHeight(rect))];
    [rightArrowPath closePath];
    [rightArrowPath moveToPoint: CGPointMake(CGRectGetMinX(rect) + 0.98805 * CGRectGetWidth(rect), CGRectGetMinY(rect) + 0.53554 * CGRectGetHeight(rect))];
    [rightArrowPath addLineToPoint: CGPointMake(CGRectGetMinX(rect) + 0.96164 * CGRectGetWidth(rect), CGRectGetMinY(rect) + 0.78571 * CGRectGetHeight(rect))];
    [rightArrowPath addLineToPoint: CGPointMake(CGRectGetMinX(rect) + 0.94308 * CGRectGetWidth(rect), CGRectGetMinY(rect) + 0.78571 * CGRectGetHeight(rect))];
    [rightArrowPath addLineToPoint: CGPointMake(CGRectGetMinX(rect) + 0.96949 * CGRectGetWidth(rect), CGRectGetMinY(rect) + 0.53554 * CGRectGetHeight(rect))];
    [rightArrowPath addLineToPoint: CGPointMake(CGRectGetMinX(rect) + 0.94308 * CGRectGetWidth(rect), CGRectGetMinY(rect) + 0.28571 * CGRectGetHeight(rect))];
    [rightArrowPath addLineToPoint: CGPointMake(CGRectGetMinX(rect) + 0.96164 * CGRectGetWidth(rect), CGRectGetMinY(rect) + 0.28571 * CGRectGetHeight(rect))];
    [rightArrowPath addLineToPoint: CGPointMake(CGRectGetMinX(rect) + 0.98805 * CGRectGetWidth(rect), CGRectGetMinY(rect) + 0.53554 * CGRectGetHeight(rect))];
    [rightArrowPath closePath];
    CGContextSaveGState(context);
    [rightArrowPath addClip];
    CGRect rightArrowBounds = CGPathGetPathBoundingBox(rightArrowPath.CGPath);
    CGContextDrawLinearGradient(context, gradient,
                                CGPointMake(CGRectGetMinX(rightArrowBounds), CGRectGetMidY(rightArrowBounds)),
                                CGPointMake(CGRectGetMaxX(rightArrowBounds), CGRectGetMidY(rightArrowBounds)),
                                0);
    CGContextRestoreGState(context);
    
    
    //// Cleanup
    CGGradientRelease(gradient);
    CGColorSpaceRelease(colorSpace);
    
    

}

- (void)drawRectButtonInRect:(CGRect)rect {

    //// General Declarations
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    //// Color Declarations
    UIColor* color = [UIColor colorWithRed: 0.443 green: 0.439 blue: 0.443 alpha: 1];
    UIColor* buttonGradientColor = [UIColor colorWithRed: 0.843 green: 0.843 blue: 0.843 alpha: 1];
    UIColor* buttonGradientColor2 = [UIColor colorWithRed: 0.871 green: 0.867 blue: 0.867 alpha: 1];
    UIColor* buttonGradientColor3 = [UIColor colorWithRed: 0.781 green: 0.781 blue: 0.781 alpha: 1];
    UIColor* buttonGradientColor4 = [UIColor colorWithRed: 0.408 green: 0.408 blue: 0.408 alpha: 1];
    
    //// Gradient Declarations
    NSArray* buttonGradientColors = [NSArray arrayWithObjects:
                                     (id)color.CGColor,
                                     (id)[UIColor colorWithRed: 0.643 green: 0.641 blue: 0.643 alpha: 1].CGColor,
                                     (id)buttonGradientColor.CGColor,
                                     (id)[UIColor colorWithRed: 0.812 green: 0.812 blue: 0.812 alpha: 1].CGColor,
                                     (id)buttonGradientColor3.CGColor,
                                     (id)[UIColor colorWithRed: 0.826 green: 0.824 blue: 0.824 alpha: 1].CGColor,
                                     (id)buttonGradientColor2.CGColor,
                                     (id)[UIColor colorWithRed: 0.639 green: 0.637 blue: 0.637 alpha: 1].CGColor,
                                     (id)buttonGradientColor4.CGColor, nil];
    CGFloat buttonGradientLocations[] = {0, 0.05, 0.2, 0.24, 0.33, 0.35, 0.37, 0.52, 1};
    CGGradientRef buttonGradient = CGGradientCreateWithColors(colorSpace, (__bridge CFArrayRef)buttonGradientColors, buttonGradientLocations);
    
    //// Shadow Declarations
    UIColor* shadow2 = [UIColor blackColor];
    CGSize shadow2Offset = CGSizeMake(0.1, -0.1);
    CGFloat shadow2BlurRadius = 5;
    
    //// Frames
//    CGRect rect = CGRectMake(0, 0, 30.5, 69.5);
    
    
    //// Rectangle Drawing
    CGRect rectangleRect = CGRectMake(CGRectGetMinX(rect) + 2, CGRectGetMinY(rect) + 1, CGRectGetWidth(rect) - 3.5, CGRectGetHeight(rect) - 2.5);
    UIBezierPath* rectanglePath = [UIBezierPath bezierPathWithRect: rectangleRect];
    CGContextSaveGState(context);
    CGContextSetShadowWithColor(context, shadow2Offset, shadow2BlurRadius, shadow2.CGColor);
    CGContextBeginTransparencyLayer(context, NULL);
    [rectanglePath addClip];
    CGContextDrawLinearGradient(context, buttonGradient,
                                CGPointMake(CGRectGetMaxX(rectangleRect), CGRectGetMidY(rectangleRect)),
                                CGPointMake(CGRectGetMinX(rectangleRect), CGRectGetMidY(rectangleRect)),
                                0);
    CGContextEndTransparencyLayer(context);
    CGContextRestoreGState(context);
    
    
    
    //// Cleanup
    CGGradientRelease(buttonGradient);
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
    
    
    NSInteger dx = frame.size.width / (_jogShuttle.grooveCount - 1);
    
    if (_jogShuttle.jogShuttleButtonType != IBJogButtonArrows) {
        float maxGrooveWidth = 4;
        for (float i=0; i<=_jogShuttle.grooveCount; i++) {
            if ((i != (int) (_jogShuttle.grooveCount/2)) || (_jogShuttle.jogShuttleButtonType==IBJogButtonNone) ) {
                float prozent = 0.5 - i / _jogShuttle.grooveCount;
                float grooveWidth = maxGrooveWidth - maxGrooveWidth * (prozent * prozent) * 4 + 1;
                NSLog(@"Pro %f - groovew %f", prozent, grooveWidth);
                
                CGRect rectangleRect = CGRectMake(i * dx - grooveWidth/2 , 1, grooveWidth, floor(CGRectGetHeight(group)  ) );
                
                CGContextSaveGState(context);
                
                CGContextDrawLinearGradient(context, wheelGradient,
                                            CGPointMake(CGRectGetMinX(rectangleRect), CGRectGetMidY(rectangleRect)),
                                            CGPointMake(CGRectGetMaxX(rectangleRect), CGRectGetMidY(rectangleRect)),
                                            0);
                CGContextRestoreGState(context);
            }
            
        }
    }
    
    int i = floor(_jogShuttle.grooveCount / 2);
    
    switch (_jogShuttle.jogShuttleButtonType) {
        case IBJogButtonArrows:
            [self drawArrowsInRect:CGRectMake(frame.size.width/4, 0, frame.size.width/2, frame.size.height )];
            break;
        case IBJogButtonRectButton:
            [self drawRectButtonInRect:CGRectMake(i * dx - dx/4   , 0, dx/2, frame.size.height )];
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

    /*
    CGContextSetCMYKStrokeColor(context, 255, 0, 0, 0, 1);
    
    int centerx = rect.size.width/2;
    int centery = rect.size.height/2;
    CGContextMoveToPoint(context, centerx, centery-10);
    CGContextAddLineToPoint(context, centerx, centery+10);
    
    CGContextMoveToPoint(context, centerx-10, centery);
    CGContextAddLineToPoint(context, centerx+10  , centery);
    CGContextDrawPath(context  , kCGPathStroke);
    */
    
}
@end
