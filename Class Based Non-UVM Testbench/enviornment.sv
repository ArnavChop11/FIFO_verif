class env #(parameter int DATA_WIDTH = 32,
            parameter int FIFO_DEPTH = 16);

  driver      d0;
  monitor     m0;
  generator   g0;
  scoreboard #(DATA_WIDTH, FIFO_DEPTH) s0;

  mailbox gen_drv_mbx;
  mailbox mon_scb_mbx;

  event drv_done;

  virtual FIFO_if #(DATA_WIDTH, FIFO_DEPTH) vif;

  function new();

    d0 = new();
    m0 = new();
    g0 = new();
    s0 = new();

    gen_drv_mbx = new();
    mon_scb_mbx = new();

    g0.gen_drv_mbx = gen_drv_mbx;
    d0.gen_drv_mbx = gen_drv_mbx;

    m0.mon_scb_mbx = mon_scb_mbx;
    s0.mon_scb_mbx = mon_scb_mbx;

    d0.drv_done = drv_done;
    g0.drv_done = drv_done;

  endfunction

  virtual task run();

    d0.vif = vif;
    m0.vif = vif;

    fork
      d0.run();
      m0.run();
      g0.run();
      s0.run();
    join_any
    
  repeat (2) @(posedge vif.clk);

  s0.report();

  endtask

endclass
