class scoreboard #(
  parameter int DATA_WIDTH = 32,
  parameter int FIFO_DEPTH = 16
) extends uvm_scoreboard;

  typedef FIFO_item #(DATA_WIDTH, FIFO_DEPTH) fifo_item_t;

  `uvm_component_param_utils(scoreboard #(DATA_WIDTH, FIFO_DEPTH))

  uvm_analysis_imp #(fifo_item_t, scoreboard #(DATA_WIDTH, FIFO_DEPTH)) mon_scb_imp;

  int num_fails = 0;

  logic [DATA_WIDTH-1:0] expected_vals[$];

  function new(string name = "scoreboard", uvm_component parent = null);
    super.new(name, parent);
  endfunction

  function void pass_msg(string msg);
    `uvm_info("SCB_PASS", msg, UVM_LOW)
  endfunction

  function void fail_msg(string msg);
    num_fails += 1;
    `uvm_error("SCB_FAIL", msg)
  endfunction

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    mon_scb_imp = new("mon_scb_imp", this);
  endfunction

  virtual function void write(fifo_item_t item);

    logic [DATA_WIDTH-1:0] out_val;

    int pre_size;
    bit read_valid;
    bit write_valid;

    bit expected_empty;
    bit expected_full;

    pre_size = expected_vals.size();

    read_valid = item.read_enable && (pre_size > 0);

    write_valid = item.write_enable && ((pre_size < FIFO_DEPTH) || read_valid);

    if (item.write_enable && item.read_enable) begin

      if (pre_size == 0) begin
        `uvm_info("Scoreboard", "Read+write while empty case", UVM_LOW)
        `uvm_info("Scoreboard", "Read ignored, write accepted", UVM_LOW)
      end else if (pre_size == FIFO_DEPTH) begin
        `uvm_info("Scoreboard", "Read+write while full case", UVM_LOW)
        `uvm_info("Scoreboard", "Read accepted, write accepted, FIFO stays full", UVM_LOW)
      end else begin
        `uvm_info("Scoreboard", "Normal read+write case", UVM_LOW)
      end

      if (read_valid) begin
        out_val = expected_vals.pop_front();

        if (item.data_out !== out_val) begin
          fail_msg($sformatf("[Scoreboard] read+write mismatch. Expected=0x%0h Got=0x%0h",
                             out_val, item.data_out));
        end else begin
          pass_msg("[Scoreboard] read+write output correct");
        end
      end

      if (write_valid) begin
        expected_vals.push_back(item.data_in);
        pass_msg("[Scoreboard] write stored in expected queue");
      end

    end else if (item.read_enable) begin

      if (pre_size == 0) begin
        `uvm_info("Scoreboard", "Read while empty case", UVM_LOW)
        pass_msg("[Scoreboard] read correctly ignored because FIFO was empty");
      end else begin
        out_val = expected_vals.pop_front();

        if (item.data_out !== out_val) begin
          fail_msg($sformatf("[Scoreboard] read mismatch. Expected=0x%0h Got=0x%0h",
                             out_val, item.data_out));
        end else begin
          pass_msg("[Scoreboard] read output correct");
        end
      end

    end else if (item.write_enable) begin

      if (pre_size == FIFO_DEPTH) begin
        `uvm_info("Scoreboard", "Write while full case", UVM_LOW)
        pass_msg("[Scoreboard] write correctly ignored because FIFO was full");
      end else begin
        expected_vals.push_back(item.data_in);
        pass_msg("[Scoreboard] write stored in expected queue");
      end

    end else begin

      pass_msg("[Scoreboard] idle cycle");

    end

    expected_empty = (expected_vals.size() == 0);
    expected_full  = (expected_vals.size() == FIFO_DEPTH);

    if (item.empty !== expected_empty) begin
      fail_msg($sformatf("[Scoreboard] empty mismatch. Expected=%0b Got=%0b",
                         expected_empty, item.empty));
    end else begin
      pass_msg("[Scoreboard] empty flag correct");
    end

    if (item.full !== expected_full) begin
      fail_msg($sformatf("[Scoreboard] full mismatch. Expected=%0b Got=%0b",
                         expected_full, item.full));
    end else begin
      pass_msg("[Scoreboard] full flag correct");
    end

    `uvm_info("Scoreboard", item.sprint(), UVM_HIGH)

  endfunction

  virtual function void report_phase(uvm_phase phase);
    super.report_phase(phase);

    if (num_fails > 0) begin
      `uvm_error("Scoreboard", $sformatf(
        "ALL TEST CASES NOT PASSING, NUMBER OF FAILS = %0d",
        num_fails
      ))
    end else begin
      `uvm_info("Scoreboard", "ALL TEST CASES PASSING!", UVM_NONE)
    end
  endfunction

endclass
