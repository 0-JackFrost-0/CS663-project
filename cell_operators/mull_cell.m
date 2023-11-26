function mul = mull_cell(a,b)
    if size(a) == [1,1]
        a_mat = a(1,1);
    else
        a_mat = cell2mat(a);
    end
    if size(a) == [1,1]
        b_mat = b(1,1);
    else
        b_mat = cell2mat(b);
    end
    a_mat
    b_mat
    mul = a_mat.*b_mat;
end