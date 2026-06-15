module s1(
          clk,rst,
          
          AWADDR,AWLEN,AWSIZE,AWBURST,AWVALID,AWREADY,
          WDATA,WSTRB,WLAST,WVALID,WREADY,
          BRESP,BVALID,BREADY,
          
          ARADDR,ARLEN,ARSIZE,ARBURST,ARVALID,ARREADY,
          RDATA,RLAST,RVALID,RREADY,RRESP
          );


    // global signals
    input clk;
    input rst;

    
    // write address signals
    input [31:0] AWADDR;
    input [3:0]  AWLEN;
    input [2:0]  AWSIZE;
    input [1:0]  AWBURST;
    input        AWVALID;
    output reg   AWREADY;

    // write data signals
    input [31:0] WDATA;
    input [3:0]  WSTRB;
    input        WLAST;
    input        WVALID;
    output reg   WREADY;

    // write response signals
    input            BREADY;
    output reg       BVALID;
    output reg [1:0] BRESP;

    // read address signals
    input [31:0] ARADDR;
    input [3:0]  ARLEN;
    input [2:0]  ARSIZE;
    input [1:0]  ARBURST;
    input        ARVALID;
    output reg   ARREADY;

    // read data signals
    input             RREADY;
    output reg        RVALID;
    output reg        RLAST;
    output reg [1:0]  RRESP;
    output reg [31:0] RDATA;
    

    parameter FIXED=2'b00;
    parameter INC  =2'b01;
    parameter WRAP =2'b10;

    parameter OKAY   = 2'd0;
    parameter EXOKAY = 2'd1;
    parameter SLVERR = 2'd2;
    parameter DECERR = 2'd3;
    //  write temp signals

    wire [4:0] w_len;
    wire [2:0] w_size;

    wire [31:0] wstart_addr;
    wire [31:0] waladdr;

    wire [31:0] wlow_bound;
    wire [31:0] wup_bound;
    
    reg [31:0] data;

    
   
    reg [4:0] wcount;
    


    reg [31:0] waddr_1;
    reg [31:0] waddr_n;
   

    reg [31:0] waddr;

    reg ERROR;



    //  read temp signals

    wire [4:0] r_len;
    wire [2:0] r_size;

    wire [31:0] rstart_addr;
    wire [31:0] raladdr;

    wire [31:0] rlow_bound;
    wire [31:0] rup_bound;
    

    reg [4:0] rcount;

    reg [31:0] raddr_1;
    reg [31:0] raddr_n;

    reg [31:0] raddr;

   

    reg [31:0] mem [31:0];


    assign w_len =   AWLEN+1;
    assign w_size =  2**AWSIZE ;

    
    assign wstart_addr = AWADDR;
   
    assign waladdr =  (wstart_addr/w_size)*w_size;
    
    
    assign wlow_bound = (wstart_addr/(w_size*w_len))*(w_size*w_len);
    
    assign wup_bound = wlow_bound+(w_size*w_len);
    

    assign r_len =  (ARLEN+1) ;
    assign r_size = 2**ARSIZE ;

    assign rstart_addr = ARADDR;
    assign raladdr = (rstart_addr/r_size)*r_size ;
    
    assign rlow_bound = (rstart_addr/(r_size*r_len))*(r_size*r_len);
    
    assign rup_bound = rlow_bound+(r_size*r_len);


    //  reset
    always @(posedge clk or negedge rst)
        begin
            if(!rst)
                begin
                    AWREADY=0;
                    WREADY=0;
                    ARREADY=0;
                    data=32'd0;
                   // wcount_en=0;
                    wcount=1;
                    rcount=1;
                    waddr=0;
                    ERROR=0;
                    
                end
        end

    always @(*) 
        begin
            
            data = 0;
            if(WREADY==1)
                begin                
                    if(WSTRB[3])
                        data[31:24] = WDATA[31:24];
                    if(WSTRB[2])
                        data[23:16] = WDATA[23:16];
                    if(WSTRB[1])
                        data[15:8] = WDATA[15:8];
                    if(WSTRB[0])
                        data[7:0] = WDATA[7:0]; 
                end
        end


    //  write address channel
    always @(posedge clk)
        begin
            if(AWVALID)
            
                begin
                    AWREADY=1;
                end
                waddr_1 = wstart_addr;
            if(AWVALID && AWREADY)
            case(AWBURST)
                        
                            FIXED       :       begin
                                                    if(wcount<=w_len)
                                                        begin
                                                            waddr=waddr_1; 
                                                            wcount=wcount+1;
                                                        end
                                                    else
                                                        wcount=0;
                                                end
                            INC         :       begin
                                                    if(wcount==1)
                                                        begin
                                                                waddr=wstart_addr;
                                                                wcount=wcount+1;
                                                            end
                                                            
                                                           else if(wcount<=w_len)
                                                            
                                                            begin
                                                               
                                                                waddr_n=waladdr+((wcount-1)*(w_size));
                                                                waddr=waddr_n;
                                                                wcount=wcount+1;
                                                            end
                                                        else
                                                        wcount=0;
                                                    
                                                end

                            WRAP        :       begin
                                                    
                                                    if(wcount==1)
                                                        begin
                                                                    
                                                                    waddr=waladdr;
                                                                   
                                                                    wcount=wcount+1;
                                                                
                                                        end
                                                            
                                                            else if(wcount<=w_len)
                                                                begin
                                                                    waddr=waddr+w_size;
                                                                    
                                                                    if(waddr>=wup_bound)
                                                                        begin
                                                                        waddr=wlow_bound;
                                                                        
                                                                        
                                                                        wcount=wcount+1;
                                                                        end
                                                                    else
                                                                        wcount=wcount+1;
                                                                       
                                                                    end
                                                       
                                                    else
                                                        wcount=0;

                                                   
                                                end
            endcase
           
        end


    //  write data channel
    always @(posedge clk)
        begin
            if(WVALID)
            
                begin
                    WREADY=1;
                end
            if(AWVALID && AWREADY)
            case(AWBURST)
                        
                            FIXED       :       begin
                                                    
                                                    mem[waddr]=data;
                                                    $display("display time= %0d  , waddr = %h, data = %h",$time,waddr,data);
                                                    $monitor("monitor time= %0d , waddr = %h, data = %h",$time,waddr,data);                                                end
                            INC         :       begin
                                                    if(data==32'hxx || waddr==32'hxx)
                                                        begin
                                                            ERROR = 1;
                                                        end
                                                    mem[waddr]=data;
                                                    $display("display time= %0d , waddr = %h, data = %h",$time,waddr,data);
                                                    $monitor("monitor time= %0d , waddr = %h, data = %h",$time,waddr,data);
                                                end

                            WRAP        :       begin
                                                    
                                                    mem[waddr]=data;
                                                    $display(" display time= %0d , waddr = %h, data = %h",$time,waddr,data);
                                                    $monitor(" monitor time= %0d , waddr = %h, data = %h",$time,waddr,data);
                                                end
            endcase
        end

    //  write resp channel
    always @(posedge clk)
        begin
            if(WVALID && WREADY)
                begin
                BVALID=1;
                end
            if(BVALID && WLAST)
                BRESP=OKAY;
            if(BVALID && ERROR)
                BRESP=SLVERR;            
        end




    //  read address channel
    always @(posedge clk)
        begin
            if(ARVALID)
            
                begin
                    ARREADY=1;
                end
                waddr_1 = wstart_addr;
            if(ARVALID && ARREADY)
            case(ARBURST)
                        
                            FIXED       :       begin
                                                    if(rcount<=r_len)
                                                        begin
                                                            raddr=raddr_1; 
                                                            rcount=rcount+1;
                                                        end
                                                    else
                                                        rcount=0;
                                                end
                            INC         :       begin
                                                    if(rcount==1)
                                                        begin
                                                                raddr=rstart_addr;
                                                                rcount=rcount+1;
                                                            end
                                                            
                                                           else if(rcount<=r_len)
                                                            
                                                            begin
                                                               
                                                                raddr_n=raladdr+((rcount-1)*(r_size));
                                                                raddr=raddr_n;
                                                                rcount=rcount+1;
                                                            end
                                                        else
                                                        rcount=0;
                                                    
                                                end

                            WRAP        :       begin
                                                    
                                                    if(rcount==1)
                                                        begin
                                                                    
                                                                    raddr=raladdr;
                                                                   
                                                                    rcount=rcount+1;
                                                                
                                                        end
                                                            
                                                            else if(rcount<=r_len)
                                                                begin
                                                                    raddr=raddr+r_size;
                                                                    
                                                                    if(raddr>=rup_bound)
                                                                        begin
                                                                        raddr=rlow_bound;
                                                                        
                                                                        
                                                                        rcount=rcount+1;
                                                                        end
                                                                    else
                                                                        rcount=rcount+1;
                                                                       
                                                                    end
                                                       
                                                    else
                                                        rcount=0;

                                                   
                                                end
            endcase
           
        end


    //  read data channel
    always @(posedge clk)
        begin
            if(ARVALID && ARREADY)
                begin
                    RVALID=1;
                end
            case(ARBURST)
                        
                            FIXED       :       begin
                                                    RDATA=mem[raddr];
                                                    RLAST=1;
                                                    RRESP=0;
                                                    $monitor("time= %0d  , raddr = %h, data = %h",$time,raddr,RDATA);


                                                end
                            INC         :       begin
                                                    RDATA=mem[raddr];
                                                    RLAST=1;
                                                    RRESP=0;
                                                    $monitor("time= %0d , raddr = %h, data = %h",$time,raddr,RDATA);
                                                end

                            WRAP        :       begin
                                                    RDATA=mem[raddr];
                                                    RLAST=1;
                                                    RRESP=0;
                                                    $monitor("time= %0d , raddr = %h, data = %h",$time,raddr,RDATA);
                                                end
            endcase
        end



endmodule
