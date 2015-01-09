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
}

@end
