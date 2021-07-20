function [newX] = solve_Dist_Constr(X1,X2,Do)
    X_Dist = norm(X2-X1);
    derX = (X1-X2)/X_Dist*(Do-X_Dist)/2;
    newX(1,:) = X1 + derX;
    newX(2,:) = X2 - derX;
end