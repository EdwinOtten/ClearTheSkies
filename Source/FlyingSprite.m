//
//  FlyingSprite.m
//  ClearTheSkies
//
//  Created by Edwin on 12/01/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

#import "FlyingSprite.h"

@implementation FlyingSprite
-(void)update:(CCTime)delta {
    
    static float timeSinceLastTick = 0.f;
    
    timeSinceLastTick += delta;
    if (timeSinceLastTick > 1.0f) {
        timeSinceLastTick=0.f;
        if ([self outOfScreen]) {
            [self leftScreen];
            [self removeFromParent];
            return;
        }
    }
}

-(void)leftScreen {
}

-(BOOL)outOfScreen {
    
    CCNode* levelScene = self.parent;
    
    int xMin = self.boundingBox.origin.x;
    int xMax = xMin + self.boundingBox.size.width;
    int yMin = self.boundingBox.origin.y;
    int yMax = yMin + self.boundingBox.size.height;
    
    if (xMax < levelScene.boundingBox.origin.x) {
        return TRUE;
    }
    
    if (yMax < levelScene.boundingBox.origin.x) {
        return TRUE;
    }
    
    int xMaxScene = levelScene.boundingBox.origin.x + levelScene.boundingBox.size.width;
    if (yMin > xMaxScene) {
        return TRUE;
    }
    
    int yMaxScene = levelScene.boundingBox.origin.y + levelScene.boundingBox.size.height;
    if (yMin > yMaxScene) {
        return TRUE;
    }
    
    return FALSE;
}

@end
