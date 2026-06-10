class env #(
  parameter int DATA_WIDTH = 32,
  parameter int FIFO_DEPTH = 16
) extends uvm_env;

  `uvm_component_param_utils(env #(DATA_WIDTH, FIFO_DEPTH))

  function new(string name = "env", uvm_component parent = null);
    super.new(name, parent);
  endfunction

  agent #(DATA_WIDTH, FIFO_DEPTH)      a0;   // Agent handle
  scoreboard #(DATA_WIDTH, FIFO_DEPTH) sb0;  // Scoreboard handle

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);

    a0  = agent #(DATA_WIDTH, FIFO_DEPTH)::type_id::create("a0", this);
    sb0 = scoreboard #(DATA_WIDTH, FIFO_DEPTH)::type_id::create("sb0", this);
  endfunction

  virtual function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);

    a0.m0.mon_analysis_port.connect(sb0.mon_scb_imp);
  endfunction

endclass
