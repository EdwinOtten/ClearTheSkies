//
//  Level.m
//  ClearTheSkies
//
//  Created by Edwin on 07/01/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

#import "Level.h"
#import "Airplane.h"
#import "Missile.h"
#include <CCTextureCache.h>

@implementation Level

int score;
int lives;
float difficulty;
float minDelay,maxDelay;
BOOL spawnEnabled;

- (void)didLoadFromCCB {
    _physicsNode.collisionDelegate = self;
}

-(void)touchBegan:(CCTouch *)touch withEvent:(CCTouchEvent *)event {
    if(lives >= 1) {
        CGPoint positionInScene = [touch locationInNode:_physicsNode];
        [self fireMissile:positionInScene];
    }
}

-(void)startNewGame {
    [self startNewGame:1.0f];
}

-(void)startNewGame:(float)difficultyLevel {
    
    // Set difficulty
    difficulty = difficultyLevel;
    minDelay = 4.0;                      // seconds
    maxDelay = 8.0;                      // seconds
    
    // Reset default values
    [self updateLives:3];
    [self updateScore:10];
    self.userInteractionEnabled = TRUE;
    
    // Move level into view
    CGPoint levelPosition = self.position;
    levelPosition.x = -182;
    CCActionMoveTo *actionMoveTo = [CCActionMoveTo actionWithDuration:1.f position:levelPosition];
    [self runAction:actionMoveTo];
    
    // start spawning airplanes
    spawnEnabled = TRUE;
    [self scheduleOnce:@selector(spawnAirplane) delay:2];
    
    // Make sure the city and lives counter is visible
    _imgCity.color = [CCColor colorWithCcColor3b:ccWHITE];
    _imgHeart.visible = TRUE;
    _lblLives.visible = TRUE;
}

-(void)gameOver {
    self.userInteractionEnabled = TRUE;
    spawnEnabled = FALSE;
    
    // make the city explode
    [self explodeCity];
    
    CCNode* gameOverScreen = [CCBReader load:@"GameOver"];
    CGPoint gameOverPos = gameOverScreen.position;
    gameOverPos.x = 750;
    gameOverScreen.position = gameOverPos;
    [self performSelector:@selector(addChild:) withObject:gameOverScreen afterDelay:2.4f];
}

-(void)ccPhysicsCollisionPostSolve:(CCPhysicsCollisionPair *)pair missile:(CCNode *)nodeA airplane:(CCNode *)nodeB
{
    NSLog(@"Missile collision detected.");
    
    CCNode* explosion = [CCBReader load:@"Explosion"];
    explosion.position = nodeA.position;
    explosion.scale = 0.7f;
    [self addChild:explosion];
    
    [self playSoundExplode];
    [nodeA removeFromParent];
    [nodeB removeFromParent];
    
    // Add 5 points for hitting a airplane
    [self updateScore:score+5];
}

-(void)planeLeftScreen {
    // If this was you last life, you're game over
    if(lives == 1) {
        [self gameOver];
        [self updateLives:lives-1];
    }
    
    // Substract 1 life for letting a plane pass
    if(lives > 0) {
        [self updateLives:lives-1];
    }
}

-(void)updateLives:(int)newLives {
    lives = newLives;
    _lblLives.string = [NSString stringWithFormat:@"%d", lives];
}

-(void)updateScore:(int)newScore {
    score = newScore;
    _lblPoints.string = [NSString stringWithFormat:@"%d points", score];
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
    
    //Apply a force to the missile
    CGPoint force = ccpMult(directionVector, 10000);
    [missile.physicsBody applyForce:force];
    
    // Substract 1 point for firing this missile
    [self updateScore:score-1];
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
    if(!spawnEnabled) return;
    
    // create and add a plane at the random coordinate
    Airplane* airplane = (Airplane*) [CCBReader load:@"Airplane"];
    int speedIncrease = (score / 2) + 10*difficulty;
    [airplane spawn:speedIncrease];
    [_physicsNode addChild:airplane];
    
    // compute the next spawn time
    u_int32_t delta = (u_int32_t) (ABS(maxDelay-minDelay)*1000);  // ms resolution
    float randomDelta = arc4random_uniform(delta)/1000.;          // now in seconds
    [self scheduleOnce:@selector(spawnAirplane) delay:randomDelta];
}

-(void)explodeCity {
    // make the city explode
    [self playSoundExplode:1.0f];
    [self addChild:[self generateExplosion:3.0f x:300 y:80]];
    [_imgCity performSelector:@selector(setColor:) withObject:[CCColor colorWithCcColor3b:ccBLACK] afterDelay:0.2f];
}

- (CCNode*)generateExplosion:(float)scale x:(float)x y:(float)y {
    CCNode* explosion = [CCBReader load:@"Explosion"];
    CGPoint explosionPos = _launcher.position;
    explosionPos.x = x;
    explosionPos.y = y;
    explosion.position = explosionPos;
    explosion.scale = scale;
    return explosion;
}


-(void)playSoundExplode {
    [self playSoundExplode:0.7f];
}
- (void)playSoundExplode:(float)volume
{
    [[OALSimpleAudio sharedInstance] stopAllEffects];
    [[OALSimpleAudio sharedInstance] playEffect:@"explosion.caf" volume:volume pitch:1.0f pan:1.0f loop:FALSE];
}

@end
