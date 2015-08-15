% plot_convergence plots the convergence of the icp algorithm based on
% debugging output from the c++ program test_gicp. test_gicp outputs both
% pointclouds, a sequence of transformations (one for each iteration),
% the final correspondence, and the corresponding weight matrices. Running
% plot_convergence will plot this information.
% dir -- base directory were debug output was saved (directory test_gicp was run in)
% show_corresp -- set to 1 to plot final correspondences
% show_metrics -- set to 1 to plot final weight matrix ellipsoids (slow)
% skip1 -- draws every skip1 point in pointcloud1
% skip2 -- draws every skip2 point in pointcloud2
% the default values for show_corresp, show_metrics, skip1, skip2 are
% 0,0,1,1 respecively.

function plot_convergence(dir, show_corresp, show_metrics, skip1, skip2)
    if(~exist('show_corresp', 'var'))
        show_corresp = 0;
    end
    if(~exist('show_metrics', 'var'))
        show_metrics = 0;
    end
    if(~exist('skip1', 'var'))
        skip1 = 1;
    end
    if(~exist('skip2', 'var'))
        skip2 = 1;
    end
    
    start_view = view;
    
    % read the number of iterations from the output file
    iter = read_iterations([dir 'iterations.txt']);
    
    pause_time = .25; % pause between plots
    pts1 = load([dir 'pts1.dat']);
    pts2 = load([dir 'pts2.dat']);
    clf;
    %view(start_view);
    t_base = read_tfm([dir 't_base.tfm']);
    h1 = -1;
    h2 = -1;
    for i = 1:iter+1
        t{i} = read_tfm([dir '/t_' num2str(i-1) '.tfm']);    

        if(h1 ~= -1 && h2 ~= -1) 
            delete([h1 h2]);
        end
        pts_tfm = ((t{i}*t_base)*[pts1'; ones(1, size(pts1,1))])';
        start_view = view;
        h1 = plot3(pts_tfm(1:skip1:end,1), pts_tfm(1:skip1:end,2), pts_tfm(1:skip1:end,3),'rx');
        hold on;
        h2 = plot3(pts2(1:skip2:end,1), pts2(1:skip2:end,2), pts2(1:skip2:end,3),'go');
        %view(start_view);
        pause(pause_time);
    end
    
    if(show_corresp)
        correspondence = load([dir 'correspondence.txt']);
        for i = 1:skip1:size(correspondence, 1)
            starts = pts_tfm(correspondence(i,1)+1,:);
            ends = pts2(correspondence(i,2)+1,:);
            line([starts(1); ends(1)], [starts(2); ends(2)], [starts(3); ends(3)]);
        end
    end
    
    if(show_metrics)
        if(~show_corresp)
            correspondence = load([dir 'correspondence.txt']);
        end
        metrics = load([dir 'mahalanobis.txt']);        
        for i = 1:skip1:size(correspondence, 1)
            M = reshape(metrics(correspondence(i,1)+1,:), [3 3]);
            h = plot_gaussian_ellipsoid(pts_tfm(correspondence(i,1)+1,1:3), M, .01);
            set(h, 'FaceAlpha', 0);
            set(h, 'EdgeColor', 'flat');
        end
    end
end
