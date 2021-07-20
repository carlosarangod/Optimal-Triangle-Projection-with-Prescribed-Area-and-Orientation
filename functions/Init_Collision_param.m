function [invDm, CirCenters, CircRad] = Init_Collision_param(X,DT,Edge_neighbors)
    invDm = zeros(2,2,length(Edge_neighbors));
    CirCenters = zeros(length(Edge_neighbors),2);
    CircRad = zeros(1,length(Edge_neighbors));
    for k = 1:length(Edge_neighbors)
        Vert = cat(2,X(DT(Edge_neighbors(k),:),:),zeros(3,1));
        Dm = [(Vert(2,1:2)-Vert(1,1:2))' (Vert(3,1:2)-Vert(1,1:2))'];
        invDm(:,:,k) = inv(Dm);
        TriX = X(DT(Edge_neighbors(k),:),:);
        [CirCenters(k,:),CircRad(k)] = trian_circums_circle(TriX);
    end
end