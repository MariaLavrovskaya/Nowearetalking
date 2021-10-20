% % Upload data 
x1 = readtable('/Users/user/Desktop/UCL_CS_Masters/cpp_learn/num_methods_solutions/monte-carlo-integration/1.csv');
x2 = readtable('/Users/user/Desktop/UCL_CS_Masters/cpp_learn/num_methods_solutions/monte-carlo-integration/2.csv');
x1 = table2array(x1);
x2 = table2array(x2);
x1 = x1(1:50,:);
x2 = x2(1:50,:);
x = [x1;x2];

% Finding D
D = zeros(length(x));
for i = 1: length(x)
    for j = 1:length(x)
        D(i,j) = x(i,3)*x(j,3)*x(i, 1:2)*x(j, 1:2)';
    end
end

% Reset x and y
y = x(:,3);
x = x(:, 1:2);

%% 
% % For unseparable data
x = readtable('/Users/user/Desktop/UCL_CS_Masters/num-opt/Courseworks/CW4/data/X_100_unsep.csv');
y = readtable('/Users/user/Desktop/UCL_CS_Masters/num-opt/Courseworks/CW4/data/y_100_unsep.csv');
x = table2array(x);
y = table2array(y);

% Finding D
D = zeros(length(x));
for i = 1: length(x)
    for j = 1:length(x)
        D(i,j) = y(i)*y(j)*x(i, 1:2)*x(j, 1:2)';
    end
end



% Objective function 
F.f = @(x) 1/2*x'*D*x - x'*ones(length(x),1);
F.df = @(x) D*x - ones(length(x),1);
F.d2f = @(x) D;

