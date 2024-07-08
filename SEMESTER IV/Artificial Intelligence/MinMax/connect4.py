from exceptions import GameplayException


class Connect4:
    def __init__(self, width=5, height=4):
        self.width = width
        self.height = height
        self.who_moves = 'o'
        self.game_over = False
        self.wins = None
        self.board = []
        for n_row in range(self.height):
            self.board.append(['_' for _ in range(self.width)])

    def possible_drops(self):
        return [n_column for n_column in range(self.width) if self.board[0][n_column] == '_']

    def drop_token(self, n_column):
        if self.game_over:
            raise GameplayException('game over')
        if n_column not in self.possible_drops():
            raise GameplayException('invalid move')

        n_row = 0
        while n_row + 1 < self.height and self.board[n_row+1][n_column] == '_':
            n_row += 1
        self.board[n_row][n_column] = self.who_moves
        self.game_over = self._check_game_over()
        self.who_moves = 'o' if self.who_moves == 'x' else 'x'

    def center_column(self):
        return [self.board[n_row][self.width//2] for n_row in range(self.height)]

    def iter_fours(self):
        # horizontal
        for n_row in range(self.height):
            for start_column in range(self.width-3):
                yield self.board[n_row][start_column:start_column+4]

        # vertical
        for n_column in range(self.width):
            for start_row in range(self.height-3):
                yield [self.board[n_row][n_column] for n_row in range(start_row, start_row+4)]

        # diagonal
        for n_row in range(self.height-3):
            for n_column in range(self.width-3):
                yield [self.board[n_row+i][n_column+i] for i in range(4)]  # decreasing
                yield [self.board[n_row+i][self.width-1-n_column-i] for i in range(4)]  # increasing

    def iter_twos(self):
        # horizontal
        for n_row in range(self.height):
            for start_column in range(self.width-1):
                yield self.board[n_row][start_column:start_column+2]

        # vertical
        for n_column in range(self.width):
            for start_row in range(self.height-1):
                yield [self.board[n_row][n_column] for n_row in range(start_row, start_row+2)]

        # diagonal
        for n_row in range(self.height-1):
            for n_column in range(self.width-1):
                yield [self.board[n_row+i][n_column+i] for i in range(2)]
                yield [self.board[n_row+i][self.width-1-n_column-i] for i in range(2)]

    def iter_threes(self):
        # horizontal
        for n_row in range(self.height):
            for start_column in range(self.width-2):
                yield self.board[n_row][start_column:start_column+3]

        # vertical
        for n_column in range(self.width):
            for start_row in range(self.height-2):
                yield [self.board[n_row][n_column] for n_row in range(start_row, start_row+3)]

        # diagonal
        for n_row in range(self.height-2):
            for n_column in range(self.width-2):
                yield [self.board[n_row+i][n_column+i] for i in range(3)]
                yield [self.board[n_row+i][self.width-1-n_column-i] for i in range(3)]

    def check_twos(self, token):
        twos_count = 0
        for two in self.iter_twos():
            if two == [token, token]:
                twos_count += 1
        return twos_count

    def check_threes(self, token):
        threes_count = 0
        for three in self.iter_threes():
            if three == [token, token, token]:
                threes_count += 1
        return threes_count

    def _check_game_over(self):
        if not self.possible_drops():
            self.wins = None  # tie
            return True

        for four in self.iter_fours():
            if four == ['o', 'o', 'o', 'o']:
                self.wins = 'o'
                return True
            elif four == ['x', 'x', 'x', 'x']:
                self.wins = 'x'
                return True
        return False

    def draw(self):
        for row in self.board:
            print(' '.join(row))
        if self.game_over:
            print('game over')
            print('wins:', self.wins)
        else:
            print('now moves:', self.who_moves)
            print('possible drops:', self.possible_drops())

    def get_board(self):
        return self.board

    def set_board(self, board):
        self.board = board

    def get_area(self):
        return self.width * self.height

    def get_winner(self):
        return self.wins
