function prob=solveLP(prob) %Fill prob=prob
[sol,fval,exitflag,output,lambda]=linprog(prob);
g=prob.edges;
g1=g(:,1);
g1_2=g(:,1:2);
g3=g(:,3);
sol_edges=g1_2(find(sol==1),:);
cost=fval;
cost_edges=g3(find(sol==1));
isFeasible=exitflag==1;
hasSubtours=[];

if isFeasible==1
hasSubtours=subtourDetect(sol_edges);
end

prob=struct('f',prob.f,'Aeq',prob.Aeq,'beq',prob.beq,...
    'lb',prob.lb,'ub',prob.ub,'options',prob.options,...
    'solver',prob.solver,'sol',sol,'sol_edges',sol_edges,...
    'cost',cost,'cost_edges',cost_edges,...
    'isFeasible',isFeasible,'hasSubtours',hasSubtours);

end