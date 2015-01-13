//
//  Airplane.h
//  ClearTheSkies
//
//  Created by Edwin on 09/01/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

#import "FlyingSprite.h"

@interface Airplane : FlyingSprite

@property CGFloat speed;

-(void)spawn;
-(void)spawn:(int)speedIncrease;

@end
