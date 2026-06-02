`include "interface.sv"
`include "transaction_item.sv"
`include "generator.sv"
`include "driver.sv"
`include "monitor.sv"
`include "scoreboard.sv"
`include "enviornment.sv"
`include "test.sv"
`include "FIFO.sv"

module tb;

  parameter int DATA_WIDTH = 32;
  parameter int FIFO_DEPTH = 16;

  logic clk;

  always #10 clk = ~clk;

  FIFO_if #(DATA_WIDTH, FIFO_DEPTH) _if (clk);

  FIFO #(
    .DATA_WIDTH(DATA_WIDTH),
    .FIFO_DEPTH(FIFO_DEPTH)
  ) dut (
    .clk          (_if.clk),
    .rst          (_if.rst),
    .data_in      (_if.data_in),
    .write_enable (_if.write_enable),
    .read_enable  (_if.read_enable),
    .data_out     (_if.data_out),
    .full         (_if.full),
    .empty        (_if.empty)
  );

  test #(DATA_WIDTH, FIFO_DEPTH) t0;

  initial begin
    
    clk = 0;

    _if.rst          = 1'b1;
    _if.data_in      = '0;
    _if.write_enable = 1'b0;
    _if.read_enable  = 1'b0;

    repeat (3) @(posedge clk);
    _if.rst = 1'b0;

    t0 = new();
    t0.e0.vif = _if;
    t0.run();

    repeat (3) @(posedge clk);

    $finish;
  end

  initial begin
    $dumpfile("dump.vcd");
    $dumpvars(0, tb);
  end

endmodule
