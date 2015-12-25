require 'ruby-graphviz'
$g = GraphViz.new(:G, :type => "strict digraph" )

class Unit
  attr_accessor :name
  def initialize(name, parent, &block)
    @name = name
    @parent = parent
    self.instance_eval(&block)
  end
  def add_employee(text, &block)
    children << Employee.new(text, self, &block)
  end
  def add_unit(text, &block)
    children << Unit.new(text, self, &block)
  end
  def children
    @children ||= []
  end
  def run
    if @parent != nil
      par = $g.add_node(@parent.name)
      child = $g.add_node(@name)
      $g.add_edge(par, child)
    end
    children.each(&:run)
  end

end

class Employee
  attr_accessor :name
  def initialize(name, parent, &block)
    @name = name
    @parent = parent
    instance_eval(&block)
  end
  def run
    if @parent != nil
      par = $g.add_node(@parent.name)
      child = $g.add_node(@name)
      $g.add_edge(par, child)
    end
  end
end


def root(name, &block)
  Unit.new(name, nil, &block).run
end

load 'company.qm'


$g.output( :png => "graph_company.png" )
