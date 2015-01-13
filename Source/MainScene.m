#import "MainScene.h"
#import "Level.h"

@implementation MainScene

bool gameStarted = FALSE;

-(void)btnStartGamePressed:(id)sender {
    if (!gameStarted) {
        _gameTitle.visible = FALSE;
        _btnStartGame.visible = FALSE;
        _lblDescription.visible = FALSE;
        
        [_level gameStarted];
        
        gameStarted = TRUE;
        return;
    }
}

@end
