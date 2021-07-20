close all
clearvars
clc
funcdir = strcat('functions');addpath(funcdir);
start_flag = true;
shape_sel = 4;
pbd_lin_flag = 1;
disp_perc = 0.01;
num_iter = 300;
%     disp_perc = 0.01;
dragging = [];
list = {'Square','Circle','Ellipse','RectCircle','Donut','Cactus','Bean','Woody'};
dist_const_flag = false;
pin_const_flag = true;
grav_const_flag = false;
dt = 1e-4;
g = [0 -9.8];
if start_flag
    [X,DT,Edge_vertices,Sides,Graph_Lim] = Mesh_Model_Load(list{shape_sel});
    %%%% Plot Initialization
    f1 = figure('Position',[55 78 733 690]);
    hold on
    trplt1 = triplot(DT,X(:,1),X(:,2));
    trplt2 = [];
    if isempty(Graph_Lim)
        limit_x = 1.5;
        limit_y = 1.5;
    else
        limit_x = Graph_Lim(1);
        limit_y = Graph_Lim(2);
    end
    axis([-limit_x limit_x -limit_y limit_y])
    axis square
    f2 = figure('Position',[795 598 590 170],'visible','off');
    f3 = figure('Position',[795 338 590 170],'visible','off');
    f4 = figure('Position',[795 78  590  170],'visible','off');
    %%%%% Graph Colors %%%%%%%%%%
    red = [0.6350 0.0780 0.1840];
    blue = [0 0.4470 0.7410];
    purple = [0.4940 0.1840 0.5560];
    yellow = [0.9290 0.6940 0.1250];
    green = [0.4660, 0.6740, 0.1880];
    orange = [0.8500, 0.3250, 0.0980];
    
    %%%% Deformation parameters
    n_particles = size(X,1);
    n_triangles = size(DT,1);
    for k = 1:n_triangles
        Vo = reshape(X(DT(k,:),:)',[1,6]);
        Avo = (Vo(1)*Vo(4) - Vo(1)*Vo(6) + Vo(3)*Vo(6) - Vo(3)*Vo(2) + Vo(5)*Vo(2) - Vo(5)*Vo(4))/2;
        Area_presc(k) = abs(Avo);
        Ori_presc(k) = sign(Avo);
    end
    if dist_const_flag
        DT2 = unique(sort(cat(1,DT(:,1:2),DT(:,[1,3]),DT(:,2:3)),2),'rows');
        Dist_presc_temp = (X(DT2(:,1),:)-X(DT2(:,2),:)).^2;
        Dist_presc = sqrt(Dist_presc_temp(:,1) + Dist_presc_temp(:,2));
    else
        DT2 = 0;
        Dist_presc = 0;
    end
    
    %%%%%%% Setting Displacement Convergence
    mu = mean(X);
    Sigma = cov(X);
    p = 0.9;
    s = -2 * log(1 - p);
    [V, D] = eig(Sigma * s);
    VSD = V*sqrt(D);
    max_axis = max(sqrt(VSD(:,1).^2+VSD(:,2).^2));
    Max_displacement = 2*max_axis;
    Displ_conv = Max_displacement*disp_perc;
    %%%%%% Initializing parameters for colision detection
    Vertices_neighborhood = zeros(length(Edge_vertices),2);
    for k = 1:length(Edge_vertices)
        triangles_of_vertex = mod(find(DT==Edge_vertices(k)),n_triangles);
        triangles_of_vertex(triangles_of_vertex==0) = n_triangles;
        Vertices_neighborhood(k,1:length(triangles_of_vertex)) = triangles_of_vertex;
    end
    Edge_neighbors =  nonzeros(unique(Vertices_neighborhood));
    [invDm, CirCenters, CircRad] = Init_Collision_param(X,DT,Edge_neighbors);
    external_points = zeros(1,length(Sides));
    Sides_norm{length(Sides)} = [];
    external_vert = [];
    for k = 1:length(Sides)
        Z = Sides{k};
        external_vert = cat(2,external_vert,Z);
    end
    external_vert = unique(external_vert);
    %%%%% Initial Deformation Animation
    %     unfixed = setdiff(1:n_particles,fixed_seg);
    pin_start_flag = false;
    
    Convergence_point = Displ_conv;
    Init_X = X;
    Prev_X = X;
    fixed_indices = [];
    t=1;
    Xtemp = X;
    fixed_seg_right = Sides{3};
    Xtemp(fixed_seg_right,1) = Xtemp(fixed_seg_right,1) + 0.25;
    pin_vert = cat(2,Sides{5},Sides{6},Sides{7},Sides{8});

    % Xtemp(fixed_seg_left,2) = Xtemp(fixed(k),1) + FinPos(k,2);
    iter = 30;
    oldPos = X(fixed_seg_right,:);
    mid_Step = (Xtemp(fixed_seg_right,:)-oldPos)/iter;
    newPos = oldPos;
    figure(f1)
    for k = 1:length(fixed_seg_right)
        circ(k) = plot(X(fixed_seg_right(k),1),X(fixed_seg_right(k),2),'o','MarkerSize',10,'MarkerFaceColor',red,...
            'MarkerEdgeColor',red,'UserData',k,'Tag',strcat('circ',num2str(k)));
    end
    for k = 1:length(pin_vert)
        circ2(k) = plot(X(pin_vert(k),1),X(pin_vert(k),2),'o','MarkerSize',10,'MarkerFaceColor',yellow,...
            'MarkerEdgeColor',yellow,'UserData',k,'Tag',strcat('circ2',num2str(k)));
    end
    for k=1:iter
        X(fixed_seg_right,:) = X(fixed_seg_right,:) + mid_Step;
        set(circ,'XData', X(fixed_seg_right,1));
        set(circ,'YData', X(fixed_seg_right,2));
        figure(1)
        delete(trplt1)
        trplt1 = triplot(DT,X(:,1),X(:,2));
        h = get(gca,'Children');
        set(gca,'Children',flipud(h))
        drawnow
    end
    fixed_indices = cat(2,fixed_seg_right,pin_vert);
    %%%%%% Deformation Animation
    unfixed = setdiff(1:n_particles,fixed_indices);
    X1 = X;
    t=1;
    Cost1 = 100;
    Cost2 = 100;
    Cost_hist1 = 0;
    Area_hist1 = 0;
    Disp_hist1 = 0;
    if pbd_lin_flag
        X2 = X;
        Cost_hist2 = 0;
        Area_hist2 = 0;
        Disp_hist2 = 0;
    end
    while ((Cost1>Convergence_point) || ((Cost2>Convergence_point) && pbd_lin_flag))&& ((t <= num_iter) && start_flag)
        if (Cost1>Convergence_point)
            P1 = X1;
            if grav_const_flag; P1 = P1 + g*dt; end
            P1 = Solve_Opt_Area_Const(P1,DT,Area_presc,Ori_presc);
            if dist_const_flag; P1 = Solve_Dist_Const(P1,DT2,Dist_presc); end
            P1 = box_limits(P1,limit_x,limit_y);
            X1P1 = X1-P1;
            DiffX1P1 = sqrt(X1P1(:,1).^2+X1P1(:,2).^2);
            DiffX1P1(fixed_indices) = 0;
            Cost1 = sum(DiffX1P1);
            Cost_hist1(t) = Cost1;
            Av = Calc_Areas(X1,DT);
            Area_hist1(t) = sum(abs(Ori_presc.*Av - Area_presc));
            X1(unfixed,:) = P1(unfixed,:);
            X1X = X1-X;
            Disp_hist1(t) = sum(sqrt(X1X(:,1).^2+X1X(:,2).^2));
            t1_fin = t;
        end
        if  pbd_lin_flag && (Cost2>Convergence_point)
            P2 = X2;
            if grav_const_flag; P2 = P2 + g*dt; end
            P2 = Solve_PBD_Area_Const(P2,DT,Area_presc,Ori_presc);
            if dist_const_flag; P2 = Solve_Dist_Const(P2,DT2,Dist_presc); end
            P2 = box_limits(P2,limit_x,limit_y);
            X2P2 = X2-P2;
            DiffX2P2 = sqrt(X2P2(:,1).^2+X2P2(:,2).^2);
            DiffX2P2(fixed_indices) = 0;
            Cost2 = sum(DiffX2P2);
            Cost_hist2(t) = Cost2;
            X2(unfixed,:) = P2(unfixed,:);
            X2X = X2-X;
            Av = Calc_Areas(X2,DT);
            Area_hist2(t) = sum(abs(Ori_presc.*Av - Area_presc));
            Disp_hist2(t) = sum(sqrt(X2X(:,1).^2+X2X(:,2).^2));
            t2_fin = t;
        end
        figure(f1)
        title(strcat('Iteration = ',num2str(t)))
        for k = 1:length(fixed_indices)
            q = findobj('Tag',strcat('circ',num2str(k)));
            set(q,'XData',X1(fixed_indices(k),1),'YData',X1(fixed_indices(k),2))
        end
        delete(trplt1)
        if pbd_lin_flag; delete(trplt2); end
        hold on
        trplt1 = triplot(DT,X1(:,1),X1(:,2));
        if pbd_lin_flag; trplt2 = triplot(DT,X2(:,1),X2(:,2),'Color',red); end
        if pbd_lin_flag
            legend([trplt1,trplt2],{'PBD-opt','PBD-lin'})
        else
            legend([trplt1],{'PBD-opt'})
        end
        h = get(gca,'Children');
        set(gca,'Children',flipud(h))
        drawnow
        KeyPressed = get(f1,'CurrentCharacter');
        if  strcmp(KeyPressed,'q')
            break
        end
        
        t=t+1;
    end
    if start_flag
        figure(f2)
        cla; hold on;
        plot(Cost_hist1,'LineWidth',2);
        if pbd_lin_flag; plot(Cost_hist2,'LineWidth',2); end
        plot([0,t],[Convergence_point,Convergence_point],'k--','LineWidth',2)
        xlabel('# iterations'); ylabel('Cost');
        title('Speed of convergence')
        legTc = strcat('$T_c = ',num2str(disp_perc*100),'\%$');
        if pbd_lin_flag
            hl = legend('PBD-opt','PBD-lin',legTc);
        else
            hl = legend('PBD-opt','$T_c$');
        end
        set(hl,'Interpreter','latex','FontSize',10)
        
        figure(f3)
        cla; hold on;
        a1=plot(Area_hist1,'LineWidth',2);
        plot([t1_fin,t],[Area_hist1(end),Area_hist1(end)],'LineWidth',2,'Color',blue);
        if pbd_lin_flag; a2 = plot(Area_hist2,'LineWidth',2,'Color',orange); end
        xlabel('# iterations'); ylabel('Constraint Satisfaction');
        title('Constraint Satisfaction')
        if pbd_lin_flag
            h2 = legend([a1,a2],{'PBD-opt','PBD-lin'});
        else
            h2 = legend(a1,'PBD-opt');
        end
        set(h2, 'Interpreter','latex','FontSize',10)

        figure(f4)
        cla; hold on;
        d1 = plot(Disp_hist1,'LineWidth',2);
        plot([t1_fin,t],[Disp_hist1(end),Disp_hist1(end)],'LineWidth',2,'Color',blue);
        if pbd_lin_flag; d2=plot(Disp_hist2,'LineWidth',2,'Color',orange); end
        xlabel('# iterations'); ylabel('Total Displacement');
        title('Total Displacement')
        legend('PBD-opt','Location','Southeast')
         if pbd_lin_flag
            h3=legend('PBD-opt','PBD-lin','Location','Southeast');
        else
            h3=legend('PBD-opt','Location','Southeast');
        end
        set(h3, 'Interpreter','latex','FontSize',10)
    end
    t = 1;
    X = X1;
    pin_start_flag = false;
    
end
function P = Solve_Opt_Area_Const(P,DT,Area_presc,Ori_presc)
    n_triangles = size(DT,1);
    for k=1:n_triangles
        ver1 = DT(k,1);
        ver2 = DT(k,2);
        ver3 = DT(k,3);
        Tri_X = P(DT(k,:),:);
        [newVer,~,~] = optimal_Area_constr(Tri_X,Area_presc(k),Ori_presc(k));
        P(ver1,:) = newVer(1,:);
        P(ver2,:) = newVer(2,:);
        P(ver3,:) = newVer(3,:);
    end
end
function P = Solve_PBD_Area_Const(P,DT,Area_presc,Ori_presc)
    n_triangles = size(DT,1);
    for k=1:n_triangles
        ver1 = DT(k,1);
        ver2 = DT(k,2);
        ver3 = DT(k,3);
        Tri_X = P(DT(k,:),:);
        [newVer] = PBDlin_Area_constr(Tri_X,Area_presc(k),Ori_presc(k));
        P(ver1,:) = newVer(1,:);
        P(ver2,:) = newVer(2,:);
        P(ver3,:) = newVer(3,:);
    end
end
function P = Solve_Dist_Const(P,DT2,Dist_presc)
    for k=1:size(DT2,1)
        ver1 = DT2(k,1);
        ver2 = DT2(k,2);
        newVer = solve_Dist_Constr(P(ver1,:),P(ver2,:),Dist_presc(k));
        P(ver1,:) = newVer(1,:);
        P(ver2,:) = newVer(2,:);
    end
end
function Pos = new_pos_limits(Pos,limit)
    if abs(Pos)> limit
        Pos = limit * sign(Pos);
    end
end
function Pos = box_limits(Pos,limit_x,limit_y)
    Ind_lim_x = (abs(Pos(:,1))>limit_x);
    Ind_lim_y = (abs(Pos(:,2))>limit_y);
    if sum(Ind_lim_x)>0
        Pos(Ind_lim_x,1) = limit_x * sign(Pos(Ind_lim_x,1));
    end
    if sum(Ind_lim_y)>0
        Pos(Ind_lim_y,2) = limit_y * sign(Pos(Ind_lim_y,2));
    end
end
function Area = Calc_Areas(X,DT)
    n_triangles = size(DT,1);
    for k = 1:n_triangles
        Vert = reshape(X(DT(k,:),:)',[1,6]);
        Area(k) = (Vert(1)*Vert(4) - Vert(1)*Vert(6) + Vert(3)*Vert(6) - Vert(3)*Vert(2) + Vert(5)*Vert(2) - Vert(5)*Vert(4))/2;
    end
end
