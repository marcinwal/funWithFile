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
    expect(report.extract[:loyalty_passanger].length).to eq(2)
  end

  it 'should set error' do 
    report.set_files("./sample3.txt")
    report.extract_data
    expect(report.errors[0]).to eq("Wrong number of routes")
  end 

  it 'should extract the route' do
    ROUTE_KEYS = [:operator,:type,:origin,:destination,
                :cost_pp,:price_pp,
                :min_pct]
    ROUTE_CONV = [:to_s,:to_s,:to_s,:to_s,
                :to_f,:to_f,
                :to_f]  
    report.set_files("./sample1.txt")
    report.extract_data
    expect(report.convert_to_hash(:route,0,ROUTE_KEYS,ROUTE_CONV)).to eq({:operator=>"add",
                                                                          :type=>"route",
                                                                          :origin=>"London",
                                                                          :destination=>"Dublin",
                                                                          :cost_pp=>100,
                                                                          :price_pp=>150,
                                                                          :min_pct=>75})
  end

  it 'should extract the route' do
    ROUTE_KEYS = [:operator,:type,:origin,:destination,
                :cost_pp,:price_pp,
                :min_pct]
    ROUTE_CONV = [:to_s,:to_s,:to_s,:to_s,
                :to_f,:to_f,
                :to_f]  
    report.set_files("./sample1.txt")
    report.extract_data
    expect(report.convert_to_hash(:route,0,ROUTE_KEYS,ROUTE_CONV)).to eq({:operator=>"add",
                                                                          :type=>"route",
                                                                          :origin=>"London",
                                                                          :destination=>"Dublin",
                                                                          :cost_pp=>100,
                                                                          :price_pp=>150,
                                                                          :min_pct=>75})
  end

  it 'should extract the aircraft' do 

    AIRCRAFT_KEYS = [:operator,:type,:name,:seats_number]
    AIRCRAFT_CONV = [:to_s,:to_s,:to_s,:to_f]  
    report.set_files("./sample1.txt")
    report.extract_data
    expect(report.convert_to_hash(:aircraft,0,
                      AIRCRAFT_KEYS,AIRCRAFT_CONV)).to eq({:operator=>"add",
                      :type=>"aircraft",
                      :name=>"Gulfstream-G550",
                      :seats_number=>8.0})
  end 
  it 'should extract loyalty_passanger' do 
    LOYALTY_KEYS = [:operator,:type,:name,:age,:points,:use_points,:extra_luggage]
    LOYALTY_CONV = [:to_s,:to_s,:to_s,:to_f,:to_f,:downcase,:downcase] 
    report.set_files("./sample1.txt")
    report.extract_data
    expect(report.convert_passangers_to_hash(:loyalty_passanger,LOYALTY_KEYS,LOYALTY_CONV)).to eq([{
          :operator=>"add",
          :type=>"loyalty",
          :name=>"Alan", :age=>65.0, 
          :points=>50.0, :use_points=>false, 
          :extra_luggage=>false},{:operator=>"add",:type=>"loyalty",:name=>"Max", :age=>42.0, :points=>50.0, :use_points=>true, :extra_luggage=>true}])
  end

  it 'should extract discount passanger' do 
    DISCOUNT_KEYS = [:operator,:type,:name,:age]
    DISCOUNT_CONV = [:to_s,:to_s,:to_s,:to_f]
    report.set_files("./sample1.txt")
    report.extract_data
    expect(report.convert_passangers_to_hash(:discount_passanger,DISCOUNT_KEYS,DISCOUNT_CONV)).to eq([{
        :operator=>"add",
        :type=>"discount",
        :name=>"Max",
        :age=>37.0
      }])
  end 

  it 'should load and convert all the data' do 
    report.set_files('./sample1.txt')
    report.extract_data
    report.convert_all_data
    expect(report.routes).to eq({:operator=>"add",:type=>"route",
                                :origin=>"London",
                                :destination=>"Dublin",
                                :cost_pp=>100,
                                :price_pp=>150,
                                :min_pct=>75})
    expect(report.airline).to eq([{:operator=>"add",:type=>"airline",:name=>"Trevor", :age=>54.0}])
  end

  it 'should calculate number of pass' do 
    report.set_files('./sample1.txt')
    report.extract_data
    report.convert_all_data
    expect(report.total_number_passangers).to eq(7)
    expect(report.general_number_passangers).to eq(3)
    expect(report.airline_number_passangers).to eq(1)
    expect(report.loyalty_number_passangers).to eq(2)
    expect(report.discount_number_passangers).to eq(1)
  end

  it 'should calculate bags ' do 
    report.set_files('./sample1.txt')
    report.extract_data
    report.convert_all_data
    expect(report.number_bags).to eq(7)
  end

  it 'should calculate total cost and revenue' do 
    report.set_files('./sample1.txt')
    report.extract_data
    report.convert_all_data
    expect(report.total_cost_flight).to eq(700.0)
    expect(report.total_unadj_revenue).to eq(1050.0)
    expect(report.total_adj_revenue).to eq(775.0)
  end

  it 'should calculate redeemed' do 
    report.set_files('./sample1.txt')
    report.extract_data
    report.convert_all_data
    expect(report.redeemed).to eq(50)
  end

  it 'should check if flight is allowed' do 
    report.set_files('./sample1.txt')
    report.extract_data
    report.convert_all_data
    expect(report.can_fly?).to eq('TRUE')
    report.set_files('./sample4.txt')
    report.extract_data
    report.convert_all_data
    expect(report.can_fly?).to eq('FALSE')
  end 

  it 'should get the answer' do 
    report.set_files('./sample1.txt')
    report.extract_data
    report.convert_all_data
    expect(report.final).to eq([6, 3, 1, 2, 7, 50.0,
                                600.0, 900.0, 700.0, "TRUE"])
  end

end
