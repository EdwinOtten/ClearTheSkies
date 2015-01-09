//
//  Airplane.m
//  ClearTheSkies
//
//  Created by Edwin on 09/01/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

#import "Airplane.h"

@implementation Airplane

- (void)didLoadFromCCB {
    self.physicsBody.collisionType = @"airplane";
}

-(void)update:(CCTime)delta {
    [self
     moveTo:self.position.x - _speed/30
     y:self.position.y
    ];
}

-(void)spawn {
    // compute random speed between 60 and 100
    _speed = 70 + arc4random() % (100 - 70);
    
    
    
    // compute random spawning position
    int lowerBound = 240;
    int upperBound = 290;
    int x = 750;
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
