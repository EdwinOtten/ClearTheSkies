//
//  Level.m
//  ClearTheSkies
//
//  Created by Edwin on 07/01/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

#import "Level.h"
#import "Paratrooper.h"

@implementation Level

NSMutableArray *paratroopers;
int score;

- (void) onEnter {
    NSMutableArray *paratroopers = [[NSMutableArray alloc] initWithCapacity:40];
    self.userInteractionEnabled = TRUE;
    [super onEnter];
}

-(void)touchBegan:(CCTouch *)touch withEvent:(CCTouchEvent *)event {

    CGPoint positionInScene = [touch locationInNode:_physicsNode];
    
    _launcher.rotation = 360+90-[self calculateMissileDegree:&positionInScene];

    if(positionInScene.y < _launcher.position.y) {
        return;
    }
    
    //Calculatie the rotation in radians
    float rotationRadians = CC_DEGREES_TO_RADIANS( [self calculateMissileDegree:&positionInScene] );
    
    //Vector for the rotation
    CGPoint directionVector = ccp(cosf(rotationRadians), sinf(rotationRadians));
    CGPoint missileOffset = ccpMult(directionVector, 45);
    
    //Load a missile and set its initial position
    CCNode* missile = [CCBReader load:@"Missile"];
    missile.position = ccpAdd(_launcher.position, missileOffset);
    missile.scale = 0.40;
    missile.rotation = _launcher.rotation;
    
    //Add the missile to the physics node
    [_physicsNode addChild:missile];
    
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

-(void)checkIFHit
{
    CGPoint positionInScene;
    
    for(int i = 0; i < [paratroopers count]; i++) {
        
        CCSprite *currentPlane = [paratroopers objectAtIndex:i];
        
        float fl = [currentPlane boundingBox].size.height;
        
        if(CGRectContainsPoint([currentPlane boundingBox], positionInScene)) {
            // It's a hit! Let's explode, and add 1 to score
            [paratroopers removeObject:currentPlane];
            [_physicsNode removeChild:currentPlane];
            score++;
            //_scoreLabel.string = [NSString stringWithFormat:@"Score: %d", score];
            return;
        }
    }
}

@end
