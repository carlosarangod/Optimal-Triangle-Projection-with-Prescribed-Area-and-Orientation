function Inverted = Check_Self_Collisions(X,DT,Edge_neighbors,invDM)
    Inverted = false;
    for k = 1:length(Edge_neighbors)
        Vert = cat(2,X(DT(Edge_neighbors(k),:),:),zeros(3,1));
        Ds = [(Vert(2,1:2)-Vert(1,1:2))' (Vert(3,1:2)-Vert(1,1:2))'];
        F = Ds*invDM(:,:,k);
        if det(F)<=0
            Inverted = true;
        end
    end
end