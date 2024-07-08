from exceptions import AgentException
import copy

inf = float('inf')


class AlphaBetaAgent:
    def __init__(self, token, depth):
        self.my_token = token
        self.initial_depth = depth

    def decide(self, connect4):
        if connect4.who_moves != self.my_token:
            raise AgentException('not my round')
        return self.alphabeta(connect4, self.initial_depth, -inf, inf, True)[1]

    def alphabeta(self, connect4, depth, alpha, beta, maximizing_token):
        if depth == 0 or connect4.game_over:
            return self.evaluate(connect4), None

        if maximizing_token:
            max_eval = -inf
            best_column = None
            for column in connect4.possible_drops():
                connect4_copy = copy.deepcopy(connect4)
                connect4_copy.drop_token(column)
                eval_score, _ = self.alphabeta(connect4_copy, depth - 1, alpha, beta, False)
                if eval_score > max_eval:
                    max_eval = eval_score
                    best_column = column
                alpha = max(alpha, eval_score)
                if beta <= alpha:
                    break
            return max_eval, best_column
        else:
            min_eval = inf
            worst_column = None
            for column in connect4.possible_drops():
                connect4_copy = copy.deepcopy(connect4)
                connect4_copy.drop_token(column)
                eval_score, _ = self.alphabeta(connect4_copy, depth - 1, alpha, beta, True)
                if eval_score < min_eval:
                    min_eval = eval_score
                    worst_column = column
                beta = min(beta, eval_score)
                if beta <= alpha:
                    break
            return min_eval, worst_column

    def evaluate(self, connect4):
        if connect4.wins == self.my_token:
            return 1
        elif connect4.wins is None and connect4.game_over:
            return 0
        elif connect4.wins is None:
            return self.heuristic_evaluation(connect4, self.my_token)
        else:
            return -1

    def heuristic_evaluation(self, connect4, token):
        # Define weights for different aspects of the evaluation
        CENTER_WEIGHT = 0.2
        THREAT_WEIGHT = 0.3

        # Calculate the total number of possible twos and threes on the board
        possible_threes = connect4.get_area() // 3

        # Calculate the opponent's token
        opponent_token = 'o' if token == 'x' else 'x'

        # Initialize evaluation score
        eval_score = 0

        # Evaluate control of center columns
        center_tokens = connect4.center_column()
        for token_in_center in center_tokens:
            if token_in_center == token:
                eval_score += CENTER_WEIGHT
            elif token_in_center == opponent_token:
                eval_score -= CENTER_WEIGHT

        # Evaluate threat detection
        token_threats = connect4.check_threes(token)
        opponent_threats = connect4.check_threes(opponent_token)
        eval_score += (token_threats - opponent_threats) * THREAT_WEIGHT

        # Normalize evaluation score based on total possible twos and threes
        eval_score /= possible_threes

        if eval_score > 1:
            eval_score = 0.99
        elif eval_score < -1:
            eval_score = -0.99

        return eval_score
