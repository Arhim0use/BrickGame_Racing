//
//  common.h
//  CommonBrickGame
//
//  Created by Chingisbek Anvardinov on 17.12.2024.
//

#ifndef common_h
#define common_h

enum Action
{
    Start,
    Pause,
    Terminate,
    Left,
    Right,
    Up,
    Down,
    Action
};

typedef enum Action UserAction_t;

typedef struct {
    int **field;
    int **next;
    int score;
    int high_score;
    int level;
    int speed;
    int pause;
} GameInfo_t;

void userInput(UserAction_t action, int hold);

GameInfo_t updateCurrentState(void);

#endif /* common_h */
