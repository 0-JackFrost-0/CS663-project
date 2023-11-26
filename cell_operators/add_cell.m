function x = add_cell(a,b)
    a_mat = cell2mat(a);
    b_mat = cell2mat(b);
    x = a_mat+b_mat;
end