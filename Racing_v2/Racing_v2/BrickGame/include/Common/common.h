//
//  test.h
//  AP2_BrickGame3_Swift
//
//  Created by Chingisbek Anvardinov on 05.10.2024.
//

#ifndef common_h
#define common_h

#include <stdio.h>

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
