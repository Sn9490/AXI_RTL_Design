module tb;

    reg clk,rst;
    
    reg[31:0] tawaddr;
    reg[3:0]  tawlen;
    reg[2:0]  tawsize;
    reg[1:0]  tawburst;

    reg[31:0] twdata;
    reg[3:0]  twstrb;
    reg       twlast;

    reg[31:0] taraddr;
    reg[3:0]  tarlen;
    reg[2:0]  tarsize;
    reg[1:0]  tarburst;

    top a1(.*);

        initial begin 
            clk=0;
            forever #5 clk=~clk;

        end

        initial #200 $stop;

        initial begin 
               rst=0;
            #5 rst=1;
        end


        initial begin //address signals
           #10
            tawaddr =25;
            tawlen  ='d3;
            tawsize ='d2;
            tawburst='d2;
        end

        initial begin // write data signals
           #10
            twdata =8;
            twstrb ='d2;
            twlast ='d1;

        end



        initial begin // rd signals
           #10
            taraddr =24;
            tarlen  ='d1;
            tarsize ='d2;
            tarburst='d2;

        end
                   
endmodule
