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
  end

  it 'should set error' do 
    report.set_files("./sample3.txt")
    report.extract_data
    expect(report.errors[0]).to eq("Wrong number of routes")
  end 

  it 'should extract the route' do
    ROUTE_KEYS = [:origin,:destination,
                :cost_pp,:price_pp,
                :min_pct]
    ROUTE_CONV = [:to_s,:to_s,
                :to_f,:to_f,
                :to_f]  
    report.set_files("./sample1.txt")
    report.extract_data
    expect(report.convert_to_hash(:route,0,2,ROUTE_KEYS,ROUTE_CONV)).to eq({:origin=>"London",
                                                                          :destination=>"Dublin",
                                                                          :cost_pp=>100,
                                                                          :price_pp=>150,
                                                                          :min_pct=>75})
  end

  it 'should extract the aircraft' do 

    AIRCRAFT_KEYS = [:name,:seats_number]
    AIRCRAFT_CONV = [:to_s,:to_f]  
    report.set_files("./sample1.txt")
    report.extract_data
    expect(report.convert_to_hash(:aircraft,0,2,
                      AIRCRAFT_KEYS,AIRCRAFT_CONV)).to eq({:name=>"Gulfstream-G550",
                      :seats_number=>8.0})
  end 

end
