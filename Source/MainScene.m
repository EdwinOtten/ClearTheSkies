#import "MainScene.h"

@implementation MainScene

bool gameStarted = FALSE;

-(void)btnStartGamePressed:(id)sender {
    if (!gameStarted) {
        _gameTitle.visible = FALSE;
        _btnStartGame.visible = FALSE;
        CGPoint scrollPosition = _scrollview.scrollPosition;
        scrollPosition.x += 200;
        [_scrollview setScrollPosition:scrollPosition animated:FALSE];
        _scrollview.horizontalScrollEnabled = FALSE;
        gameStarted = TRUE;
        return;
    }
}

@end
