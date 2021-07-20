function [X,DT,Edge_vertices,Sides,B_Sides,Graph_Lim] = Mesh_Model_Generation(Name,type)
    meshdir = 'distmesh'; 
    addpath(meshdir)
    if strcmp(type,'coarse')
        if strcmp(Name,'Square')
            Big_rad = 1;
            fd=@(p) drectangle(p, -Big_rad, Big_rad, -Big_rad, Big_rad);
            [X,DT]=distmesh2d(fd,@huniform,0.285,[-Big_rad,-Big_rad;Big_rad,Big_rad],[-Big_rad,-Big_rad;-Big_rad,Big_rad;Big_rad,-Big_rad;Big_rad,Big_rad]);
            Edge_vertices = Polygon_mesh_edge(DT);
            Sides{1} = Edge_vertices(1:9); %% Left Segment
            Sides{2} = Edge_vertices(9:16); %% Up Segment
            Sides{3} = Edge_vertices(16:24); %% Right Segment
            Sides{4} = Edge_vertices([24:31,1]); %% Down Segment
            B_Sides{1} = Sides{3};
            B_Sides{2} = Sides{4};
            B_Sides{3} = Sides{1};
            B_Sides{4} = Sides{2};
            Graph_Lim = [1.5, 1.5];
        elseif strcmp(Name,'Circle')
            fd=@(p) sqrt(sum(p.^2,2))-1.1;
            [X,DT]=distmesh2d(fd,@huniform,0.26,[-1,-1;1,1],[]);
            Edge_vertices = Polygon_mesh_edge(DT);
            Sides{1} = Edge_vertices(1:7); %% 1st Quadrant
            Sides{2} = Edge_vertices(8:14); %% 2nd Quadrant
            Sides{3} = Edge_vertices(14:20); %% 3rd Quadrant
            Sides{4} = Edge_vertices([20:25,1]); %% 4th Quadrant
            B_Sides{1} = Sides{3};
            B_Sides{2} = Sides{4};
            B_Sides{3} = Sides{1};
            B_Sides{4} = Sides{2};
            Graph_Lim = [1.6, 1.6];
        elseif strcmp(Name,'Ellipse')
            fd=@(p) p(:,1).^2/1.5^2+p(:,2).^2/0.8^2-1;
            [X,DT]=distmesh2d(fd,@huniform,0.2,[-1,-0.5;0.5,1],[]);
            Edge_vertices = Polygon_mesh_edge(DT);
            Sides{1} = Edge_vertices(1:7); %% 1st Quadrant
            Sides{2} = Edge_vertices(8:14); %% 2nd Quadrant
            Sides{3} = Edge_vertices(14:20); %% 3rd Quadrant
            Sides{4} = Edge_vertices([20:25,1]); %% 4th Quadrant
            B_Sides{1} = Sides{3};
            B_Sides{2} = Sides{4};
            B_Sides{3} = Sides{1};
            B_Sides{4} = Sides{2};
            Graph_Lim = [2, 1.6];
        elseif strcmp(Name,'RectCircle')
            Big_rad = 1.1; Small_rad = 0.5;
            fd=@(p) ddiff(drectangle(p,-Big_rad,Big_rad,-Big_rad,Big_rad),dcircle(p,0,0,Small_rad));
            [X,DT]=distmesh2d(fd,@huniform,0.26,[-Big_rad,-Big_rad;Big_rad,Big_rad],...
                [-Big_rad,-Big_rad;-Big_rad,Big_rad;Big_rad,-Big_rad;Big_rad,Big_rad]);
            Edge_vertices = Polygon_mesh_edge(DT);
            Sides{1} = Edge_vertices([28:33,1:4]); %% Left Segment
            Sides{2} = Edge_vertices(4:12); %% Up Segment
            Sides{3} = Edge_vertices(12:19); %% Right Segment
            Sides{4} = Edge_vertices(19:28); %% Down Segment
            Sides{5} = Edge_vertices(34:36); %% 1st Quadrant
            Sides{6} = Edge_vertices(37:39); %% 2nd Quadrant
            Sides{7} = Edge_vertices(40:42); %% 3rd Quadrant
            Sides{8} = Edge_vertices([42:43,34]); %% 4th Quadrant
            B_Sides{1} = Sides{5};
            B_Sides{2} = Sides{6};
            B_Sides{3} = Sides{7};
            B_Sides{4} = Sides{8};
            B_Sides{5} = Sides{1};
            B_Sides{6} = Sides{2};
            B_Sides{7} = Sides{3};
            B_Sides{8} = Sides{4};
            Graph_Lim = [1.5, 1.5];
        elseif strcmp(Name,'Donut')
            Big_rad = 1.2; Small_rad = 0.55;
            fd=@(p) ddiff(dcircle(p,0,0,Big_rad),dcircle(p,0,0,Small_rad));
            [X,DT]=distmesh2d(fd,@huniform,0.25,[-1,-1;1,1],[-1,-1;-1,1;1,-1;1,1]);
            Edge_vertices = Polygon_mesh_edge(DT);
            Sides{1} = Edge_vertices(1:7); %% 1st Ext Quadrant
            Sides{2} = Edge_vertices(8:14); %% 2nd Ext Quadrant
            Sides{3} = Edge_vertices(15:21); %% 3rd Ext Quadrant
            Sides{4} = Edge_vertices([21:26,1]); %% 4th Ext Quadrant
            Sides{5} = Edge_vertices(27:29); %% 1st Int Quadrant
            Sides{6} = Edge_vertices(30:32); %% 2nd Int Quadrant
            Sides{7} = Edge_vertices(32:34); %% 3rd Int Quadrant
            Sides{8} = Edge_vertices([35:36,27]); %% 4th Int Quadrant
            B_Sides{1} = Sides{8};
            B_Sides{2} = Sides{7};
            B_Sides{3} = Sides{6};
            B_Sides{4} = Sides{5};
            B_Sides{5} = Sides{4};
            B_Sides{6} = Sides{3};
            B_Sides{7} = Sides{2};
            B_Sides{8} = Sides{1};
            Graph_Lim = [1.7, 1.7];
        elseif strcmp(Name,'Cactus')
            load Cactus_polygon.mat
            Cactus_poly = 3.5*(Cactus_Poly2 - repmat(mean(Cactus_Poly2),[size(Cactus_Poly2,1),1]));
            [X,DT]=distmesh2d(@dpoly,@huniform,0.5,[-1.8,-1.8; 1.8,1.8],Cactus_poly,Cactus_poly);
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
            B_Sides{1} = Sides{2};
            B_Sides{2} = Sides{1};
            B_Sides{3} = Sides{4};
            B_Sides{4} = Sides{3};
            B_Sides{5} = Sides{6};
            B_Sides{6} = Sides{5};
            B_Sides{7} = Sides{8};
            B_Sides{8} = Sides{7};
            B_Sides{9} = Sides{10};
            B_Sides{10} = Sides{9};
            B_Sides{11} = Sides{14};
            B_Sides{12} = Sides{13};
            B_Sides{13} = Sides{12};
            B_Sides{14} = Sides{11};
            Graph_Lim = [2.5, 2.5];
        elseif strcmp(Name,'Bean')
            load Bean_polygon.mat
            Bean_poly = 3*(Poly_bean - repmat(mean(Poly_bean),[size(Poly_bean,1),1]));
            [X,DT]=distmesh2d(@dpoly,@huniform,0.35,[-1.3,-1.3; 1.3,1.3],Bean_poly,Bean_poly);
            Edge_vertices = Polygon_mesh_edge(DT);
            Sides{1} = Edge_vertices(5:10); %% Left Segment Up
            Sides{2} = Edge_vertices([34:35,1:4]); %% Left Segment Down
            Sides{3} = Edge_vertices(9:14); %% Up Segment
            Sides{4} = Edge_vertices(28:33); %% Down Segment
            Sides{5} = Edge_vertices(15:21); %% Right Segment Up
            Sides{6} = Edge_vertices(22:27); %% Right Segment Down
            B_Sides{1} = Sides{5};
            B_Sides{2} = Sides{6};
            B_Sides{3} = Sides{4};
            B_Sides{4} = Sides{3};
            B_Sides{5} = Sides{1};
            B_Sides{6} = Sides{2};
            Graph_Lim = [1.5, 2];
        elseif strcmp(Name,'Woody')
            load Woody_polygon.mat
            Woody_poly = 3*(Woody_poly2 - repmat(mean(Woody_poly2),[size(Woody_poly2,1),1]));
            [X,DT]=distmesh2d(@dpoly,@huniform,0.35,[-1,-1; 1,1],Woody_poly,Woody_poly);
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
            B_Sides{1} = Sides{2};
            B_Sides{2} = Sides{1};
            B_Sides{3} = Sides{6};
            B_Sides{4} = Sides{5};
            B_Sides{5} = Sides{4};
            B_Sides{6} = Sides{3};
            B_Sides{7} = Sides{9};
            B_Sides{8} = Sides{14};
            B_Sides{9} = Sides{7};
            B_Sides{10} = Sides{12};
            B_Sides{11} = Sides{14};
            B_Sides{12} = Sides{10};
            B_Sides{13} = Sides{15};
            B_Sides{14} = Sides{8};
            B_Sides{15} = Sides{13};
            Graph_Lim = [2, 2];
        end
    elseif strcmp(type,'fine')
        if strcmp(Name,'Square')
            Big_rad = 1.56;
            fd=@(p) drectangle(p, -Big_rad, Big_rad, -Big_rad, Big_rad);
            [X,DT]=distmesh2d(fd,@huniform,0.145,[-Big_rad,-Big_rad;Big_rad,Big_rad],...
                [-Big_rad,-Big_rad;-Big_rad,Big_rad;Big_rad,-Big_rad;Big_rad,Big_rad]);  
            Edge_vertices = Polygon_mesh_edge(DT);
            Sides{1} = Edge_vertices(1:26); %% Left Segment
            Sides{2} = Edge_vertices(26:47); %% Up Segment
            Sides{3} = Edge_vertices(47:71); %% Right Segment
            Sides{4} = Edge_vertices([71:93,1]); %% Down Segment
            B_Sides{1} = Sides{3};
            B_Sides{2} = Sides{4};
            B_Sides{3} = Sides{1};
            B_Sides{4} = Sides{2};
            Graph_Lim = [2.1, 2.1];
        elseif strcmp(Name,'Circle')
            Rad = 1.78;
            fd=@(p) sqrt(sum(p.^2,2))-Rad;
            [X,DT]=distmesh2d(fd,@huniform,0.145,[-Rad,-Rad;Rad,Rad],[]);
            Edge_vertices = Polygon_mesh_edge(DT);
            Sides{1} = Edge_vertices(1:20); %% 1st Quadrant
            Sides{2} = Edge_vertices(20:40); %% 2nd Quadrant
            Sides{3} = Edge_vertices(40:57); %% 3rd Quadrant
            Sides{4} = Edge_vertices([57:74,1]); %% 4th Quadrant
            B_Sides{1} = Sides{3};
            B_Sides{2} = Sides{4};
            B_Sides{3} = Sides{1};
            B_Sides{4} = Sides{2};
            Graph_Lim = [2.2, 2.2];
        elseif strcmp(Name,'Ellipse')
            majax = 1.2;minax = 0.7;
            majax = 2.3; minax = 1.5;
            fd=@(p) p(:,1).^2/majax^2+p(:,2).^2/minax^2-1;
            [X,DT]=distmesh2d(fd,@huniform,0.137,[-majax,-minax;minax,majax],[]);
            Edge_vertices = Polygon_mesh_edge(DT);
            Sides{1} = Edge_vertices(1:11); %% 1st Quadrant
            Sides{2} = Edge_vertices(11:21); %% 1st Quadrant
            Sides{3} = Edge_vertices(21:30); %% 2nd Quadrant
            Sides{4} = Edge_vertices(30:39); %% 2nd Quadrant
            Sides{5} = Edge_vertices(40:49); %% 3rd Quadrant
            Sides{6} = Edge_vertices(49:59); %% 3rd Quadrant
            Sides{7} = Edge_vertices(59:70); %% 4th Quadrant
            Sides{8} = Edge_vertices([70:79,1]); %% 4th Quadrant
            B_Sides{1} = Sides{5};
            B_Sides{2} = Sides{6};
            B_Sides{3} = Sides{7};
            B_Sides{4} = Sides{8};
            B_Sides{5} = Sides{1};
            B_Sides{6} = Sides{2};
            B_Sides{7} = Sides{3};
            B_Sides{8} = Sides{4};
            Graph_Lim = [3.2, 2.5];
        elseif strcmp(Name,'RectCircle')
            Big_rad = 1.8; Small_rad = 0.9;
            fd=@(p) ddiff(drectangle(p,-Big_rad,Big_rad,-Big_rad,Big_rad),dcircle(p,0,0,Small_rad));
            [X,DT]=distmesh2d(fd,@huniform,0.144,[-Big_rad,-Big_rad;Big_rad,Big_rad],[-Big_rad,-Big_rad;-Big_rad,Big_rad;Big_rad,-Big_rad;Big_rad,Big_rad]);
            Edge_vertices = Polygon_mesh_edge(DT);
            Sides{1} = Edge_vertices(1:30); %% Left Segment
            Sides{2} = Edge_vertices(30:55); %% Up Segment
            Sides{3} = Edge_vertices(55:84); %% Right Segment
            Sides{4} = Edge_vertices([84:108,1]); %% Down Segment
            Sides{5} = Edge_vertices(109:119); %% 1st Quadrant
            Sides{6} = Edge_vertices(120:130); %% 2nd Quadrant
            Sides{7} = Edge_vertices(130:139); %% 3rd Quadrant
            Sides{8} = Edge_vertices([139:147,109]); %% 4th Quadrant
            B_Sides{1} = Sides{5};
            B_Sides{2} = Sides{6};
            B_Sides{3} = Sides{7};
            B_Sides{4} = Sides{8};
            B_Sides{5} = Sides{1};
            B_Sides{6} = Sides{2};
            B_Sides{7} = Sides{3};
            B_Sides{8} = Sides{4};
            Graph_Lim = [2.5, 2.5];
        elseif strcmp(Name,'Donut')
            Big_rad = 2; Small_rad = 1;
            fd=@(p) ddiff(dcircle(p,0,0,Big_rad),dcircle(p,0,0,Small_rad));
            [X,DT]=distmesh2d(fd,@huniform,0.139,[-Big_rad,-Big_rad;Big_rad,Big_rad],[-Big_rad,-Big_rad;-Big_rad,Big_rad;Big_rad,-Big_rad;Big_rad,Big_rad]);
            Edge_vertices = Polygon_mesh_edge(DT);
            Sides{1} = Edge_vertices(1:24); %% 1st Ext Quadrant
            Sides{2} = Edge_vertices(24:48); %% 2nd Ext Quadrant
            Sides{3} = Edge_vertices(49:69); %% 3rd Ext Quadrant
            Sides{4} = Edge_vertices([69:90,1]); %% 4th Ext Quadrant
            Sides{5} = Edge_vertices(91:102); %% 1st Int Quadrant
            Sides{6} = Edge_vertices(103:113); %% 2nd Int Quadrant
            Sides{7} = Edge_vertices(114:124); %% 3rd Int Quadrant
            Sides{8} = Edge_vertices(125:134); %% 4th Int Quadrant
            B_Sides{1} = Sides{5};
            B_Sides{2} = Sides{6};
            B_Sides{3} = Sides{7};
            B_Sides{4} = Sides{8};
            B_Sides{5} = Sides{1};
            B_Sides{6} = Sides{2};
            B_Sides{7} = Sides{3};
            B_Sides{8} = Sides{4};
            Graph_Lim = [2.5, 2.5];
        elseif strcmp(Name,'Cactus')
            load Cactus_polygon.mat
            Cactus_poly = 5*(Cactus_Poly2 - repmat(mean(Cactus_Poly2),[size(Cactus_Poly2,1),1]));
            [X,DT]=distmesh2d(@dpoly,@huniform,0.15,[-2.5,-2.5; 2.5,2.5],Cactus_poly,Cactus_poly);
            Edge_vertices = Polygon_mesh_edge(DT);
            Sides{1} = Edge_vertices([171:173,1:11]); %% Left Segment Left Branch
            Sides{2} = Edge_vertices(154:163); %% Right Segment Left Branch
            Sides{3} = Edge_vertices(163:170); %% Up Segment Left Branch
            Sides{4} = Edge_vertices(12:21); %% Down Segment Left Branch
            Sides{5} = Edge_vertices(88:96); %% Left Segment Right Branch
            Sides{6} = Edge_vertices(72:81); %% Right Segment Right Branch
            Sides{7} = Edge_vertices(82:87); %% Up Segment Right Branch
            Sides{8} = Edge_vertices(59:69); %% Down Segment Right Branch
            Sides{9} = Edge_vertices(133:147); %% Left Segment Central Branch
            Sides{10} = Edge_vertices(105:121); %% Right Segment Central Branch
            Sides{11} = Edge_vertices(123:132); %% Up Segment Central Branch
            Sides{12} = Edge_vertices(23:37); %% Left Segment Trunk
            Sides{13} = Edge_vertices(44:57); %% Right Segment Trunk
            Sides{14} = Edge_vertices(37:44); %% Right Segment Trunk
            B_Sides{1} = Sides{2};
            B_Sides{2} = Sides{1};
            B_Sides{3} = Sides{4};
            B_Sides{4} = Sides{3};
            B_Sides{5} = Sides{6};
            B_Sides{6} = Sides{5};
            B_Sides{7} = Sides{8};
            B_Sides{8} = Sides{7};
            B_Sides{9} = Sides{10};
            B_Sides{10} = Sides{9};
            B_Sides{11} = Sides{14};
            B_Sides{12} = Sides{13};
            B_Sides{13} = Sides{12};
            B_Sides{14} = Sides{11};
            Graph_Lim = [3.2, 3.2];
        elseif strcmp(Name,'Bean')
            load Bean_polygon.mat
            Bean_poly = 4.8*(Poly_bean - repmat(mean(Poly_bean),[size(Poly_bean,1),1]));
            [X,DT]=distmesh2d(@dpoly,@huniform,0.143,[-1.8,-1.8; 1.8,1.8],Bean_poly,Bean_poly);
            Edge_vertices = Polygon_mesh_edge(DT);
            Sides{1} = Edge_vertices(67:81); %% Left Segment Up
            Sides{2} = Edge_vertices([82:88,1:11]); %% Left Segment Down
            Sides{3} = Edge_vertices(55:66); %% Up Segment
            Sides{4} = Edge_vertices(12:21); %% Down Segment
            Sides{5} = Edge_vertices(35:51); %% Right Segment Up
            Sides{6} = Edge_vertices(22:35); %% Right Segment Down
            B_Sides{1} = Sides{5};
            B_Sides{2} = Sides{6};
            B_Sides{3} = Sides{4};
            B_Sides{4} = Sides{3};
            B_Sides{5} = Sides{1};
            B_Sides{6} = Sides{2};
            Graph_Lim = [2.5, 3];
        elseif strcmp(Name,'Woody')
            load Woody_polygon.mat
            Woody_poly = 4.5*(Woody_poly2 - repmat(mean(Woody_poly2),[size(Woody_poly2,1),1]));
            [X,DT]=distmesh2d(@dpoly,@huniform,0.15,[-2.5,-2.5; 2.5,2.5],Woody_poly,Woody_poly);
            Edge_vertices = Polygon_mesh_edge(DT);
            Sides{1} = Edge_vertices(120:126); %% Left Arm Up Segment
            Sides{2} = Edge_vertices(3:11); %% Left Arm Down Segment
            Sides{3} = Edge_vertices([127:128,1:3]); %% Left Arm Left Segment
            Sides{4} = Edge_vertices(85:92); %% Right Arm Up Segment
            Sides{5} = Edge_vertices(72:78); %% Right Arm Down Segment
            Sides{6} = Edge_vertices(79:84); %% Right Arm Left Segment
            Sides{7} = Edge_vertices(13:26); %% Left Leg Left Segment
            Sides{8} = Edge_vertices(27:34); %% Left Leg Down Segment
            Sides{9} = Edge_vertices(35:40); %% Left Leg Right Segment
            Sides{10} = Edge_vertices(42:48); %% Right Leg Left Segment
            Sides{11} = Edge_vertices(49:55); %% Right Leg Down Segment
            Sides{12} = Edge_vertices(56:70); %% Right Leg Right Segment
            Sides{13} = Edge_vertices(111:116); %% Head Left Segment
            Sides{14} = Edge_vertices(101:110); %% Head Up Segment
            Sides{15} = Edge_vertices(95:100); %% Head Right Segment
            B_Sides{1} = Sides{2};
            B_Sides{2} = Sides{1};
            B_Sides{3} = Sides{6};
            B_Sides{4} = Sides{5};
            B_Sides{5} = Sides{4};
            B_Sides{6} = Sides{3};
            B_Sides{7} = Sides{9};
            B_Sides{8} = Sides{14};
            B_Sides{9} = Sides{7};
            B_Sides{10} = Sides{12};
            B_Sides{11} = Sides{14};
            B_Sides{12} = Sides{10};
            B_Sides{13} = Sides{15};
            B_Sides{14} = Sides{8};
            B_Sides{15} = Sides{13};
            Graph_Lim = [3, 3];
        end
    end
end