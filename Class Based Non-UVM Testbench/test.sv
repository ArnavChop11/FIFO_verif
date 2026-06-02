class test #(parameter int DATA_WIDTH = 32,
             parameter int FIFO_DEPTH = 16);

  env #(DATA_WIDTH, FIFO_DEPTH) e0;

  function new();
    e0 = new();
  endfunction

  task run();
    e0.run();
  endtask

endclass
