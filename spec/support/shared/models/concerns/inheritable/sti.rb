shared_examples "models/concerns/inheritable/sti" do

  let(:sti_column) { described_class.inheritance_column }
  it { should respond_to sti_column }
  it('should respond_to .act_as_sti') {
    expect(described_class).to respond_to(:act_as_sti)
  }
  it { should validate_presence_of sti_column }
  it { should ensure_inclusion_of(sti_column).in_array(described_class.sti_map.keys) }

end
