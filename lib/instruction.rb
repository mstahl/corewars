

class Instruction < Treetop::Runtime::SyntaxNode
  attr_accessor :address
  attr_accessor :labels
  
  attr_accessor :label
  attr_accessor :opcode
  attr_accessor :modifier
  attr_accessor :a_operand
  attr_accessor :a_mode
  attr_accessor :b_operand
  attr_accessor :b_mode
  
  def value
    # Handle labels here. If this line has a label, add it to @labels
    if label_list then
      labels += label_list.value
    end
    
    if field then
      # First form: label_list? operation mode? field comment
      opcode = operation.value
      a_mode = mode.value if mode
      a_operand = field.value
    else
      # Second form: label_list? operation a_operand:(mode? expr) "," b_operand:(mode? expr) comment
      
    end
  end
end