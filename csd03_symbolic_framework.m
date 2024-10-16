addpath('C:\casadi-3.6.5-windows64-matlab2018b');

import casadi.*

%% The SX Symbolics

x = MX.sym('x');

y = SX.sym('y',5);
Z = SX.sym('Z',4,2);

f = x^2 + 10;
f = sqrt(f);
display(f)

B1 = SX.zeros(4,5);  % dense 4x5 empty matrix with all zeros
B2 = SX(4,5);        % sparse 4x5 matrix with all zeros
B4 = SX.eye(4);      % sparse 4x4 matrix with ones on the diagonal

% sparse: structural zeros

%% DM

% converting DM to other data types
C = DM(2,3);
C_dense = full(C);
C_sparse = sparse(C);

%% The MX Symbolics
x = SX.sym('x',2,2);
y = SX.sym('y');
f = 3*x + y;

x = MX.sym('x',2,2);
y = MX.sym('y');
f = 3*x + y;
% disp(f)
% disp(size(f))

x = MX.sym('x',2,2);
% x(1,1) % first structurally non-zero element of x

x = MX.sym('x',2);
A = MX(2,2);
A(1,1) = x(1);
A(2,2)  = x(1) + x(2);
% display(A);  % starting with an all zero sparse matrix, an element is
            % assigned to x_0. It is then projected to a matrix of
            % different sparsity and an another element is assigned to
            % x_0 + x_1

%% The Sparsity class
% disp(SX.sym('x',Sparsity.lower(3)))

% Getting and setting elements in matrices
M = SX([3,7;4,5]);
disp(M(1,:))
M(1,:) = 1;
disp(M)

% single element access: getting or setting by provinding a row-column pair
% or its flattened index
M = diag(SX([3,4,5,6]));
disp(M)
disp(M(1,1))
disp(M(2,1))
disp(M(end,end))

% slice access: setting multiple elements at once
% get a slice: (start, stop, step)
disp(M(:,2))
disp(M(2:end,2:2:4))

% list access: less efficient than slice access
M = SX([3 7 8 9; 4 5 6 1]);
disp(M)
disp(M(1,[1,4]))
disp(M([6,numel(M)-5]))

% Arithmetic operations
x = SX.sym('x');
y = SX.sym('y',2,2);
disp(sin(y)-x)

disp(y.*y)  % element-wise multiplication
disp(y*y)   % matrix multiplication

disp(y)
disp(y')    % transpose

% reshaping: changing the number of rows and columns but retaining the
% number of elements and the relative location of the nonzeros. cheap
% operation

x = SX.eye(4);
reshape(x,2,8)

% concatenation: stacking matrices horizontally or vertically. it is most
% efficient to stack matrices horizontally
x = SX.sym('x',5);
y = SX.sym('y',5);
disp([x;y])
disp([x,y])

L = {x,y};
disp([L{:}])

% horizontal and vertical split: inverse operations of concatenation. 
% to split up an expression horizontally into n smaller expressions, you
% nedd to provide, in addition to the expression being split, a vector
% offset of length n+1. first element of the offset vector must be 0. last
% element must be the number of columns. Remaining elements must follow in
% a non-decreasing order. the output i of the split operation then contains
% the columns c with offset[i <= c , offset[i+1]. 

x = SX.sym('x',5,2);
w = horzsplit(x,[0,1,2]);
disp(w{1}), disp(w{2})

% vertsplit: offset vector referring to rows
w = vertsplit(x,[0,3,5]);
disp(w{1}), disp(w{2})

% inner product: <A,B> := tr(A,B) = \sum_{i,j} A_{i,j}B_{ij}
x = SX.sym('x',2,2);
disp(dot(x,x))

%% Querying properties
% to check if a matrix or sparsity pattern has a certain property by
% calling an appropriate member function
y = SX.sym('y',10,1);
size(y)