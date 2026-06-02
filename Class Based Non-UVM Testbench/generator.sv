class generator;

  mailbox gen_drv_mbx;
  event drv_done;

  int num_runs = 25;

  task run();

    for (int i = 1; i <= num_runs; i++) begin
      FIFO_item item;
      item = new();

      if (!item.randomize()) begin
        $display("[Generator] Randomization failed");
      end

      $display("T=%0t [Generator] Creating item number: %0d / %0d",
               $time, i, num_runs);

      gen_drv_mbx.put(item);
      @(drv_done);
    end

    $display("T=%0t [Generator] Done generation of %0d items",
             $time, num_runs);

  endtask

endclass
