function [newX] = lin_Area_constr(X,Ao,s)
    Vo = reshape(X',[1,numel(X)]);
    Avo = (Vo(1)*Vo(4) - Vo(1)*Vo(6) + Vo(3)*Vo(6) - Vo(3)*Vo(2) + Vo(5)*Vo(2) - Vo(5)*Vo(4))/2;
    Xprime = [Vo(4)-Vo(6),Vo(5)-Vo(3);Vo(6)-Vo(2),Vo(1)-Vo(3);Vo(2)-Vo(4),Vo(3)-Vo(1)]*s;
    sumXprime = Xprime(1,:)*Xprime(1,:)' + Xprime(2,:)*Xprime(2,:)' + Xprime(3,:)*Xprime(3,:)';
    C = s*(Avo) - Ao;
    lambda = C/sumXprime;
    deltaX = -lambda*Xprime;
    newX = X + deltaX;
end