function T = read_tfm(filename)
    fid = fopen(filename);
       
    rx = fscanf(fid, 'RX RAD %f %*\n');
    ry = fscanf(fid, 'RY RAD %f %*\n');
    rz = fscanf(fid, 'RZ RAD %f %*\n');
    
    c = fscanf(fid, 'T M %f %f %f %*\n');
    tx = c(1);
    ty = c(2);
    tz = c(3);
    
    
    R = angle2dcm(-rx, -ry, -rz, 'XYZ');
    
    T = [R [tx; ty; tz]; 0 0 0 1];
    
    fclose(fid);
end