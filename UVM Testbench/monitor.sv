class monitor #(
  parameter int DATA_WIDTH = 32,
  parameter int FIFO_DEPTH = 16
) extends uvm_monitor;

  typedef FIFO_item #(DATA_WIDTH, FIFO_DEPTH) fifo_item_t;

  `uvm_component_param_utils(monitor #(DATA_WIDTH, FIFO_DEPTH))

  virtual _if vif;

  uvm_analysis_port #(fifo_item_t) mon_analysis_port;

  function new(string name = "fifo_monitor", uvm_component parent = null);
    super.new(name, parent);
  endfunction

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);

    if (!uvm_config_db #(virtual _if)::get(this, "", "_if", vif)) begin
      `uvm_fatal("MON", "Could not get vif")
    end

    mon_analysis_port = new("mon_analysis_port", this);
  endfunction

  virtual task run_phase(uvm_phase phase);
    fifo_item_t tr;

    super.run_phase(phase);

    forever begin
      @(posedge vif.clk);

      if (!vif.rst) begin
        tr = fifo_item_t::type_id::create("tr");

        tr.data_in      = vif.data_in;
        tr.write_enable = vif.write_enable;
        tr.read_enable  = vif.read_enable;

        @(negedge vif.clk);

        tr.data_out = vif.data_out;
        tr.full     = vif.full;
        tr.empty    = vif.empty;

        mon_analysis_port.write(tr);
      end
    end
  endtask

endclass
