class FIFO_item #(
  parameter int DATA_WIDTH = 32,
  parameter int FIFO_DEPTH = 16
) extends uvm_sequence_item;

  rand bit [DATA_WIDTH-1:0] data_in;
  rand bit                  write_enable;
  rand bit                  read_enable;

  logic [DATA_WIDTH-1:0] data_out;
  logic                  full;
  logic                  empty;

  `uvm_object_param_utils_begin(FIFO_item #(DATA_WIDTH, FIFO_DEPTH))
    `uvm_field_int(data_in,      UVM_DEFAULT | UVM_HEX)
    `uvm_field_int(write_enable, UVM_DEFAULT)
    `uvm_field_int(read_enable,  UVM_DEFAULT)
    `uvm_field_int(data_out,     UVM_DEFAULT | UVM_HEX)
    `uvm_field_int(full,         UVM_DEFAULT)
    `uvm_field_int(empty,        UVM_DEFAULT)
  `uvm_object_utils_end

  function new(string name = "FIFO_item");
    super.new(name);
  endfunction

endclass
