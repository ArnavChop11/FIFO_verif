interface _if #(
  parameter int DATA_WIDTH = 32,
  parameter int FIFO_DEPTH = 16
)(
  input logic clk
);

  logic rst;

  logic [DATA_WIDTH-1:0] data_in;
  logic                  write_enable;
  logic                  read_enable;

  logic [DATA_WIDTH-1:0] data_out;
  logic                  full;
  logic                  empty;

endinterface
