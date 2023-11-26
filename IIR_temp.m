function [temp_filtered_phase, reg0, reg1] = IIR_temp(B,A,phase,register0,register1)
    temp_filtered_phase = B(1)*phase + register0;
    reg0 = B(2)*phase + register1 - A(2)*temp_filtered_phase;
    reg1 = B(3)*phase - A(2)*temp_filtered_phase;
end