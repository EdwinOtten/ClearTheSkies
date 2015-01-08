//
//  Level.h
//  ClearTheSkies
//
//  Created by Edwin on 07/01/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

#import "CCNode.h"

@interface Level : CCNode
{
    CCNode* _physicsNode;
    CCNode* _launcher;
}

@property (nonatomic, strong) NSString *kees;

@end
