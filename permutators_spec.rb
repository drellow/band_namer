require 'rspec'
load 'permutators.rb'

describe String do
  describe "word_combiner" do
    it "combiners words!" do
      expect("Derp Fleep".combine_words).to eq("Derpeep")
      expect("Manicure Limbs".combine_words).to eq("Manicurimbs")
    end

    it "just returns single words" do
      expect("Derp".combine_words).to eq("Derp")
    end
  end

  describe "spoonerize" do
    it "spoonerizes complexish phrases" do
      expect("Tom Cruise".spoonerize).to eq("Crom Tuise")
      expect("Fleep Boop".spoonerize).to eq("Beep Floop")
    end

    it "avoids spoonerizing single words" do
      expect("Derp".spoonerize).to eq("Derp")
    end

    it "first limits phrases to two words before spoonerizing" do
      expect("The Yellow Dart".spoonerize).to eq("Ye Thellow")
    end

    it "does not explode on empty strings" do
      expect("".spoonerize).to eq("")
    end
  end

  describe "take" do
    it "returns the first n words in a string" do
      expect("Foo Bar Baz".take(2)).to eq("Foo Bar")
      expect("Foo Bar Baz Bleep".take(3)).to eq("Foo Bar Baz")
      expect("Foo Bar".take(4)).to eq("Foo Bar")
    end
  end

  describe "letters_only" do
    it "strips non-letter characters" do
      expect("Foo2Baz".letters_only).to eq("FooBaz")
      expect("Foo) (Baz".letters_only).to eq("Foo Baz")
    end
  end

  describe "undisambiguate" do
    it "undisambiguates" do
      expect("Martyrs (disambiguation)".undisambiguate).to eq("Martyrs")
      expect("Martyrs and Kings(disambiguation)".undisambiguate).to eq("Martyrs and Kings")
    end
  end

  describe "repeat_first_word" do
    it "repeats the first word" do
      expect("Gang Dance".repeat_first_word).to eq("Gang Gang Dance")
    end
  end

  describe "shuffle" do
    it "shuffles the words in a string" do
      expect(["Foo Bar", "Bar Foo"]).to include("Bar Foo".shuffle)
    end
  end
end
