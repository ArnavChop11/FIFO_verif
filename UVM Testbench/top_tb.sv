// UVM tb
module tb_top;

  import uvm_pkg::*;
  `include "uvm_macros.svh"
  `include "interface.sv"
  `include "sequencer_item.sv"
  `include "gen.sv"
  `include "driver.sv"
  `include "monitor.sv"
  `include "scoreboard.sv"
  `include "agent.sv"
  `include "enviornment.sv"
  `include "test.sv"
  `include "FIFO.sv"
  

  parameter int DATA_WIDTH = 32;
  parameter int FIFO_DEPTH = 16;

  logic clk;

  // Clock generation
  initial begin
    clk = 0;
    forever #5 clk = ~clk;
  end

  // Interface instance
  _if #(
    .DATA_WIDTH(DATA_WIDTH),
    .FIFO_DEPTH(FIFO_DEPTH)
  ) fifo_if_inst (
    .clk(clk)
  );

  // DUT instance
  FIFO #(
    .DATA_WIDTH(DATA_WIDTH),
    .FIFO_DEPTH(FIFO_DEPTH)
  ) dut (
    .clk          (clk),
    .rst          (fifo_if_inst.rst),
    .data_in      (fifo_if_inst.data_in),
    .write_enable (fifo_if_inst.write_enable),
    .read_enable  (fifo_if_inst.read_enable),
    .data_out     (fifo_if_inst.data_out),
    .full         (fifo_if_inst.full),
    .empty        (fifo_if_inst.empty)
  );

  initial begin
    uvm_config_db #(virtual _if #(DATA_WIDTH, FIFO_DEPTH))::set(
      null,
      "uvm_test_top",
      "_if",
      fifo_if_inst
    );

    run_test("test");
  end

endmodule
