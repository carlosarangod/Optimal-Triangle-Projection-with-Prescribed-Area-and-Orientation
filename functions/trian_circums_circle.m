function [CirCen,R] = trian_circums_circle(X)
    DT2 = [1,2;1,3;2,3];
    k = 1;
    k2 = 1;
    Mfin = zeros(2,2);
    Bfin = zeros(2,2);
    while k2<3
        Xa = X(DT2(k,1),:);
        Xb = X(DT2(k,2),:);
        Cab = (Xa + Xb)/2;
        Mab = (Xa(2)-Xb(2))/(Xa(1)-Xb(1));
        if Mab ~=0
            PMab = -1/Mab;
            Bab = Cab(2) - PMab*Cab(1);
            Mfin(k2) = PMab;
            Bfin(k2) = Bab;
            k2 = k2+1;
        end
        k = k+1;
    end
    A = [-Mfin(1),1;-Mfin(2),1];
    B = [Bfin(1);Bfin(2)];
    CirCen = A\B;
    a = norm(X(1,:)-X(2,:));
    b = norm(X(2,:)-X(3,:));
    c = norm(X(1,:)-X(3,:));
    s = (a+b+c)/2;
    R = a*b*c/(4*sqrt(s*(a+b-s)*(a+c-s)*(b+c-s)));
end