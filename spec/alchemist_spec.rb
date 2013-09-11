require 'spec_helper'

describe Alchemist do

  it "sets up Numeric" do
    category_module = double()
    module_builder = double()
    module_builder.should_receive(:build).and_return(category_module)
    fake_module = double()
    fake_module.should_receive(:include).with(category_module)
    Alchemist::ModuleBuilder.should_receive(:new).with('distance').and_return(module_builder)
    stub_const("Numeric", fake_module)
    Alchemist.setup('distance')
  end

  it "creates a measurement" do
    unit = Alchemist.measure(1, :meter)
    expect(unit).to eq(1.meter)
  end

  it "knows if it has a measurement" do
    expect(Alchemist.library.has_measurement?(:meter)).to be_true
  end

  it "knows if it doesn't have a measurement" do
    expect(Alchemist.library.has_measurement?(:wombat)).to be_false
  end

  it "can register units" do
    Alchemist.library.register :quux, :qaat, 1.0
    Alchemist.library.register :quux, :quut, 3.0
    expect(Alchemist.library.conversion_table[:quux]).to eq({:qaat=>1.0, :quut=>3.0})
  end

  it "can register units with plural names" do
    Alchemist.library.register(:beards, [:beard_second, :beard_seconds], 1.0)
    expect(Alchemist.library.conversion_table[:beards]).to eq({:beard_second=>1.0, :beard_seconds=>1.0})
  end

  it "can register units with formulas" do
    to = lambda { |t| t + 1 }
    from = lambda { |t| t - 1 }
    Alchemist.library.register(:yetis, :yeti, [to, from])
    expect(Alchemist.library.conversion_table[:yetis]).to eq({:yeti => [to, from]})
  end

  it "can parse a prefix" do
    parsed = Alchemist::PrefixParser.new.parse(:kilometer)
    expect(parsed).to eq([1000.0, :meter])
  end
end
