import { applyRootStyles } from './src/utils.js';
import { GameBoard } from './src/game-board.js';
import { rootStyles, keyCodes, GAME_BOARD_WIDTH, GAME_BOARD_HEIGHT } from './src/config.js';

applyRootStyles(rootStyles);
setInterval(getGameInfo, 30)


const gameBoard = new GameBoard(document.querySelector('#game-board'));

const $sidePanel = document.querySelector('#side-panel');

document.addEventListener('keydown', function (event) {
    let action = ''
    if (keyCodes.up.includes(event.code)) {
        action = 'up'
    } else 
    if (keyCodes.right.includes(event.code)) {
        action = 'right'
    } else
    if (keyCodes.down.includes(event.code)) {
        action = 'down'
    } else
    if (keyCodes.left.includes(event.code)) {
        action = 'left'
    } else 
    if (keyCodes.start.includes(event.code)) {
        action = 'start'
    } else
    if (keyCodes.pause.includes(event.code)) {
        action = 'pause'
    } else
    if (keyCodes.quit.includes(event.code)) {
        action = 'quit'
    }
    sendUserInput(event.code)
    
    console.log(action + ' |event.key ' + event.code)
});

async function sendUserInput(action) {
    try {
        const response = await fetch('http://localhost:8080/race-input', {
            method: 'Post',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify({ rawValue: action }),
        });
        if (!response.ok) {
            throw new Error('Server error: ${response.status');
        }
        const gameInfo = await response.json();
        updateView(gameInfo);
    } catch (error) {
        console.error('Faild to send input:', error);
    } 
}

async function getGameInfo() {
    try {
        const response = await fetch('http://localhost:8080/game-info', {
            method: 'Get',
            headers: { 'Content-Type': 'application/json' },
            mode: 'cors'
        })

        if (!response.ok) {
            throw new Error('Error: response.status: ', response.status);            
        }
        const gameInfo = await response.json();
        console.log(gameInfo);
        updateView(gameInfo);
    } catch (error) {
        console.error('Faild to get game info:', error);
    }
}


function updateView(gameInfo) {
    updateBoard(gameInfo);
    updateSideTable(gameInfo);
    if (gameInfo.pause === 0 && gameInfo.score > 0) {
        saveHighscore(gameInfo.score);
        restartGame();
    }
}

function restartGame() {
    sendUserInput('KeyS');
    sendUserInput('KeyP');
}

function updateBoard(gameInfo) {
    const field = gameInfo.field;
    for (let row = 0; row < GAME_BOARD_HEIGHT; row++) {
        for (let cell = 0; cell < GAME_BOARD_WIDTH; cell++) {
            if (field[row][cell] >= 1) {
                gameBoard.enableTile(cell, row);
            } else {
                gameBoard.disableTile(cell, row);
            }
        }
    }
}

async function saveHighscore(score) {
    try {
        const userInp = prompt(`Save your highscore: ${score}`, "");
        if (userInp) {
            const response = await fetch('http://localhost:8080/save-highscore', {
                method: 'Put',
                headers: { 'Content-type': 'application/json'},
                body: JSON.stringify( { name: userInp } )
            });
            if (!response.ok) {
                throw new Error('Error: ${response.status}', response.status);            
            }
        }
    } catch (error) { 
        console.error('Faild to save highscore:', error);
    }
}

function updateSideTable(gameInfo) {
    document.querySelector('#score p:nth-child(2)').textContent = gameInfo.score;
    document.querySelector('#score p:nth-child(4)').textContent = gameInfo.high_score;
    document.querySelector('#score p:nth-child(6)').textContent = gameInfo.level;
    document.querySelector('#score p:nth-child(8)').textContent = gameInfo.lives;
    document.querySelector('#score p:nth-child(10)').textContent = gameInfo.speed;
}


async function getHello() {
    try {
        const response = await fetch('http://localhost:8080/');
        if (!response.ok) {
            throw new Error(`Error: ${response.status}`);            
        }

        console.log('hello');
    } catch (error) {
        console.error('Faild to get game info:', error);
    }
}