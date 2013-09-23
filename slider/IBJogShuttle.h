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

- (void)IBJogShuttledidChangePercentage:(IBJogShuttle *)jogShuttle;
@end


enum IBJogShuttleButtonType {
    IBJogButtonNone = 0,
    IBJogButtonRoundButton = 1,
    IBJogButtonRectButton = 2,
    IBJogButtonArrows = 3
    };


@interface IBJogShuttle : UIView {
    UIView *sliderView;
}




@property (nonatomic) enum IBJogShuttleButtonType jogShuttleButtonType;

@property (nonatomic) NSInteger grooveCount;
@property (nonatomic) float grooveAlpa;// to be done (13-09-13 12:58)
@property (nonatomic) float grooveWidth; // to be done (13-09-13 12:58)

@property (nonatomic) double minValue;
@property (nonatomic) double maxValue;
@property (nonatomic) double value;
@property (nonatomic) double percent;

@property (nonatomic) CGSize centerButtonSize;




@property (nonatomic) BOOL borderBottom;
@property (nonatomic) BOOL borderTop;

@property (nonatomic, strong) IBJogShuttleSlider *slider;

@property (nonatomic, strong) id <IBJogShuttleDelegate> jogShuttleDelegate;

@end

