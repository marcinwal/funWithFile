class Report

  PATTERNS = {:route => /add route \D+ \D+ \d+ \d+ \d+/,
             :aircraft => /add aircraft \S+ \d+/,
             :general_passanger => /add general \D+ \d{1,3}/,
             :airline_passanger => /add airline \D+ \d{1,3}/,
             :discount_passanger => /add discount \D+ \d{1,3}/,
             :loyalty_passanger => /add loyalty \D+ \d{1,3} \d+ (TRUE|FALSE) (TRUE|FALSE)/}
  
  ROUTE_KEYS = [:operator,:type,:origin,:destination,
                :cost_pp,:price_pp,
                :min_pct]

  ROUTE_CONV = [:to_s,:to_s,:to_s,:to_s,
                :to_f,:to_f,
                :to_f]    

  AIRCRAFT_KEYS = [:operator,:type,:name,:seats_number]
  AIRCRAFT_CONV = [:to_s,:to_s,:to_s,:to_f]   

  GENERAL_AIRLINE_KEYS = [:operator,:type,:name,:age]
  GENERAL_AIRLINE_CONV = [:to_s,:to_s,:to_s,:to_f] 

  LOYALTY_KEYS = [:operator,:type,:name,:age,:points,:use_points,:extra_luggage]
  LOYALTY_CONV = [:to_s,:to_s,:to_s,:to_f,:to_f,:downcase,:downcase] 

  DISCOUNT_KEYS = [:operator,:type,:name,:age]
  DISCOUNT_CONV = [:to_s,:to_s,:to_s,:to_f]

  attr_reader :input_file,:output_file,:extract,:errors,
              :general,:airline,:loyalty,
              :aircrafts,:routes           

  include File_helper

  def initialize
    @extract = {}
    @errors = []
  end

  def set_error(text)
    @errors << text
  end

  def read_inputs
    puts "Input file with data:"
    @input_file = gets.chomp
    puts "Input destination file:"
    @output_file = gets.chomp
  end

  #set up for testing to load files for tests
  def set_files(input = "./sample1.txt",output = './dest1.txt')
    @input_file = input
    @output_file = output
    @extract = load_file(@input_file,PATTERNS)
  end

  def extract_data
    @extract = load_file(input_file,PATTERNS)
    set_error("Wrong number of routes") if @extract[:route].size != 1
    set_error("Wrong number of aircrafts") if @extract[:aircraft].size != 1
  end

  #reads given data and converts it into hash/dictionary
  def convert_to_hash(symbol,array_num,keys,conv)
    result = {}
    @extract[symbol][array_num].split(' ').each_with_index do |el,ix|
      converted_el = el.send(conv[ix])
      result[keys[ix]] = (converted_el == 'true' || 
                          converted_el == 'false')? eval(converted_el) : converted_el
    #eval has to be performed on 'false'/'true'
    end
    result
  end

  def convert_passangers_to_hash(symbol,keys,conv)
    result = []
    return result unless @extract[symbol]
    number_of_passangers = @extract[symbol].size
    for i in 0...number_of_passangers
      result << convert_to_hash(symbol,i,keys,conv)
    end
    return result
  end

  def convert_all_data
    if @errors.size > 0 
      puts @errors
      exit 0
    end
    @routes = convert_to_hash(:route,0,ROUTE_KEYS,ROUTE_CONV)
    @aircrafts = convert_to_hash(:aircraft,0,AIRCRAFT_KEYS,AIRCRAFT_CONV)
    @general = convert_passangers_to_hash(:general_passanger,
                        GENERAL_AIRLINE_KEYS,GENERAL_AIRLINE_CONV)
    @airline = convert_passangers_to_hash(:airline_passanger,
                        GENERAL_AIRLINE_KEYS,GENERAL_AIRLINE_CONV)
    @loyalty = convert_passangers_to_hash(:loyalty_passanger,
                        LOYALTY_KEYS,LOYALTY_CONV)
    @discount = convert_passangers_to_hash(:discount_passanger,
                        DISCOUNT_KEYS,DISCOUNT_CONV)
  end

  def total_number_passangers
    @general.size + @airline.size + @loyalty.size + @discount.size
  end

  def general_number_passangers
    @general.size
  end

  def airline_number_passangers
    @airline.size
  end

  def loyalty_number_passangers
    @loyalty.size
  end

  def discount_number_passangers
    @discount.size
  end

  def number_bags
    extra = @loyalty.reduce(0){|sum,el| el[:extra_luggage]? sum+1 : sum}
    extra + total_number_passangers - discount_number_passangers
  end

  def total_cost_flight
    total_number_passangers * @routes[:cost_pp]
  end

  def total_unadj_revenue
    total_number_passangers * @routes[:price_pp]
  end

  def discount_rev
    discount_number_passangers * @routes[:price_pp] * 0.5
  end

  def total_adj_revenue
    loyalty_rev = @loyalty.reduce(0){|sum,el| el[:use_points]? 
      sum+[0,@routes[:price_pp]-el[:points]].max : sum+@routes[:price_pp]}
    #price cannot be negative and that is why .max is added   
    loyalty_rev + @routes[:price_pp] * general_number_passangers + discount_rev
  end

  def redeemed
    total_unadj_revenue - total_adj_revenue -
    airline_number_passangers * @routes[:price_pp]
  end

  def can_fly?
    (total_number_passangers/@aircrafts[:seats_number] >= 
      @routes[:min_pct]/100.0).to_s.upcase
    #to match task spec of TRUE value converted to string and upcase
  end

  def final
    [total_number_passangers,general_number_passangers,
    airline_number_passangers,loyalty_number_passangers,
    number_bags,redeemed,total_cost_flight,
    total_unadj_revenue,total_adj_revenue,
    can_fly?]
  end

end