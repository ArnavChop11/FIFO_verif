class scoreboard #(parameter int DATA_WIDTH = 32,
                   parameter int FIFO_DEPTH = 16);

  mailbox mon_scb_mbx;
  
  int num_fails = 0;

task pass_msg(string msg);
  $display("PASS: %s", msg);
endtask

task fail_msg(string msg);
  $display("FAIL: %s", msg);
endtask
  
 task report();
    if (num_fails > 0) begin
      $display("ALL TEST CASES NOT PASSING, NUMBER OF FAILS = %0d", num_fails);
    end else begin
      $display("ALL TEST CASES PASSING!");
    end
  endtask

  task run();

    logic [DATA_WIDTH-1:0] expected_vals[$];
    logic [DATA_WIDTH-1:0] out_val;

    int pre_size;
    bit read_valid;
    bit write_valid;

    bit expected_empty;
    bit expected_full;
   

    forever begin
      FIFO_item item;
      mon_scb_mbx.get(item);

      pre_size = expected_vals.size();

      read_valid = item.read_enable && (pre_size > 0);

      write_valid = item.write_enable && ((pre_size < FIFO_DEPTH) || read_valid);

      if (item.write_enable && item.read_enable) begin

        if (pre_size == 0) begin
          $display("[Scoreboard] Read+write while empty case");
          $display("[Scoreboard] Read ignored, write accepted");
        end else if (pre_size == FIFO_DEPTH) begin
          $display("[Scoreboard] Read+write while full case");
          $display("[Scoreboard] Read accepted, write accepted, FIFO stays full");
        end else begin
          $display("[Scoreboard] Normal read+write case");
        end

        if (read_valid) begin
          out_val = expected_vals.pop_front();

          if (item.data_out !== out_val) begin
            num_fails += 1; 
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
          $display("[Scoreboard] Read while empty case");
          pass_msg("[Scoreboard] read correctly ignored because FIFO was empty");
        end else begin
          out_val = expected_vals.pop_front();

          if (item.data_out !== out_val) begin
            num_fails += 1;
            fail_msg($sformatf("[Scoreboard] read mismatch. Expected=0x%0h Got=0x%0h",
                               out_val, item.data_out));
          end else begin
            pass_msg("[Scoreboard] read output correct");
          end
        end

      end else if (item.write_enable) begin

        if (pre_size == FIFO_DEPTH) begin
          $display("[Scoreboard] Write while full case");
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
        num_fails += 1;
        fail_msg($sformatf("[Scoreboard] empty mismatch. Expected=%0b Got=%0b",
                           expected_empty, item.empty));
      end else begin
        pass_msg("[Scoreboard] empty flag correct");
      end

      if (item.full !== expected_full) begin
        num_fails += 1;
        fail_msg($sformatf("[Scoreboard] full mismatch. Expected=%0b Got=%0b",
                           expected_full, item.full));
      end else begin
        pass_msg("[Scoreboard] full flag correct");
      end

      item.print("Scoreboard");

    end
   

  endtask

endclass
