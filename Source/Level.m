//
//  Level.m
//  ClearTheSkies
//
//  Created by Edwin on 07/01/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

#import "Level.h"

@implementation Level

-(void)launchMissile:(id)sender
{
    //Calculatie the rotation in radians
    float rotationRadians = CC_DEGREES_TO_RADIANS(_launcher.rotation);
    
    //Vector for the rotation
    CGPoint directionVector = ccp(sinf(rotationRadians), cosf(rotationRadians));
    CGPoint missileOffset = ccpMult(directionVector, 50);
    
    //Load a missile and set its initial position
    CCNode* missile = [CCBReader load:@"Missile"];
    missile.position = ccpAdd(_launcher.position, missileOffset);
    
    //Add the missile to the physics node
    [_physicsNode addChild:missile];
    
    //Apply a force to the missile
    CGPoint force = ccpMult(directionVector, 50000);
    [missile.physicsBody applyForce:force];
}

@end
