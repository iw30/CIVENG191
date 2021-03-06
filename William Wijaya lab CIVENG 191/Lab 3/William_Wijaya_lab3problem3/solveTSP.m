function [tour,cost]=solveTSP(graph) %fill graph=graph.edges
prob=formLP(graph);
prob=solveLP(prob);
bestSolM=[inf,0];

    if prob.hasSubtours==1
  %% Begin branching
  
 prob=branch(prob,graph);
 bestSolution=inf;
 i=1;
 while isempty(struct2cell(prob))==0
     myField=strcat('p',num2str(i));
     if isempty(struct2cell(prob))==1
         cost=bestSolution;
     else
         extractProb=prob.(myField);
         prob=rmfield(prob,myField);
         if extractProb.isFeasible==0
             extractProb=[];
         elseif extractProb.hasSubtours==0
             if bestSolution>extractProb.cost
                 bestSolution=extractProb.cost;
                 bestProb=extractProb;
             end
             extractProb=[];
         elseif bestSolM(end)==bestSolM(end-1)
                 break
         elseif extractProb.hasSubtours==1
            extractProb=branch(extractProb,graph);  
            pname=fieldnames(prob);
            pend=pname(end,1);
            pendString=string(pend);
            pNumber=str2double(regexp(pendString,'[\d.]+','match'));
            j=pNumber+1;
             while isempty(struct2cell(extractProb))==0
                myField1=strcat('p',num2str(j));
                myField2=strcat('p',num2str(j-pNumber));
                prob.(myField1)=extractProb.(myField2);
                extractProb=rmfield(extractProb,myField2);
                j=j+1;
             end
         end
     end
     bestSolM(1,i)=bestSolution;
     i=i+1;
 end
    elseif prob.hasSubtours==0 % No Subtour problem
        bestSolution=prob.cost;
        bestProb=prob;
    else
        bestSolution=[];
        bestProb=[];
    end
 
 %Cost
 if bestSolution~=inf
 cost=bestSolution;
 else
     cost=[];
 end
 
 %Tour
if bestSolution~=inf
 tour=tourFun(bestProb.sol_edges);
else
    tour=[];
end
 fprintf("\nThe final answer is:\n")
 fprintf("\ncost= %4.2f \n",cost)
 display(tour)
 if isempty(cost)==1
 fprintf("\nEmpty answer means the problem is infeasible\n")
 elseif isempty(cost)==0
     visGraph([bestProb.sol_edges,bestProb.cost_edges])
 end
end
 
  
          
  
  
 
