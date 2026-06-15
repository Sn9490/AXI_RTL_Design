module m1(
          clk,rst,
          Awaddr,Awlen,Awsize,Awburst,Wdata,Wstrb,Wlast,
          AWADDR,AWLEN,AWSIZE,AWBURST,AWVALID,AWREADY,
          WDATA,WSTRB,WLAST,WVALID,WREADY,
          BRESP,BVALID,BREADY,
          Araddr,Arlen,Arsize,Arburst,
          ARADDR,ARLEN,ARSIZE,ARBURST,ARVALID,ARREADY,
          RDATA,RLAST,RVALID,RREADY,RRESP
          );


    // global signals
    input clk;
    input rst;

    // write inputs from tb
    input [31:0] Awaddr;
    input [3:0]  Awlen;
    input [2:0]  Awsize;
    input [1:0]  Awburst;
    input [31:0] Wdata;
    input [3:0]  Wstrb;
    input        Wlast;
    
    // write address signals(AW)
    output reg [31:0] AWADDR;          
    output reg [3:0]  AWLEN;
    output reg [2:0]  AWSIZE;
    output reg [1:0]  AWBURST;
    output reg        AWVALID;
    input             AWREADY;

    // write data signals(W)
    output reg [31:0] WDATA;
    output reg [3:0]  WSTRB;
    output reg        WLAST;
    output reg        WVALID;
    input             WREADY;

    // write response signals(B)
    output reg  BREADY;
    input       BVALID;
    input [1:0] BRESP;

    // read inputs from tb
    input [31:0] Araddr;
    input [3:0]  Arlen;
    input [2:0]  Arsize;
    input [1:0]  Arburst;
   

    // read address signals
    output reg [31:0] ARADDR;
    output reg [3:0]  ARLEN;
    output reg [2:0]  ARSIZE;
    output reg [1:0]  ARBURST;
    output reg ARVALID;
    input ARREADY;

    // read data signals
    output reg   RREADY;
    input        RVALID;
    input        RLAST;
    input [1:0]  RRESP;
    input [31:0] RDATA;


    //  reset 
    always @(posedge clk or negedge rst)
        begin
            if(!rst)
                begin
                    AWVALID=0;
                    WVALID=0;
                    ARVALID=0;
                    WLAST=0;
                end
        end



    //  write address channel
    always @(posedge clk)
        begin
            AWADDR=Awaddr;
            AWLEN=Awlen;
            AWSIZE=Awsize;
            AWBURST=Awburst;
            if(AWADDR)
            //if(rst)
                begin
                    AWVALID=1;
                end
        end

    //  write data channel
    always @(posedge clk)
        begin
            WDATA=Wdata;
            WSTRB=Wstrb;
            WLAST=Wlast;
            if(WDATA && WSTRB)
                begin
                    WVALID=1;
                end            
        end

    //  write resp channel
    always @(posedge clk)
        begin
            if(BVALID)
                BREADY=1;
        end


    //  read address channel
    always @(posedge clk)
        begin
            ARADDR=Araddr;
            ARLEN=Arlen;
            ARSIZE=Arsize;
            ARBURST=Arburst;
            if(ARADDR)
                begin
                    ARVALID=1;
                end


        end

    //  read data channel
    always @(posedge clk)
        begin
            if(RVALID)
                RREADY=1;

        end

endmodule
