#  BRICKGAME_v3_RACE

Проект BRICKGAME_v3_RACE представляет реализацию игры Race с консоли BrickGame на языке Swift 

![BrickGameRace](../misc/images/race-game.png)


### Race

В игре прежвставлена реализация конечного автомата который можно описать по схеме представленной ниже:

![BrickGameRace](misc/img/UML_Racing.png)


Игра подерживает управление с клавиатуры:

- `S` - старт/рестарт игры
- `←` `→` - передвижение влево и вправо
- `↑` - ускорение игры
- `P` - пауза/запуск игры
- `Q` - выход из игры
- `Space` - подтвержение действий

### Cli

![BrickGameRace](misc/img/Cli_Race.png)
<details> 
  <summary> Gameplay </summary>

![CliRaceGameplay](misc/gif/Cli_ameplay.gif)

</details>

В Cli версии реализована возможность ввода имени для сохранения вашего результата

![CliRaceGameplay](misc/gif/Save_score.gif)

А так же возможность просмотра таблицы лучших игроков 

![CliRaceGameplay](misc/gif/Higscore_table.gif)

### Web


В Web версии существует механика жизней, то есть можно совершать ошибки во время игры

![CliRaceGameplay](misc/gif/Web_gameplay.gif)

