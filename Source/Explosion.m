//
//  Explosion.m
//  ClearTheSkies
//
//  Created by Edwin on 12/01/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

#import "Explosion.h"

@implementation Explosion

- (void) didLoadFromCCB
{
    // Setup a delegate method for the animationManager of the explostion
    CCAnimationManager* animationManager = self.userObject;
    animationManager.delegate = self;
}

- (void) completedAnimationSequenceNamed:(NSString *)name
{
    // Remove the explosion object after the animation has finished
    [self removeFromParent];
}

@end