function [newX,Cost_x,Area_x] = optimal_Area_constr(X,Ao,s,varargin)
    p = inputParser();
    default_sol_out = 'Opt_sol'; %If true, use reference filter 
    type_sol_out = {'Opt_sol','Constr_sol','All_sol'}; 
    checksolType = @(x) find(ismember(x, type_sol_out));
    addOptional(p, 'Type_sol', default_sol_out, checksolType);
    parse(p, varargin{:});
    SolType  = p.Results.Type_sol;
    Vo = reshape(X',[1,numel(X)]);
    Avo = (Vo(1)*Vo(4) - Vo(1)*Vo(6) + Vo(3)*Vo(6) - Vo(3)*Vo(2) + Vo(5)*Vo(2) - Vo(5)*Vo(4))/2;
    sA = sign(Avo);
    Xbar = mean(X);
    Varo = (Vo(1)-Xbar(1))^2+(Vo(3)-Xbar(1))^2+(Vo(5)-Xbar(1))^2 + ...
        (Vo(2)-Xbar(2))^2+(Vo(4)-Xbar(2))^2+(Vo(6)-Xbar(2))^2;
    k3 = 1;
    newX = [];
    Xsol = zeros(6,5);
    Asol = zeros(1,5);
    Csol = zeros(1,5);

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%   Case I   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %% Quartic coefficients
    p = -16*(s*Avo + 2*Ao)/(3*Ao);
    q = 32*(Varo)/(3*Ao);
    r = 256*(Ao - s*Avo)/(9*Ao);
    %% Resolvent cubic coefficients
    Q1 = -(p^2+12*r)/36;
    Q2 = (2*p^3-72*r*p + 27*q^2)/432;
    Q3 = sqrt(Q1^3+Q2^2);
    alpha0 = (Q2+Q3)^(1/3) + (Q2-Q3)^(1/3) - p/3;
    %% Extracting the roots
    for k1=-1:2:1
        for k2=-1:2:1
            lambda = (k1*sqrt(alpha0)+k2*sqrt(-(p+alpha0+k1*q/sqrt(2*alpha0))))/sqrt(2);
            lambdaR = real(lambda);
            d = pinv(3*lambdaR^2-16);
            xa = d*((lambdaR^2-16)*Vo(1) + lambdaR^2*(Vo(3) + Vo(5)) + 4*s*lambdaR*(Vo(4)-Vo(6)));
            ya = d*((lambdaR^2-16)*Vo(2) + lambdaR^2*(Vo(4) + Vo(6)) + 4*s*lambdaR*(Vo(5)-Vo(3)));
            xb = d*((lambdaR^2-16)*Vo(3) + lambdaR^2*(Vo(1) + Vo(5)) + 4*s*lambdaR*(Vo(6)-Vo(2)));
            yb = d*((lambdaR^2-16)*Vo(4) + lambdaR^2*(Vo(2) + Vo(6)) + 4*s*lambdaR*(Vo(1)-Vo(5)));
            xc = d*((lambdaR^2-16)*Vo(5) + lambdaR^2*(Vo(1) + Vo(3)) + 4*s*lambdaR*(Vo(2)-Vo(4)));
            yc = d*((lambdaR^2-16)*Vo(6) + lambdaR^2*(Vo(2) + Vo(4)) + 4*s*lambdaR*(Vo(3)-Vo(1)));
            Xsol(:,k3) = [xa,ya,xb,yb,xc,yc];
            Asol(k3) = (xa*yb - xa*yc + xb*yc - xb*ya + xc*ya - xc*yb)*0.5;
            Csol(k3) = norm(Xsol(:,k3)-Vo',2);
            k3 = k3+1;
        end
    end
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%   Case II   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    if abs(Avo) > 10^-3
        q = s*sA;
    else
        q = -1;
    end
    lambdao = 4/sqrt(3);
    phi = sqrt(lambdao*(sA*Avo-4*q*Ao)/12);
    Vc = real(phi)*[-1/2, -q*s*2/lambdao, -1/2, q*s*2/lambdao, 1, 0];
    Xt = X-Xbar;
    Xot = reshape(Xt',[1,prod(size(Xt))]);
    Vt = reshape(Vc,size(X'))';

    H=Vt'*Xt;
    [U,~,V] = svd(H);
    OrCorr = [1,0;0,det(V*U')];
    RotMat2 = V*OrCorr*U';

    Vp(1) = (2*Xot(1)+Xot(3)+Xot(5))/4 - sA*(Xot(6)-Xot(4))/(3*lambdao); 
    Vp(2) = (2*Xot(2)+Xot(4)+Xot(6))/4 + sA*(Xot(5)-Xot(3))/(3*lambdao); 
    Vp(3) = (2*Xot(3)+Xot(5)+Xot(1))/4 - sA*(Xot(2)-Xot(6))/(3*lambdao); 
    Vp(4) = (2*Xot(4)+Xot(6)+Xot(2))/4 + sA*(Xot(1)-Xot(5))/(3*lambdao); 
    Vp(5) = (2*Xot(5)+Xot(1)+Xot(3))/4 - sA*(Xot(4)-Xot(2))/(3*lambdao); 
    Vp(6) = (2*Xot(6)+Xot(2)+Xot(4))/4 + sA*(Xot(3)-Xot(1))/(3*lambdao); 
    Vp2 = reshape(Vp,size(X'))';

    Vrot = real((RotMat2*Vt')' + Vp2 + Xbar);
    Vroto = reshape(Vrot(:,1:2)',[1,6]);
    Xsol(:,k3) = Vroto;
    Asol(k3) = 0.5*(Vroto(1)*Vroto(4) - Vroto(1)*Vroto(6) + Vroto(3)*Vroto(6) ...
                   - Vroto(3)*Vroto(2) + Vroto(5)*Vroto(2) - Vroto(5)*Vroto(4));
    Csol(k3) = norm(Vroto-Vo,2);
    
    error = 10^-5;
    AreaDiff =Asol-s*Ao;
    Valid_cand = find(abs(AreaDiff)<error);
    [~,minindex]=min(Csol(Valid_cand));
    Optsol = Valid_cand(minindex);

    if strcmp(SolType,'Opt_sol')
        Cost_x = Csol(Optsol);
        Area_x = Asol(Optsol);
        newX = reshape(Xsol(:,Optsol),size(X'))';
    elseif strcmp(SolType,'Constr_sol')
        Cost_x = Csol(Valid_cand);
        Area_x = Asol(Valid_cand);
        newX = permute(reshape(Xsol(:,Valid_cand),[size(X'),length(Valid_cand)]),[2,1,3]);
    elseif strcmp(SolType,'All_sol')
        newX = permute(reshape(Xsol,[size(X'),5]),[2,1,3]);
        Cost_x = Csol;
        Area_x = Asol;
    end
end