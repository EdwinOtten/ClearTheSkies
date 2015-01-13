//
//  GameOver.m
//  ClearTheSkies
//
//  Created by Edwin on 13/01/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

#import "GameOver.h"
#import "Level.h"

@implementation GameOver

-(void)btnPlayAgainPressed:(id)sender {
    Level* levelScene = (Level*) self.parent;
    [levelScene startNewGame];
    [self removeFromParent];
}

@end
