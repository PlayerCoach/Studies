from exceptions import GameplayException
from connect4 import Connect4
from randomagent import RandomAgent
from minmaxagent import MinMaxAgent
from alphabetaagent import AlphaBetaAgent
starting_depth = 5

games = 2
minmax_wins = 0
alphabeta_wins = 0
for _ in range(games):
    if _ % 2 == 0:
        minmax_token = 'x'
        alphabeta_token = 'o'

    else:
        minmax_token = 'o'
        alphabeta_token = 'x'

    connect4 = Connect4(width=7, height=6)
    agent1 = MinMaxAgent(minmax_token, starting_depth)
    agent2 = AlphaBetaAgent(alphabeta_token, starting_depth)

    while not connect4.game_over:
        connect4.draw()
        try:
            if connect4.who_moves == agent1.my_token:
                n_column = agent1.decide(connect4)
            else:
                n_column = agent2.decide(connect4)
            connect4.drop_token(n_column)
        except (ValueError, GameplayException):
            print('invalid move')

    connect4.draw()
    if connect4.get_winner() == minmax_token:
        minmax_wins += 1
    elif connect4.get_winner() == alphabeta_token:
        alphabeta_wins += 1

print(f'MinMax wins: {minmax_wins}')
print(f'AlphaBeta wins: {alphabeta_wins}')
print(f'Games: {games}')
print(f'Minmax Win rate: {minmax_wins/games*100:.2f}%')
print(f' AlphaBeta Win rate: {alphabeta_wins/games*100:.2f}%')




