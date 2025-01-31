require 'faussaire/tv'

RSpec.describe Faussaire::Tv do
  describe '.show' do
    it 'returns a string' do
      expect(Faussaire::Tv.show).to be_a(String)
    end

    it 'returns a non-empty string' do
      expect(Faussaire::Tv.show).not_to be_empty
    end

    it 'has shows encoded in UTF-8' do
      show = Faussaire::Tv.show
      expect(show.encoding.name).to eq("UTF-8")
      expect(show.valid_encoding?).to be(true)
    end

    context '.randomness when called multiple times' do
      it 'returns unique shows indicating randomness' do
        shows = Array.new(10) { Faussaire::Tv.show }
        unique_shows = shows.uniq
        expect(unique_shows.size).to be > 1
      end

      it 'has a high proportion of unique shows' do
        shows = Array.new(10) { Faussaire::Tv.show }
        unique_shows = shows.uniq
        expect(unique_shows.size).to be >= (0.5 * shows.size)
      end
    end
  end

  describe '.famous_couples' do
    let(:famous_couple) { Faussaire::Tv.famous_couples }
  
    it 'returns a string' do
      expect(famous_couple).to be_a(String)
    end

    it 'contains a year within parentheses' do
      expect(famous_couple).to match(/\(\d{4}\)/)
    end

    it 'is encoded in UTF-8' do
      expect(famous_couple.encoding.name).to eq("UTF-8")
      expect(famous_couple.valid_encoding?).to be(true)
    end
  end

  describe '.channel' do
    let(:channel) { Faussaire::Tv.channel }
  
    it 'does not contain "/" in any channel' do
      expect(channel).not_to include('/')
    end
  
    it 'does not contain sequences like "L1234:5" or any similar format' do
      expect(channel).not_to match(/\b[A-Za-z]\d+:\d+\b/)
    end
  end

  describe '.festival_cannes' do
    let(:festival_cannes) { Faussaire::Tv.festival_cannes }

    context 'total_films' do
      it 'returns the total number of projected films as a string' do
        expect(festival_cannes.total_films).to be_a(String)
      end
    end

    context 'most_represented_countries' do
      it 'returns a string with one of the most represented countries and its film count' do
        country = festival_cannes.most_represented_countries
        expect(country).to match(/\d+ \(.+\)/)
      end
    end

    context 'awarded_countries' do
      it 'returns a string with one of the awarded countries and its award total' do
        country = festival_cannes.awarded_countries
        expect(country).to match(/\A.+ \(total de \d+ récompense(s)?\)$/)
      end
    end

    context 'winners' do
      it 'ends with a year in brackets within the range 1939 to 2023 (10 samples)' do
        10.times do
          winner = festival_cannes.winners 
          expect(winner).to match(/\[(19[3-9]\d|20[0-1]\d|202[0-3])\]$/)
        end
      end
    end
  end

  context 'in Netflix list' do
    it 'does not contain duplicates' do
      shows = YAML.load_file(Faussaire::Tv::DATA_PATH).dig('fr', 'faussaire', 'tv', 'netflix')
      duplicates = shows.group_by { |show| show }.select { |_, v| v.size > 1 }.keys
  
      expect(duplicates).to be_empty, "Duplicates found in netflix: #{duplicates.join(', ')}"
    end
  end
  
  context 'in shows list' do
    it 'does not contain duplicates' do
      shows = YAML.load_file(Faussaire::Tv::DATA_PATH).dig('fr', 'faussaire', 'tv', 'show')
      duplicates = shows.group_by { |show| show }.select { |_, v| v.size > 1 }.keys
  
      expect(duplicates).to be_empty, "Duplicates found in shows: #{duplicates.join(', ')}"
    end
  end
  
  context 'in influencers list' do
    it 'does not contain duplicates' do
      influencers = YAML.load_file(Faussaire::Tv::DATA_PATH).dig('fr', 'faussaire', 'tv', 'influencer')
      duplicates = influencers.group_by { |influencer| influencer }.select { |_, v| v.size > 1 }.keys
  
      expect(duplicates).to be_empty, "Duplicates found in influencers: #{duplicates.join(', ')}"
    end
  end
  
  context 'in channels list' do
    it 'does not contain duplicates' do
      channels = YAML.load_file(Faussaire::Tv::DATA_PATH).dig('fr', 'faussaire', 'tv', 'channel')
      duplicates = channels.group_by { |channel| channel }.select { |_, v| v.size > 1 }.keys
  
      expect(duplicates).to be_empty, "Duplicates found in channels: #{duplicates.join(', ')}"
    end
  end
end