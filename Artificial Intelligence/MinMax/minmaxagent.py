from exceptions import AgentException
import copy

inf = float('inf')


# minmax base https://www.youtube.com/watch?v=l-hh51ncgDI
class MinMaxAgent:
    def __init__(self, token, depth):
        self.my_token = token
        self.initial_depth = depth

    def decide(self, connect4):
        if connect4.who_moves != self.my_token:
            raise AgentException('not my round')
        return self.minmax(connect4, self.initial_depth, True)[1]

    def minmax(self, connect4, depth, maximizing_token):
        if depth == 0 or connect4.game_over:
            return self.evaluate(connect4), None

        if maximizing_token:
            max_eval = -inf
            best_column = None
            for column in connect4.possible_drops():
                connect4_copy = copy.deepcopy(connect4)
                connect4_copy.drop_token(column)
                eval_score, _ = self.minmax(connect4_copy, depth - 1, False)
                if eval_score > max_eval:
                    max_eval = eval_score
                    best_column = column
            return max_eval, best_column
        else:
            min_eval = inf
            worst_column = None
            for column in connect4.possible_drops():
                connect4_copy = copy.deepcopy(connect4)
                connect4_copy.drop_token(column)
                eval_score, _ = self.minmax(connect4_copy, depth - 1, True)
                if eval_score < min_eval:
                    min_eval = eval_score
                    worst_column = column
            return min_eval, worst_column

    def evaluate(self, connect4):
        if connect4.wins == self.my_token:
            return 1
        elif connect4.wins is None:
            return 0
        else:
            return -1
