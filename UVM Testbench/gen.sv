class gen_item_seq #(
  parameter int DATA_WIDTH = 32,
  parameter int FIFO_DEPTH = 16
) extends uvm_sequence #(FIFO_item #(DATA_WIDTH, FIFO_DEPTH));

  typedef FIFO_item #(DATA_WIDTH, FIFO_DEPTH) fifo_item_t;

  `uvm_object_param_utils(gen_item_seq #(DATA_WIDTH, FIFO_DEPTH))

  function new(string name = "gen_item_seq");
    super.new(name);
  endfunction

  rand int num; // total number of FIFO transactions to send

  constraint c1 {
    soft num inside {[20:30]};
  }

  virtual task body();

    for (int i = 0; i < num; i++) begin

      fifo_item_t m_item;

      m_item = fifo_item_t::type_id::create("m_item");

      start_item(m_item);

      if (!m_item.randomize()) begin
        `uvm_error("SEQ", "FIFO item randomization failed")
      end

      `uvm_info("SEQ", "Generate new FIFO item:", UVM_LOW)
      m_item.print();

      finish_item(m_item);

    end

    `uvm_info("SEQ", $sformatf("Done generation of %0d items", num), UVM_LOW)

  endtask

endclass
