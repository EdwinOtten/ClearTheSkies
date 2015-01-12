#import "MainScene.h"
#import "Level.h"

@implementation MainScene

bool gameStarted = FALSE;

-(void)btnStartGamePressed:(id)sender {
    if (!gameStarted) {
        _gameTitle.visible = FALSE;
        _btnStartGame.visible = FALSE;
        CGPoint levelPosition = _level.position;
        levelPosition.x -= 182;
        
        CCActionMoveTo *actionMoveTo = [CCActionMoveTo actionWithDuration:1.f position:levelPosition];
        [_level runAction:actionMoveTo];
        
        // start spawning airplanes
        _level.spawnEnabled = TRUE;
        [_level scheduleOnce:@selector(spawnAirplane) delay:2];
        
        gameStarted = TRUE;
        return;
    }
}

@end
