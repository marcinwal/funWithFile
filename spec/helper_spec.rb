require_relative '../app/file_helper.rb'

describe File_helper do

  let(:sample_data_file){'./sample1.txt'}
  let(:output_data_file){'./out.txt'}
  let(:tester){(Class.new{include File_helper}).new}
  let(:pattern){{:route => /add route \D+ \D+ \d+ \d+ \d+/,
                 :aircraft => /add aircraft \S+ \d/,
                 :general_passanger => /add general \D+ \d{1,3}/,
                 :airline_passanger => /add airline \D+ \d{1,3}/,
                 :loyalty_passanger => /add loyalty \D+ \d{1,3} \d+ (TRUE|FALSE) (TRUE|FALSE)/}}


  it "should load a flight route" do
    dictionary = tester.load_file(sample_data_file,pattern)
    expect(dictionary[:route].length).to eq(1)
  end

  it "should load an aircraft route" do
    dictionary = tester.load_file(sample_data_file,pattern)
    expect(dictionary[:aircraft].length).to eq(1)
  end

  it "should load 3 general passangers" do 
    dictionary = tester.load_file(sample_data_file,pattern)
    expect(dictionary[:general_passanger].length).to eq(3)
  end

  it "should load 1 airline passangers" do 
    dictionary = tester.load_file(sample_data_file,pattern)
    expect(dictionary[:airline_passanger].length).to eq(1)
  end

  it "should load 2 general loyalty" do 
    dictionary = tester.load_file(sample_data_file,pattern)
    expect(dictionary[:loyalty_passanger].length).to eq(2)
  end  

  it 'should write to a file' do 
    tester.save_file(output_data_file,[6, 3, 1, 2, 7, 50.0,
                                600.0, 900.0, 700.0, "TRUE"])
  end

end