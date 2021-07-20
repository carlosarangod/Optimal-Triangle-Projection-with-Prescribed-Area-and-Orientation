function Edge_vertices = Polygon_mesh_edge(DT)
    DT2 = unique(sort(cat(1,DT(:,1:2),DT(:,[1,3]),DT(:,2:3)),2),'rows');
    DT3 = sort(cat(1,DT(:,1:2),DT(:,[1,3]),DT(:,2:3)),2);
    Ext_edge = [];
    for k = 1:size(DT2,1)
        Edges_of_triangle = find((DT3(:,1)==DT2(k,1))&(DT3(:,2)==DT2(k,2)));
        triangles_of_vertex = mod(Edges_of_triangle,size(DT,1));
        triangles_of_vertex(triangles_of_vertex==0) = size(DT,1);
        if length(triangles_of_vertex) == 1
            Ext_edge = cat(1,Ext_edge,DT2(k,:));
        end
    end

    Edge_vertices = Ext_edge(1,:);
    Temp_Ext_edge = Ext_edge;
    Temp_Ext_edge(1,:) = [];
    for k=2:size(Ext_edge,1)
        if Edge_vertices(k) == 1
            Edge_vertices(k) = Temp_Ext_edge(1,1);
        end
        next_edge_index = find(Temp_Ext_edge == Edge_vertices(k),1);
        k1 = floor(next_edge_index/size(Temp_Ext_edge,1));
        mod_edge = mod(next_edge_index,size(Temp_Ext_edge,1));
        if mod_edge > 0
            k1 = k1 + 1;
        else
            mod_edge = size(Temp_Ext_edge,1);
        end
        k2 = 3-k1;
        Edge_vertices(k+1) = Temp_Ext_edge(mod_edge,k2);
        Temp_Ext_edge(mod_edge,:) = [];
    end
end