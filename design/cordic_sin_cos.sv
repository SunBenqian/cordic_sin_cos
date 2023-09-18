// a 10b represent 360 reg 
// cosa : 13 = 1 + 1 + 11
// sina : 13 = 1 + 1 + 11

module cordic_sin_cos(
    input       wire        clk,
    input       wire        rst_n,
    input       wire        clk_vld,
    input       wire        soft_rst,

    input       wire        trig,
    output      reg         vld,

    input       wire  [9:0] a,
    output      reg  signed [12:0]  cosa3_latch,
    output      reg  signed [12:0]  sina3_latch
);

//-------------------------------------------------
reg                     [3:0]               cnt;
reg                                         vld_pre;

reg                     [8:0]               a2;
reg         signed      [16:0]              tmp1;
reg         signed      [16:0]              tmp2;
reg         signed      [15:0]              ar;
reg                     [13:0]              tt;//注意这个地方的tt本来应该是15位的，现在写成14位是因为它是一个无符号数，在和ar进行加减迭代的时候要对tt进行有符号化即signed'({1'b0,tt})，使得在计算时变成了15位。


reg         signed      [16:0]              cosa;
reg         signed      [16:0]              sina;
wire        signed      [13:0]              cosa_tmp;
wire        signed      [13:0]              sina_tmp;
wire        signed      [12:0]              cosa2;
wire        signed      [12:0]              sina2;
reg         signed      [12:0]              cosa3;
reg         signed      [12:0]              sina3;
//-------------------------------------------------

//先生成一个状态机
always @ (posedge clk or negedge rst_n)
begin
    if (!rst_n)
        cnt <= 4'd0;
    else if (soft_rst)
        cnt <= 4'd0;
    else if (clk_vld)
        begin
            if (trig)
                cnt <= 4'd1;
            else if ((cnt > 4'd0) & (cnt < 4'd14))
                cnt <= cnt + 4'd1;
            else 
                cnt <= 4'd0;
        end
end

//生成valid_pre信号

