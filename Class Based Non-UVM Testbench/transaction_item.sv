class FIFO_item #(
  parameter int DATA_WIDTH = 32,
  parameter int FIFO_DEPTH = 16
);

  rand bit [DATA_WIDTH-1:0] data_in;
  rand bit                  write_enable;
  rand bit                  read_enable;

  logic [DATA_WIDTH-1:0] data_out;
  logic                  full;
  logic                  empty;

  function void print(string tag = "");
    $display("T=%0t [%s] data_in=0x%0h wr=%0b rd=%0b data_out=0x%0h full=%0b empty=%0b",
             $time, tag, data_in, write_enable, read_enable, data_out, full, empty);
  endfunction

endclass
