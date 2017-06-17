require 'rspec'
load 'band_namer.rb'

describe BandNamer do
  describe "#literature_me" do
    it "returns a string" do
      new_literature = described_class.new.literature_me
      puts "literature_me returned #{new_literature}"
      expect(new_literature).to be_instance_of(String)
    end
  end

  describe "algorithms" do
    describe ":lit_spooner" do
      it "returns a string" do
        lit_spooner = described_class.new(:lit_spooner).to_s
        puts "lit_spooner returned #{lit_spooner}"
        expect(lit_spooner).to be_instance_of(String)
      end
    end
  end
end
