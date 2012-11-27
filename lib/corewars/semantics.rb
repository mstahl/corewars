
class Instruction < Treetop::Runtime::SyntaxNode
  attr_accessor :warrior
  
  def value
    hash = {
      :opcode   => operation.value[:opcode],
      :modifier => operation.value[:modifier],
      :label    => lbl ? lbl.text_value.gsub(/\s+/, '_').gsub(/[^\w_]/, '').to_sym : nil
    }
    
    hash[:a_mode] = a.value[:mode]
    hash[:a] = a.value[:expression]
    
    
    if defined? b
      hash[:b_mode] = b.value[:mode]
      hash[:b] = b.value[:expression]
    end
    
    hash
  end
end

class Operation < Treetop::Runtime::SyntaxNode
  def value
    {
      :opcode   => opcode.text_value.to_sym,
      :modifier => defined? modifier ? nil : modifier.text_value.to_sym
    }
  end
end

class Operand < Treetop::Runtime::SyntaxNode
  def value
    {
      :expression => primary.value,
      :mode       => defined? mode ? mode.text_value : nil
    }
  end
end
