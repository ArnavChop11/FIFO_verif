class driver #(
  parameter int DATA_WIDTH = 32,
  parameter int FIFO_DEPTH = 16
) extends uvm_driver #(FIFO_item #(DATA_WIDTH, FIFO_DEPTH));
  
  
  `uvm_component_utils(driver)
  
  function new(string name = "driver", uvm_component parent=null);
    super.new(name, parent);
  endfunction
  
  virtual _if vif;
  
  virtual function void build_phase (uvm_phase phase);
    super.build_phase(phase);
    if (!uvm_config_db#(virtual _if)::get(this, "", "_if", vif)) begin      
      `uvm_fatal("NOVIF", "Could not get vif in DRIVER")   
    end
  endfunction
  
  
  virtual task run_phase (uvm_phase phase);
    super.run_phase(phase);
    forever begin
      FIFO_item item; 
      seq_item_port.get_next_item(item);
      drive_item(item);
      seq_item_port.item_done();
    end
  endtask
    
    
  virtual task drive_item (FIFO_item item);
    
     @(negedge vif.clk);
    
      vif.data_in      <= item.data_in; 
      vif.write_enable <= item.write_enable; 
      vif.read_enable  <= item.read_enable;
 
  endtask
  
 
endclass
