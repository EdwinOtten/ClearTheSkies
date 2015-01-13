//
//  Missile.m
//  ClearTheSkies
//
//  Created by Edwin on 08/01/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

#import "Missile.h"

@implementation Missile

- (void)didLoadFromCCB {
    self.physicsBody.collisionType = @"missile";
    [self playSoundLaunch];
}

- (void)playSoundLaunch
{
    [[OALSimpleAudio sharedInstance] playEffect:@"missile_launch.caf" volume:0.2f pitch:1.0f pan:1.0f loop:FALSE];
}

@end
