//
//  Level.h
//  ClearTheSkies
//
//  Created by Edwin on 07/01/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

#import "CCNode.h"

@interface Level : CCNode <CCPhysicsCollisionDelegate>
{
    CCPhysicsNode* _physicsNode;
    CCNode* _launcher;
    CCLabelTTF* _lblPoints;
    CCLabelTTF* _lblLives;
    CCNode* _imgHeart;
    CCNode* _imgCity;
}

-(void)startNewGame;
-(void)spawnAirplane;
-(void)planeLeftScreen;

@end
