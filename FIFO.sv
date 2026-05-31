module FIFO #(
  
  parameter DATA_WIDTH = 32,
  parameter FIFO_DEPTH = 16 

)(
  
  input logic clk,
  input logic rst,
  
  input logic [DATA_WIDTH-1:0] data_in,
  input logic write_enable, 
  input logic read_enable,
  
  output logic [DATA_WIDTH-1:0] data_out,
  output logic full, 
  output logic empty
); 
  
  
  logic [$clog2(FIFO_DEPTH)-1:0] read_idx;
  logic [$clog2(FIFO_DEPTH)-1:0] write_idx;
  logic [$clog2(FIFO_DEPTH)-1:0] read_idx_next;
  logic [$clog2(FIFO_DEPTH)-1:0] write_idx_next;
  
  logic [$clog2(FIFO_DEPTH):0] count;
  logic [$clog2(FIFO_DEPTH):0] count_next;
  
  logic [FIFO_DEPTH-1:0][DATA_WIDTH-1:0] FIFO;
  
  typedef enum logic [1:0] {
    NOTHING,
    WRITE,
    READ,
    WRITE_AND_READ
  } fifo_action_t; 
  
  fifo_action_t FIFO_ACTION; 
  
  always_ff @(posedge clk) begin
    
    if (rst) begin
    
      FIFO <= '0; 
      count <= '0; 
      read_idx <= '0; 
      write_idx <= '0; 
      data_out <= '0;
      
    end else begin 
      
      count <= count_next; 
      read_idx <= read_idx_next; 
      write_idx <= write_idx_next;
      
      case (FIFO_ACTION)
        
        NOTHING: ;
        
        WRITE: begin
          FIFO[write_idx][DATA_WIDTH-1:0] <= data_in; 
        end
        
        READ: begin
          data_out <= FIFO[read_idx][DATA_WIDTH-1:0];
        end
        
        WRITE_AND_READ: begin
          FIFO[write_idx][DATA_WIDTH-1:0] <= data_in;
          data_out <= FIFO[read_idx][DATA_WIDTH-1:0];
        end
        
        default: ;
        
      endcase
        
    end
    
  end
  
  
  
  always_comb begin
    
    full  = (count == FIFO_DEPTH); 
    empty = (count == 0); 
    
    read_idx_next  = read_idx; 
    write_idx_next = write_idx;
    count_next     = count;
    FIFO_ACTION    = NOTHING;
    
    if (write_enable && read_enable && !empty) begin
      
      FIFO_ACTION = WRITE_AND_READ;
      
      read_idx_next = (read_idx == (FIFO_DEPTH-1)) 
                    ? '0 
                    : (read_idx + 1);
                    
      write_idx_next = (write_idx == (FIFO_DEPTH-1)) 
                     ? '0 
                     : (write_idx + 1);
      
    end else if (write_enable && !full) begin
      
      FIFO_ACTION = WRITE;
      
      write_idx_next = (write_idx == (FIFO_DEPTH-1)) 
                     ? '0 
                     : (write_idx + 1);
                     
      count_next = count + 1; 
      
    end else if (read_enable && !empty) begin
      
      FIFO_ACTION = READ;
      
      read_idx_next = (read_idx == (FIFO_DEPTH-1)) 
                    ? '0 
                    : (read_idx + 1);
                    
      count_next = count - 1; 
      
    end else begin
      
      FIFO_ACTION = NOTHING;
      
    end
    

  end
  
  
  
endmodule
