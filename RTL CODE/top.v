`include "tb.v"
`include "master.v"
`include "slave.v"

module top(
           clk,rst,
           tawaddr,tawlen,tawsize,tawburst,
           twdata,twstrb,twlast,
           taraddr,tarlen,tarsize,tarburst

          );

    input clk;
    input rst;
    
    input [31:0] tawaddr;
    input [3:0]  tawlen;
    input [2:0]  tawsize;
    input [1:0]  tawburst;

    input [31:0] twdata;
    input [3:0]  twstrb;
    input        twlast;

    input [31:0] taraddr;
    input [3:0]  tarlen;
    input [2:0]  tarsize;
    input [1:0]  tarburst;

    // write address wires
    wire [31:0] awaddr;
    wire [3:0]  awlen;
    wire [2:0]  awsize;
    wire [1:0]  awburst;
    wire        awvalid;
    wire        awready;

    // write data wires
    wire [31:0] wdata;
    wire [3:0]  wstrb;
    wire        wlast;
    wire        wvalid;
    wire        wready;

    // write response wires
    wire        bready;
    wire        bvalid;
    wire [1:0] bresp;

    // read address signals
    wire [31:0] araddr;
    wire [3:0]  arlen;
    wire [2:0]  arsize;
    wire [1:0]  arburst;
    wire        arvalid;
    wire        arready;

    // read data signals
    wire [31:0] rdata;
    wire        rlast;
    wire [1:0]  rresp;
    wire        rvalid;
    wire        rready;



    m1 m(
         .clk(clk),
         .rst(rst),
         .Awaddr(tawaddr),
         .Awlen(tawlen),
         .Awsize(tawsize),
         .Awburst(tawburst),
         
         .AWADDR(awaddr),
         .AWLEN(awlen),
         .AWSIZE(awsize),
         .AWBURST(awburst),
         .AWVALID(awvalid),
         .AWREADY(awready),
         
         .Wdata(twdata),
         .Wstrb(twstrb),
         .Wlast(twlast),
         .WDATA(wdata),
         .WSTRB(wstrb),
         .WLAST(wlast),
         .WVALID(wvalid),
         .WREADY(wready),
         .BVALID(bvalid),
         .BREADY(bready),
         .BRESP(bresp),
            
         .Araddr(taraddr),
         .Arlen(tarlen),
         .Arsize(tarsize),
         .Arburst(tarburst),

         .ARADDR(araddr),
         .ARLEN(arlen),
         .ARSIZE(arsize),
         .ARBURST(arburst),
         .ARVALID(arvalid),
         .ARREADY(arready),
         
         .RDATA(rdata),
         .RLAST(rlast),
         .RVALID(rvalid),
         .RREADY(rready),
         .RRESP(rresp)
         );

    s1 s(
         .clk(clk),
         .rst(rst),
         
         .AWADDR(awaddr),
         .AWLEN(awlen),
         .AWSIZE(awsize),
         .AWBURST(awburst),
         .AWVALID(awvalid),
         .AWREADY(awready),
         
         .WDATA(wdata),
         .WSTRB(wstrb),
         .WLAST(wlast),
         .WVALID(wvalid),
         .WREADY(wready),
         .BVALID(bvalid),
         .BREADY(bready),
         .BRESP(bresp),

         .ARADDR(araddr),
         .ARLEN(arlen),
         .ARSIZE(arsize),
         .ARBURST(arburst),
         .ARVALID(arvalid),
         .ARREADY(arready),
         
         .RDATA(rdata),
         .RLAST(rlast),
         .RVALID(rvalid),
         .RREADY(rready),
         .RRESP(rresp)
         );

endmodule
