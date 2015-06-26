require_relative '../app/report.rb'

describe Report do 

  let(:report){Report.new}

  it 'should read data into report' do

    report.set_files
    report.extract_data
    expect(report.extract[:route].length).to eq(1)
    expect(report.extract[:aircraft].length).to eq(1)
    expect(report.extract[:general_passanger].length).to eq(3)
    expect(report.extract[:airline_passanger].length).to eq(1)
    expect(report.extract[:loyalty_passanger].length).to eq(1)
    p report.extract[:route] 
  end

  it 'should set error' do 
    report.set_files("./sample3.txt")
    report.extract_data
    expect(report.errors[0]).to eq("Wrong number of routes")
  end 

end
