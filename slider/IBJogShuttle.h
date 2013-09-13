//
//  IBJogShuttle.h
//  slider
//
//  Created by Ingo Böhme on 02.06.13.
//  Copyright (c) 2013 Ingo Böhme. All rights reserved.
//

#import <UIKit/UIKit.h>

@class IBJogShuttleSlider, IBJogShuttle;


@protocol IBJogShuttleDelegate<NSObject>

@optional

- (void)didChangeJogShuttlePercentage:(IBJogShuttle *)jogShuttle;
@end;

@interface IBJogShuttle : UIScrollView <UIScrollViewDelegate>
@property (nonatomic) NSInteger grooveCount;

@property (nonatomic) double minValue;
@property (nonatomic) double maxValue;
@property (nonatomic) double value;

@property (nonatomic) BOOL borderBottom;
@property (nonatomic) BOOL borderTop;
@property (nonatomic, retain) IBJogShuttleSlider *slider;
@property (nonatomic, weak) id <IBJogShuttleDelegate> jogShuttleDelegate;
@end

@interface IBJogShuttleSlider : UIView
@property (nonatomic) NSInteger grooveCount;

@end

@interface IBJogShuttleButton : UIView

@end
