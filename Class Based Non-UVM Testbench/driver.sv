class driver; 
  
  virtual FIFO_if vif; 
  mailbox gen_drv_mbx;
  event drv_done; 
  
  task run(); 

    vif.data_in      = '0;
    vif.write_enable = 1'b0;
    vif.read_enable  = 1'b0;

    forever begin
      
      FIFO_item item;
      
      $display("[Driver] Retrieving transaction from Generator @ time = %0t", $time);
      gen_drv_mbx.get(item); 

      @(negedge vif.clk);

      vif.data_in      = item.data_in; 
      vif.write_enable = item.write_enable; 
      vif.read_enable  = item.read_enable;

      item.print("Driver");
      
      @(posedge vif.clk);
      
      -> drv_done;

      @(negedge vif.clk);
      vif.write_enable = 1'b0;
      vif.read_enable  = 1'b0;
      
    end 
    
  endtask

endclass
