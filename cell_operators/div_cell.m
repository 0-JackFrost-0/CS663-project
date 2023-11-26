function div = div_cell(a,b)
    a_mat= cell2mat(a);
    b_mat= cell2mat(b);
    div = a_mat./b_mat;
end