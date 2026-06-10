class test extends uvm_test;

  `uvm_component_utils(test)

  function new(string name = "test", uvm_component parent = null);
    super.new(name, parent);
  endfunction

  env #(32, 16) e0;
  virtual _if #(32, 16) vif;

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);

    e0 = env #(32, 16)::type_id::create("e0", this);

    if (!uvm_config_db #(virtual _if #(32, 16))::get(this, "", "_if", vif)) begin
      `uvm_fatal("TEST", "Did not get vif")
    end

    uvm_config_db #(virtual _if #(32, 16))::set(this, "e0.a0.*", "_if", vif);
  endfunction

  virtual task run_phase(uvm_phase phase);

    gen_item_seq #(32, 16) seq;

    phase.raise_objection(this);

    apply_reset();

    seq = gen_item_seq #(32, 16)::type_id::create("seq");

    if (!seq.randomize() with { num inside {[20:30]}; }) begin
      `uvm_error("TEST", "Sequence randomization failed")
    end

    seq.start(e0.a0.s0);

    #200;

    phase.drop_objection(this);

  endtask

  virtual task apply_reset();

    vif.rst          <= 1;
    vif.data_in      <= '0;
    vif.write_enable <= 0;
    vif.read_enable  <= 0;

    repeat (5) @(posedge vif.clk);

    vif.rst <= 0;

    repeat (10) @(posedge vif.clk);

  endtask

endclass