always @ (posedge clk or negedge rst_n)
begin
   if (!rst_n)
        vld_pre <= 1'b0;
    else if (soft_rst)
        vld_pre <= 1'b0;
    else if (clk_vld)
        vld_pre <= (cnt == 4'd14);
end


//生成vld信号

always @ (posedge clk or negedge rst_n)
begin
    if (!rst_n)
        vld <= 1'b0;
    else if (soft_rst)
        vld <= 1'b0;
    else if (clk_vld)
        vld <= vld_pre;
end

//当vld_pre信号起来之后保持信息

always @ (posedge clk or negedge rst_n)
begin
    if (!rst_n)
    begin
        cosa3_latch <= {1'b0,1'b1,11'd0};
        sina3_latch <= 13'd0;
    end
    else if (soft_rst)
    begin
        cosa3_latch <= {1'b0,1'b1,11'd0};
        sina3_latch <= 13'd0;  
    end
    else if (clk_vld & vld_pre)
    begin
        cosa3_latch <= cosa3;
        sina3_latch <= sina3;
    end
end

//cordic算法

always @ (*)
begin
    if (a < 10'd256)
        a2 = a;
    else if ((a >= 10'd256) & (a < 10'd512))
        a2 = 11'd512 - a;
    else if ((a >= 10'd512) & (a < 10'd768))
        a2 = a - 11'd512;
    else
        a2 = 11'd1024 - a;
end

//生成tmp1和tmp2

always @ (*)
begin
    case (cnt)
            4'd1 : 
            begin
                tmp1 = sina;
                tmp2 = cosa;
            end
            4'd2 :
            begin
                tmp1 = sina >>> 1;
                tmp2 = cosa >>> 1;
            end
            4'd3 :
            begin
                tmp1 = sina >>> 2;
                tmp2 = cosa >>> 2;
            end
            4'd4 :
            begin
                tmp1 = sina >>> 3;
                tmp2 = cosa >>> 3;
            end
            4'd5 :
            begin
                tmp1 = sina >>> 4;
                tmp2 = cosa >>> 4;
            end
            4'd6 :
            begin
                tmp1 = sina >>> 5;
                tmp2 = cosa >>> 5;
            end
            4'd7 :
            begin
                tmp1 = sina >>> 6;
                tmp2 = cosa >>> 6;
            end
            4'd8 :
            begin
                tmp1 = sina >>> 7;
                tmp2 = cosa >>> 7;
            end
            4'd9 :
            begin
                tmp1 = sina >>> 8;
                tmp2 = cosa >>> 8;
            end
            4'd10 :
            begin
                tmp1 = sina >>> 9;
                tmp2 = cosa >>> 9;
            end
            4'd11 :
            begin
                tmp1 = sina >>> 10;
                tmp2 = cosa >>> 10;
            end
            4'd12 :
            begin
                tmp1 = sina >>> 11;
                tmp2 = cosa >>> 11;
            end
            4'd13 :
            begin
                tmp1 = sina >>> 12;
                tmp2 = cosa >>> 12;
            end
            4'd14 :
            begin
                tmp1 = sina >>> 13;
                tmp2 = cosa >>> 13;
            end
            default :
            begin
                tmp1 = 17'd0;
                tmp2 = 17'd0;
            end
    endcase
end


//迭代的过程
always @ (posedge clk or negedge rst_n)
begin
    if (!rst_n)
        begin
            cosa <= 17'd19898;
            sina <= 17'd0;
        end
    else if (soft_rst)
        begin
            cosa <= 17'd19898;
            sina <= 17'd0;
        end
    else if (clk_vld)
        begin
            if (cnt == 4'd0)
            begin
                cosa <= 17'd19898;
                sina <= 17'd0;
            end
            else 
            begin
                if (ar >= 0)
                begin
                    cosa <= cosa - tmp1;
                    sina <= sina + tmp2;
                end
                else 
                begin
                    cosa <= cosa + tmp1;
                    sina <= sina - tmp2;
                end
            end
        end
end


//ar的迭代过程

always @ (posedge clk or negedge rst_n)
begin
    if (!rst_n)
        ar <= 16'd0;
    else if (soft_rst)
        ar <= 16'd0;
    else if (clk_vld)
        begin
            if (cnt == 4'd0)
                ar <= {1'b0,a2,6'd0};
            else 
            begin
                if (ar >= 0)
                    ar <= ar - signed'({1'b0,tt});
                else 
                    ar <= ar + signed'({1'b0,tt});
            end
        end
end

//生成每种状态下tt的值

always @ (*)
begin
    case (cnt)
            4'd0 : tt = 14'd0;
            4'd1 : tt = 14'd8192;
            4'd2 : tt = 14'd4836;
            4'd3 : tt = 14'd2555;
            4'd4 : tt = 14'd1297;
            4'd5 : tt = 14'd651;
            4'd6 : tt = 14'd326;
            4'd7 : tt = 14'd163;
            4'd8 : tt = 14'd81;
            4'd9 : tt = 14'd41;
            4'd10 : tt = 14'd20;
            4'd11 : tt = 14'd10;
            4'd12 : tt = 14'd5;
            4'd13 : tt = 14'd3;
            4'd14 : tt = 14'd1;
            default : tt = 14'd0;
    endcase
end 

assign cosa_tmp = (cosa >>> 3) + signed'(14'd1);
assign sina_tmp = (sina >>> 3) + signed'(14'd1);

assign cosa2 = cosa_tmp >>> 1;
assign sina2 = sina_tmp >>> 1;

//转换到各自的象限

always @ (*)
begin
    if (a < 10'd256)
        begin
            cosa3 = cosa2;
            sina3 = sina2;
        end
    else if ((a >= 10'd256) & (a < 10'd512))
        begin
            cosa3 = -cosa2;
            sina3 = sina2;
        end
    else if ((a >= 10'd512) & (a < 10'd768))
        begin
            cosa3 = -cosa2;
            sina3 = -sina2;
        end
    else 
        begin
            cosa3 = cosa2;
            sina3 = -sina2;
        end 
end


endmodule 