//
//  ViewController.h
//  slider
//
//  Created by Ingo Böhme on 01.06.13.
//  Copyright (c) 2013 Ingo Böhme. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IBJogShuttle.h"


@interface ViewController : UIViewController <IBJogShuttleDelegate>
@property (strong, nonatomic) IBOutlet UILabel *percentageLable;

@end
