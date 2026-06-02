class monitor;

  virtual FIFO_if vif;
  mailbox mon_scb_mbx;

  task run();

    forever begin
      @(posedge vif.clk);

      if (!vif.rst) begin
        FIFO_item item;
        item = new();

        #1;

        item.data_in      = vif.data_in;
        item.write_enable = vif.write_enable;
        item.read_enable  = vif.read_enable;

        item.data_out = vif.data_out;
        item.full     = vif.full;
        item.empty    = vif.empty;

        mon_scb_mbx.put(item);
        item.print("Monitor");
      end
    end

  endtask

endclass
