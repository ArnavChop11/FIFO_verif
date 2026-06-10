class agent #(
  parameter int DATA_WIDTH = 32,
  parameter int FIFO_DEPTH = 16
) extends uvm_agent;

  typedef FIFO_item #(DATA_WIDTH, FIFO_DEPTH) fifo_item_t;

  `uvm_component_param_utils(agent #(DATA_WIDTH, FIFO_DEPTH))

  uvm_sequencer #(fifo_item_t) s0;
  driver  #(DATA_WIDTH, FIFO_DEPTH) d0;
  monitor #(DATA_WIDTH, FIFO_DEPTH) m0;

  function new(string name = "agent", uvm_component parent = null);
    super.new(name, parent);
  endfunction

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);

    s0 = uvm_sequencer #(fifo_item_t)::type_id::create("s0", this);
    d0 = driver  #(DATA_WIDTH, FIFO_DEPTH)::type_id::create("d0", this);
    m0 = monitor #(DATA_WIDTH, FIFO_DEPTH)::type_id::create("m0", this);
  endfunction

  virtual function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);

    d0.seq_item_port.connect(s0.seq_item_export);
  endfunction

endclass
