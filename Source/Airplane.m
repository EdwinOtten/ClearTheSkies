//
//  Airplane.m
//  ClearTheSkies
//
//  Created by Edwin on 09/01/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

#import "Airplane.h"
#import "Level.h"

@implementation Airplane

int minSpeed = 140;
int maxSpeed = 180;

- (void)didLoadFromCCB {
    self.physicsBody.collisionType = @"airplane";
    self.speed = 0;
}

-(void)update:(CCTime)delta {
    [self
     moveTo:self.position.x - _speed/30
     y:self.position.y
     ];

    [super update:delta];
}

-(void)leftScreen {
    Level* levelScene = (Level*) self.parent.parent;
    [levelScene planeLeftScreen];
}

-(void)spawn {
    [self spawn:0];
}
-(void)spawn:(int)speedIncrease {
    // compute random speed between 60 and 100
    _speed = (minSpeed + arc4random() % (maxSpeed - minSpeed)) + speedIncrease;
    
    // compute random spawning position
    int lowerBound = 240;
    int upperBound = 290;
    int x = 742;
    int y = lowerBound + arc4random() % (upperBound - lowerBound);
    [self moveTo:x y:y];
}

-(void)moveTo:(CGFloat)x y:(CGFloat)y {
    CGPoint pos = self.position;
    pos.x = x;
    pos.y = y;
    self.position = pos;
}

@end
