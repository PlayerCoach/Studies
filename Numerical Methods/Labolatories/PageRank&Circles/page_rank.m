function [numer_indeksu, Edges, I, B, A, b, r] = page_rank()
numer_indeksu = 193415;
Edges = [1, 1, 2, 2, 2, 3, 3, 3, 4, 4, 5, 5, 5, 6, 6, 7, 8;
         4, 6, 3, 4, 5, 5, 6, 7, 5, 6, 4, 6, 8, 4, 7, 6, 2   ];

d = 0.85;

I = speye(8);
B = sparse(Edges(2,:), Edges(1,:), 1, 8, 8);

L = 1 ./ sum(B, 1)';
A = spdiags(L, 0, 8, 8);
x = (1 - 0.85) / 8;
b = x * ones(8, 1);

M = sparse(I - d * B * A);
r = M \ b;

L1 = 1;
L2 = 4;

end