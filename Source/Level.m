//
//  Level.m
//  ClearTheSkies
//
//  Created by Edwin on 07/01/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

#import "Level.h"
#import "Paratrooper.h"
#import "Airplane.h"
#import "Missile.h"
#include <CCTextureCache.h>

@implementation Level

NSMutableArray *paratroopers;
NSMutableArray *missiles;
NSMutableArray *airplanes;
int score;
float minDelay,maxDelay;

- (void) onEnter {
    paratroopers = [[NSMutableArray alloc] initWithCapacity:40];
    missiles = [[NSMutableArray alloc] initWithCapacity:40];
    self.userInteractionEnabled = TRUE;
    [super onEnter];
    
    minDelay = 4.0;                      // seconds
    maxDelay = 8.0;                      // seconds
    _spawnEnabled = FALSE;
}

- (void)didLoadFromCCB {
    _physicsNode.collisionDelegate = self;
}

-(void)touchBegan:(CCTouch *)touch withEvent:(CCTouchEvent *)event {

    CGPoint positionInScene = [touch locationInNode:_physicsNode];
    
    [self fireMissile:positionInScene];
//    [self collisionCheck];
}

-(void)ccPhysicsCollisionPostSolve:(CCPhysicsCollisionPair *)pair missile:(CCNode *)nodeA airplane:(CCNode *)nodeB
{
    NSLog(@"Missile collision detected.");
    
    CCNode* explosion = [CCBReader load:@"Explosion"];
    explosion.position = nodeA.position;
    explosion.scale = 0.7f;
    [self addChild:explosion];
    
    [(Missile*)nodeA playSoundExplode];
    [nodeA removeFromParentAndCleanup:TRUE];
    [nodeB removeFromParentAndCleanup:TRUE];
}

-(void)fireMissile:(CGPoint)clickLocation {
    //If the user click below the launcher
    if(clickLocation.y < _launcher.position.y) {
        if (clickLocation.x > _launcher.position.x) {
            _launcher.rotation = 90;
        } else {
            _launcher.rotation = -90;
        }
        return;
    }
    
    _launcher.rotation = 360+90-[self calculateMissileDegree:&clickLocation];
    
    //Calculatie the rotation in radians
    float rotationRadians = CC_DEGREES_TO_RADIANS( [self calculateMissileDegree:&clickLocation] );
    
    //Vector for the rotation
    CGPoint directionVector = ccp(cosf(rotationRadians), sinf(rotationRadians));
    CGPoint missileOffset = ccpMult(directionVector, 40);
    
    //Load a missile and set its initial position
    Missile* missile = (Missile*) [CCBReader load:@"Missile"];
    missile.position = ccpAdd(_launcher.position, missileOffset);
    missile.scale = 0.36;
    missile.rotation = _launcher.rotation;
    
    //Add the missile to the physics node
    [_physicsNode addChild:missile];
    [missiles addObject:missile];
    
    //Apply a force to the missile
    CGPoint force = ccpMult(directionVector, 10000);
    [missile.physicsBody applyForce:force];
}

-(CGFloat) calculateMissileDegree:(CGPoint*)clickPoint {
    // Provides a directional bearing from (0,0) to the given point.
    // standard cartesian plain coords: X goes up, Y goes right
    // result returns degrees, -180 to 180 ish: 0 degrees = up, -90 = left, 90 = right
    float y = clickPoint->y - _launcher.position.y;
    float x = clickPoint->x - _launcher.position.x;
    
    CGFloat bearingRadians = atan2f(y, x);
    CGFloat bearingDegrees = bearingRadians * (180. / M_PI);
    return bearingDegrees;
}

-(void)spawnAirplane {
    // check if spawning is actually allowed
    if(!_spawnEnabled) return;
    
    // create and add a plane at the random coordinate
    Airplane* airplane = (Airplane*) [CCBReader load:@"Airplane"];
    [airplane spawn];
    [_physicsNode addChild:airplane];
    [airplanes addObject:airplane];
    
    // compute the next spawn time
    u_int32_t delta = (u_int32_t) (ABS(maxDelay-minDelay)*1000);  // ms resolution
    float randomDelta = arc4random_uniform(delta)/1000.;          // now in seconds
    [self scheduleOnce:@selector(spawnAirplane) delay:randomDelta];
}
@end
