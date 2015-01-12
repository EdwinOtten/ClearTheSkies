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

- (void)playSoundExplode
{
    [[OALSimpleAudio sharedInstance] stopAllEffects];
    [[OALSimpleAudio sharedInstance] playEffect:@"explosion.caf" volume:0.7f pitch:1.0f pan:1.0f loop:FALSE];
}

-(void)outOfScreenCheck {
    
    int xMin = self.boundingBox.origin.x;
    if (xMin < self.parent.boundingBox.origin.x) {
        [self removeFromParentAndCleanup:TRUE];
        return;
    }
    
    int yMin = self.boundingBox.origin.y;
    if (yMin < self.parent.boundingBox.origin.y) {
        [self removeFromParentAndCleanup:TRUE];
        return;
    }
    
    int xMax = xMin + self.boundingBox.size.width;
    if (xMax > (self.parent.boundingBox.origin.x + self.parent.boundingBox.size.width)) {
        [self removeFromParentAndCleanup:TRUE];
        return;
    }
    
    int yMax = yMin + self.boundingBox.size.height;
    if (yMax > (self.parent.boundingBox.origin.y + self.parent.boundingBox.size.height)) {
        [self removeFromParentAndCleanup:TRUE];
        return;
    }
}

@end
