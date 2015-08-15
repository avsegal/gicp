function iter = read_iterations(filename)
    fid = fopen(filename);
    iter = fscanf(fid, 'Converged in %d%*\n');   
    fclose(fid);
end