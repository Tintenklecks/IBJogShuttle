//
//  ViewController.m
//  slider
//
//  Created by Ingo Böhme on 01.06.13.
//  Copyright (c) 2013 Ingo Böhme. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
//    int width = 40;
//    int top = (int) self.view.bounds.size.height - width;
//    IBJogShuttle *jog = [[IBJogShuttle alloc] initWithFrame:CGRectMake(20, top, self.view.bounds.size.width - 40, width)];
    IBJogShuttle *jog = [[IBJogShuttle alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 40)];
    jog.grooveCount = 20;
    jog.jogShuttleButtonType = IBJogButtonArrows;
    jog.jogShuttleDelegate = self;
    jog.autoresizingMask = UIViewAutoresizingFlexibleWidth;
//    jog.autoresizingMask = UIViewAutoresizingFlexibleWidth;
	[self.view addSubview:jog];

    
}

-(void) IBJogShuttledidChangePercentage:(IBJogShuttle *)jogShuttle {
    _percentageLable.text = [NSString stringWithFormat:@"%5.4f%%", jogShuttle.percent];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setPercentageLable:nil];
    [super viewDidUnload];
}
@end
