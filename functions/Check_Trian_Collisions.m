function Collided = Check_Trian_Collisions(X,DT,fixed,Edge_vertices,Vertices_neighborhood,CirCenters, CircRad)
    Collided = false;
    fixed_neighbors = [];
    Edge_neighbors =  nonzeros(unique(Vertices_neighborhood));
    for k = 1:length(fixed)
        index = find(Edge_vertices==fixed(k));
        fixed_neighbors = cat(1,fixed_neighbors,nonzeros(Vertices_neighborhood(index,:)));
    end
    fixed_neighbors = unique(fixed_neighbors);
    TotCirThresh = false(1,length(CircRad));
    %%%% Circle collision
    for k = 1:length(fixed_neighbors)
        TriX = X(DT(fixed_neighbors(k),:),:);
        [CandCirCenters,CandCircRad] = trian_circums_circle(TriX);
        TotRad = CandCircRad + CircRad;
%         TotDis = vecnorm(CirCenters' - CandCirCenters);
%         TotDistemp = CirCenters' - CandCirCenters;
        TotDistemp = (CirCenters - CandCirCenters').^2;
        TotDis = sqrt(TotDistemp(:,1) + TotDistemp(:,2))'; 
        CirThresh = TotDis<TotRad;
        TotCirThresh = TotCirThresh | CirThresh;
    end
    for l=1:length(fixed)
        PosTriang = Edge_neighbors(TotCirThresh);
        index = find(Edge_vertices==fixed(l));
        fixed_neighbors = nonzeros(Vertices_neighborhood(index,:));
        for k = 1:length(fixed_neighbors)
            PosTriang(PosTriang==fixed_neighbors(k)) = [];
        end
        %%%% Triangle collision
        for k = 1:length(fixed_neighbors)
            X1 = X(DT(fixed_neighbors(k),:),:);
            for j = 1:length(PosTriang)
                X2 = X(DT(PosTriang(j),:),:);
                [xj,~]=polyxpoly(X1(:,1),X1(:,2),X2(:,1),X2(:,2));
                if length(xj)<3 || isempty(xj)
                    [xi1,yi1]=inpolygon(X1(:,1),X1(:,2),X2(:,1),X2(:,2));
                    [xi2,yi2]=inpolygon(X2(:,1),X2(:,2),X1(:,1),X1(:,2));
                    if isempty(xj) && sum(xi1+yi1+xi2+yi2)>0 %%% 2 triangle sharing one vertex
                        Collided = true;
                    elseif length(xj)==1 && (sum(xi1)~=1 || sum(xi2)~=1) %%% 2 triangle sharing one vertex
                        Collided = true;
                    elseif length(xj)==2 && (sum(xi1)~=2 || sum(xi2)~=2) %%% 2 triangle sharing one edge
                        Collided = true;
                    end
                else
                    Collided = true;
                end
            end
        end
    end
end