% First inequality constraint x-Ce <= 0 C=5
constraintC.f = @(x) x-5*ones(length(x),1);
% constraintC.df = @(x) ones(length(x),1)';
constraintC.df = @(x) diag(ones(length(x),1)');
for i= 1: length(x)
    HessConstC(:,:,i) = zeros(length(x));
end
constraintC.d2f = @(x) HessConstC;

% Second inequality constraint -lambda <=0
constraintL.f = @(x) -x;
constraintL.df = @(x) diag(-ones(length(x),1)');
for i= 1: 2*length(x)
    HessConstL(:,:,i) = zeros(length(x));
end
constraintL.d2f = @(x) HessConstL;

% Equality constrain x^Ty = 0
%    eqConstraint.A = diag(y');
  eqConstraint.A = y';
eqConstraint.b = zeros(1,1);


% Inequality constraints (circle and linear)
constraint2.f = @(x) [x-5*ones(length(x),1); -x];
constraint2.df = @(x) [diag(ones(length(x),1)'); diag(-ones(length(x),1)')];
% HessConst2(:,:,1:100) = HessConstC;
% HessConst2(:,:,101:200) = HessConstL;
constraint2.d2f = @(x) HessConstL; 



% % Setting up a problem 
ineqConstraint = constraint2; %constraintC, constraintL
lambda0 = ones(length(x)*2,1);% ensure: lambda > 0

x0 = 0.001*ones(length(x),1);

eqConstraint = eqConstraint;
nu0 = ones(1,1); 
% nu0 = ones(100,1); 

%% Parameters 
% Set parameters
mu = 10; % in (3, 100);
t = 1;
tol = 1e-12;
maxIter = 200;

% Backtracking options
optsBT.maxIter = 30;
optsBT.alpha = 0.1; %1e-4; %0.1;
optsBT.beta = 0.8; %0.5;
%% Minimisation 
% Primal dual
tic
[xPD, fPD, tPD, nPD, infoPD] = interiorPoint_PrimalDual(F, ineqConstraint, eqConstraint, x0, lambda0, nu0, mu, tol, tol, maxIter, optsBT);
disp(['xPD = [' num2str(xPD(1)) ' ' num2str(xPD(2)) ']']);
toc
%% Convergence Analysis 
%% Empirical convergence rates
%

conPDr = convergenceHistory(infoPD, [], F, 2); % using 2-norm.
% conPD.x_nw = sqrt(sum((infoPD.xs_nw - repmat(infoPD.xs(:,end),1,size(infoPD.xs_nw ,2))).^2,1));
conPD = convergenceHistory(infoPD, [], F, 2); % using 2-norm.
%conPD = convergenceHistory(infoPD, xBar, F, 2); % using 2-norm. (for C, PD struggles to reduce the dual residual, one of the eigevalues of KKT matrix close to 0/)


con = conPD; %{conPD, conBar}

% Q convergence: $||x_{k+1} - x^*|| / ||x_{k} - x^*||^p <= r$, convergence rate $r \in (0,1)$, convergence order $p$
p = 1; % convergance rate
rs1 = con.x(2:end)./(con.x(1:end-1).^p);
%p=2; rs2 = con.x(2:end)./(con.x(1:end-1).^p);
figure, plot(rs1, 'r'); hold on; grid on; title('Q convergence');
%hold on, plot(find(info.FRsteps(2:end)), rs1(logical(info.FRsteps(2:end))), 'xk', 'MarkerSize', 10);
%legend('p=1', 'FR step')
% 0 < r < 1 indicates linear convergence (after initial phase) for feasible x0
  
% Exponential convergence: ||x_{k} - x^*|| = c q^k, c>0, bounded, q in (0,1)
% ln ||x_{k} - x^*|| = ln c + (ln q)*k    [linear function in semilogy with slope (ln q)<0 and offset (ln c)]
% Note that exponential convergence is essentially Q convegence ||x_{k+1} - x^*|| / ||x_{k} - x^*||^p <= r for r=q and p=1
figure, semilogy(con.x, 'r'); grid on; title('Exponential convergence'); xlabel('k'); ylabel('ln(||x_{k} - x^*||')
if isfield(con,'x_nw') % Barrier
figure, semilogy(con.x_nw, 'r'); grid on; title('Exponential convergence (Newton iterates)'); xlabel('k'); ylabel('ln(||x_{k} - x^*||')
hold on, semilogy(find(infoBar.alphas_nw > 1-eps), con.x_nw(infoBar.alphas_nw > 1-eps), 'xk', 'MarkerSize', 10);
legend('p=1', 'Full step')
else %PD
hold on, semilogy(find(infoPD.s > 1-eps), con.x(infoPD.s > 1-eps), 'xk', 'MarkerSize', 10);
legend('p=1', 'Full step')
end
 %% Retriving betas
 alphas = find(xPD>0.0001);
 betas = [0,0];
 for i = [alphas']
     
     betas = betas + xPD(i)*y(i)*x(i,:);
 end
 
% % Solving for any support vector to obtain beta0
 biass = y(30) - x(30,:)*betas'
% 
% % Plot the separating hyperplane
% %x1 = -8, x2 -?
% hyper_x_2 = (-b0+8*betas(1))/betas(2);
% %x1 = 8, x2 -?
% hyper_x_3 = (-b0-8*betas(1))/betas(2);
% 
% plot([-8,8], [hyper_x_2, hyper_x_3]); hold on; plot(x(1:50,1), x(1:50,2), '*'); hold on; plot(x(50:100,1), x(50:100,2), '*')
    
W=sum(xPD.*y.*x);
% biass =mean( y - x*W');
% Plotting 
hold on
Xsupport=x;Ysupport=y;
scatter(x(y==1,1),x(y==1,2),'b')
scatter(x(y==-1,1),x(y==-1,2),'r')
scatter(Xsupport(Ysupport==1,1),Xsupport(Ysupport==1,2),'.b')
scatter(Xsupport(Ysupport==-1,1),Xsupport(Ysupport==-1,2),'.r')
syms x1 x2
fn=vpa((-biass-W(1)*x1)/W(2),6);
fn1=vpa((-1-biass-W(1)*x1)/W(2),6);
fn2=vpa((1-biass-W(1)*x1)/W(2),6);
fplot(fn,'Linewidth',2);
fplot(fn1,'Linewidth',1);
fplot(fn2,'Linewidth',1);
% axis([-2 2 -2 2])
xlabel ('Positive - blue dots , Negative - red dots')
hold off


% Save result 
 saveas(gcf, '/Users/user/Desktop/UCL_CS_Masters/num-opt/Courseworks/CW4/project-images/IP-c10.png')
 
 
 alphas = find(xPD>0.0001);
 W=sum(xPD(alphas,:).*y(alphas,:).*x(alphas,:))
 bias =mean( y(alphas,:) - x(alphas,:)*W')
%  Xsupport=x((find(xPD~=0)),:);
% Ysupport=y((find(xPD~=0)),:);
Xsupport=x(alphas,:);
Ysupport=y(alphas,:);

hold on
scatter(x(y==1,1),x(y==1,2),'b')
scatter(x(y==-1,1),x(y==-1,2),'r')
scatter(Xsupport(Ysupport==1,1),Xsupport(Ysupport==1,2),'.b')
scatter(Xsupport(Ysupport==-1,1),Xsupport(Ysupport==-1,2),'.r')
syms x1 x2
fn=vpa((-bias-W(1)*x1)/W(2),6);
fn1=vpa((-1-bias-W(1)*x1)/W(2),6);
fn2=vpa((1-bias-W(1)*x1)/W(2),6);
fplot(fn,'Linewidth',3);
fplot(fn1,'Linewidth',1,'Color','g', 'LineStyle', '--');
fplot(fn2,'Linewidth',1,'Color','g', 'LineStyle', '--');

legend('Positive class', 'Negative Class', 'Support Vectors', 'Support Vectors', 'Decision Boundary', 'Margins', 'Location', 'best')
xlabel ('x1')
ylabel('y1')
hold off

saveas(gcf, '/Users/user/Desktop/UCL_CS_Masters/num-opt/Courseworks/CW4/SVM_results/IP-C5-DATA2.png')

