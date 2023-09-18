`timescale 1ns/1ps

module tb();

//---------------------------------------
int                             fsdbDump;
integer                         seed;

logic                           clk;
logic                           rst_n;

int                             ii;

logic                           trig;
wire                            vld;

real                            delta;
real                            a;
logic              [10:0]       a_fix;

wire        signed [12:0]       cosa_fix;
wire        signed [12:0]       sina_fix;

real                            cosa;
real                            sina;

real                            cosa_real;
real                            sina_real;

real                            err_cos;
real                            err_sin;

real                            max_ecos;
real                            max_esin;

//---------------------------------------

initial 
begin
    clk = 1'b0;

    #30;
    forever 
    begin
       #(1e9/(2.0*20e6)) clk = ~clk; 
    end
end 


initial 
begin
    rst_n = 0;
    #60 rst_n = 1;
end

initial 
begin
    delta = 0.006135923151543;
    a = 0;
    a_fix = 0;
    trig = 1'b0;
    cosa_real = 1;
    sina_real = 0;
    cosa = 1;
    sina = 0;
    err_cos = 0;
    err_sin = 0;
    max_ecos = 0;
    max_esin = 0;

    @ (posedge rst_n);
    #700;

    for (a_fix = 0;a_fix < 1024;a_fix++)
    begin
        a = real'(a_fix)*delta;
        cosa_real = $cos(a);
        sina_real = $sin(a);

        @ (posedge clk);
        #1;
        trig = 1;

        fork
            begin
                @ (posedge clk);
                #1;
                trig = 0;
            end

            begin
                @ (negedge vld);
                cosa = real'(cosa_fix)/2048;
                sina = real'(sina_fix)/2048;
                err_cos = (cosa_real - cosa) >=0 ? (cosa_real - cosa) : (cosa - cosa_real);
                err_sin = (sina_real - sina) >=0 ? (sina_real - sina) : (sina - sina_real);

                if (max_ecos < err_cos)
                    max_ecos = err_cos;

                if (max_esin < err_sin)
                    max_esin = err_sin;
            end

        join
    end
    #100 $finish;
end

cordic_sin_cos    inst_cordic_sin_cos(
    .clk (clk),
    .rst_n (rst_n),
    .clk_vld (1'b1),
    .soft_rst(1'b0),

    .trig (trig),
    .vld (vld),

    .a(a_fix),
    .cosa3_latch (cosa_fix),
    .sina3_latch (sina_fix)
);

endmodule 