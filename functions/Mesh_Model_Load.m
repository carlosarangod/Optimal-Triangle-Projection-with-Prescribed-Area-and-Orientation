function [X,DT,Edge_vertices,Sides,Graph_Lim] = Mesh_Model_Load(Name)
    meshdir = 'meshes'; 
    addpath(meshdir)
    if strcmp(Name,'Square')
        load('mesh_square','X','DT')
        Edge_vertices = Polygon_mesh_edge(DT);
        Sides{1} = Edge_vertices(1:9); %% Left Segment
        Sides{2} = Edge_vertices(9:16); %% Up Segment
        Sides{3} = Edge_vertices(16:24); %% Right Segment
        Sides{4} = Edge_vertices([24:31,1]); %% Down Segment
        Graph_Lim = [1.5, 1.5];
    elseif strcmp(Name,'Circle')
        load('mesh_circle','X','DT')
        Edge_vertices = Polygon_mesh_edge(DT);
        Sides{1} = Edge_vertices(1:7); %% 1st Quadrant
        Sides{2} = Edge_vertices(8:14); %% 2nd Quadrant
        Sides{3} = Edge_vertices(14:20); %% 3rd Quadrant
        Sides{4} = Edge_vertices([20:25,1]); %% 4th Quadrant
        Graph_Lim = [1.6, 1.6];
    elseif strcmp(Name,'Ellipse')
        load('mesh_ellipse','X','DT')
        Edge_vertices = Polygon_mesh_edge(DT);
        Sides{1} = Edge_vertices(1:7); %% 1st Quadrant
        Sides{2} = Edge_vertices(8:14); %% 2nd Quadrant
        Sides{3} = Edge_vertices(14:20); %% 3rd Quadrant
        Sides{4} = Edge_vertices([20:25,1]); %% 4th Quadrant
        Graph_Lim = [2, 1.6];
    elseif strcmp(Name,'RectCircle')
        load('mesh_rectcircle','X','DT')
        Edge_vertices = Polygon_mesh_edge(DT);
        Sides{1} = Edge_vertices([28:33,1:4]); %% Left Segment
        Sides{2} = Edge_vertices(4:12); %% Up Segment
        Sides{3} = Edge_vertices(12:19); %% Right Segment
        Sides{4} = Edge_vertices(19:28); %% Down Segment
        Sides{5} = Edge_vertices(34:36); %% 1st Quadrant
        Sides{6} = Edge_vertices(37:39); %% 2nd Quadrant
        Sides{7} = Edge_vertices(40:42); %% 3rd Quadrant
        Sides{8} = Edge_vertices([42:43,34]); %% 4th Quadrant
        Graph_Lim = [1.5, 1.5];
    elseif strcmp(Name,'Donut')
        load('mesh_donut','X','DT')
        Edge_vertices = Polygon_mesh_edge(DT);
        Sides{1} = Edge_vertices(1:7); %% 1st Ext Quadrant
        Sides{2} = Edge_vertices(8:14); %% 2nd Ext Quadrant
        Sides{3} = Edge_vertices(15:21); %% 3rd Ext Quadrant
        Sides{4} = Edge_vertices([21:26,1]); %% 4th Ext Quadrant
        Sides{5} = Edge_vertices(27:29); %% 1st Int Quadrant
        Sides{6} = Edge_vertices(30:32); %% 2nd Int Quadrant
        Sides{7} = Edge_vertices(32:34); %% 3rd Int Quadrant
        Sides{8} = Edge_vertices([35:36,27]); %% 4th Int Quadrant
        Graph_Lim = [1.7, 1.7];
    elseif strcmp(Name,'Cactus')
        load('mesh_cactus','X','DT')
        Edge_vertices = Polygon_mesh_edge(DT);
        Sides{1} = Edge_vertices([80:82,1:3]); %% Left Segment Left Branch
        Sides{2} = Edge_vertices(7:11); %% Right Segment Left Branch
        Sides{3} = Edge_vertices(4:6); %% Up Segment Left Branch
        Sides{4} = Edge_vertices(76:79); %% Down Segment Left Branch
        Sides{5} = Edge_vertices(39:43); %% Left Segment Right Branch
        Sides{6} = Edge_vertices(46:52); %% Right Segment Right Branch
        Sides{7} = Edge_vertices(44:46); %% Up Segment Right Branch
        Sides{8} = Edge_vertices(54:57); %% Down Segment Right Branch
        Sides{9} = Edge_vertices(14:22); %% Left Segment Central Branch
        Sides{10} = Edge_vertices(27:36); %% Right Segment Central Branch
        Sides{11} = Edge_vertices(23:26); %% Up Segment Central Branch
        Sides{12} = Edge_vertices(67:75); %% Left Segment Trunk
        Sides{13} = Edge_vertices(58:65); %% Right Segment Trunk
        Sides{14} = Edge_vertices(65:67); %% Right Segment Trunk
        Graph_Lim = [2.5, 2.5];
    elseif strcmp(Name,'Bean')
        load('mesh_bean','X','DT')
        Edge_vertices = Polygon_mesh_edge(DT);
        Sides{1} = Edge_vertices(5:10); %% Left Segment Up
        Sides{2} = Edge_vertices([34:35,1:4]); %% Left Segment Down
        Sides{3} = Edge_vertices(9:14); %% Up Segment
        Sides{4} = Edge_vertices(28:33); %% Down Segment
        Sides{5} = Edge_vertices(15:21); %% Right Segment Up
        Sides{6} = Edge_vertices(22:27); %% Right Segment Down
        Graph_Lim = [1.5, 2];
    elseif strcmp(Name,'Woody')
        load('mesh_woody','X','DT')
        Edge_vertices = Polygon_mesh_edge(DT);
        Sides{1} = Edge_vertices(63:66); %% Left Arm Up Segment
        Sides{2} = Edge_vertices(2:6); %% Left Arm Down Segment
        Sides{3} = Edge_vertices([67,1:3]); %% Left Arm Left Segment
        Sides{4} = Edge_vertices(46:49); %% Right Arm Up Segment
        Sides{5} = Edge_vertices(38:42); %% Right Arm Down Segment
        Sides{6} = Edge_vertices(42:45); %% Right Arm Left Segment
        Sides{7} = Edge_vertices(6:12); %% Left Leg Left Segment
        Sides{8} = Edge_vertices(13:17); %% Left Leg Down Segment
        Sides{9} = Edge_vertices(17:21); %% Left Leg Right Segment
        Sides{10} = Edge_vertices(23:27); %% Right Leg Left Segment
        Sides{11} = Edge_vertices(28:30); %% Right Leg Down Segment
        Sides{12} = Edge_vertices(31:37); %% Right Leg Right Segment
        Sides{13} = Edge_vertices(59:62); %% Head Left Segment
        Sides{14} = Edge_vertices(55:58); %% Head Up Segment
        Sides{15} = Edge_vertices(50:54); %% Head Right Segment
        Graph_Lim = [2, 2];
    end
    
end